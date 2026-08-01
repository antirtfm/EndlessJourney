import QtQuick
import EndlessJourney.Backend 1.0

import ".."
import "../components"
import "../util"

FocusScope {
    id: root

    required property GameEngine engine
    required property real touchTargetSize

    visible: root.engine.state === GameState.GameOver
    enabled: root.visible
    onVisibleChanged: {
        if (root.visible)
            restartButton.forceActiveFocus()
    }

    Keys.onEscapePressed: root.engine.quitToMenu()

    Rectangle {
        anchors.fill: parent
        color: GameTheme.scrimStrong
    }

    MouseArea {
        anchors.fill: parent
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("You Died")
            color: GameTheme.health
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Survived %1 | Level %2 | Kills: %3")
                    .arg(timeFormatter.duration(root.engine.elapsed))
                    .arg(root.engine.level)
                    .arg(root.engine.kills)
            color: GameTheme.textPrimary
            font.pixelSize: 14
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            GameActionButton {
                id: restartButton

                width: 110
                height: root.touchTargetSize
                text: qsTr("Restart")
                KeyNavigation.right: menuButton
                onClicked: root.engine.newGame()
            }

            GameActionButton {
                id: menuButton

                width: 110
                height: root.touchTargetSize
                text: qsTr("Menu")
                KeyNavigation.left: restartButton
                onClicked: root.engine.quitToMenu()
            }
        }
    }

    TimeFormatter {
        id: timeFormatter
    }
}
