#pragma once

#include <cstdint>

enum class EntityKind : std::uint8_t {
    Hero,
    Bandit,
    Goblin,
    Wolf,
    Slime,
    BanditBow,
    Skeleton,
    Orc,
    DarkElf,
    FlyingDemon,
    DarkAngel,
    Treant,
    Dragon,
    Arrow,
};

enum class AnimState : std::uint8_t {
    Idle,
    Walk,
    Run,
    Attack,
    Die,
};

struct Entity {
    int id = 0;
    EntityKind kind = EntityKind::Bandit;
    float x = 0.0f;
    float y = 0.0f;
    float radius = 12.0f;
    float hp = 1.0f;
    float maxHp = 1.0f;
    float speed = 0.0f;
    float damage = 0.0f;
    float xpReward = 0.0f;
    float attackInterval = 1.0f;
    float attackCooldown = 0.0f;
    float attackAnimTime = 0.0f;
    float attackAnimDuration = 0.0f;
    float vx = 0.0f; // projectiles fly on a fixed velocity
    float vy = 0.0f;
    float lifetime = 0.0f; // projectiles expire when this runs out
    bool ranged = false;   // keeps its distance and shoots instead of closing
    bool shotPending = false; // drawing a bow, releases when the draw finishes
    int octant = 2;
    AnimState anim = AnimState::Idle;
};

constexpr bool isProjectile(const Entity& entity) noexcept
{
    return entity.kind == EntityKind::Arrow;
}

constexpr bool isEnemy(const Entity& entity) noexcept
{
    return entity.kind != EntityKind::Hero && !isProjectile(entity);
}
