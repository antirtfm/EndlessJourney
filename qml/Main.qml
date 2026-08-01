import Felgo
import QtQuick
import EndlessJourney.Backend 1.0
import "scenes"

GameWindow {
    id: gameWindow

    title: qsTr("Endless Journey")

    // the size of the window on desktop - on mobile the window always fills the screen
    screenWidth: 960
    screenHeight: 640

    // free license keys are available at https://felgo.com/licenseKey
    licenseKey: ""

    activeScene: gameEngine.state === GameState.Menu ? menuScene : gameplayScene

    GameEngine {
        id: gameEngine
    }

    MenuScene {
        id: menuScene

        engine: gameEngine
        visible: gameWindow.activeScene === menuScene
    }

    GameScene {
        id: gameplayScene

        engine: gameEngine
        visible: gameWindow.activeScene === gameplayScene
    }
}
