pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.common.functions

Singleton {
    id: root

    readonly property MprisPlayer activePlayer: MprisController.activePlayer

    property bool isSynced: false
    property var lyricsLines: []
    property int activeIndex: -1
    property string status: "loading"
    property var slots: ["", "", "", "", "", "", ""]

    readonly property int before: 3
    readonly property int after:  3
    readonly property int total:  7

    function buildSlots(idx) {
        let result = []
        for (let i = 0; i < root.total; i++) {
            let lineIdx = idx - root.before + i
            if (lineIdx >= 0 && lineIdx < root.lyricsLines.length)
                result.push(root.lyricsLines[lineIdx].text || "♪")
            else
                result.push("")
        }
        return result
    }

    function updateActiveIndex() {
        if (root.status !== "ok" || !root.lyricsLines.length) return
        const pos = root.activePlayer?.position ?? 0
        let idx = -1
        for (let i = 0; i < root.lyricsLines.length; i++) {
            if (root.lyricsLines[i].time <= pos) idx = i
            else break
        }
        if (idx !== root.activeIndex) {
            root.activeIndex = idx
            root.slots = root.buildSlots(idx)
        }
    }

    Timer {
        id: syncTimer
        interval: 200
        repeat: true
        running: root.status === "ok" && root.lyricsLines.length > 0
        onTriggered: root.updateActiveIndex()
    }

    Process {
        id: lyricsProc
        running: false
        stdout: SplitParser {
            onRead: data => {
                const trimmed = data.trim()
                if (trimmed === "not_found") { root.status = "not_found"; return }
                if (trimmed === "no_info")   { root.status = "no_info";   return }

                const parts = trimmed.split("§")
                if (parts.length < 3) return
                const endTag = parts[parts.length - 1].trim()
                if (endTag !== "ok" && endTag !== "synced_ok" && endTag !== "plain_ok") return

                root.isSynced = (endTag === "synced_ok" || endTag === "ok")

                let rawLines = []
                for (let i = 0; i < parts.length - 1; i += 2) {
                    const t = parseFloat(parts[i])
                    const txt = parts[i + 1] || ""
                    if (!isNaN(t)) rawLines.push({ time: t, text: txt })
                }

                if (rawLines.length === 0) { root.status = "not_found"; return }

                // Process lines and insert instrumental breaks for gaps > 10s
                let lines = []
                for (let i = 0; i < rawLines.length; i++) {
                    lines.push(rawLines[i])
                    if (i < rawLines.length - 1) {
                        const gap = rawLines[i + 1].time - rawLines[i].time
                        if (gap > 10) {
                            lines.push({
                                time: rawLines[i].time + 2.5,
                                text: "♫  Instrumental Interlude  ♫",
                                isInstrumental: true
                            })
                        }
                    }
                }

                root.lyricsLines = lines
                root.status = "ok"
                root.updateActiveIndex()
            }
        }
    }

    function seekToTime(seconds) {
        if (root.activePlayer && root.activePlayer.canSeek) {
            root.activePlayer.position = seconds
        }
        Quickshell.execDetached(["playerctl", "position", String(seconds)])
    }

    function restartLyrics() {
        lyricsProc.running = false
        root.lyricsLines = []
        root.activeIndex = -1
        root.slots = ["", "", "", "", "", "", ""]
        root.status = "loading"

        const title    = root.activePlayer?.trackTitle  ?? ""
        const artist   = root.activePlayer?.trackArtist ?? ""
        const duration = root.activePlayer?.length       ?? 0

        if (!title) { root.status = "no_info"; return }

        lyricsProc.command = [
            "python3",
            `${Directories.scriptPath}/lyrics/lyrics.py`,
            title, artist, String(Math.floor(duration))
        ]
        lyricsProc.running = true
    }

    onActivePlayerChanged: root.restartLyrics()

    Connections {
        target: MprisController
        function onTrackChanged() { root.restartLyrics() }
    }

    Connections {
        target: root.activePlayer
        function onTrackTitleChanged() { root.restartLyrics() }
        function onTrackArtistChanged() { root.restartLyrics() }
    }

    Component.onCompleted: root.restartLyrics()
}