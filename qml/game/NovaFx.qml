import QtQuick
import EndlessJourney.Backend 1.0

Item {
    id: root

    required property GameEngine engine

    z: 8000
    visible: burst.running

    Connections {
        target: root.engine

        function onNovaFired(x: real, y: real, radius: real): void {
            ring.x = x - radius
            ring.y = y - radius
            ring.width = 2 * radius
            ring.height = 2 * radius
            burst.restart()
        }

        function onRunStarted(): void {
            burst.stop()
        }
    }

    Rectangle {
        id: ring

        radius: width / 2
        color: Qt.rgba(0.30, 0.79, 0.94, 0.16)
        border.width: 4
        border.color: "#4cc9f0"
        opacity: 0
    }

    SequentialAnimation {
        id: burst

        ParallelAnimation {
            NumberAnimation {
                target: ring
                property: "scale"
                from: 0.25
                to: 1
                duration: 240
                easing.type: Easing.OutCubic
            }

            NumberAnimation {
                target: ring
                property: "opacity"
                from: 0.95
                to: 0.55
                duration: 240
            }
        }

        NumberAnimation {
            target: ring
            property: "opacity"
            to: 0
            duration: 180
            easing.type: Easing.InQuad
        }
    }
}
