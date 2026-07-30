import QtQuick

import "../components"
import "../util"

FocusScope {
    id: root

    required property bool opened
    required property int kills
    required property int level
    required property real elapsed
    required property real touchTargetSize

    signal restartRequested()
    signal exitRequested()

    visible: root.opened
    enabled: root.opened
    onVisibleChanged: {
        if (root.visible)
            restartButton.forceActiveFocus()
    }

    Keys.onEscapePressed: root.exitRequested()

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
            text: qsTr("You Died")
            color: "#e63946"
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Survived %1 | Level %2 | Kills: %3")
                    .arg(timeFormatter.duration(root.elapsed))
                    .arg(root.level)
                    .arg(root.kills)
            color: "#e8e8f0"
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
                onClicked: root.restartRequested()
            }

            GameActionButton {
                id: menuButton

                width: 110
                height: root.touchTargetSize
                text: qsTr("Menu")
                KeyNavigation.left: restartButton
                onClicked: root.exitRequested()
            }
        }
    }

    TimeFormatter {
        id: timeFormatter
    }
}
