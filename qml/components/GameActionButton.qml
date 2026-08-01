import Felgo
import QtQuick
import EndlessJourney.Backend 1.0
import ".."

AppButton {
    id: root

    activeFocusOnTab: true
    hoverEnabled: true

    minimumWidth: 0
    minimumHeight: 0
    horizontalPadding: 8
    verticalPadding: 0

    backgroundColor: root.highlighted ? GameTheme.surfaceRaised : GameTheme.surface
    backgroundColorHovered: GameTheme.surfaceRaised
    backgroundColorPressed: GameTheme.border
    disabledColor: GameTheme.surfaceDeep

    borderColor: root.highlighted ? GameTheme.accent : GameTheme.border
    borderColorHovered: GameTheme.accent
    borderColorPressed: GameTheme.accent
    borderColorDisabled: GameTheme.borderDisabled
    borderWidth: 1
    radius: 6

    textColor: root.highlighted ? GameTheme.textEmphasis : GameTheme.textPrimary
    textColorHovered: GameTheme.textEmphasis
    textColorPressed: GameTheme.textEmphasis
    textColorDisabled: GameTheme.textMuted
    textSize: 14
    fontCapitalization: Font.MixedCase
    dropShadow: false
    rippleEffect: true
}
