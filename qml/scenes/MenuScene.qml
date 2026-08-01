import Felgo
import QtQuick
import EndlessJourney.Backend 1.0
import ".."

Scene {
    id: menuScene

    required property GameEngine engine

    // the "logical size" - all content is scaled from this size to the real window size
    width: 480
    height: 320

    onBackButtonPressed: Qt.quit()
    onVisibleChanged: {
        if (visible)
            menu.forceActiveFocus()
    }

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
            id: menu

            anchors.horizontalCenter: parent.horizontalCenter
            touchTargetSize: menuScene.dp(48)
            focus: true
            onEntrySelected: action => {
                if (action === "newGame")
                    menuScene.engine.newGame()
                else if (action === "quit")
                    Qt.quit()
            }
        }
    }
}
