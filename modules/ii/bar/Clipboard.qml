import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    property bool vertical: Config.options.bar.vertical
    property bool isMaterial: Config.options.bar.cornerStyle === 3

    readonly property int itemCount: Cliphist.entries.length

    implicitWidth: vertical ? 32 : (contentLoader.item?.implicitWidth ?? 0)
    implicitHeight: vertical ? (contentLoader.item?.implicitHeight ?? 0) : Appearance.sizes.barHeight

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: !Config.options.bar.tooltips.clickToShow

    onClicked: (mouse) => {
        if (mouse.button === Qt.RightButton) {
            Cliphist.wipe()
        } else if (mouse.button === Qt.LeftButton) {
            GlobalStates.overviewOpen = !GlobalStates.overviewOpen
        }
    }

    Loader {
        id: contentLoader
        anchors.centerIn: parent
        sourceComponent: root.vertical ? colContent : rowContent
    }

    Component {
        id: rowContent
        RowLayout {
            spacing: 6

            MaterialSymbol {
                visible: !root.isMaterial
                text: "assignment"
                iconSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer1
                Layout.alignment: Qt.AlignVCenter
            }

            StyledText {
                font.pixelSize: Appearance.font.pixelSize.small
                color: root.isMaterial ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
                text: `${root.itemCount}`
                Layout.alignment: Qt.AlignVCenter
                leftPadding: root.isMaterial ? 5 : 0
            }

            Rectangle {
                visible: root.isMaterial
                width: 25
                height: 25
                radius: Appearance.rounding.full
                color: Appearance.colors.colPrimary

                MaterialSymbol {
                    anchors.centerIn: parent
                    text: "assignment"
                    iconSize: Appearance.font.pixelSize.normal
                    color: Appearance.colors.colOnPrimary
                }
            }
        }
    }

    Component {
        id: colContent
        ColumnLayout {
            spacing: root.isMaterial ? 2 : 0

            MaterialSymbol {
                visible: !root.isMaterial
                text: "assignment"
                iconSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer1
                Layout.alignment: Qt.AlignHCenter
            }

            StyledText {
                font.pixelSize: Appearance.font.pixelSize.small
                color: root.isMaterial ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
                text: `${root.itemCount}`
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                visible: root.isMaterial
                width: 25
                height: 25
                radius: Appearance.rounding.full
                color: Appearance.colors.colPrimary
                Layout.alignment: Qt.AlignHCenter

                MaterialSymbol {
                    anchors.centerIn: parent
                    text: "assignment"
                    iconSize: Appearance.font.pixelSize.normal
                    color: Appearance.colors.colOnPrimary
                }
            }
        }
    }
}
