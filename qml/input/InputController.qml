import Felgo
import QtQuick

FocusScope {
    id: root

    property bool inputEnabled: true
    property real steeringDeadZone: 12

    signal moveRequested(real x, real y)
    signal sprintRequested(bool sprinting)
    signal castRequested()
    signal pauseRequested()

    enabled: root.inputEnabled
    focus: root.inputEnabled
    Keys.forwardTo: [wasdController, arrowController]
    Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Shift:
            internal.publishSprint(true)
            event.accepted = true
            return
        case Qt.Key_Space:
            // A held key auto-repeats, which would empty the mana pool at once.
            if (!event.isAutoRepeat)
                root.castRequested()
            event.accepted = true
            return
        case Qt.Key_Escape:
            if (!event.isAutoRepeat)
                root.pauseRequested()
            event.accepted = true
            return
        default:
            event.accepted = false
        }
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

    MouseArea {
        id: pointerArea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: mouse => {
            if (mouse.button === Qt.RightButton) {
                root.castRequested()
                return
            }

            internal.steering = true
            internal.updateSteering(mouse.x, mouse.y)
        }
        onPositionChanged: mouse => {
            if (internal.steering)
                internal.updateSteering(mouse.x, mouse.y)
        }
        onReleased: mouse => {
            if (mouse.button === Qt.LeftButton)
                internal.stopSteering()
        }
        onCanceled: internal.stopSteering()
    }

    QtObject {
        id: internal

        property bool ready: false
        property real publishedX: 0
        property real publishedY: 0
        property bool publishedSprinting: false
        property bool steering: false
        property real steerX: 0
        property real steerY: 0

        function stopSteering(): void {
            internal.steering = false
            internal.steerX = 0
            internal.steerY = 0
            internal.publishMovement()
        }

        function releaseInput(): void {
            internal.resetController(wasdController)
            internal.resetController(arrowController)
            internal.steering = false
            internal.steerX = 0
            internal.steerY = 0
            internal.publishMovement()
            internal.publishSprint(false)
        }

        function resetController(controller: TwoAxisController): void {
            controller.setInputActionPressedStatus("up", false)
            controller.setInputActionPressedStatus("down", false)
            controller.setInputActionPressedStatus("left", false)
            controller.setInputActionPressedStatus("right", false)
        }

        function updateSteering(mouseX: real, mouseY: real): void {
            const dx = mouseX - pointerArea.width / 2
            const dy = mouseY - pointerArea.height / 2
            const length = Math.sqrt(dx * dx + dy * dy)

            if (length < root.steeringDeadZone) {
                internal.steerX = 0
                internal.steerY = 0
            } else {
                internal.steerX = dx / length
                internal.steerY = dy / length
            }
            internal.publishMovement()
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

            if (x === 0 && y === 0 && internal.steering) {
                x = internal.steerX
                y = internal.steerY
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
