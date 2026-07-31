pragma ComponentBehavior: Bound
import QtQuick
import EndlessJourney.Backend 1.0

import "../components"

FocusScope {
    id: root

    required property GameEngine engine

    visible: root.engine.state === GameState.LevelUp
    enabled: root.visible
    onVisibleChanged: {
        if (root.visible) {
            internal.currentIndex = 0
            root.forceActiveFocus()
        }
    }

    Keys.onLeftPressed: internal.currentIndex = Math.max(
                            0, internal.currentIndex - 1)
    Keys.onRightPressed: internal.currentIndex = Math.min(
                             root.engine.offeredPowerups.length - 1,
                             internal.currentIndex + 1)
    Keys.onReturnPressed: internal.choose(internal.currentIndex)
    Keys.onEnterPressed: internal.choose(internal.currentIndex)
    Keys.onDigit1Pressed: internal.choose(0)
    Keys.onDigit2Pressed: internal.choose(1)
    Keys.onDigit3Pressed: internal.choose(2)
    Keys.onPressed: event => {
        if (event.key !== Qt.Key_R)
            return

        root.engine.rerollPowerups()
        event.accepted = true
    }

    Connections {
        target: root.engine

        function onOfferedPowerupsChanged(): void {
            internal.currentIndex = 0
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#d90a0e1a"
    }

    MouseArea {
        anchors.fill: parent
    }

    Column {
        anchors.centerIn: parent
        spacing: 14

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Level %1 — choose an upgrade").arg(
                      root.engine.powerupChoiceLevel)
            color: "#f9c74f"
            font.pixelSize: 20
            font.bold: true
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            Repeater {
                model: root.engine.offeredPowerups

                delegate: Rectangle {
                    id: card

                    required property var modelData
                    required property int index

                    readonly property bool selected: internal.currentIndex === card.index

                    width: 118
                    height: 120
                    radius: 8
                    color: card.selected ? "#1c2541" : "#111827"
                    border.color: card.selected ? "#f9c74f" : "#3a506b"
                    border.width: card.selected ? 2 : 1

                    Accessible.role: Accessible.Button
                    Accessible.name: card.modelData.name
                    Accessible.description: card.modelData.description
                    Accessible.onPressAction: internal.choose(card.index)

                    Column {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 6

                        Text {
                            width: parent.width
                            text: (card.index + 1) + ". " + card.modelData.name
                            color: "#e8e8f0"
                            font.pixelSize: 13
                            font.bold: true
                            wrapMode: Text.WordWrap
                        }

                        Text {
                            width: parent.width
                            text: card.modelData.description
                            color: "#8d99ae"
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: internal.currentIndex = card.index
                        onClicked: internal.choose(card.index)
                    }
                }
            }
        }

        GameActionButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 160
            height: 28
            textSize: 11
            enabled: root.engine.rerollsLeft > 0
            text: qsTr("Reroll (R) — %1 left").arg(root.engine.rerollsLeft)
            onClicked: root.engine.rerollPowerups()
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("arrows + enter, 1-3, or click")
            color: "#8d99ae"
            font.pixelSize: 10
        }
    }

    QtObject {
        id: internal

        property int currentIndex: 0

        function choose(index: int): void {
            const offers = root.engine.offeredPowerups
            if (index >= 0 && index < offers.length)
                root.engine.selectPowerup(offers[index].id)
        }
    }
}
