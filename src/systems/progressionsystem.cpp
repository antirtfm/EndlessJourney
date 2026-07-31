#include "worldsystems.h"

void ProgressionSystem::step(World& world, World::StepEvents& events)
{
    while (world.m_xp >= world.xpToNext()) {
        world.m_xp -= world.xpToNext();
        ++world.m_level;
        ++events.levelsGained;
    }
}
