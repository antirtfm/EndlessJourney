import QtQuick

Item {
    id: root

    required property int octant

    implicitWidth: 18
    implicitHeight: 6
    rotation: root.octant * 45

    Rectangle {
        x: 0
        y: 2
        width: 13
        height: 2
        color: "#a8845c"
    }

    Rectangle {
        x: 12
        y: 1
        width: 5
        height: 4
        color: "#d9d9e3"
    }

    Rectangle {
        x: 0
        y: 1
        width: 3
        height: 4
        color: "#7a7f8c"
    }
}
