import Felgo
import QtQuick
import EndlessJourney.Backend 1.0

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

    Scene {
        id: menuScene

        // the "logical size" - all content is scaled from this size to the real window size
        width: 480
        height: 320

        visible: gameWindow.activeScene === menuScene

        onBackButtonPressed: Qt.quit()

        // background fills the whole window, beyond the logical scene bounds
        Rectangle {
            anchors.fill: menuScene.fullWindowAnchorItem
            color: GameTheme.background
        }

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Endless Journey")
                color: GameTheme.textPrimary
                font.pixelSize: 30
            }

            MainMenu {
                anchors.horizontalCenter: parent.horizontalCenter
                touchTargetSize: menuScene.dp(48)
                focus: true
                onEntrySelected: action => {
                    if (action === "newGame")
                        gameEngine.newGame()
                    else if (action === "quit")
                        Qt.quit()
                }
            }
        }
    }

    GameScene {
        id: gameplayScene

        engine: gameEngine
        visible: gameWindow.activeScene === gameplayScene
    }
}
