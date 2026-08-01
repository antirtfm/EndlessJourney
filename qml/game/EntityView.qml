pragma ComponentBehavior: Bound
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

    readonly property bool isProjectile: root.kind === "arrow"
    readonly property bool flashesOnHit: root.kind !== "hero" && !root.isProjectile

    x: root.worldX - width / 2
    y: root.worldY - height / 2
    z: root.worldY
    implicitWidth: visual.implicitWidth
    implicitHeight: visual.implicitHeight

    onHpRatioChanged: {
        if (root.flashesOnHit && root.hpRatio < internal.previousHpRatio)
            hitFlash.restart()
        internal.previousHpRatio = root.hpRatio
    }

    Loader {
        id: visual

        sourceComponent: root.isProjectile ? arrowVisual : spriteVisual
    }

    Component {
        id: spriteVisual

        DirectionalSprite {
            entityKind: root.kind
            octant: root.octant
            animationName: root.animationName
            running: root.running
        }
    }

    Component {
        id: arrowVisual

        ArrowSprite {
            octant: root.octant
        }
    }

    MultiEffect {
        id: flashOverlay

        anchors.fill: visual
        source: visual
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
        visible: root.flashesOnHit && root.hpRatio < 1

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
