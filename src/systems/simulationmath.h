#pragma once

#include "entity.h"

#include <cmath>
#include <numbers>

namespace SimulationMath {

inline constexpr float pi = std::numbers::pi_v<float>;

inline int octantFromDirection(float dx, float dy, int fallback) noexcept
{
    if (dx == 0.0f && dy == 0.0f)
        return fallback;

    const float sector = std::atan2(dy, dx) / (pi / 4.0f);
    return (static_cast<int>(std::lround(sector)) % 8 + 8) % 8;
}

inline float distance(const Entity& first, const Entity& second) noexcept
{
    return std::hypot(first.x - second.x, first.y - second.y);
}

} // namespace SimulationMath
