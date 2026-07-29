import Felgo
import QtQuick

import "game"
import "hud"
import "input"

Scene {
    id: gameScene

    signal exitRequested()

    width: 480
    height: 320

    Keys.onEscapePressed: gameScene.exitRequested()
    onBackButtonPressed: gameScene.exitRequested()
    onVisibleChanged: {
        if (gameScene.visible)
            internal.resetHero()
    }

    Rectangle {
        anchors.fill: gameScene.fullWindowAnchorItem
        color: "#0a0e1a"
    }

    Item {
        id: world

        x: gameScene.width / 2 - internal.heroX
        y: gameScene.height / 2 - internal.heroY

        GroundLayer {
            heroX: internal.heroX
            heroY: internal.heroY
            viewWidth: gameScene.gameWindowAnchorItem.width
            viewHeight: gameScene.gameWindowAnchorItem.height
        }

        HeroSprite {
            x: internal.heroX - width / 2
            y: internal.heroY - height / 2
            animationName: internal.moving ? "walk" : "idle"
            facingDirection: internal.sheetDirection
            running: gameScene.visible
        }
    }

    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        text: qsTr("Position: %1, %2")
                .arg(Math.round(internal.heroX))
                .arg(Math.round(internal.heroY))
        color: "#8d99ae"
        font.pixelSize: 11
    }

    FrameAnimation {
        running: gameScene.visible
        onTriggered: internal.advance(frameTime)
    }

    InputController {
        anchors.fill: gameScene.gameWindowAnchorItem
        inputEnabled: gameScene.visible
        onMoveRequested: (x, y) => internal.setMovement(x, y)
    }

    // placeholder values until real gameplay fills the hud
    GameHud {
        anchors.fill: gameScene.gameWindowAnchorItem
        touchTargetSize: gameScene.dp(48)
        mana: 30
        onExitRequested: gameScene.exitRequested()
    }

    QtObject {
        id: internal

        readonly property real movementSpeed: 120
        readonly property list<int> directionMap: [6, 7, 8, 1, 2, 3, 4, 5]

        property real heroX: 0
        property real heroY: 0
        property real moveX: 0
        property real moveY: 0
        property int facingOctant: 2

        readonly property bool moving: internal.moveX !== 0 || internal.moveY !== 0
        readonly property int sheetDirection: internal.directionMap[internal.facingOctant]

        function resetHero(): void {
            internal.heroX = 0
            internal.heroY = 0
            internal.moveX = 0
            internal.moveY = 0
            internal.facingOctant = 2
        }

        function setMovement(x: real, y: real): void {
            internal.moveX = x
            internal.moveY = y

            if (x !== 0 || y !== 0)
                internal.facingOctant = internal.octantFromDirection(x, y)
        }

        function advance(frameTime: real): void {
            if (!internal.moving)
                return

            const distance = internal.movementSpeed * frameTime
            internal.heroX += internal.moveX * distance
            internal.heroY += internal.moveY * distance
        }

        function octantFromDirection(x: real, y: real): int {
            const sector = Math.round(Math.atan2(y, x) / (Math.PI / 4))
            return (sector % 8 + 8) % 8
        }
    }
}
