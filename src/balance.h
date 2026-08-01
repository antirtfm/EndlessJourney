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
    float weight; // relative chance of being picked for a spawn
    bool ranged;
};

inline constexpr EnemyDefinition enemyRoster[] = {
    // kind                   hp     speed   damage radius xp    interval animation      weight ranged
    { EntityKind::Bandit,     30.0f, 55.0f,  10.0f, 13.0f, 3.0f, 0.9f,    12.0f / 15.0f, 40.0f, false },
    { EntityKind::Goblin,     10.0f, 90.0f,  4.0f,  9.0f,  2.0f, 0.5f,    12.0f / 15.0f, 24.0f, false },
    { EntityKind::Wolf,       14.0f, 105.0f, 5.0f,  10.0f, 2.0f, 0.55f,   12.0f / 15.0f, 25.0f, false },
    { EntityKind::BanditBow,  24.0f, 50.0f,  8.0f,  12.0f, 4.0f, 1.8f,    12.0f / 12.0f, 15.0f, true },
};

inline constexpr float enemyContactPadding = 2.0f;
// Past the corner of the 480x320 scene, so enemies never appear on camera.
inline constexpr float enemySpawnDistance = 340.0f;
inline constexpr float spawnInterval = 2.2f;
inline constexpr int maxEnemies = 60;

inline constexpr float xpBase = 10.0f;
inline constexpr float xpPerLevel = 8.0f;
inline constexpr int powerupRerolls = 2;

} // namespace Balance
