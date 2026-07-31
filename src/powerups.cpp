#include "powerups.h"

#include "herostats.h"
#include "world.h"

#include <QCoreApplication>
#include <QVariantMap>

#include <algorithm>

namespace {

struct PowerupDefinition {
    PowerupId id;
    const char* name;
    const char* description;
    void (*apply)(HeroStats& stats, float& hp);
};

constexpr PowerupDefinition definitions[] = {
    { PowerupId::SharperBlade,
      QT_TRANSLATE_NOOP("Powerups", "Sharper Blade"),
      QT_TRANSLATE_NOOP("Powerups", "+25% attack damage"),
      [](HeroStats& stats, float&) { stats.damage *= 1.25f; } },
    { PowerupId::SwiftStrikes,
      QT_TRANSLATE_NOOP("Powerups", "Swift Strikes"),
      QT_TRANSLATE_NOOP("Powerups", "+20% attack speed"),
      [](HeroStats& stats, float&) { stats.attackRate *= 1.2f; } },
    { PowerupId::FleetFoot,
      QT_TRANSLATE_NOOP("Powerups", "Fleet Foot"),
      QT_TRANSLATE_NOOP("Powerups", "+12% movement speed"),
      [](HeroStats& stats, float&) {
          stats.moveSpeed *= 1.12f;
          stats.sprintSpeed *= 1.12f;
      } },
    { PowerupId::ToughSkin,
      QT_TRANSLATE_NOOP("Powerups", "Tough Skin"),
      QT_TRANSLATE_NOOP("Powerups", "+25 max health, heal 25"),
      [](HeroStats& stats, float& hp) {
          stats.maxHp += 25.0f;
          hp = std::min(stats.maxHp, hp + 25.0f);
      } },
    { PowerupId::Regeneration,
      QT_TRANSLATE_NOOP("Powerups", "Regeneration"),
      QT_TRANSLATE_NOOP("Powerups", "+1.5 health per second"),
      [](HeroStats& stats, float&) { stats.hpRegen += 1.5f; } },
    { PowerupId::ArcaneBattery,
      QT_TRANSLATE_NOOP("Powerups", "Arcane Battery"),
      QT_TRANSLATE_NOOP("Powerups", "+20 max mana, +2 mana per second"),
      [](HeroStats& stats, float&) {
          stats.maxMana += 20.0f;
          stats.manaRegen += 2.0f;
      } },
    { PowerupId::GreaterNova,
      QT_TRANSLATE_NOOP("Powerups", "Greater Nova"),
      QT_TRANSLATE_NOOP("Powerups", "+40% nova damage, +15% radius"),
      [](HeroStats& stats, float&) {
          stats.novaDamage *= 1.4f;
          stats.novaRadius *= 1.15f;
      } },
    { PowerupId::LongReach,
      QT_TRANSLATE_NOOP("Powerups", "Long Reach"),
      QT_TRANSLATE_NOOP("Powerups", "+20% attack range"),
      [](HeroStats& stats, float&) { stats.attackRange *= 1.2f; } },
};

const PowerupDefinition* definitionFor(PowerupId id)
{
    const auto match = std::find_if(
        std::cbegin(definitions), std::cend(definitions),
        [id](const PowerupDefinition& candidate) { return candidate.id == id; });
    return match != std::cend(definitions) ? &*match : nullptr;
}

QString translate(const char* sourceText)
{
    return QCoreApplication::translate("Powerups", sourceText);
}

} // namespace

Powerups::OfferList Powerups::offer(std::mt19937& rng, int count)
{
    OfferList pool;
    pool.reserve(std::size(definitions));
    for (const PowerupDefinition& definition : definitions) {
        pool.push_back({ definition.id,
                         translate(definition.name),
                         translate(definition.description) });
    }

    std::shuffle(pool.begin(), pool.end(), rng);
    pool.resize(std::min(pool.size(),
                         static_cast<std::size_t>(std::max(0, count))));
    return pool;
}

std::optional<PowerupId> Powerups::idFromInt(int value)
{
    const auto match = std::find_if(
        std::cbegin(definitions), std::cend(definitions),
        [value](const PowerupDefinition& candidate) {
            return static_cast<int>(candidate.id) == value;
        });
    return match != std::cend(definitions) ? std::optional<PowerupId>(match->id)
                                           : std::nullopt;
}

bool Powerups::contains(const OfferList& offers, PowerupId id)
{
    return std::any_of(
        offers.cbegin(), offers.cend(),
        [id](const PowerupOffer& offer) { return offer.id == id; });
}

bool Powerups::apply(PowerupId id, World& world)
{
    const PowerupDefinition* definition = definitionFor(id);
    if (!definition)
        return false;

    definition->apply(world.m_stats, world.m_hp);
    return true;
}

QVariantList Powerups::toVariantList(const OfferList& offers)
{
    QVariantList result;
    result.reserve(static_cast<qsizetype>(offers.size()));
    for (const PowerupOffer& offer : offers) {
        QVariantMap entry;
        entry.insert(QStringLiteral("id"), static_cast<int>(offer.id));
        entry.insert(QStringLiteral("name"), offer.name);
        entry.insert(QStringLiteral("description"), offer.description);
        result.append(entry);
    }
    return result;
}
