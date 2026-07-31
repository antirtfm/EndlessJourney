#pragma once

#include <QString>
#include <QVariantList>

#include <optional>
#include <random>
#include <vector>

class World;

enum class PowerupId : int {
    SharperBlade = 1,
    SwiftStrikes,
    FleetFoot,
    ToughSkin,
    Regeneration,
    ArcaneBattery,
    GreaterNova,
    LongReach,
};

struct PowerupOffer {
    PowerupId id;
    QString name;
    QString description;
};

class Powerups final {
public:
    using OfferList = std::vector<PowerupOffer>;

    static OfferList offer(std::mt19937& rng, int count = 3);
    static std::optional<PowerupId> idFromInt(int value);
    static bool contains(const OfferList& offers, PowerupId id);
    static bool apply(PowerupId id, World& world);

    static QVariantList toVariantList(const OfferList& offers);

private:
    Powerups() = delete;
};
