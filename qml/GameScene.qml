import Felgo
import QtQuick

import "game"
import "hud"

Scene {
    id: gameScene

    signal exitRequested()

    width: 480
    height: 320

    Keys.onEscapePressed: gameScene.exitRequested()
    onBackButtonPressed: gameScene.exitRequested()
    onVisibleChanged: {
        if (gameScene.visible)
            internal.animationIndex = 0
    }

    Rectangle {
        anchors.fill: gameScene.fullWindowAnchorItem
        color: "#0a0e1a"
    }

    HeroSprite {
        anchors.centerIn: parent
        animationName: internal.animationStates[internal.animationIndex]
        running: gameScene.visible
    }

    Timer {
        interval: 2000
        running: gameScene.visible
        repeat: true
        onTriggered: {
            internal.animationIndex =
                    (internal.animationIndex + 1) % internal.animationStates.length
        }
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

        readonly property list<string> animationStates: ["idle", "walk", "run", "attack"]
        property int animationIndex: 0
    }
}
