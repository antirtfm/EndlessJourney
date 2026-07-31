#pragma once

#include "entity.h"
#include "herostats.h"

#include <optional>
#include <vector>

class CombatSystem;
class EnemyBehaviorSystem;
class MovementSystem;
class Powerups;
class ProgressionSystem;
class SpawnSystem;

class World final {
public:
    struct Input {
        float moveX = 0.0f;
        float moveY = 0.0f;
        bool sprint = false;
        bool castNova = false;
    };

    struct NovaBlast {
        float x = 0.0f;
        float y = 0.0f;
        float radius = 0.0f;
    };

    struct StepEvents {
        int enemiesDied = 0;
        int levelsGained = 0;
        bool heroDied = false;
        std::optional<NovaBlast> novaBlast;
    };

    World();

    void reset();
    StepEvents step(float deltaSeconds);
    void setMoveInput(float x, float y) noexcept;
    void setSprint(bool sprinting) noexcept;
    void requestNova() noexcept;
    void clearInput() noexcept;

    float xpToNext() const noexcept;

    const std::vector<Entity>& entities() const noexcept { return m_entities; }
    const Entity& hero() const { return m_entities.front(); }
    const HeroStats& stats() const noexcept { return m_stats; }

    float hp() const noexcept { return m_hp; }
    float maxHp() const noexcept { return m_stats.maxHp; }
    float mana() const noexcept { return m_mana; }
    float maxMana() const noexcept { return m_stats.maxMana; }
    float stamina() const noexcept { return m_stamina; }
    float maxStamina() const noexcept { return m_stats.maxStamina; }
    float xp() const noexcept { return m_xp; }
    int level() const noexcept { return m_level; }
    int kills() const noexcept { return m_kills; }
    float elapsed() const noexcept { return m_elapsed; }
    bool heroDead() const noexcept { return m_heroDead; }

private:
    friend class CombatSystem;
    friend class EnemyBehaviorSystem;
    friend class MovementSystem;
    friend class Powerups;
    friend class ProgressionSystem;
    friend class SpawnSystem;

    Entity& hero() { return m_entities.front(); }
    void spawnBanditAt(float x, float y);
    void stepHeroResources(float deltaSeconds);

    std::vector<Entity> m_entities;
    Input m_input;
    HeroStats m_stats;

    float m_hp = 0.0f;
    float m_mana = 0.0f;
    float m_stamina = 0.0f;
    float m_xp = 0.0f;
    int m_level = 1;
    int m_kills = 0;
    float m_elapsed = 0.0f;
    bool m_heroDead = false;
    bool m_sprintExhausted = false;

    float m_heroAttackCooldown = 0.0f;
    float m_enemyRespawnTime = 0.0f;
    int m_nextSpawnOctant = 1;
    int m_nextEntityId = 1;
};
