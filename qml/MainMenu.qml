pragma ComponentBehavior: Bound
import Felgo
import QtQuick

FocusScope {
    id: menu

    signal entrySelected(string action)

    readonly property var entries: [
        { label: qsTr("New Game"), action: "newGame" },
        { label: qsTr("Quit"), action: "quit" }
    ]

    width: 180
    height: menuList.height

    function trigger(index) {
        if (index < 0)
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
            color: "#1c2541"
            border.color: "#3a506b"
            border.width: 1
        }
        highlightMoveDuration: 100

        delegate: Item {
            id: delegateItem

            required property int index
            required property var modelData

            width: menuList.width
            height: 32

            Text {
                anchors.centerIn: parent
                text: delegateItem.modelData.label
                color: delegateItem.ListView.isCurrentItem ? "#ffffff" : "#8d99ae"
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
