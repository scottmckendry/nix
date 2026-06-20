pragma Singleton
import QtQuick
import Quickshell

Singleton {
    // Palette
    property color bg: "#9916181a"
    property color bgAlt: "#1e2124"
    property color bgHighlight: "#3c4048"
    property color fg: "#ffffff"
    property color grey: "#7b8496"
    property color blue: "#5ea1ff"
    property color green: "#5eff6c"
    property color cyan: "#5ef1ff"
    property color red: "#ff6e5e"
    property color yellow: "#f1ff5e"
    property color magenta: "#ff5ef1"
    property color pink: "#ff5ea0"
    property color orange: "#ffbd5e"
    property color purple: "#bd5eff"

    // Font
    property string fontFamily: "JetBrains Mono"
    property int fontSize: 10

    // Windows
    property int radius: 20
    property var primaryDisplays: ["eDP-1", "DP-1"]
}
