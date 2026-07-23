import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

ColumnLayout {
    id: root
    required property bool isSink
    readonly property list<var> appPwNodes: isSink ? Audio.outputAppNodes : Audio.inputAppNodes
    readonly property list<var> devices: isSink ? Audio.outputDevices : Audio.inputDevices
    readonly property bool hasApps: appPwNodes.length > 0
    spacing: 14

    Component.onCompleted: {
        if (root.isSink)
            Audio.refreshSinkPortsFromPactl();
    }

    Connections {
        target: Pipewire
        function onReadyChanged() {
            if (Pipewire.ready && root.isSink)
                Audio.refreshSinkPortsFromPactl();
        }
    }

    DialogSectionListView {
        Layout.fillHeight: true
        topMargin: 14

        model: ScriptModel {
            values: root.appPwNodes
        }
        delegate: VolumeMixerEntry {
            anchors {
                left: parent?.left
                right: parent?.right
            }
            required property var modelData
            node: modelData
        }
        PagePlaceholder {
            icon: "widgets"
            title: Translation.tr("No applications")
            shown: !root.hasApps
            shape: MaterialShape.Shape.Cookie7Sided
        }
    }

    // ─── Material 3 Output Port Switcher (Speaker / Headphones) ───
    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: false
        spacing: 8
        visible: root.isSink && Audio.outputSinkPorts.length > 0

        StyledText {
            Layout.fillWidth: true
            text: Translation.tr("Audio Output Port").toUpperCase()
            font.pixelSize: Appearance.font.pixelSize.smaller
            font.weight: Font.Bold
            font.letterSpacing: 0.8
            color: Appearance.m3colors.m3primary
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Repeater {
                model: Audio.outputSinkPorts

                delegate: RippleButton {
                    required property var modelData
                    required property int index
                    readonly property bool isActive: modelData.name === Audio.activeSinkPortName

                    Layout.fillWidth: true
                    implicitHeight: 44
                    buttonRadius: Appearance.rounding.full
                    colBackground: isActive ? Appearance.m3colors.m3secondaryContainer : Appearance.m3colors.m3surfaceVariant
                    colBackgroundHover: isActive ? Appearance.m3colors.m3secondaryContainer : Appearance.m3colors.m3surfaceVariant
                    colRipple: Appearance.m3colors.m3primary

                    contentItem: RowLayout {
                        anchors.centerIn: parent
                        spacing: 8

                        MaterialSymbol {
                            text: {
                                const name = (modelData.name || "").toLowerCase()
                                const desc = (modelData.description || "").toLowerCase()
                                if (isActive) return "check"
                                if (name.includes("headphone") || desc.includes("headphone")) return "headphones"
                                return "speaker"
                            }
                            iconSize: Appearance.font.pixelSize.normal
                            color: isActive ? Appearance.m3colors.m3onSecondaryContainer : Appearance.m3colors.m3onSurfaceVariant
                        }

                        StyledText {
                            text: modelData.description
                            font.pixelSize: Appearance.font.pixelSize.normal
                            font.weight: isActive ? Font.Bold : Font.Medium
                            color: isActive ? Appearance.m3colors.m3onSecondaryContainer : Appearance.m3colors.m3onSurfaceVariant
                        }
                    }

                    onClicked: {
                        Audio.setSinkPortByPortName(modelData.name)
                    }
                }
            }
        }
    }

    // ─── Material 3 Device Selector Card ───
    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.bottomMargin: 4
        spacing: 6

        StyledText {
            Layout.fillWidth: true
            text: (root.isSink ? Translation.tr("Output Device") : Translation.tr("Input Device")).toUpperCase()
            font.pixelSize: Appearance.font.pixelSize.smaller
            font.weight: Font.Bold
            font.letterSpacing: 0.8
            color: Appearance.m3colors.m3primary
        }

        StyledComboBox {
            id: deviceSelector
            Layout.fillWidth: true
            model: root.devices.map(node => Audio.friendlyDeviceName(node))
            currentIndex: root.devices.findIndex(item => {
                if (root.isSink) {
                    return item.id === Pipewire.defaultAudioSink?.id
                } else {
                    return item.id === Pipewire.defaultAudioSource?.id
                }
            })
            onActivated: (index) => {
                const item = root.devices[index]
                if (root.isSink) {
                    Audio.setDefaultSink(item)
                } else {
                    Audio.setDefaultSource(item)
                }
            }
        }
    }

    component DialogSectionListView: StyledListView {
        Layout.fillWidth: true
        Layout.topMargin: -22
        Layout.bottomMargin: -16
        Layout.leftMargin: -Appearance.rounding.large
        Layout.rightMargin: -Appearance.rounding.large
        topMargin: 12
        bottomMargin: 12
        leftMargin: 20
        rightMargin: 20

        clip: true
        spacing: 4
        animateAppearance: false
    }
}
