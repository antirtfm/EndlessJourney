import QtQuick
import EndlessJourney.Backend 1.0

import "../util"

// In-game overlay: resource bars, level/xp, timer and kill counter.
Item {
    id: root

    required property GameEngine engine
    required property real touchTargetSize

    signal exitRequested()

    Column {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10
        spacing: 4

        HudBar {
            accessibleName: qsTr("Health")
            value: root.engine.hp
            maxValue: root.engine.maxHp
            barColor: "#e63946"
        }

        HudBar {
            accessibleName: qsTr("Mana")
            value: root.engine.mana
            maxValue: root.engine.maxMana
            barColor: "#4cc9f0"
        }

        HudBar {
            accessibleName: qsTr("Stamina")
            value: root.engine.stamina
            maxValue: root.engine.maxStamina
            barColor: "#90be6d"
        }

        Row {
            spacing: 6

            HudBar {
                accessibleName: qsTr("Experience")
                width: 104
                height: 6
                anchors.verticalCenter: parent.verticalCenter
                value: root.engine.xp
                maxValue: root.engine.xpToNext
                barColor: "#f9c74f"
            }

            Text {
                text: qsTr("Lv %1").arg(root.engine.level)
                color: "#e8e8f0"
                font.pixelSize: 11
            }
        }
    }

    Column {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        spacing: 2

        Text {
            anchors.right: parent.right
            text: timeFormatter.duration(root.engine.elapsed)
            color: "#e8e8f0"
            font.pixelSize: 18
            font.bold: true
        }

        Text {
            anchors.right: parent.right
            text: qsTr("Kills: %1").arg(root.engine.kills)
            color: "#8d99ae"
            font.pixelSize: 12
        }

        FocusScope {
            id: menuButton

            anchors.right: parent.right
            width: Math.max(root.touchTargetSize, menuLabel.implicitWidth + 8)
            height: root.touchTargetSize
            activeFocusOnTab: true

            Accessible.role: Accessible.Button
            Accessible.name: menuLabel.text
            Accessible.focusable: true
            Accessible.pressed: menuTap.pressed
            Accessible.onPressAction: root.exitRequested()

            Keys.onReturnPressed: root.exitRequested()
            Keys.onEnterPressed: root.exitRequested()
            Keys.onSpacePressed: root.exitRequested()

            Text {
                id: menuLabel

                anchors.centerIn: parent
                text: qsTr("Menu")
                color: menuTap.pressed ? "#ffffff"
                                       : menuTap.containsMouse || menuButton.activeFocus ? "#e8e8f0"
                                                                                       : "#8d99ae"
                font.pixelSize: 11
                font.underline: menuTap.containsMouse || menuButton.activeFocus
            }

            MouseArea {
                id: menuTap

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.exitRequested()
            }
        }
    }

    TimeFormatter {
        id: timeFormatter
    }
}
