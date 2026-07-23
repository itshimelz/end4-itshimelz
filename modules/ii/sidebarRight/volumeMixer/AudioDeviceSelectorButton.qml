import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

RippleButton {
    id: button
    required property bool input

    buttonRadius: Appearance.rounding.small
    colBackground: Appearance.colors.colLayer2
    colBackgroundHover: Appearance.colors.colLayer2Hover
    colRipple: Appearance.colors.colLayer2Active

    implicitHeight: contentItem.implicitHeight + 6 * 2
    implicitWidth: contentItem.implicitWidth + 6 * 2

    contentItem: RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        MaterialSymbol {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: false
            Layout.leftMargin: 5
            color: Appearance.colors.colOnLayer2
            iconSize: Appearance.font.pixelSize.hugeass
            text: input ? "mic_external_on" : (Audio.activeSinkPortName.includes("headphone") ? "headphones" : "media_output")
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.rightMargin: 5
            spacing: 0
            StyledText {
                Layout.fillWidth: true
                elide: Text.ElideRight
                font.pixelSize: Appearance.font.pixelSize.normal
                text: input ? Translation.tr("Input") : Translation.tr("Output")
                color: Appearance.colors.colOnLayer2
            }
            StyledText {
                Layout.fillWidth: true
                elide: Text.ElideRight
                font.pixelSize: Appearance.font.pixelSize.smaller
                text: {
                    if (input) {
                        return Pipewire.defaultAudioSource?.description ?? Translation.tr("Unknown")
                    }
                    const activePort = Audio.outputSinkPorts.find(p => p.name === Audio.activeSinkPortName)
                    if (activePort && activePort.description) {
                        return activePort.description
                    }
                    return Pipewire.defaultAudioSink?.description ?? Translation.tr("Unknown")
                }
                color: Appearance.m3colors.m3outline
                animateChange: true
            }
        }
    }
}