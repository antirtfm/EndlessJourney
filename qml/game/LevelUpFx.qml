import QtQuick

Item {
    id: root

    required property real targetX
    required property real targetY

    x: root.targetX
    y: root.targetY
    z: 9000
    visible: fxAnimation.running

    function play(): void {
        fxAnimation.restart()
    }

    function reset(): void {
        fxAnimation.stop()
    }

    Item {
        id: glow

        opacity: 0

        Rectangle {
            x: -36
            y: -48
            width: 72
            height: 72
            radius: 36
            color: Qt.rgba(1, 0.70, 0.12, 0.28)
        }

        Rectangle {
            x: -22
            y: -38
            width: 44
            height: 44
            radius: 22
            color: Qt.rgba(1, 0.92, 0.34, 0.42)
        }

        Rectangle {
            x: -46
            y: -52
            width: 92
            height: 92
            radius: 46
            color: "transparent"
            border.width: 2
            border.color: Qt.rgba(1, 0.82, 0.22, 0.66)
        }
    }

    Text {
        id: label

        x: -width / 2
        opacity: 0
        text: qsTr("LEVEL UP")
        color: "#ffe05e"
        style: Text.Outline
        styleColor: "#3e2202"
        font.pixelSize: 16
        font.bold: true
    }

    ParallelAnimation {
        id: fxAnimation

        SequentialAnimation {
            PropertyAction {
                target: glow
                property: "opacity"
                value: 1
            }

            PropertyAction {
                target: glow
                property: "scale"
                value: 0.72
            }

            ParallelAnimation {
                NumberAnimation {
                    target: glow
                    property: "scale"
                    to: 1.18
                    duration: 580
                    easing.type: Easing.OutCubic
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 350
                    }

                    NumberAnimation {
                        target: glow
                        property: "opacity"
                        to: 0
                        duration: 1200
                    }
                }
            }
        }

        SequentialAnimation {
            PropertyAction {
                target: label
                property: "y"
                value: -58
            }

            ParallelAnimation {
                NumberAnimation {
                    target: label
                    property: "y"
                    to: -86
                    duration: 1450
                    easing.type: Easing.OutCubic
                }

                SequentialAnimation {
                    NumberAnimation {
                        target: label
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 120
                    }

                    PauseAnimation {
                        duration: 700
                    }

                    NumberAnimation {
                        target: label
                        property: "opacity"
                        to: 0
                        duration: 630
                    }
                }
            }
        }
    }
}
