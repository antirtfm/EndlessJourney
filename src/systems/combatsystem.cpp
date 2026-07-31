#include "worldsystems.h"

#include "balance.h"
#include "simulationmath.h"

#include <algorithm>
#include <cstddef>

void CombatSystem::stepHeroAttack(World& world, float deltaSeconds)
{
    world.m_heroAttackCooldown = std::max(
        0.0f, world.m_heroAttackCooldown - deltaSeconds);
    if (world.m_heroAttackCooldown > 0.0f)
        return;

    Entity& hero = world.hero();
    Entity* target = nullptr;
    float closestDistance = Balance::heroAttackRange;

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

    target->hp -= Balance::heroDamage;
    hero.attackAnimTime = Balance::heroAttackAnimDuration;
    hero.anim = AnimState::Attack;
    hero.octant = SimulationMath::octantFromDirection(
        target->x - hero.x, target->y - hero.y, hero.octant);
    world.m_heroAttackCooldown = 1.0f / Balance::heroAttackRate;
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
        world.m_enemyRespawnTime = Balance::enemyRespawnDelay;
        world.m_entities.erase(world.m_entities.begin()
                               + static_cast<std::ptrdiff_t>(index));
    }
}
