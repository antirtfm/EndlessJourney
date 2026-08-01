#pragma once

#include <QAbstractListModel>
#include <QtQml/qqmlregistration.h>

#include <unordered_map>
#include <vector>

class World;
struct Entity;

class EntityModel final : public QAbstractListModel {
    Q_OBJECT
    QML_ANONYMOUS

public:
    enum Roles {
        KindRole = Qt::UserRole + 1,
        WorldXRole,
        WorldYRole,
        OctantRole,
        AnimationRole,
        HpRatioRole,
    };

    explicit EntityModel(World* world, QObject* parent = nullptr);

    void sync();
    void resetRows();

    int rowCount(const QModelIndex& parent = {}) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    const Entity* entityForRow(int row) const;
    void rebuildIdIndex();

    World* m_world = nullptr;
    std::vector<int> m_ids;
    std::unordered_map<int, std::size_t> m_idToIndex;
};
