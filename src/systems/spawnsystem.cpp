#include "worldsystems.h"

#include "balance.h"
#include "simulationmath.h"

#include <algorithm>
#include <cmath>

void SpawnSystem::step(World& world, float deltaSeconds)
{
    const bool enemyPresent = std::any_of(
        world.m_entities.cbegin(), world.m_entities.cend(),
        [](const Entity& entity) { return isEnemy(entity); });
    if (enemyPresent)
        return;

    world.m_enemyRespawnTime = std::max(
        0.0f, world.m_enemyRespawnTime - deltaSeconds);
    if (world.m_enemyRespawnTime > 0.0f)
        return;

    const float angle = static_cast<float>(world.m_nextSpawnOctant)
        * SimulationMath::pi / 4.0f;
    const Entity& hero = world.hero();
    const float spawnX = hero.x
        + std::cos(angle) * Balance::enemySpawnDistance;
    const float spawnY = hero.y
        + std::sin(angle) * Balance::enemySpawnDistance;

    world.spawnBanditAt(spawnX, spawnY);
    world.m_nextSpawnOctant = (world.m_nextSpawnOctant + 1) % 8;
}
