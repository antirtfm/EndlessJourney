#include "worldsystems.h"

#include "balance.h"
#include "simulationmath.h"

#include <algorithm>
#include <cmath>
#include <iterator>
#include <random>

void SpawnSystem::step(World& world, float deltaSeconds)
{
    world.m_spawnTimer -= deltaSeconds;
    if (world.m_spawnTimer > 0.0f)
        return;

    world.m_spawnTimer = std::max(
        Balance::spawnIntervalMin,
        Balance::spawnIntervalStart
            - world.m_elapsed * Balance::spawnIntervalDecay);

    for (int remaining = spawnBatchSize(world.m_elapsed);
         remaining > 0 && enemyCount(world) < Balance::maxEnemies; --remaining) {
        spawnEnemy(world);
    }
}

int SpawnSystem::spawnBatchSize(float elapsed)
{
    return 1 + (elapsed > Balance::doubleSpawnTime ? 1 : 0)
        + (elapsed > Balance::tripleSpawnTime ? 1 : 0);
}

int SpawnSystem::enemyCount(const World& world)
{
    return static_cast<int>(std::count_if(
        world.m_entities.cbegin(), world.m_entities.cend(),
        [](const Entity& entity) { return isEnemy(entity); }));
}

const Balance::EnemyDefinition& SpawnSystem::pickDefinition(World& world)
{
    float totalWeight = 0.0f;
    for (const Balance::EnemyDefinition& definition : Balance::enemyRoster) {
        if (world.m_elapsed >= definition.unlockTime)
            totalWeight += definition.weight;
    }

    float roll = randomRange(world, 0.0f, totalWeight);
    for (const Balance::EnemyDefinition& definition : Balance::enemyRoster) {
        if (world.m_elapsed < definition.unlockTime)
            continue;
        roll -= definition.weight;
        if (roll <= 0.0f)
            return definition;
    }
    return *std::cbegin(Balance::enemyRoster);
}

void SpawnSystem::spawnEnemy(World& world)
{
    const Balance::EnemyDefinition& definition = pickDefinition(world);
    const Entity& hero = world.hero();
    const float angle = randomRange(world, 0.0f, 2.0f * SimulationMath::pi);
    const float scale = 1.0f
        + Balance::enemyScaleStep * (world.m_elapsed / Balance::enemyScaleWindow);

    Entity enemy;
    enemy.id = world.m_nextEntityId++;
    enemy.kind = definition.kind;
    enemy.x = hero.x + std::cos(angle) * Balance::enemySpawnDistance;
    enemy.y = hero.y + std::sin(angle) * Balance::enemySpawnDistance;
    enemy.radius = definition.radius;
    enemy.hp = enemy.maxHp = definition.hp * scale;
    enemy.speed = definition.speed;
    enemy.damage = definition.damage * scale;
    enemy.xpReward = definition.xpReward;
    enemy.attackInterval = definition.attackInterval;
    enemy.attackAnimDuration = definition.attackAnimDuration;
    enemy.ranged = definition.ranged;
    enemy.octant = SimulationMath::octantFromDirection(
        hero.x - enemy.x, hero.y - enemy.y, 2);
    enemy.anim = AnimState::Walk;
    world.m_entities.push_back(enemy);
}

float SpawnSystem::randomRange(World& world, float min, float max)
{
    std::uniform_real_distribution<float> distribution(min, max);
    return distribution(world.m_rng);
}
