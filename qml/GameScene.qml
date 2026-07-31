import Felgo
import QtQuick
import EndlessJourney.Backend 1.0

import "game"
import "hud"
import "input"

Scene {
    id: gameScene

    required property GameEngine engine

    width: 480
    height: 320

    Keys.onEscapePressed: gameScene.engine.quitToMenu()
    onBackButtonPressed: gameScene.engine.quitToMenu()

    Rectangle {
        anchors.fill: gameScene.fullWindowAnchorItem
        color: "#0a0e1a"
    }

    Item {
        id: world

        x: gameScene.width / 2 - gameScene.engine.heroX
        y: gameScene.height / 2 - gameScene.engine.heroY

        GroundLayer {
            heroX: gameScene.engine.heroX
            heroY: gameScene.engine.heroY
            viewWidth: gameScene.gameWindowAnchorItem.width
            viewHeight: gameScene.gameWindowAnchorItem.height
        }

        WorldLayer {
            engine: gameScene.engine
            running: gameScene.visible
        }

        LevelUpFx {
            engine: gameScene.engine
        }
    }

    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        text: qsTr("Position: %1, %2")
                .arg(Math.round(gameScene.engine.heroX))
                .arg(Math.round(gameScene.engine.heroY))
        color: "#8d99ae"
        font.pixelSize: 11
    }

    FrameAnimation {
        running: gameScene.engine.state === GameState.Playing
                 || gameScene.engine.state === GameState.Dying
        onTriggered: gameScene.engine.advance(frameTime * 1000)
    }

    InputController {
        anchors.fill: gameScene.gameWindowAnchorItem
        inputEnabled: gameScene.visible
                      && gameScene.engine.state === GameState.Playing
        onMoveRequested: (x, y) => gameScene.engine.setMoveInput(x, y)
        onSprintRequested: sprinting => gameScene.engine.setSprint(sprinting)
    }

    GameHud {
        anchors.fill: gameScene.gameWindowAnchorItem
        engine: gameScene.engine
        touchTargetSize: gameScene.dp(48)
        onExitRequested: gameScene.engine.quitToMenu()
    }

    GameOverDialog {
        anchors.fill: gameScene.gameWindowAnchorItem
        z: 10
        engine: gameScene.engine
        touchTargetSize: gameScene.dp(48)
    }
}
