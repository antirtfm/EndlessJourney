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

// The run opens with exactly one nova in the tank.
inline constexpr float heroStartMana = novaManaCost;

struct EnemyDefinition {
    EntityKind kind;
    float hp;
    float speed;
    float damage;
    float radius;
    float xpReward;
    float attackInterval;
    float attackAnimDuration;
};

inline constexpr EnemyDefinition bandit {
    EntityKind::Bandit,
    30.0f,
    55.0f,
    10.0f,
    13.0f,
    3.0f,
    0.9f,
    12.0f / 15.0f,
};

inline constexpr float enemyContactPadding = 2.0f;
inline constexpr float enemyRespawnDelay = 1.25f;
inline constexpr float enemySpawnDistance = 180.0f;

inline constexpr float xpBase = 10.0f;
inline constexpr float xpPerLevel = 8.0f;
inline constexpr int powerupRerolls = 2;

} // namespace Balance
