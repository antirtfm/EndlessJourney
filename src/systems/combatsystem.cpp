#include "worldsystems.h"

#include "balance.h"
#include "simulationmath.h"

#include <algorithm>
#include <cstddef>
#include <utility>

void CombatSystem::stepHeroAttack(World& world, float deltaSeconds)
{
    world.m_heroAttackCooldown = std::max(
        0.0f, world.m_heroAttackCooldown - deltaSeconds);
    if (world.m_heroAttackCooldown > 0.0f)
        return;

    Entity& hero = world.hero();
    Entity* target = nullptr;
    float closestDistance = world.m_stats.attackRange;

    for (std::size_t index = 1; index < world.m_entities.size(); ++index) {
        Entity& candidate = world.m_entities[index];
        if (!isEnemy(candidate) || candidate.hp <= 0.0f)
            continue;

        const float distance = SimulationMath::distance(hero, candidate);
        if (distance <= closestDistance) {
            closestDistance = distance;
            target = &candidate;
        }
    }

    if (!target)
        return;

    target->hp -= world.m_stats.damage;
    hero.attackAnimTime = Balance::heroAttackAnimDuration;
    hero.anim = AnimState::Attack;
    hero.octant = SimulationMath::octantFromDirection(
        target->x - hero.x, target->y - hero.y, hero.octant);
    world.m_heroAttackCooldown = 1.0f / world.m_stats.attackRate;
}

void CombatSystem::stepNova(World& world, World::StepEvents& events)
{
    if (!std::exchange(world.m_input.castNova, false))
        return;
    if (world.m_mana < Balance::novaManaCost)
        return;

    world.m_mana -= Balance::novaManaCost;

    const Entity& hero = world.hero();
    const float radius = world.m_stats.novaRadius;
    for (std::size_t index = 1; index < world.m_entities.size(); ++index) {
        Entity& enemy = world.m_entities[index];
        if (!isEnemy(enemy) || enemy.hp <= 0.0f)
            continue;
        if (SimulationMath::distance(hero, enemy) <= radius)
            enemy.hp -= world.m_stats.novaDamage;
    }

    events.novaBlast = World::NovaBlast { hero.x, hero.y, radius };
}

void CombatSystem::resolveDeaths(World& world, World::StepEvents& events)
{
    if (world.m_hp <= 0.0f && !world.m_heroDead) {
        world.m_hp = 0.0f;
        world.m_heroDead = true;
        world.hero().hp = 0.0f;
        world.hero().anim = AnimState::Die;
        events.heroDied = true;
    }

    for (std::size_t index = 1; index < world.m_entities.size();) {
        const Entity& entity = world.m_entities[index];
        if (!isEnemy(entity) || entity.hp > 0.0f) {
            ++index;
            continue;
        }

        world.m_xp += entity.xpReward;
        ++world.m_kills;
        ++events.enemiesDied;
        world.m_entities.erase(world.m_entities.begin()
                               + static_cast<std::ptrdiff_t>(index));
    }
}
