pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property color textColor: "white"
    property color activeColor: "white"
    property color dimColor: Qt.rgba(1, 1, 1, 0.35)
    property color indicatorColor: Appearance.colors.colPrimaryContainer
    property color indicatorShapeColor: Appearance.colors.colOnPrimaryContainer
    property int textAlignment: Text.AlignLeft

    property bool isUserInteracting: false

    implicitWidth: 200
    implicitHeight: 200
    clip: true

    Timer {
        id: autoResyncTimer
        interval: 4000
        repeat: false
        onTriggered: {
            root.isUserInteracting = false
            lyricsListView.scrollToActive()
        }
    }

    Item {
        anchors.fill: parent
        visible: LyricsService.status !== "ok"

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 12

            MaterialLoadingIndicator {
                Layout.alignment: Qt.AlignHCenter
                loading: LyricsService.status === "loading"
                colBg: root.indicatorColor
                colShape: root.indicatorShapeColor
                implicitSize: 48
            }
        }
    }

    onVisibleChanged: {
        if (root.visible) {
            root.isUserInteracting = false
            lyricsListView.scrollToActive()
        }
    }

    ListView {
        id: lyricsListView
        anchors.fill: parent
        visible: LyricsService.status === "ok"
        model: LyricsService.lyricsLines
        spacing: 6
        clip: true

        highlightMoveDuration: 400

        header: Item {
            width: lyricsListView.width
            height: Math.max(20, lyricsListView.height / 2 - 20)
        }

        footer: Item {
            width: lyricsListView.width
            height: Math.max(20, lyricsListView.height / 2 - 20)
        }

        NumberAnimation {
            id: scrollAnimation
            target: lyricsListView
            property: "contentY"
            duration: 450
            easing.type: Easing.OutCubic
        }

        function scrollToActive() {
            if (LyricsService.activeIndex >= 0 && LyricsService.activeIndex < lyricsListView.count) {
                lyricsListView.currentIndex = LyricsService.activeIndex
                const item = lyricsListView.itemAtIndex(LyricsService.activeIndex)
                if (item) {
                    const targetY = item.y - (lyricsListView.height / 2) + (item.height / 2)
                    scrollAnimation.stop()
                    scrollAnimation.from = lyricsListView.contentY
                    scrollAnimation.to = targetY
                    scrollAnimation.start()
                } else {
                    lyricsListView.positionViewAtIndex(LyricsService.activeIndex, ListView.Center)
                }
            }
        }

        Connections {
            target: LyricsService
            function onActiveIndexChanged() {
                if (!root.isUserInteracting) {
                    lyricsListView.scrollToActive()
                }
            }
            function onStatusChanged() {
                if (LyricsService.status === "ok") {
                    root.isUserInteracting = false
                    lyricsListView.scrollToActive()
                }
            }
        }

        onMovementStarted: {
            scrollAnimation.stop()
            root.isUserInteracting = true
            autoResyncTimer.restart()
        }

        onFlickEnded: {
            autoResyncTimer.restart()
        }

        delegate: Item {
            id: lineDelegate
            required property int index
            required property var modelData

            width: lyricsListView.width
            implicitHeight: lineContent.implicitHeight + 4

            readonly property bool isActive: index === LyricsService.activeIndex
            readonly property int dist: Math.abs(index - LyricsService.activeIndex)

            RowLayout {
                id: lineContent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                TextEdit {
                    id: lyricText
                    Layout.fillWidth: true
                    horizontalAlignment: root.textAlignment
                    readOnly: true
                    selectByMouse: true
                    activeFocusOnPress: false
                    wrapMode: Text.WordWrap
                    text: lineDelegate.modelData.text || "♪"
                    font.family: Appearance.font.family
                    font.pixelSize: {
                        if (lineDelegate.isActive) return Appearance.font.pixelSize.normal
                        if (lineDelegate.dist === 1) return Appearance.font.pixelSize.small
                        return Appearance.font.pixelSize.smaller
                    }
                    font.weight: lineDelegate.isActive ? Font.Bold : Font.Normal
                    color: lineDelegate.isActive ? (root.activeColor !== "white" ? root.activeColor : Appearance.colors.colPrimary) : root.textColor
                    selectionColor: Appearance.colors.colPrimaryContainer
                    selectedTextColor: Appearance.colors.colOnPrimaryContainer

                    opacity: {
                        if (lineDelegate.isActive) return 1.0
                        if (lineDelegate.dist === 1) return 0.70
                        if (lineDelegate.dist === 2) return 0.45
                        return 0.25
                    }

                    Behavior on opacity { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: 300 } }
                }
            }

            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: (mouse) => {
                    if (lyricText.selectedText.length === 0) {
                        LyricsService.seekToTime(lineDelegate.modelData.time)
                        root.isUserInteracting = true
                        autoResyncTimer.restart()
                    } else {
                        mouse.accepted = false
                    }
                }
            }
        }
    }
}