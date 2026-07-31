#pragma once

#include "balance.h"

struct HeroStats {
    float maxHp = Balance::heroMaxHp;
    float hpRegen = Balance::heroHpRegen;
    float maxMana = Balance::heroMaxMana;
    float manaRegen = Balance::heroManaRegen;
    float maxStamina = Balance::heroMaxStamina;
    float damage = Balance::heroDamage;
    float attackRate = Balance::heroAttackRate;
    float attackRange = Balance::heroAttackRange;
    float moveSpeed = Balance::heroMoveSpeed;
    float sprintSpeed = Balance::heroSprintSpeed;
    float novaDamage = Balance::novaDamage;
    float novaRadius = Balance::novaRadius;
};
