import Felgo
import QtQuick

AppButton {
    id: root

    activeFocusOnTab: true
    hoverEnabled: true

    minimumWidth: 0
    minimumHeight: 0
    horizontalPadding: 8
    verticalPadding: 0

    backgroundColor: root.highlighted ? "#1c2541" : "#111827"
    backgroundColorHovered: "#1c2541"
    backgroundColorPressed: "#3a506b"
    disabledColor: "#0a0e1a"

    borderColor: root.highlighted ? "#4cc9f0" : "#3a506b"
    borderColorHovered: "#4cc9f0"
    borderColorPressed: "#4cc9f0"
    borderColorDisabled: "#263247"
    borderWidth: 1
    radius: 6

    textColor: root.highlighted ? "#ffffff" : "#e8e8f0"
    textColorHovered: "#ffffff"
    textColorPressed: "#ffffff"
    textColorDisabled: "#8d99ae"
    textSize: 14
    fontCapitalization: Font.MixedCase
    dropShadow: false
    rippleEffect: true
}
