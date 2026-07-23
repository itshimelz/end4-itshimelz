pragma Singleton
pragma ComponentBehavior: Bound
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

/**
 * A nice wrapper for default Pipewire audio sink and source.
 */
Singleton {
    id: root

    // Misc props
    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource
    readonly property real hardMaxValue: 2.00 // People keep joking about setting volume to 5172% so...
    property string audioTheme: Config.options.sounds.theme
    property real value: sink?.audio.volume ?? 0

    // Audio Output Sink Ports (e.g. Line Out / Speaker vs Headphones)
    property list<var> outputSinkPorts: []
    property string activeSinkPortName: ""
    property string outputSinkPactlName: ""
    property bool switchingPortOrDevice: false
    
    function friendlyDeviceName(node) {
        return (node.nickname || node.description || Translation.tr("Unknown"));
    }
    function appNodeDisplayName(node) {
        return (node.properties["application.name"] || node.description || node.name)
    }

    // Lists
    function correctType(node, isSink) {
        return (node.isSink === isSink) && node.audio
    }
    function appNodes(isSink) {
        return Pipewire.nodes.values.filter((node) => {
            return root.correctType(node, isSink) && node.isStream
        })
    }
    function devices(isSink) {
        return Pipewire.nodes.values.filter(node => {
            return root.correctType(node, isSink) && !node.isStream
        })
    }
    readonly property list<var> outputAppNodes: root.appNodes(true)
    readonly property list<var> inputAppNodes: root.appNodes(false)
    readonly property list<var> outputDevices: root.devices(true)
    readonly property list<var> inputDevices: root.devices(false)

    // Signals
    signal sinkProtectionTriggered(string reason);

    // Controls
    function toggleMute() {
        Audio.sink.audio.muted = !Audio.sink.audio.muted
    }

    function toggleMicMute() {
        Audio.source.audio.muted = !Audio.source.audio.muted
    }

    function incrementVolume() {
        const currentVolume = Audio.value;
        const step = currentVolume < 0.1 ? 0.01 : 0.02 || 0.2;
        Audio.sink.audio.volume = Math.min(1, Audio.sink.audio.volume + step);
    }
    
    function decrementVolume() {
        const currentVolume = Audio.value;
        const step = currentVolume < 0.1 ? 0.01 : 0.02 || 0.2;
        Audio.sink.audio.volume -= step;
    }

    function setDefaultSink(node) {
        root.switchingPortOrDevice = true;
        volumeProtectionConn.resetState();
        Pipewire.preferredDefaultAudioSink = node;
        pactlPortsRefreshTimer.restart();
        portSwitchGuardTimer.restart();
    }

    function setDefaultSource(node) {
        Pipewire.preferredDefaultAudioSource = node;
    }

    onSinkChanged: {
        volumeProtectionConn.resetState();
    }

    /** Refresh output port list for Pipewire.defaultAudioSink */
    function refreshSinkPortsFromPactl() {
        if (!Pipewire.ready || !Pipewire.defaultAudioSink) {
            root.outputSinkPorts = [];
            root.activeSinkPortName = "";
            root.outputSinkPactlName = "";
            return;
        }
        pactlListSinks.running = true;
    }

    function setSinkPortByPortName(portName) {
        if (!portName || !root.outputSinkPactlName)
            return;
        root.switchingPortOrDevice = true;
        volumeProtectionConn.resetState();
        Quickshell.execDetached(["pactl", "set-sink-port", root.outputSinkPactlName, portName]);
        root.activeSinkPortName = portName;
        pactlPortsRefreshTimer.restart();
        portSwitchGuardTimer.restart();
    }

    Timer {
        id: portSwitchGuardTimer
        interval: 1200
        repeat: false
        onTriggered: root.switchingPortOrDevice = false
    }

    function pactlSinkMatchesNode(sinkJson, node) {
        if (!node || !sinkJson)
            return false;
        const pactlName = sinkJson.name || "";
        const propName = node.properties["node.name"] || "";
        if (propName && (propName === pactlName || pactlName.endsWith(propName) || propName.endsWith(pactlName)))
            return true;
        if (node.name && (node.name === pactlName || pactlName.includes(node.name) || node.name.includes(pactlName)))
            return true;
        const nd = (node.description || "").trim().toLowerCase();
        const jd = (sinkJson.description || "").trim().toLowerCase();
        if (nd && jd && (nd === jd || jd.includes(nd) || nd.includes(jd)))
            return true;
        return false;
    }

    function friendlySinkPortDescription(port) {
        if (!port)
            return "";
        const portName = (port.name || "").toLowerCase();
        if (portName === "analog-output-lineout")
            return "Speaker";
        const raw = (port.description || port.name || "").trim();
        if (/line\s*out/i.test(raw))
            return "Speaker";
        return raw || port.name || "";
    }

    function _applyPactlSinksJson(text) {
        root.outputSinkPorts = [];
        root.activeSinkPortName = "";
        root.outputSinkPactlName = "";
        if (!text || typeof text !== "string")
            return;
        const trimmed = text.trim();
        if (!trimmed)
            return;
        let sinks;
        try {
            sinks = JSON.parse(trimmed);
        } catch (e) {
            return;
        }
        if (!Array.isArray(sinks))
            return;
        const node = Pipewire.defaultAudioSink;
        if (!node)
            return;
        const sinkJson = sinks.find(s => root.pactlSinkMatchesNode(s, node));
        if (!sinkJson || !sinkJson.name)
            return;
        root.outputSinkPactlName = sinkJson.name;
        const active = sinkJson.active_port;
        root.activeSinkPortName = typeof active === "string" ? active : "";
        const portsRaw = sinkJson.ports;
        if (!Array.isArray(portsRaw))
            return;
        const out = [];
        for (let i = 0; i < portsRaw.length; i++) {
            const p = portsRaw[i];
            if (!p || !p.name)
                continue;
            const av = (p.availability || "").toLowerCase();
            if (av === "not available")
                continue;
            out.push({
                name: p.name,
                description: root.friendlySinkPortDescription(p)
            });
        }
        root.outputSinkPorts = out;
    }

    Timer {
        id: pactlPortsRefreshTimer
        interval: 200
        repeat: false
        onTriggered: root.refreshSinkPortsFromPactl()
    }

    Process {
        id: pactlListSinks
        command: ["pactl", "-f", "json", "list", "sinks"]
        stdout: StdioCollector {
            id: pactlListSinksOut
            onStreamFinished: {
                root._applyPactlSinksJson(pactlListSinksOut.text);
            }
        }
    }

    // Internals
    PwObjectTracker {
        objects: [sink, source]
    }

    Connections { // Protection against sudden volume changes
        id: volumeProtectionConn
        target: sink?.audio ?? null
        property bool lastReady: false
        property real lastVolume: 0

        function resetState() {
            lastReady = false;
            lastVolume = 0;
        }

        function onVolumeChanged() {
            if (!Config.options.audio.protection.enable || root.switchingPortOrDevice) return;
            const newVolume = sink.audio.volume;
            if (isNaN(newVolume) || newVolume === undefined || newVolume === null) {
                lastReady = false;
                lastVolume = 0;
                return;
            }
            if (!lastReady) {
                lastVolume = newVolume;
                lastReady = true;
                return;
            }
            const maxAllowedIncrease = Config.options.audio.protection.maxAllowedIncrease / 100; 
            const maxAllowed = Config.options.audio.protection.maxAllowed / 100;

            if (newVolume - lastVolume > maxAllowedIncrease) {
                sink.audio.volume = lastVolume;
                root.sinkProtectionTriggered(Translation.tr("Illegal increment"));
            } else if (newVolume > maxAllowed || newVolume > root.hardMaxValue) {
                root.sinkProtectionTriggered(Translation.tr("Exceeded max allowed"));
                sink.audio.volume = Math.min(lastVolume, maxAllowed);
            }
            lastVolume = sink.audio.volume;
        }
    }

    Connections {
        target: Pipewire
        function onDefaultAudioSinkChanged() {
            volumeProtectionConn.resetState();
            pactlPortsRefreshTimer.restart();
        }
        function onReadyChanged() {
            if (Pipewire.ready) {
                volumeProtectionConn.resetState();
                pactlPortsRefreshTimer.restart();
            }
        }
    }

    function playSystemSound(soundName) {
        const ogaPath = `/usr/share/sounds/${root.audioTheme}/stereo/${soundName}.oga`;
        const oggPath = `/usr/share/sounds/${root.audioTheme}/stereo/${soundName}.ogg`;

        let command = [
            "ffplay",
            "-nodisp",
            "-autoexit",
            ogaPath
        ];
        Quickshell.execDetached(command);

        command = [
            "ffplay",
            "-nodisp",
            "-autoexit",
            oggPath
        ];
        Quickshell.execDetached(command);
    }
}
