#pragma once

#include "world.h"

#include <vector>

class MovementSystem final {
public:
    static void step(World& world, float deltaSeconds);

private:
    MovementSystem() = delete;
};

class CombatSystem final {
public:
    static void stepHeroAttack(World& world, float deltaSeconds);
    static void stepNova(World& world, World::StepEvents& events);
    static void stepProjectiles(World& world, float deltaSeconds);
    static void resolveDeaths(World& world, World::StepEvents& events);

private:
    CombatSystem() = delete;
};

class EnemyBehaviorSystem final {
public:
    static void step(World& world, float deltaSeconds);

private:
    EnemyBehaviorSystem() = delete;

    static void stepRangedEnemy(World& world, Entity& enemy, float deltaSeconds,
                                float distanceToHero, float dx, float dy,
                                std::vector<Entity>& firedArrows);
};

class SpawnSystem final {
public:
    static void step(World& world, float deltaSeconds);

private:
    SpawnSystem() = delete;

    static int enemyCount(const World& world);
    static int spawnBatchSize(float elapsed);
    static const Balance::EnemyDefinition& pickDefinition(World& world);
    static void spawnEnemy(World& world);
    static float randomRange(World& world, float min, float max);
};

class ProgressionSystem final {
public:
    static void step(World& world, World::StepEvents& events);

private:
    ProgressionSystem() = delete;
};
