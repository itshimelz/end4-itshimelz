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
            height: Math.min(parent.height - 80, 640)
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

            ContentPage {
                anchors.fill: parent
                baseWidth: 620
                forceWidth: true
                bottomContentPadding: 35

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    ContentSection {
                        icon: "content_paste_go"
                        title: Translation.tr("Clipboard & Cache")
                        shape: MaterialShape.Shape.Puffy
                        Layout.fillWidth: true

                        ContentSubsection {
                            GroupedList {
                                ActionCard {
                                    buttonIcon: "delete_sweep"
                                    text: Translation.tr("Clear clipboard history")
                                    description: Translation.tr("Wipe all clipboard entries and sync")
                                    onClicked: {
                                        Quickshell.execDetached(["bash", "-c", "cliphist wipe && qs -c $qsConfig ipc call cliphistService update; notify-send 'Clipboard Cleared' 'All clipboard history entries have been deleted.' -a 'System Actions'"]);
                                        panelWindow.hide();
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "cleaning_services"
                                    text: Translation.tr("Clear temporary cache")
                                    description: Translation.tr("Remove thumbnail and app cache files")
                                    onClicked: {
                                        Quickshell.execDetached(["bash", "-c", "rm -rf ~/.cache/thumbnails/* ~/.cache/tmp/*; notify-send 'Cache Cleared' 'Temporary thumbnail and application cache cleared.' -a 'System Actions'"]);
                                        panelWindow.hide();
                                    }
                                }
                            }
                        }
                    }

                    ContentSection {
                        icon: "restart_alt"
                        title: Translation.tr("Services & Portals")
                        shape: MaterialShape.Shape.Clover4Leaf
                        Layout.fillWidth: true

                        ContentSubsection {
                            GroupedList {
                                ActionCard {
                                    buttonIcon: "sync"
                                    text: Translation.tr("Restart XDG desktop portals")
                                    description: Translation.tr("Fix file dialogs and screen sharing")
                                    onClicked: {
                                        Quickshell.execDetached(["bash", "-c", "systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal; notify-send 'XDG Portals Restarted' 'Hyprland and GTK desktop portals restarted.' -a 'System Actions'"]);
                                        panelWindow.hide();
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "tune"
                                    text: Translation.tr("Reload Hyprland config")
                                    description: Translation.tr("Re-apply compositor settings without restart")
                                    onClicked: {
                                        Quickshell.execDetached(["bash", "-c", "hyprctl reload; notify-send 'Hyprland Reloaded' 'Hyprland compositor configuration reloaded.' -a 'System Actions'"]);
                                        panelWindow.hide();
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "volume_up"
                                    text: Translation.tr("Restart PipeWire audio")
                                    description: Translation.tr("Fix audio glitches or missing sound output")
                                    onClicked: {
                                        Quickshell.execDetached(["bash", "-c", "systemctl --user restart pipewire pipewire-pulse wireplumber; notify-send 'PipeWire Restarted' 'Audio service and session manager restarted.' -a 'System Actions'"]);
                                        panelWindow.hide();
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "wifi"
                                    text: Translation.tr("Restart NetworkManager")
                                    description: Translation.tr("Fix WiFi or network connectivity issues")
                                    onClicked: {
                                        Quickshell.execDetached(["bash", "-c", "sudo systemctl restart NetworkManager; notify-send 'NetworkManager Restarted' 'Network service restarted. Reconnecting...' -a 'System Actions'"]);
                                        panelWindow.hide();
                                    }
                                }
                            }
                        }
                    }

                    ContentSection {
                        icon: "palette"
                        title: Translation.tr("Shell & Appearance")
                        shape: MaterialShape.Shape.Cookie4Sided
                        Layout.fillWidth: true

                        ContentSubsection {
                            GroupedList {
                                ActionCard {
                                    buttonIcon: "desktop_windows"
                                    text: Translation.tr("Restart Quickshell UI")
                                    description: Translation.tr("Kill and relaunch the desktop shell")
                                    onClicked: {
                                        Quickshell.execDetached(["bash", "-c", "notify-send 'Quickshell Restarted' 'Quickshell desktop UI reloaded successfully.' -a 'System Actions'; killall qs; qs -c $qsConfig &"]);
                                        panelWindow.hide();
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "brush"
                                    text: Translation.tr("Re-sync SDDM & theme colors")
                                    description: Translation.tr("Update login screen wallpaper and Material You colors")
                                    onClicked: {
                                        Quickshell.execDetached(["bash", "-c", "WALL=$(cat ~/.local/state/quickshell/user/generated/wallpaper/path.txt 2>/dev/null); [ -f \"$WALL\" ] && matugen image --source-color-index 0 \"$WALL\"; notify-send 'SDDM & Colors Synced' 'Material You theme colors and SDDM login background updated.' -a 'System Actions'"]);
                                        panelWindow.hide();
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "animation"
                                    text: Translation.tr("Toggle Hyprland animations")
                                    description: Translation.tr("Enable or disable compositor animations on the fly")
                                    onClicked: {
                                        Quickshell.execDetached(["bash", "-c", "STATE=$(hyprctl getoption animations:enabled -j | grep -o '\"int\": [01]' | grep -o '[01]'); if [ \"$STATE\" = \"1\" ]; then hyprctl keyword animations:enabled false; notify-send 'Animations Disabled' 'Hyprland compositor animations turned off.' -a 'System Actions'; else hyprctl keyword animations:enabled true; notify-send 'Animations Enabled' 'Hyprland compositor animations turned on.' -a 'System Actions'; fi"]);
                                        panelWindow.hide();
                                    }
                                }
                            }
                        }
                    }

                    ContentSection {
                        icon: "monitor"
                        title: Translation.tr("System")
                        shape: MaterialShape.Shape.ClamShell
                        Layout.fillWidth: true

                        ContentSubsection {
                            GroupedList {
                                ActionCard {
                                    buttonIcon: "screenshot_region"
                                    text: Translation.tr("Screenshot region")
                                    description: Translation.tr("Select and capture a region of the screen")
                                    onClicked: {
                                        panelWindow.hide();
                                        Quickshell.execDetached(["qs", "-p", Quickshell.shellPath(""), "ipc", "call", "region", "screenshot"]);
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "screen_record"
                                    text: Translation.tr("Toggle screen recording")
                                    description: Translation.tr("Start or stop wf-recorder screen capture")
                                    onClicked: {
                                        Quickshell.execDetached([Directories.recordScriptPath]);
                                        panelWindow.hide();
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "close"
                                    text: Translation.tr("Kill frozen window")
                                    description: Translation.tr("Click any window to force close it")
                                    onClicked: {
                                        panelWindow.hide();
                                        Quickshell.execDetached(["hyprctl", "kill"]);
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "lock"
                                    text: Translation.tr("Lock screen")
                                    description: Translation.tr("Lock the session with Hyprlock")
                                    onClicked: {
                                        panelWindow.hide();
                                        Quickshell.execDetached(["hyprlock"]);
                                    }
                                }
                                ActionCard {
                                    buttonIcon: "logout"
                                    text: Translation.tr("Logout session")
                                    description: Translation.tr("End the current Hyprland session")
                                    onClicked: {
                                        panelWindow.hide();
                                        Quickshell.execDetached(["hyprctl", "dispatch", "exit"]);
                                    }
                                }
                            }
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
