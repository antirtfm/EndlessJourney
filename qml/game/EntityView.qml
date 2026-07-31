import QtQuick
import QtQuick.Effects

Item {
    id: root

    required property string kind
    required property real worldX
    required property real worldY
    required property int octant
    required property string animationName
    required property real hpRatio
    required property bool running

    readonly property bool flashesOnHit: root.kind !== "hero"

    x: root.worldX - width / 2
    y: root.worldY - height / 2
    z: root.worldY
    implicitWidth: sprite.implicitWidth
    implicitHeight: sprite.implicitHeight

    onHpRatioChanged: {
        if (root.flashesOnHit && root.hpRatio < internal.previousHpRatio)
            hitFlash.restart()
        internal.previousHpRatio = root.hpRatio
    }

    DirectionalSprite {
        id: sprite

        anchors.fill: parent
        entityKind: root.kind
        octant: root.octant
        animationName: root.animationName
        running: root.running
    }

    MultiEffect {
        id: flashOverlay

        anchors.fill: sprite
        source: sprite
        brightness: 1
        opacity: 0
        visible: flashOverlay.opacity > 0
    }

    NumberAnimation {
        id: hitFlash

        target: flashOverlay
        property: "opacity"
        from: 0.9
        to: 0
        duration: 160
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

    QtObject {
        id: internal

        property real previousHpRatio: 1
    }
}
