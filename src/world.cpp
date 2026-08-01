#include "world.h"

#include "balance.h"
#include "systems/worldsystems.h"

#include <algorithm>

World::World()
{
    reset();
}

void World::reset()
{
    m_stats = {};
    m_hp = m_stats.maxHp;
    m_mana = Balance::heroStartMana;
    m_stamina = m_stats.maxStamina;
    m_xp = 0.0f;
    m_level = 1;
    m_kills = 0;
    m_elapsed = 0.0f;
    m_heroDead = false;
    m_sprintExhausted = false;

    m_input = {};
    m_heroAttackCooldown = 0.0f;
    m_spawnTimer = Balance::spawnInterval;
    m_nextEntityId = 1;

    m_entities.clear();

    Entity heroEntity;
    heroEntity.id = m_nextEntityId++;
    heroEntity.kind = EntityKind::Hero;
    heroEntity.radius = Balance::heroRadius;
    heroEntity.hp = heroEntity.maxHp = m_stats.maxHp;
    heroEntity.octant = 2;
    m_entities.push_back(heroEntity);
}

World::StepEvents World::step(float deltaSeconds)
{
    StepEvents events;
    if (m_heroDead)
        return events;

    m_elapsed += deltaSeconds;
    stepHeroResources(deltaSeconds);
    MovementSystem::step(*this, deltaSeconds);
    CombatSystem::stepHeroAttack(*this, deltaSeconds);
    CombatSystem::stepNova(*this, events);
    EnemyBehaviorSystem::step(*this, deltaSeconds);
    CombatSystem::stepProjectiles(*this, deltaSeconds);
    SpawnSystem::step(*this, deltaSeconds);
    CombatSystem::resolveDeaths(*this, events);
    ProgressionSystem::step(*this, events);
    return events;
}

void World::setMoveInput(float x, float y) noexcept
{
    m_input.moveX = std::clamp(x, -1.0f, 1.0f);
    m_input.moveY = std::clamp(y, -1.0f, 1.0f);
}

void World::setSprint(bool sprinting) noexcept
{
    m_input.sprint = sprinting;
}

void World::requestNova() noexcept
{
    m_input.castNova = true;
}

void World::clearInput() noexcept
{
    m_input = {};
}

float World::xpToNext() const noexcept
{
    return Balance::xpBase
        + Balance::xpPerLevel * static_cast<float>(m_level - 1);
}

void World::stepHeroResources(float deltaSeconds)
{
    m_hp = std::min(m_stats.maxHp, m_hp + m_stats.hpRegen * deltaSeconds);
    m_mana = std::min(m_stats.maxMana, m_mana + m_stats.manaRegen * deltaSeconds);
}

