#include "worldsystems.h"

#include "balance.h"
#include "simulationmath.h"

#include <algorithm>
#include <cmath>

void MovementSystem::step(World& world, float deltaSeconds)
{
    Entity& hero = world.hero();
    hero.attackAnimTime = std::max(
        0.0f, hero.attackAnimTime - deltaSeconds);

    float moveX = world.m_input.moveX;
    float moveY = world.m_input.moveY;
    const float inputLength = std::hypot(moveX, moveY);
    const bool moving = inputLength > 0.0f;
    if (inputLength > 1.0f) {
        moveX /= inputLength;
        moveY /= inputLength;
    }

    const bool sprinting = moving
        && world.m_input.sprint
        && world.m_stamina > 0.0f
        && !world.m_sprintExhausted;

    if (moving) {
        const float speed = sprinting
            ? Balance::heroSprintSpeed
            : Balance::heroMoveSpeed;
        hero.x += moveX * speed * deltaSeconds;
        hero.y += moveY * speed * deltaSeconds;

        if (hero.attackAnimTime <= 0.0f) {
            hero.octant = SimulationMath::octantFromDirection(
                moveX, moveY, hero.octant);
        }
    }

    if (sprinting) {
        world.m_stamina = std::max(
            0.0f,
            world.m_stamina - Balance::staminaDrain * deltaSeconds);
        if (world.m_stamina <= 0.0f)
            world.m_sprintExhausted = true;
    } else {
        world.m_stamina = std::min(
            world.m_maxStamina,
            world.m_stamina + Balance::staminaRegen * deltaSeconds);
        if (world.m_stamina >= Balance::staminaRecoveryThreshold)
            world.m_sprintExhausted = false;
    }

    if (hero.attackAnimTime > 0.0f)
        hero.anim = AnimState::Attack;
    else if (sprinting)
        hero.anim = AnimState::Run;
    else if (moving)
        hero.anim = AnimState::Walk;
    else
        hero.anim = AnimState::Idle;

    hero.hp = world.m_hp;
}
