#include "worldsystems.h"

#include "balance.h"
#include "simulationmath.h"

#include <algorithm>
#include <cmath>
#include <iterator>
#include <random>

void SpawnSystem::step(World& world, float deltaSeconds)
{
    if (enemyCount(world) >= Balance::maxEnemies)
        return;

    world.m_spawnTimer -= deltaSeconds;
    if (world.m_spawnTimer > 0.0f)
        return;

    world.m_spawnTimer = Balance::spawnInterval;
    spawnEnemy(world);
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
    for (const Balance::EnemyDefinition& definition : Balance::enemyRoster)
        totalWeight += definition.weight;

    float roll = randomRange(world, 0.0f, totalWeight);
    for (const Balance::EnemyDefinition& definition : Balance::enemyRoster) {
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

    Entity enemy;
    enemy.id = world.m_nextEntityId++;
    enemy.kind = definition.kind;
    enemy.x = hero.x + std::cos(angle) * Balance::enemySpawnDistance;
    enemy.y = hero.y + std::sin(angle) * Balance::enemySpawnDistance;
    enemy.radius = definition.radius;
    enemy.hp = enemy.maxHp = definition.hp;
    enemy.speed = definition.speed;
    enemy.damage = definition.damage;
    enemy.xpReward = definition.xpReward;
    enemy.attackInterval = definition.attackInterval;
    enemy.attackAnimDuration = definition.attackAnimDuration;
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
