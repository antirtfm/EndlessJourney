#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

namespace GameState {

Q_NAMESPACE
QML_NAMED_ELEMENT(GameState)

enum class Value {
    Menu,
    Playing,
    Dying,
    GameOver,
};
Q_ENUM_NS(Value)

} // namespace GameState

class GameStateMachine final {
public:
    using State = GameState::Value;

    enum class Event {
        StartGame,
        HeroDied,
        DeathAnimationFinished,
        ReturnToMenu,
    };

    State state() const noexcept { return m_state; }
    [[nodiscard]] bool dispatch(Event event) noexcept;

private:
    State m_state = State::Menu;
};
