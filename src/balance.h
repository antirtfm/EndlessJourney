#pragma once

#include "entity.h"

namespace Balance {

inline constexpr float fixedStep = 1.0f / 60.0f;
inline constexpr float maxFrameTime = 0.1f;

inline constexpr float heroMaxHp = 100.0f;
inline constexpr float heroHpRegen = 0.0f;
inline constexpr float heroMoveSpeed = 120.0f;
inline constexpr float heroSprintSpeed = 185.0f;
inline constexpr float heroRadius = 12.0f;
inline constexpr float heroDamage = 12.0f;
inline constexpr float heroAttackRate = 1.4f;
inline constexpr float heroAttackRange = 78.0f;
inline constexpr float heroAttackAnimDuration = 0.35f;
inline constexpr float heroDeathAnimDuration = 27.0f / 7.0f;
inline constexpr float heroMaxMana = 50.0f;
inline constexpr float heroManaRegen = 4.0f;
inline constexpr float heroMaxStamina = 100.0f;
inline constexpr float staminaDrain = 30.0f;
inline constexpr float staminaRegen = 18.0f;
inline constexpr float staminaRecoveryThreshold = 20.0f;

inline constexpr float novaManaCost = 30.0f;
inline constexpr float novaDamage = 45.0f;
inline constexpr float novaRadius = 95.0f;

inline constexpr float heroStartMana = novaManaCost;

inline constexpr float bowRange = 150.0f;
inline constexpr float arrowSpeed = 200.0f;
inline constexpr float arrowRadius = 4.0f;
inline constexpr float arrowLifetime = 1.4f;
inline constexpr float arrowSpawnOffset = 10.0f; // leaves the bow, not the feet

struct EnemyDefinition {
    EntityKind kind;
    float hp;
    float speed;
    float damage;
    float radius;
    float xpReward;
    float attackInterval;
    float attackAnimDuration;
    float weight;     // relative chance of being picked for a spawn
    float unlockTime; // seconds into the run before it can appear
    bool ranged;
};

inline constexpr EnemyDefinition enemyRoster[] = {
    // kind                    hp      speed   damage radius xp     interval animation      weight unlock  ranged
    { EntityKind::Bandit,      30.0f,  55.0f,  10.0f, 13.0f, 3.0f,  0.9f,    12.0f / 15.0f, 40.0f, 0.0f,   false },
    { EntityKind::Goblin,      10.0f,  90.0f,  4.0f,  9.0f,  2.0f,  0.5f,    12.0f / 15.0f, 24.0f, 0.0f,   false },
    { EntityKind::Wolf,        14.0f,  105.0f, 5.0f,  10.0f, 2.0f,  0.55f,   12.0f / 15.0f, 25.0f, 0.0f,   false },
    { EntityKind::Slime,       18.0f,  35.0f,  6.0f,  10.0f, 2.0f,  1.0f,    12.0f / 12.0f, 20.0f, 30.0f,  false },
    { EntityKind::BanditBow,   24.0f,  50.0f,  8.0f,  12.0f, 4.0f,  1.8f,    12.0f / 12.0f, 15.0f, 60.0f,  true },
    { EntityKind::Skeleton,    26.0f,  60.0f,  9.0f,  12.0f, 3.0f,  0.8f,    12.0f / 14.0f, 22.0f, 90.0f,  false },
    { EntityKind::Orc,         70.0f,  40.0f,  18.0f, 15.0f, 6.0f,  1.2f,    12.0f / 12.0f, 13.0f, 120.0f, false },
    { EntityKind::DarkElf,     20.0f,  115.0f, 12.0f, 11.0f, 4.0f,  0.6f,    12.0f / 15.0f, 12.0f, 150.0f, false },
    { EntityKind::FlyingDemon, 30.0f,  85.0f,  10.0f, 12.0f, 5.0f,  0.7f,    12.0f / 14.0f, 12.0f, 180.0f, false },
    { EntityKind::DarkAngel,   90.0f,  55.0f,  20.0f, 14.0f, 10.0f, 1.0f,    14.0f / 14.0f, 8.0f,  240.0f, false },
    { EntityKind::Treant,      140.0f, 25.0f,  24.0f, 18.0f, 12.0f, 1.5f,    14.0f / 12.0f, 6.0f,  300.0f, false },
    { EntityKind::Dragon,      200.0f, 50.0f,  30.0f, 20.0f, 25.0f, 1.2f,    16.0f / 14.0f, 4.0f,  360.0f, false },
};

inline constexpr float enemyContactPadding = 2.0f;
// Past the corner of the 480x320 scene, so enemies never appear on camera.
inline constexpr float enemySpawnDistance = 340.0f;
inline constexpr int maxEnemies = 100;

// Spawns start slow and creep faster; enemies get tougher over time.
inline constexpr float spawnIntervalStart = 2.2f;
inline constexpr float spawnIntervalMin = 0.45f;
inline constexpr float spawnIntervalDecay = 0.006f; // seconds shaved per elapsed second
inline constexpr float enemyScaleStep = 0.10f;      // +10% hp and damage ...
inline constexpr float enemyScaleWindow = 30.0f;    // ... every 30 seconds
inline constexpr float doubleSpawnTime = 60.0f;
inline constexpr float tripleSpawnTime = 150.0f;

inline constexpr float xpBase = 10.0f;
inline constexpr float xpPerLevel = 8.0f;
inline constexpr int powerupRerolls = 2;

} // namespace Balance
