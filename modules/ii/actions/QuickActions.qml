//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions as CF

Scope {
    id: root

    Component.onCompleted: {
        GlobalStates.quickActionsOpen = false;
    }

    PanelWindow {
        id: panelWindow
        visible: GlobalStates.quickActionsOpen

        function hide() {
            GlobalStates.quickActionsOpen = false;
        }

        exclusiveZone: 0
        WlrLayershell.namespace: "quickshell:actions"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: GlobalStates.quickActionsOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        onVisibleChanged: {
            if (visible) {
                GlobalFocusGrab.addDismissable(panelWindow);
            } else {
                GlobalFocusGrab.removeDismissable(panelWindow);
            }
        }

        Connections {
            target: GlobalFocusGrab
            function onDismissed() {
                panelWindow.hide();
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            opacity: GlobalStates.quickActionsOpen ? 1 : 0
            z: 0
            Behavior on opacity {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: false
                onClicked: panelWindow.hide()
            }
        }

        Rectangle {
            id: actionsWindow
            anchors.centerIn: parent
            width: Math.min(parent.width - 80, 720)
            height: Math.min(parent.height - 80, 440)
            color: Appearance.colors.colLayer0
            border.width: 1
            border.color: Appearance.colors.colLayer0Border
            radius: Appearance.rounding.screenRounding - Appearance.sizes.hyprlandGapsOut + 5
            z: 1

            opacity: GlobalStates.quickActionsOpen ? 1 : 0
            scale: GlobalStates.quickActionsOpen ? 1 : 0.95

            Behavior on opacity {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape) {
                    panelWindow.hide();
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                // Section Title (Matches settings design)
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Rectangle {
                        implicitWidth: 32
                        implicitHeight: 32
                        radius: 8
                        color: Appearance.colors.colPrimaryContainer

                        MaterialSymbol {
                            anchors.centerIn: parent
                            text: "bolt"
                            iconSize: 20
                            color: Appearance.colors.colOnPrimaryContainer
                        }
                    }

                    StyledText {
                        text: Translation.tr("System Actions & Maintenance")
                        font.pixelSize: Appearance.font.pixelSize.large
                        font.bold: true
                        color: Appearance.colors.colOnLayer0
                    }

                    Item { Layout.fillWidth: true }

                    Rectangle {
                        implicitWidth: 32
                        implicitHeight: 32
                        radius: 16
                        color: closeMouseArea.containsMouse ? Appearance.colors.colLayer1Hover : "transparent"

                        MouseArea {
                            id: closeMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: panelWindow.hide()
                        }

                        MaterialSymbol {
                            anchors.centerIn: parent
                            text: "close"
                            iconSize: 18
                            color: Appearance.colors.colSubtext
                        }
                    }
                }

                // Grid of 2-column cards
                GridLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    columns: 2
                    rowSpacing: 14
                    columnSpacing: 14

                    // Action 1: Clear Clipboard
                    ActionCard {
                        Layout.fillWidth: true
                        icon: "delete_sweep"
                        title: Translation.tr("Clipboard History")
                        buttonIcon: "delete"
                        buttonText: Translation.tr("Clear All")
                        onClicked: {
                            Quickshell.execDetached(["bash", "-c", "cliphist wipe && qs -c $qsConfig ipc call cliphistService update; notify-send 'Clipboard Cleared' 'All clipboard history entries have been deleted.' -a 'System Actions'"]);
                            panelWindow.hide();
                        }
                    }

                    // Action 2: Restart XDG Portals
                    ActionCard {
                        Layout.fillWidth: true
                        icon: "restart_alt"
                        title: Translation.tr("XDG Desktop Portals")
                        buttonIcon: "refresh"
                        buttonText: Translation.tr("Restart")
                        onClicked: {
                            Quickshell.execDetached(["bash", "-c", "systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal; notify-send 'XDG Portals Restarted' 'Hyprland and GTK desktop portals restarted.' -a 'System Actions'"]);
                            panelWindow.hide();
                        }
                    }

                    // Action 3: Reload Hyprland
                    ActionCard {
                        Layout.fillWidth: true
                        icon: "tune"
                        title: Translation.tr("Hyprland Compositor")
                        buttonIcon: "sync"
                        buttonText: Translation.tr("Reload Config")
                        onClicked: {
                            Quickshell.execDetached(["bash", "-c", "hyprctl reload; notify-send 'Hyprland Reloaded' 'Hyprland compositor configuration reloaded.' -a 'System Actions'"]);
                            panelWindow.hide();
                        }
                    }

                    // Action 4: Restart Shell
                    ActionCard {
                        Layout.fillWidth: true
                        icon: "desktop_windows"
                        title: Translation.tr("Quickshell Desktop UI")
                        buttonIcon: "power_settings_new"
                        buttonText: Translation.tr("Restart Shell")
                        onClicked: {
                            Quickshell.execDetached(["bash", "-c", "notify-send 'Quickshell Restarted' 'Quickshell desktop UI reloaded successfully.' -a 'System Actions'; killall qs; qs -c $qsConfig &"]);
                            panelWindow.hide();
                        }
                    }

                    // Action 5: Re-sync Wallpaper & SDDM
                    ActionCard {
                        Layout.fillWidth: true
                        icon: "palette"
                        title: Translation.tr("SDDM & Theme Colors")
                        buttonIcon: "brush"
                        buttonText: Translation.tr("Re-sync")
                        onClicked: {
                            Quickshell.execDetached(["bash", "-c", "WALL=$(cat ~/.local/state/quickshell/user/generated/wallpaper/path.txt 2>/dev/null); [ -f \"$WALL\" ] && matugen image --source-color-index 0 \"$WALL\"; notify-send 'SDDM & Colors Synced' 'Material You theme colors and SDDM login background updated.' -a 'System Actions'"]);
                            panelWindow.hide();
                        }
                    }

                    // Action 6: Clear Cache
                    ActionCard {
                        Layout.fillWidth: true
                        icon: "cleaning_services"
                        title: Translation.tr("Temporary User Cache")
                        buttonIcon: "auto_delete"
                        buttonText: Translation.tr("Clean Cache")
                        onClicked: {
                            Quickshell.execDetached(["bash", "-c", "rm -rf ~/.cache/thumbnails/* ~/.cache/tmp/*; notify-send 'Cache Cleared' 'Temporary thumbnail and application cache cleared.' -a 'System Actions'"]);
                            panelWindow.hide();
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "actions"
        function toggle(): void { GlobalStates.quickActionsOpen = !GlobalStates.quickActionsOpen; }
        function open(): void   { GlobalStates.quickActionsOpen = true; }
        function close(): void  { GlobalStates.quickActionsOpen = false; }
    }

    GlobalShortcut {
        name: "actionsToggle"
        description: "Toggles quick actions panel"
        onPressed: GlobalStates.quickActionsOpen = !GlobalStates.quickActionsOpen;
    }
}
