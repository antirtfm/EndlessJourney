import QtQuick
import EndlessJourney.Backend 1.0

import "../components"
import "../util"

FocusScope {
    id: root

    required property GameEngine engine
    required property real touchTargetSize

    visible: root.engine.state === GameState.Paused
    enabled: root.visible
    onVisibleChanged: {
        if (root.visible)
            resumeButton.forceActiveFocus()
    }

    Keys.onEscapePressed: root.engine.togglePause()

    Rectangle {
        anchors.fill: parent
        color: "#d90a0e1a"
    }

    MouseArea {
        anchors.fill: parent
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Paused")
            color: "#e8e8f0"
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Survived %1 | Level %2 | Kills: %3")
                    .arg(timeFormatter.duration(root.engine.elapsed))
                    .arg(root.engine.level)
                    .arg(root.engine.kills)
            color: "#8d99ae"
            font.pixelSize: 14
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            GameActionButton {
                id: resumeButton

                width: 110
                height: root.touchTargetSize
                text: qsTr("Resume")
                KeyNavigation.right: menuButton
                onClicked: root.engine.togglePause()
            }

            GameActionButton {
                id: menuButton

                width: 110
                height: root.touchTargetSize
                text: qsTr("Menu")
                KeyNavigation.left: resumeButton
                onClicked: root.engine.quitToMenu()
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("escape to resume")
            color: "#8d99ae"
            font.pixelSize: 10
        }
    }

    TimeFormatter {
        id: timeFormatter
    }
}
