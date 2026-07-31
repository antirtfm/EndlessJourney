#pragma once

#include "world.h"

class MovementSystem final {
public:
    static void step(World& world, float deltaSeconds);

private:
    MovementSystem() = delete;
};

class CombatSystem final {
public:
    static void stepHeroAttack(World& world, float deltaSeconds);
    static void stepNova(World& world, float deltaSeconds,
                         World::StepEvents& events);
    static void resolveDeaths(World& world, World::StepEvents& events);

private:
    CombatSystem() = delete;
};

class EnemyBehaviorSystem final {
public:
    static void step(World& world, float deltaSeconds);

private:
    EnemyBehaviorSystem() = delete;
};

class SpawnSystem final {
public:
    static void step(World& world, float deltaSeconds);

private:
    SpawnSystem() = delete;
};

class ProgressionSystem final {
public:
    static void step(World& world, World::StepEvents& events);

private:
    ProgressionSystem() = delete;
};
