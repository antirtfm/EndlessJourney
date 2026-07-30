import QtQuick

// A resource bar (health, mana, stamina or experience).
Item {
    id: root

    required property string accessibleName
    required property real value
    required property real maxValue
    required property color barColor

    implicitWidth: 130
    implicitHeight: 10

    Accessible.role: Accessible.ProgressBar
    Accessible.name: root.accessibleName
    Accessible.description: qsTr("%1 of %2").arg(root.value).arg(root.maxValue)

    Rectangle {
        anchors.fill: parent
        radius: 3
        color: "#66000000"
        border.color: "#33ffffff"
        border.width: 1
    }

    Rectangle {
        x: 1
        y: 1
        width: Math.max(0, (parent.width - 2) * Math.min(1, root.maxValue > 0 ? root.value / root.maxValue : 0))
        height: parent.height - 2
        radius: 2
        color: root.barColor
    }
}
