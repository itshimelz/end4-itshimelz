import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common
import qs.modules.common.widgets

RippleButton {
    id: root
    property string buttonIcon: ""
    property string description: ""

    Layout.fillWidth: true
    implicitHeight: contentItem.implicitHeight + 8
    font.pixelSize: Appearance.font.pixelSize.small
    colBackgroundHover: "transparent"

    contentItem: RowLayout {
        spacing: 10
        OptionalMaterialSymbol {
            icon: root.buttonIcon
            iconSize: Appearance.font.pixelSize.larger
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0
            StyledText {
                Layout.fillWidth: true
                text: root.text
                font: root.font
                color: Appearance.colors.colOnSecondaryContainer
            }
            StyledText {
                Layout.fillWidth: true
                visible: root.description.length > 0
                text: root.description
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.colors.colSubtext
            }
        }
        MaterialSymbol {
            text: "play_arrow"
            iconSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.colPrimary
        }
    }
}
