pragma ComponentBehavior: Bound
import QtQuick
import EndlessJourney.Backend 1.0

FocusScope {
    id: menu

    readonly property var entries: [
        { label: qsTr("New Game"), action: "newGame" },
        { label: qsTr("Quit"), action: "quit" }
    ]
    required property real touchTargetSize

    signal entrySelected(string action)

    width: 180
    height: menuList.height

    function trigger(index: int): void {
        if (index < 0 || index >= menu.entries.length)
            return
        menu.entrySelected(menu.entries[index].action)
    }

    ListView {
        id: menuList

        width: parent.width
        height: contentHeight
        focus: true

        // a short menu should not scroll or flick, but still handle arrow keys
        interactive: false
        keyNavigationEnabled: true
        keyNavigationWraps: true

        model: menu.entries
        spacing: 6

        highlight: Rectangle {
            radius: 6
            color: GameTheme.surface
            border.color: GameTheme.border
            border.width: 1
        }
        highlightMoveDuration: 100

        delegate: Item {
            id: delegateItem

            required property int index
            required property var modelData

            width: menuList.width
            height: menu.touchTargetSize

            Accessible.role: Accessible.MenuItem
            Accessible.name: delegateItem.modelData.label
            Accessible.focusable: true
            Accessible.selected: delegateItem.ListView.isCurrentItem
            Accessible.onPressAction: menu.trigger(delegateItem.index)

            Text {
                anchors.centerIn: parent
                text: delegateItem.modelData.label
                color: delegateItem.ListView.isCurrentItem
                       ? GameTheme.textEmphasis
                       : GameTheme.textSecondary
                font.pixelSize: 16
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: menuList.currentIndex = delegateItem.index
                onClicked: menu.trigger(delegateItem.index)
            }
        }

        Keys.onReturnPressed: menu.trigger(menuList.currentIndex)
        Keys.onEnterPressed: menu.trigger(menuList.currentIndex)
    }
}
