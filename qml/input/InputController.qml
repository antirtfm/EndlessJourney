import Felgo
import QtQuick

FocusScope {
    id: root

    property bool inputEnabled: true

    signal moveRequested(real x, real y)
    signal sprintRequested(bool sprinting)

    enabled: root.inputEnabled
    focus: root.inputEnabled
    Keys.forwardTo: [wasdController, arrowController]
    Keys.onPressed: event => {
        if (event.key !== Qt.Key_Shift) {
            event.accepted = false
            return
        }

        internal.publishSprint(true)
        event.accepted = true
    }
    Keys.onReleased: event => {
        if (event.key !== Qt.Key_Shift) {
            event.accepted = false
            return
        }

        internal.publishSprint(false)
        event.accepted = true
    }

    onInputEnabledChanged: {
        if (!internal.ready)
            return

        if (root.inputEnabled)
            root.forceActiveFocus()
        else
            internal.releaseInput()
    }
    onActiveFocusChanged: {
        if (internal.ready && root.inputEnabled && !root.activeFocus)
            internal.releaseInput()
    }
    Component.onCompleted: {
        internal.ready = true
        if (root.inputEnabled)
            root.forceActiveFocus()
    }

    TwoAxisController {
        id: wasdController

        inputActionsToKeyCode: ({
            "up": Qt.Key_W,
            "down": Qt.Key_S,
            "left": Qt.Key_A,
            "right": Qt.Key_D
        })

        onXAxisChanged: internal.publishMovement()
        onYAxisChanged: internal.publishMovement()
    }

    // TwoAxisController accepts one key per action, so a second instance adds
    // arrow-key aliases while preserving one semantic movement signal.
    TwoAxisController {
        id: arrowController

        inputActionsToKeyCode: ({
            "up": Qt.Key_Up,
            "down": Qt.Key_Down,
            "left": Qt.Key_Left,
            "right": Qt.Key_Right
        })

        onXAxisChanged: internal.publishMovement()
        onYAxisChanged: internal.publishMovement()
    }

    QtObject {
        id: internal

        property bool ready: false
        property real publishedX: 0
        property real publishedY: 0
        property bool publishedSprinting: false

        function releaseInput(): void {
            internal.resetController(wasdController)
            internal.resetController(arrowController)
            internal.publishMovement()
            internal.publishSprint(false)
        }

        function resetController(controller: TwoAxisController): void {
            controller.setInputActionPressedStatus("up", false)
            controller.setInputActionPressedStatus("down", false)
            controller.setInputActionPressedStatus("left", false)
            controller.setInputActionPressedStatus("right", false)
        }

        function publishMovement(): void {
            let x = Math.max(-1, Math.min(1,
                                         wasdController.xAxis + arrowController.xAxis))
            // Felgo uses positive Y for up; scene coordinates grow downwards.
            let y = Math.max(-1, Math.min(1,
                                         -wasdController.yAxis - arrowController.yAxis))
            const length = Math.sqrt(x * x + y * y)

            if (length > 1) {
                x /= length
                y /= length
            }

            if (x === internal.publishedX && y === internal.publishedY)
                return

            internal.publishedX = x
            internal.publishedY = y
            root.moveRequested(x, y)
        }

        function publishSprint(sprinting: bool): void {
            if (sprinting === internal.publishedSprinting)
                return

            internal.publishedSprinting = sprinting
            root.sprintRequested(sprinting)
        }
    }
}
