#include "worldsystems.h"

#include "balance.h"
#include "simulationmath.h"

#include <algorithm>
#include <cmath>

void EnemyBehaviorSystem::step(World& world, float deltaSeconds)
{
    Entity& hero = world.hero();

    for (std::size_t index = 1; index < world.m_entities.size(); ++index) {
        Entity& enemy = world.m_entities[index];
        if (!isEnemy(enemy) || enemy.hp <= 0.0f)
            continue;

        const float dx = hero.x - enemy.x;
        const float dy = hero.y - enemy.y;
        const float distanceToHero = std::hypot(dx, dy);

        enemy.octant = SimulationMath::octantFromDirection(
            dx, dy, enemy.octant);
        enemy.attackCooldown = std::max(
            0.0f, enemy.attackCooldown - deltaSeconds);
        enemy.attackAnimTime = std::max(
            0.0f, enemy.attackAnimTime - deltaSeconds);

        if (enemy.attackAnimTime > 0.0f) {
            enemy.anim = AnimState::Attack;
            continue;
        }

        const float contactDistance = enemy.radius
            + hero.radius
            + Balance::enemyContactPadding;
        if (distanceToHero > contactDistance && distanceToHero > 0.0f) {
            const float travelDistance = std::min(
                enemy.speed * deltaSeconds,
                distanceToHero - contactDistance);
            enemy.x += dx / distanceToHero * travelDistance;
            enemy.y += dy / distanceToHero * travelDistance;
            enemy.anim = AnimState::Walk;
            continue;
        }

        if (enemy.attackCooldown <= 0.0f) {
            world.m_hp -= enemy.damage;
            enemy.attackCooldown = enemy.attackInterval;
            enemy.attackAnimTime = Balance::bandit.attackAnimDuration;
            enemy.anim = AnimState::Attack;
        } else {
            enemy.anim = AnimState::Idle;
        }
    }
}
