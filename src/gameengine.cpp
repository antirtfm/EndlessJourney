#include "gameengine.h"

#include "balance.h"

#include <algorithm>
#include <cmath>

namespace {

using State = GameStateMachine::State;
using Event = GameStateMachine::Event;

} // namespace

GameEngine::GameEngine(QObject* parent)
    : QObject(parent)
    , m_entityModel(&m_world, this)
    , m_rng(std::random_device {}())
{
    m_entityModel.resetRows();
}

void GameEngine::newGame()
{
    if (!m_stateMachine.dispatch(Event::StartGame))
        return;

    m_world.reset();
    m_accumulator = 0.0;
    m_deathAnimationRemaining = 0.0;
    m_entityModel.resetRows();
    clearLevelUpState();

    emit stateChanged();
    emit offeredPowerupsChanged();
    emit runStarted();
    emit frameUpdated();
}

void GameEngine::advance(qreal deltaMilliseconds)
{
    if (!std::isfinite(deltaMilliseconds) || deltaMilliseconds <= 0.0)
        return;

    const qreal deltaSeconds = std::min(
        deltaMilliseconds / 1000.0,
        static_cast<qreal>(Balance::maxFrameTime));

    if (state() == State::Playing)
        advancePlaying(deltaSeconds);
    else if (state() == State::Dying)
        advanceDying(deltaSeconds);
}

void GameEngine::setMoveInput(qreal x, qreal y)
{
    if (state() != State::Playing) {
        m_world.setMoveInput(0.0f, 0.0f);
        return;
    }

    const float moveX = std::isfinite(x) ? static_cast<float>(x) : 0.0f;
    const float moveY = std::isfinite(y) ? static_cast<float>(y) : 0.0f;
    m_world.setMoveInput(moveX, moveY);
}

void GameEngine::setSprint(bool sprinting)
{
    m_world.setSprint(state() == State::Playing && sprinting);
}

void GameEngine::castNova()
{
    if (state() != State::Playing)
        return;

    m_world.requestNova();
}

void GameEngine::selectPowerup(int id)
{
    if (state() != State::LevelUp || m_pendingPowerupChoices <= 0)
        return;

    const std::optional<PowerupId> selected = Powerups::idFromInt(id);
    if (!selected || !Powerups::contains(m_offeredPowerups, *selected))
        return;
    if (!Powerups::apply(*selected, m_world))
        return;

    // Several levels can land in the same step, so keep offering until the
    // queue drains before handing control back.
    if (--m_pendingPowerupChoices > 0) {
        ++m_powerupChoiceLevel;
        offerNextPowerupChoice();
        emit offeredPowerupsChanged();
        emit leveledUp(m_powerupChoiceLevel);
        emit frameUpdated();
        return;
    }

    if (!m_stateMachine.dispatch(Event::PowerupSelected))
        return;

    clearLevelUpState();
    emit stateChanged();
    emit offeredPowerupsChanged();
    emit frameUpdated();
}

void GameEngine::togglePause()
{
    if (!m_stateMachine.dispatch(Event::TogglePause))
        return;

    if (state() == State::Paused)
        m_world.clearInput();

    emit stateChanged();
}

void GameEngine::rerollPowerups()
{
    if (state() != State::LevelUp || m_rerollsLeft <= 0)
        return;

    --m_rerollsLeft;
    m_offeredPowerups = Powerups::offer(m_rng);
    emit offeredPowerupsChanged();
}

void GameEngine::quitToMenu()
{
    if (!m_stateMachine.dispatch(Event::ReturnToMenu))
        return;

    m_world.clearInput();
    m_accumulator = 0.0;
    m_deathAnimationRemaining = 0.0;
    const bool hadLevelUpState = clearLevelUpState();

    emit stateChanged();
    if (hadLevelUpState)
        emit offeredPowerupsChanged();
}

void GameEngine::advancePlaying(qreal deltaSeconds)
{
    m_accumulator += deltaSeconds;
    while (m_accumulator >= Balance::fixedStep
           && state() == State::Playing) {
        m_accumulator -= Balance::fixedStep;
        const World::StepEvents events = m_world.step(Balance::fixedStep);

        if (events.novaBlast) {
            emit novaFired(events.novaBlast->x, events.novaBlast->y,
                           events.novaBlast->radius);
        }
        if (events.heroDied)
            beginHeroDeath();
        else if (events.levelsGained > 0)
            beginLevelUp(events.levelsGained);
    }

    m_entityModel.sync();
    emit frameUpdated();
}

void GameEngine::advanceDying(qreal deltaSeconds)
{
    m_deathAnimationRemaining = std::max(
        0.0, m_deathAnimationRemaining - deltaSeconds);
    if (m_deathAnimationRemaining <= 0.0
        && m_stateMachine.dispatch(Event::DeathAnimationFinished)) {
        emit stateChanged();
    }
    emit frameUpdated();
}

void GameEngine::beginHeroDeath()
{
    if (!m_stateMachine.dispatch(Event::HeroDied))
        return;

    m_world.clearInput();
    m_deathAnimationRemaining = Balance::heroDeathAnimDuration;
    emit stateChanged();
}

void GameEngine::beginLevelUp(int levelsGained)
{
    if (levelsGained <= 0 || !m_stateMachine.dispatch(Event::LevelReached))
        return;

    m_world.clearInput();
    m_pendingPowerupChoices = levelsGained;
    m_powerupChoiceLevel = m_world.level() - levelsGained + 1;
    offerNextPowerupChoice();

    emit stateChanged();
    emit offeredPowerupsChanged();
    emit leveledUp(m_powerupChoiceLevel);
}

void GameEngine::offerNextPowerupChoice()
{
    m_offeredPowerups = Powerups::offer(m_rng);
    m_rerollsLeft = Balance::powerupRerolls;
}

bool GameEngine::clearLevelUpState()
{
    if (m_offeredPowerups.empty() && m_pendingPowerupChoices == 0
        && m_powerupChoiceLevel == 0 && m_rerollsLeft == 0) {
        return false;
    }

    m_offeredPowerups.clear();
    m_pendingPowerupChoices = 0;
    m_powerupChoiceLevel = 0;
    m_rerollsLeft = 0;
    return true;
}
