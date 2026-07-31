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
    m_maxHp = Balance::heroMaxHp;
    m_hp = m_maxHp;
    m_maxMana = Balance::heroMaxMana;
    m_mana = 30.0f;
    m_maxStamina = Balance::heroMaxStamina;
    m_stamina = m_maxStamina;
    m_xp = 0.0f;
    m_level = 1;
    m_kills = 0;
    m_elapsed = 0.0f;
    m_heroDead = false;
    m_sprintExhausted = false;

    m_input = {};
    m_heroAttackCooldown = 0.0f;
    m_enemyRespawnTime = 0.0f;
    m_nextSpawnOctant = 1;
    m_nextEntityId = 1;

    m_entities.clear();

    Entity heroEntity;
    heroEntity.id = m_nextEntityId++;
    heroEntity.kind = EntityKind::Hero;
    heroEntity.radius = Balance::heroRadius;
    heroEntity.hp = heroEntity.maxHp = m_maxHp;
    heroEntity.octant = 2;
    m_entities.push_back(heroEntity);

    spawnBanditAt(Balance::enemySpawnDistance, 0.0f);
}

World::StepEvents World::step(float deltaSeconds)
{
    StepEvents events;
    if (m_heroDead)
        return events;

    m_elapsed += deltaSeconds;
    MovementSystem::step(*this, deltaSeconds);
    CombatSystem::stepHeroAttack(*this, deltaSeconds);
    EnemyBehaviorSystem::step(*this, deltaSeconds);
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

void World::clearInput() noexcept
{
    m_input = {};
}

float World::xpToNext() const noexcept
{
    return Balance::xpBase
        + Balance::xpPerLevel * static_cast<float>(m_level - 1);
}

void World::spawnBanditAt(float x, float y)
{
    const Balance::EnemyDefinition& definition = Balance::bandit;

    Entity bandit;
    bandit.id = m_nextEntityId++;
    bandit.kind = definition.kind;
    bandit.x = x;
    bandit.y = y;
    bandit.radius = definition.radius;
    bandit.hp = bandit.maxHp = definition.hp;
    bandit.speed = definition.speed;
    bandit.damage = definition.damage;
    bandit.xpReward = definition.xpReward;
    bandit.attackInterval = definition.attackInterval;
    bandit.octant = 4;
    bandit.anim = AnimState::Walk;
    m_entities.push_back(bandit);
}
