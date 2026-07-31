#include "gamestatemachine.h"

#include <algorithm>
#include <array>

namespace {

using State = GameStateMachine::State;
using Event = GameStateMachine::Event;

struct Transition {
    State from;
    Event event;
    State to;
};

constexpr std::array transitions {
    Transition { State::Menu, Event::StartGame, State::Playing },
    Transition { State::GameOver, Event::StartGame, State::Playing },
    Transition { State::Playing, Event::HeroDied, State::Dying },
    Transition { State::Dying, Event::DeathAnimationFinished, State::GameOver },
    Transition { State::Playing, Event::ReturnToMenu, State::Menu },
    Transition { State::Dying, Event::ReturnToMenu, State::Menu },
    Transition { State::GameOver, Event::ReturnToMenu, State::Menu },
};

} // namespace

bool GameStateMachine::dispatch(Event event) noexcept
{
    const auto match = std::find_if(
        transitions.cbegin(), transitions.cend(),
        [this, event](const Transition& candidate) {
            return candidate.from == m_state && candidate.event == event;
        });
    if (match == transitions.cend())
        return false;

    m_state = match->to;
    return true;
}
