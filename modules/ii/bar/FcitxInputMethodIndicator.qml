import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property color color: Appearance.colors.colOnLayer1
    property string inputMethod: "keyboard-us"

    implicitWidth: 24
    implicitHeight: 24

    function isBangla(im) {
        if (!im) return false
        const lower = im.toLowerCase()
        return lower.includes("openbangla") || lower.includes("bd") || lower.includes("bangla")
    }

    function iconFor(im) {
        return isBangla(im) ? "translate" : "keyboard"
    }

    function descriptionFor(im) {
        return isBangla(im) ? (typeof Translation !== "undefined" ? Translation.tr("Bangla (OpenBangla)") : "Bangla (OpenBangla)") 
                            : (typeof Translation !== "undefined" ? Translation.tr("English (US)") : "English (US)")
    }

    Process {
        id: fcitxProc
        command: ["fcitx5-remote", "-n"]
        stdout: SplitParser {
            onRead: data => {
                const method = data.trim()
                if (method.length > 0) {
                    root.inputMethod = method
                }
            }
        }
    }

    Process {
        id: toggleProc
        command: ["fcitx5-remote", "-t"]
        onExited: {
            fcitxProc.running = true
        }
    }

    Timer {
        interval: 300
        running: true
        repeat: true
        onTriggered: {
            if (!fcitxProc.running) {
                fcitxProc.running = true
            }
        }
    }

    Component.onCompleted: {
        fcitxProc.running = true
    }

    MaterialSymbol {
        anchors.centerIn: parent
        text: root.iconFor(root.inputMethod)
        iconSize: Appearance.font.pixelSize.larger
        color: root.color
        animateChange: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            toggleProc.running = true
        }

        PopupToolTip {
            extraVisibleCondition: mouseArea.containsMouse
            text: root.descriptionFor(root.inputMethod)
        }
    }
}
