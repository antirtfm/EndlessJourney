import Felgo
import QtQuick

// Animated hero presentation. Movement and gameplay state will be introduced
// separately; this component only maps a visual state to its sprite sheet.
Item {
    id: root

    property string animationName: "idle"
    property int facingDirection: 8
    property bool running: true

    implicitWidth: 60
    implicitHeight: implicitWidth

    GameAnimatedSprite {
        anchors.fill: parent
        source: Qt.resolvedUrl("../../assets/hero/"
                               + internal.animation.directory
                               + "/"
                               + internal.animation.fileName
                               + "_dir"
                               + root.facingDirection
                               + ".png")
        frameCount: internal.animation.frameCount
        frameWidth: 256
        frameHeight: 256
        frameRate: internal.animation.frameRate
        loops: Animation.Infinite
        running: root.running
        interpolate: false

        // Changing animationName swaps the sheet; restart at its first frame.
        onSourceChanged: restart()
    }

    QtObject {
        id: internal

        readonly property var animations: ({
            "idle": {
                directory: "Idle",
                fileName: "Knight_Idle",
                frameCount: 17,
                frameRate: 7
            },
            "walk": {
                directory: "Walk",
                fileName: "Knight_Walk",
                frameCount: 11,
                frameRate: 10
            },
            "run": {
                directory: "Run",
                fileName: "Knight_Run",
                frameCount: 8,
                frameRate: 12
            },
            "attack": {
                directory: "Attack",
                fileName: "Knight_Attack",
                frameCount: 15,
                frameRate: 30
            }
        })
        readonly property var animation: internal.animations[root.animationName]
                                         || internal.animations.idle
    }
}
