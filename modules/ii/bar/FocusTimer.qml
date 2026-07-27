import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    property bool vertical: Config.options.bar.vertical
    property bool isMaterial: Config.options.bar.cornerStyle === 3

    readonly property bool isRunning: TimerService.pomodoroRunning
    readonly property bool isBreak: TimerService.pomodoroBreak
    readonly property bool isLongBreak: TimerService.pomodoroLongBreak
    readonly property int remainingSeconds: TimerService.pomodoroSecondsLeft

    readonly property string formattedTime: {
        let mins = Math.floor(Math.max(0, root.remainingSeconds) / 60)
        let secs = Math.max(0, root.remainingSeconds) % 60
        let mStr = mins < 10 ? `0${mins}` : `${mins}`
        let sStr = secs < 10 ? `0${secs}` : `${secs}`
        return `${mStr}:${sStr}`
    }

    readonly property string timerIconName: root.isLongBreak ? "self_improvement" : root.isBreak ? "coffee" : "timer"

    implicitWidth: vertical ? 32 : (contentLoader.item?.implicitWidth ?? 0)
    implicitHeight: vertical ? (contentLoader.item?.implicitHeight ?? 0) : Appearance.sizes.barHeight

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: !Config.options.bar.tooltips.clickToShow

    onPressed: (mouse) => {
        if (mouse.button === Qt.RightButton) {
            TimerService.resetPomodoro()
        } else if (mouse.button === Qt.LeftButton) {
            TimerService.togglePomodoro()
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

            StyledText {
                font.pixelSize: Appearance.font.pixelSize.small
                color: root.isMaterial ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
                text: root.formattedTime
                font.features: { "tnum": 1 }
                Layout.alignment: Qt.AlignVCenter
                leftPadding: root.isMaterial ? 5 : 0
            }

            Rectangle {
                visible: root.isMaterial
                width: 25
                height: 25
                radius: Appearance.rounding.full
                color: root.isRunning ? Appearance.colors.colPrimary : Appearance.colors.colSecondaryContainer

                MaterialSymbol {
                    anchors.centerIn: parent
                    text: root.timerIconName
                    iconSize: Appearance.font.pixelSize.normal
                    color: root.isRunning ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
                }
            }

            MaterialSymbol {
                visible: !root.isMaterial
                text: root.timerIconName
                iconSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer1
                opacity: root.isRunning ? 1.0 : 0.6
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    Component {
        id: colContent
        ColumnLayout {
            spacing: root.isMaterial ? 2 : 0

            StyledText {
                font.pixelSize: Appearance.font.pixelSize.small
                color: root.isMaterial ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
                text: root.formattedTime
                font.features: { "tnum": 1 }
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                visible: root.isMaterial
                width: 25
                height: 25
                radius: Appearance.rounding.full
                color: root.isRunning ? Appearance.colors.colPrimary : Appearance.colors.colSecondaryContainer
                Layout.alignment: Qt.AlignHCenter

                MaterialSymbol {
                    anchors.centerIn: parent
                    text: root.timerIconName
                    iconSize: Appearance.font.pixelSize.normal
                    color: root.isRunning ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
                }
            }

            MaterialSymbol {
                visible: !root.isMaterial
                text: root.timerIconName
                iconSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer1
                opacity: root.isRunning ? 1.0 : 0.6
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
