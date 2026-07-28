import QtQuick

// In-game overlay: resource bars, level/xp, timer and kill counter.
Item {
    id: root

    required property real touchTargetSize
    property real hp: 100
    property real maxHp: 100
    property real mana: 0
    property real maxMana: 50
    property real stamina: 100
    property real maxStamina: 100
    property real xp: 0
    property real xpToNext: 10
    property int level: 1
    property int kills: 0
    property real elapsed: 0

    signal exitRequested()

    function formatTime(seconds: real): string {
        const total = Math.floor(seconds)
        const minutes = Math.floor(total / 60)
        const remainingSeconds = total % 60
        return minutes + ":" + (remainingSeconds < 10 ? "0" : "") + remainingSeconds
    }

    Column {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10
        spacing: 4

        HudBar {
            accessibleName: qsTr("Health")
            value: root.hp
            maxValue: root.maxHp
            barColor: "#e63946"
        }

        HudBar {
            accessibleName: qsTr("Mana")
            value: root.mana
            maxValue: root.maxMana
            barColor: "#4cc9f0"
        }

        HudBar {
            accessibleName: qsTr("Stamina")
            value: root.stamina
            maxValue: root.maxStamina
            barColor: "#90be6d"
        }

        Row {
            spacing: 6

            HudBar {
                accessibleName: qsTr("Experience")
                width: 104
                height: 6
                anchors.verticalCenter: parent.verticalCenter
                value: root.xp
                maxValue: root.xpToNext
                barColor: "#f9c74f"
            }

            Text {
                text: qsTr("Lv %1").arg(root.level)
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
            text: root.formatTime(root.elapsed)
            color: "#e8e8f0"
            font.pixelSize: 18
            font.bold: true
        }

        Text {
            anchors.right: parent.right
            text: qsTr("Kills: %1").arg(root.kills)
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
}
