import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: brightness

    signal levelChanged(string glyph, real value)

    property int currentBrightness: 0
    property int maxBrightness: 0
    property string backlightDevice: ""

    readonly property real brightnessRatio: maxBrightness > 0 ? currentBrightness / maxBrightness : 0

    readonly property string brightnessGlyph: {
        if (brightnessRatio <= 0.10)
            return "󰃞";
        if (brightnessRatio < 0.66)
            return "󰃟";
        return "󰃠";
    }

    Process {
        command: ["ls", "/sys/class/backlight/"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const devices = this.text.trim().split('\n').filter(d => d.length > 0);
                if (devices.length > 0)
                    brightness.backlightDevice = devices[0];
            }
        }
    }

    FileView {
        id: brightnessFile
        path: brightness.backlightDevice ? "/sys/class/backlight/" + brightness.backlightDevice + "/brightness" : ""
        watchChanges: true
        onFileChanged: reload()
    }

    FileView {
        id: maxBrightnessFile
        path: brightness.backlightDevice ? "/sys/class/backlight/" + brightness.backlightDevice + "/max_brightness" : ""
        watchChanges: true
        onFileChanged: reload()
    }

    Connections {
        target: maxBrightnessFile
        function onLoaded() {
            brightness.maxBrightness = parseInt(maxBrightnessFile.text()) || 0;
        }
    }

    Connections {
        target: brightnessFile
        function onLoaded() {
            brightness.currentBrightness = parseInt(brightnessFile.text()) || 0;
            brightness.levelChanged(brightness.brightnessGlyph, brightness.brightnessRatio);
        }
    }
}
