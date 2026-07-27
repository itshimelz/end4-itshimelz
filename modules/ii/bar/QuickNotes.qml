import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

MouseArea {
    id: root
    property bool vertical: Config.options.bar.vertical
    property bool isMaterial: Config.options.bar.cornerStyle === 3

    property string noteText: ""
    readonly property int wordCount: {
        let trimmed = noteText.trim()
        if (trimmed.length === 0) return 0
        return trimmed.split(/\s+/).length
    }

    implicitWidth: vertical ? 32 : (contentLoader.item?.implicitWidth ?? 0)
    implicitHeight: vertical ? (contentLoader.item?.implicitHeight ?? 0) : Appearance.sizes.barHeight

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: true

    onClicked: (mouse) => {
        if (mouse.button === Qt.RightButton) {
            Quickshell.execDetached(["bash", "-c", "wl-copy < ~/.cache/quickshell/quick_notes.txt"])
        } else if (mouse.button === Qt.LeftButton) {
            notesPopup.toggle()
        }
    }

    FileView {
        id: noteFile
        path: `${Directories.home}/.cache/quickshell/quick_notes.txt`
        printErrors: false
        onLoaded: root.noteText = text()
    }

    Process {
        id: saveProc
        running: false
    }

    function saveNote(text) {
        root.noteText = text
        saveProc.command = ["bash", "-c", `mkdir -p ~/.cache/quickshell && printf '%s' '${text.replace(/'/g, "'\\''")}' > ~/.cache/quickshell/quick_notes.txt`]
        saveProc.running = true
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
                text: "edit_note"
                iconSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer1
                Layout.alignment: Qt.AlignVCenter
            }

            StyledText {
                font.pixelSize: Appearance.font.pixelSize.small
                color: root.isMaterial ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
                text: root.wordCount > 0 ? `${root.wordCount}w` : "Notes"
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
                    text: "edit_note"
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
                text: "edit_note"
                iconSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer1
                Layout.alignment: Qt.AlignHCenter
            }

            StyledText {
                font.pixelSize: Appearance.font.pixelSize.small
                color: root.isMaterial ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
                text: root.wordCount > 0 ? `${root.wordCount}w` : ""
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
                    text: "edit_note"
                    iconSize: Appearance.font.pixelSize.normal
                    color: Appearance.colors.colOnPrimary
                }
            }
        }
    }

    StyledPopup {
        id: notesPopup
        hoverTarget: root

        ColumnLayout {
            implicitWidth: 320
            spacing: 8

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                MaterialSymbol {
                    text: "edit_note"
                    iconSize: Appearance.font.pixelSize.large
                    color: Appearance.colors.colPrimary
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: -2

                    StyledText {
                        text: Translation.tr("Quick Notes")
                        font.pixelSize: Appearance.font.pixelSize.normal
                        font.weight: Font.Bold
                        color: Appearance.colors.colOnSurface
                    }

                    StyledText {
                        text: `${root.wordCount} ${Translation.tr("words")} · ${root.noteText.length} ${Translation.tr("chars")}`
                        font.pixelSize: Appearance.font.pixelSize.smallest
                        color: Appearance.colors.colOnSurfaceVariant
                        opacity: 0.7
                    }
                }

                RippleButton {
                    implicitWidth: 30
                    implicitHeight: 30
                    buttonRadius: Appearance.rounding.small
                    colBackground: Appearance.colors.colSurfaceContainerLow
                    colBackgroundHover: Appearance.colors.colSurfaceContainerHigh
                    colRipple: Appearance.colors.colPrimary
                    downAction: () => {
                        Quickshell.execDetached(["bash", "-c", "wl-copy < ~/.cache/quickshell/quick_notes.txt"])
                    }

                    contentItem: MaterialSymbol {
                        text: "content_copy"
                        iconSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        color: Appearance.colors.colOnSurfaceVariant
                    }
                }

                RippleButton {
                    implicitWidth: 30
                    implicitHeight: 30
                    buttonRadius: Appearance.rounding.small
                    colBackground: ColorUtils.transparentize(Appearance.colors.colErrorContainer, 0.5)
                    colBackgroundHover: Appearance.colors.colErrorContainer
                    colRipple: Appearance.colors.colError
                    downAction: () => {
                        noteArea.text = ""
                        root.saveNote("")
                    }

                    contentItem: MaterialSymbol {
                        text: "delete"
                        iconSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        color: Appearance.colors.colOnErrorContainer
                    }
                }
            }

            // Note Text Area
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 180
                color: Appearance.colors.colSurfaceContainerLow
                radius: Appearance.rounding.small
                clip: true

                Flickable {
                    anchors.fill: parent
                    anchors.margins: 8
                    contentWidth: width
                    contentHeight: noteArea.implicitHeight

                    TextEdit {
                        id: noteArea
                        width: parent.width
                        text: root.noteText
                        font.family: Appearance.font.family
                        font.pixelSize: Appearance.font.pixelSize.small
                        color: Appearance.colors.colOnSurface
                        selectionColor: Appearance.colors.colPrimaryContainer
                        selectedTextColor: Appearance.colors.colOnPrimaryContainer
                        wrapMode: Text.WordWrap
                        selectByMouse: true

                        StyledText {
                            visible: noteArea.text.length === 0
                            text: Translation.tr("Jot down quick thoughts, code, or links...")
                            font.pixelSize: Appearance.font.pixelSize.smaller
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 0.5
                        }

                        onTextChanged: {
                            saveTimer.restart()
                        }

                        Timer {
                            id: saveTimer
                            interval: 500
                            repeat: false
                            onTriggered: root.saveNote(noteArea.text)
                        }
                    }
                }
            }
        }
    }
}
