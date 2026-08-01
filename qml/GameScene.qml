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

    onBackButtonPressed: {
        if (gameScene.engine.state === GameState.Playing
                || gameScene.engine.state === GameState.Paused)
            gameScene.engine.togglePause()
        else
            gameScene.engine.quitToMenu()
    }

    Rectangle {
        anchors.fill: gameScene.fullWindowAnchorItem
        color: GameTheme.background
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

        NovaFx {
            engine: gameScene.engine
        }

        LevelUpFx {
            engine: gameScene.engine
        }
    }

    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 8
        text: qsTr("WASD / arrows / hold mouse — move · Shift — sprint · Space / RMB — nova")
        color: GameTheme.textSecondary
        font.pixelSize: 9
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
        onCastRequested: gameScene.engine.castNova()
        onPauseRequested: gameScene.engine.togglePause()
    }

    GameHud {
        anchors.fill: gameScene.gameWindowAnchorItem
        engine: gameScene.engine
        touchTargetSize: gameScene.dp(48)
        onExitRequested: gameScene.engine.quitToMenu()
    }

    PowerupDialog {
        anchors.fill: gameScene.gameWindowAnchorItem
        z: 10
        engine: gameScene.engine
    }

    PauseOverlay {
        anchors.fill: gameScene.gameWindowAnchorItem
        z: 11
        engine: gameScene.engine
        touchTargetSize: gameScene.dp(48)
    }

    GameOverDialog {
        anchors.fill: gameScene.gameWindowAnchorItem
        z: 12
        engine: gameScene.engine
        touchTargetSize: gameScene.dp(48)
    }
}
