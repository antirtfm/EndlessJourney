#include "entitymodel.h"

#include "entity.h"
#include "world.h"

#include <unordered_set>

namespace {

QString kindName(EntityKind kind)
{
    switch (kind) {
    case EntityKind::Hero:
        return QStringLiteral("hero");
    case EntityKind::Bandit:
        return QStringLiteral("bandit");
    case EntityKind::Goblin:
        return QStringLiteral("goblin");
    case EntityKind::Wolf:
        return QStringLiteral("wolf");
    case EntityKind::Slime:
        return QStringLiteral("slime");
    case EntityKind::BanditBow:
        return QStringLiteral("banditBow");
    case EntityKind::Skeleton:
        return QStringLiteral("skeleton");
    case EntityKind::Orc:
        return QStringLiteral("orc");
    case EntityKind::DarkElf:
        return QStringLiteral("darkElf");
    case EntityKind::FlyingDemon:
        return QStringLiteral("flyingDemon");
    case EntityKind::DarkAngel:
        return QStringLiteral("darkAngel");
    case EntityKind::Treant:
        return QStringLiteral("treant");
    case EntityKind::Dragon:
        return QStringLiteral("dragon");
    case EntityKind::Arrow:
        return QStringLiteral("arrow");
    }
    return {};
}

QString animationName(AnimState animation)
{
    switch (animation) {
    case AnimState::Idle:
        return QStringLiteral("idle");
    case AnimState::Walk:
        return QStringLiteral("walk");
    case AnimState::Run:
        return QStringLiteral("run");
    case AnimState::Attack:
        return QStringLiteral("attack");
    case AnimState::Die:
        return QStringLiteral("die");
    }
    return {};
}

} // namespace

EntityModel::EntityModel(World* world, QObject* parent)
    : QAbstractListModel(parent)
    , m_world(world)
{
}

void EntityModel::rebuildIdIndex()
{
    m_idToIndex.clear();
    const auto& entities = m_world->entities();
    m_idToIndex.reserve(entities.size());
    for (std::size_t index = 0; index < entities.size(); ++index)
        m_idToIndex.emplace(entities[index].id, index);
}

void EntityModel::resetRows()
{
    beginResetModel();
    m_ids.clear();
    for (const Entity& entity : m_world->entities())
        m_ids.push_back(entity.id);
    rebuildIdIndex();
    endResetModel();
}

void EntityModel::sync()
{
    rebuildIdIndex();

    std::unordered_set<int> liveIds;
    liveIds.reserve(m_world->entities().size());
    for (const Entity& entity : m_world->entities())
        liveIds.insert(entity.id);

    for (int row = static_cast<int>(m_ids.size()) - 1; row >= 0; --row) {
        if (!liveIds.contains(m_ids[static_cast<std::size_t>(row)])) {
            beginRemoveRows({}, row, row);
            m_ids.erase(m_ids.begin() + row);
            endRemoveRows();
        }
    }

    std::unordered_set<int> knownIds(m_ids.cbegin(), m_ids.cend());
    for (const Entity& entity : m_world->entities()) {
        if (knownIds.contains(entity.id))
            continue;

        const int row = static_cast<int>(m_ids.size());
        beginInsertRows({}, row, row);
        m_ids.push_back(entity.id);
        endInsertRows();
    }

    if (!m_ids.empty()) {
        emit dataChanged(
            index(0), index(static_cast<int>(m_ids.size()) - 1),
            { WorldXRole, WorldYRole, OctantRole, AnimationRole, HpRatioRole });
    }
}

int EntityModel::rowCount(const QModelIndex& parent) const
{
    return parent.isValid() ? 0 : static_cast<int>(m_ids.size());
}

QVariant EntityModel::data(const QModelIndex& index, int role) const
{
    const Entity* entity = entityForRow(index.row());
    if (!entity)
        return {};

    switch (role) {
    case KindRole:
        return kindName(entity->kind);
    case WorldXRole:
        return entity->x;
    case WorldYRole:
        return entity->y;
    case OctantRole:
        return entity->octant;
    case AnimationRole:
        return animationName(entity->anim);
    case HpRatioRole:
        return entity->maxHp > 0.0f ? entity->hp / entity->maxHp : 0.0f;
    }
    return {};
}

QHash<int, QByteArray> EntityModel::roleNames() const
{
    return {
        { KindRole, QByteArrayLiteral("kind") },
        { WorldXRole, QByteArrayLiteral("worldX") },
        { WorldYRole, QByteArrayLiteral("worldY") },
        { OctantRole, QByteArrayLiteral("octant") },
        { AnimationRole, QByteArrayLiteral("animationName") },
        { HpRatioRole, QByteArrayLiteral("hpRatio") },
    };
}

const Entity* EntityModel::entityForRow(int row) const
{
    if (row < 0 || row >= static_cast<int>(m_ids.size()))
        return nullptr;

    const int id = m_ids[static_cast<std::size_t>(row)];
    const auto match = m_idToIndex.find(id);
    if (match == m_idToIndex.cend())
        return nullptr;

    return &m_world->entities()[match->second];
}
