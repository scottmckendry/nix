import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: volume

    signal levelChanged(string glyph, real value, bool muted)

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property real sinkVolume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    readonly property bool sinkMuted: Pipewire.defaultAudioSink?.audio.muted ?? false

    readonly property string volumeGlyph: {
        if (sinkMuted)
            return "󰖁";
        if (sinkVolume < 0.10)
            return "󰕿";
        if (sinkVolume < 0.50)
            return "󰖀";
        return "󰕾";
    }

    Connections {
        target: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio ? Pipewire.defaultAudioSink.audio : null
        ignoreUnknownSignals: true
        function onVolumeChanged() {
            Qt.callLater(() => volume.levelChanged(volume.volumeGlyph, volume.sinkVolume, volume.sinkMuted));
        }
        function onMutedChanged() {
            Qt.callLater(() => volume.levelChanged(volume.volumeGlyph, volume.sinkVolume, volume.sinkMuted));
        }
    }
}
