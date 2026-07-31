import QtQuick

Item {
    id: root

    required property string kind
    required property real worldX
    required property real worldY
    required property int octant
    required property string animationName
    required property real hpRatio
    required property bool running

    x: root.worldX - width / 2
    y: root.worldY - height / 2
    z: root.worldY
    implicitWidth: sprite.implicitWidth
    implicitHeight: sprite.implicitHeight

    DirectionalSprite {
        id: sprite

        anchors.fill: parent
        entityKind: root.kind
        octant: root.octant
        animationName: root.animationName
        running: root.running
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: -2
        width: 26
        height: 3
        radius: 1
        color: "#40000000"
        visible: root.kind !== "hero" && root.hpRatio < 1

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, root.hpRatio))
            height: parent.height
            radius: parent.radius
            color: "#e63946"
        }
    }
}
