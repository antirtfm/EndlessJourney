pragma ComponentBehavior: Bound
import QtQuick
import EndlessJourney.Backend 1.0

Item {
    id: root

    required property GameEngine engine
    required property bool running

    Repeater {
        model: root.engine.entityModel

        delegate: EntityView {
            id: entityView

            running: root.running
                     && (entityView.kind === "hero"
                         || root.engine.state === GameState.Playing)
        }
    }
}
