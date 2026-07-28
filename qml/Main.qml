import Felgo
import QtQuick

GameWindow {
    id: gameWindow

    // the size of the window on desktop - on mobile the window always fills the screen
    screenWidth: 960
    screenHeight: 640

    // free license keys are available at https://felgo.com/licenseKey
    licenseKey: ""

    Scene {
        id: gameScene

        // the "logical size" - all content is scaled from this size to the real window size
        width: 480
        height: 320

        // background fills the whole window, beyond the logical scene bounds
        Rectangle {
            anchors.fill: gameScene.gameWindowAnchorItem
            color: "#0a0e1a"
        }

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Endless Journey"
                color: "#e8e8f0"
                font.pixelSize: 30
            }

            MainMenu {
                anchors.horizontalCenter: parent.horizontalCenter
                focus: true
                onEntrySelected: action => {
                    if (action === "newGame")
                        console.debug("new game - not implemented yet")
                    else if (action === "quit")
                        Qt.quit()
                }
            }
        }
    }
}
