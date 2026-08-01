#include "worldsystems.h"

#include "balance.h"
#include "simulationmath.h"

#include <algorithm>
#include <cmath>
#include <vector>

void EnemyBehaviorSystem::step(World& world, float deltaSeconds)
{
    Entity& hero = world.hero();

    // Arrows are appended after the loop; growing the vector inside it would
    // invalidate the reference to the enemy that fired.
    std::vector<Entity> firedArrows;

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

        if (enemy.ranged) {
            stepRangedEnemy(world, enemy, deltaSeconds, distanceToHero, dx, dy,
                            firedArrows);
            continue;
        }

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
            enemy.attackAnimTime = enemy.attackAnimDuration;
            enemy.anim = AnimState::Attack;
        } else {
            enemy.anim = AnimState::Idle;
        }
    }

    world.m_entities.insert(
        world.m_entities.end(), firedArrows.cbegin(), firedArrows.cend());
}

void EnemyBehaviorSystem::stepRangedEnemy(World& world, Entity& enemy,
                                          float deltaSeconds,
                                          float distanceToHero, float dx,
                                          float dy,
                                          std::vector<Entity>& firedArrows)
{
    if (enemy.shotPending && enemy.attackAnimTime <= 0.0f) {
        enemy.shotPending = false;
        const float direction = std::max(0.001f, distanceToHero);

        Entity arrow;
        arrow.id = world.m_nextEntityId++;
        arrow.kind = EntityKind::Arrow;
        arrow.x = enemy.x;
        arrow.y = enemy.y - Balance::arrowSpawnOffset;
        arrow.vx = dx / direction * Balance::arrowSpeed;
        arrow.vy = dy / direction * Balance::arrowSpeed;
        arrow.radius = Balance::arrowRadius;
        arrow.damage = enemy.damage;
        arrow.lifetime = Balance::arrowLifetime;
        arrow.octant = SimulationMath::octantFromDirection(dx, dy, 0);
        firedArrows.push_back(arrow);
    }

    if (distanceToHero > Balance::bowRange) {
        if (distanceToHero > 0.0f) {
            const float travelDistance = std::min(
                enemy.speed * deltaSeconds,
                distanceToHero - Balance::bowRange);
            enemy.x += dx / distanceToHero * travelDistance;
            enemy.y += dy / distanceToHero * travelDistance;
        }
        enemy.anim = enemy.attackAnimTime > 0.0f ? AnimState::Attack
                                                 : AnimState::Walk;
        return;
    }

    if (!enemy.shotPending && enemy.attackCooldown <= 0.0f) {
        enemy.attackCooldown = enemy.attackInterval;
        enemy.attackAnimTime = enemy.attackAnimDuration;
        enemy.shotPending = true;
    }

    enemy.anim = enemy.attackAnimTime > 0.0f ? AnimState::Attack
                                             : AnimState::Idle;
}
