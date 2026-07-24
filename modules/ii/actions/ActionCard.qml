import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    property string icon: ""
    property string title: ""
    property string buttonIcon: "play_arrow"
    property string buttonText: "Run"
    signal clicked()

    radius: Appearance.rounding.normal
    color: Appearance.colors.colLayer1
    border.width: 0
    implicitHeight: 90

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // Title Header with Icon
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            MaterialSymbol {
                text: root.icon
                iconSize: 18
                color: Appearance.colors.colSubtext
                visible: root.icon !== ""
            }

            StyledText {
                Layout.fillWidth: true
                text: root.title
                font.pixelSize: Appearance.font.pixelSize.normal
                font.bold: true
                color: Appearance.colors.colOnLayer1
                elide: Text.ElideRight
            }
        }

        // Action Pill Button Row
        RowLayout {
            Layout.fillWidth: true

            Item { Layout.fillWidth: true }

            Rectangle {
                implicitHeight: 34
                implicitWidth: buttonRow.implicitWidth + 24
                radius: 17
                color: pillMouseArea.containsMouse ? Appearance.colors.colPrimaryContainerHover : Appearance.colors.colPrimaryContainer

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                MouseArea {
                    id: pillMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.clicked()
                }

                RowLayout {
                    id: buttonRow
                    anchors.centerIn: parent
                    spacing: 6

                    MaterialSymbol {
                        text: root.buttonIcon
                        iconSize: 16
                        color: Appearance.colors.colOnPrimaryContainer
                        visible: root.buttonIcon !== ""
                    }

                    StyledText {
                        text: root.buttonText
                        font.pixelSize: Appearance.font.pixelSize.small
                        font.bold: true
                        color: Appearance.colors.colOnPrimaryContainer
                    }
                }
            }
        }
    }
}
