import Felgo
import QtQuick

import "../config/Visuals.js" as Visuals

Item {
    id: root

    required property string entityKind
    required property int octant
    required property string animationName
    property bool running: true

    implicitWidth: internal.config.renderSize
    implicitHeight: implicitWidth

    GameAnimatedSprite {
        anchors.fill: parent
        source: Qt.resolvedUrl("../../assets/"
                               + internal.animation.pattern.replace(
                                   "{dir}", internal.sheetDirection))
        frameCount: internal.animation.frameCount
        frameWidth: internal.config.frameSize
        frameHeight: internal.config.frameSize
        frameRate: internal.animation.fps
        loops: internal.animation.loop === false ? 1 : Animation.Infinite
        running: root.running
        interpolate: false

        onSourceChanged: restart()
    }

    QtObject {
        id: internal

        readonly property var config: Visuals.configs[root.entityKind]
        readonly property var animation: Visuals.animationFor(
                                             internal.config,
                                             root.animationName)
        readonly property int sheetDirection: internal.config.directionMap[root.octant]
    }
}
