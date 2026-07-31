#pragma once

#include "entitymodel.h"
#include "gamestatemachine.h"
#include "powerups.h"
#include "world.h"

#include <QObject>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

#include <random>

class GameEngine : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(GameState::Value state READ state NOTIFY stateChanged)
    Q_PROPERTY(EntityModel* entityModel READ entityModel CONSTANT)
    Q_PROPERTY(QVariantList offeredPowerups READ offeredPowerups NOTIFY offeredPowerupsChanged)
    Q_PROPERTY(int powerupChoiceLevel READ powerupChoiceLevel NOTIFY offeredPowerupsChanged)
    Q_PROPERTY(int rerollsLeft READ rerollsLeft NOTIFY offeredPowerupsChanged)
    Q_PROPERTY(qreal heroX READ heroX NOTIFY frameUpdated)
    Q_PROPERTY(qreal heroY READ heroY NOTIFY frameUpdated)
    Q_PROPERTY(qreal hp READ hp NOTIFY frameUpdated)
    Q_PROPERTY(qreal maxHp READ maxHp NOTIFY frameUpdated)
    Q_PROPERTY(qreal mana READ mana NOTIFY frameUpdated)
    Q_PROPERTY(qreal maxMana READ maxMana NOTIFY frameUpdated)
    Q_PROPERTY(qreal stamina READ stamina NOTIFY frameUpdated)
    Q_PROPERTY(qreal maxStamina READ maxStamina NOTIFY frameUpdated)
    Q_PROPERTY(qreal xp READ xp NOTIFY frameUpdated)
    Q_PROPERTY(qreal xpToNext READ xpToNext NOTIFY frameUpdated)
    Q_PROPERTY(int level READ level NOTIFY frameUpdated)
    Q_PROPERTY(int kills READ kills NOTIFY frameUpdated)
    Q_PROPERTY(qreal elapsed READ elapsed NOTIFY frameUpdated)

public:
    explicit GameEngine(QObject* parent = nullptr);

    GameState::Value state() const noexcept { return m_stateMachine.state(); }
    EntityModel* entityModel() noexcept { return &m_entityModel; }
    QVariantList offeredPowerups() const { return Powerups::toVariantList(m_offeredPowerups); }
    int powerupChoiceLevel() const noexcept { return m_powerupChoiceLevel; }
    int rerollsLeft() const noexcept { return m_rerollsLeft; }

    qreal heroX() const noexcept { return m_world.hero().x; }
    qreal heroY() const noexcept { return m_world.hero().y; }
    qreal hp() const noexcept { return m_world.hp(); }
    qreal maxHp() const noexcept { return m_world.maxHp(); }
    qreal mana() const noexcept { return m_world.mana(); }
    qreal maxMana() const noexcept { return m_world.maxMana(); }
    qreal stamina() const noexcept { return m_world.stamina(); }
    qreal maxStamina() const noexcept { return m_world.maxStamina(); }
    qreal xp() const noexcept { return m_world.xp(); }
    qreal xpToNext() const noexcept { return m_world.xpToNext(); }
    int level() const noexcept { return m_world.level(); }
    int kills() const noexcept { return m_world.kills(); }
    qreal elapsed() const noexcept { return m_world.elapsed(); }

    Q_INVOKABLE void newGame();
    Q_INVOKABLE void advance(qreal deltaMilliseconds);
    Q_INVOKABLE void setMoveInput(qreal x, qreal y);
    Q_INVOKABLE void setSprint(bool sprinting);
    Q_INVOKABLE void castNova();
    Q_INVOKABLE void selectPowerup(int id);
    Q_INVOKABLE void rerollPowerups();
    Q_INVOKABLE void quitToMenu();

signals:
    void stateChanged();
    void frameUpdated();
    void runStarted();
    void leveledUp(int newLevel);
    void novaFired(qreal x, qreal y, qreal radius);
    void offeredPowerupsChanged();

private:
    void advancePlaying(qreal deltaSeconds);
    void advanceDying(qreal deltaSeconds);
    void beginHeroDeath();
    void beginLevelUp(int levelsGained);
    void offerNextPowerupChoice();
    bool clearLevelUpState();

    World m_world;
    EntityModel m_entityModel;
    GameStateMachine m_stateMachine;
    Powerups::OfferList m_offeredPowerups;
    std::mt19937 m_rng;
    qreal m_accumulator = 0.0;
    qreal m_deathAnimationRemaining = 0.0;
    int m_pendingPowerupChoices = 0;
    int m_powerupChoiceLevel = 0;
    int m_rerollsLeft = 0;
};
