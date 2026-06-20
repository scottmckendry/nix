import QtQuick
import Quickshell
import Quickshell.Widgets
import "./osd" as OsdKinds

Scope {
    id: osd

    property int timeout: 1500

    readonly property real panelWidth: 160
    readonly property real panelHeight: 160
    readonly property real panelRadius: 24
    readonly property real iconSize: 56
    readonly property real barWidth: 100
    readonly property real barHeight: 10
    readonly property real barRadius: 5

    property bool shouldShow: false
    property string activeIcon: ""
    property real activeValue: 0
    property color activeAccent: Config.cyan
    property string activeMode: "level"
    property bool activeToggleOn: false

    function show() {
        shouldShow = true;
        hideTimer.restart();
    }

    function showLevel(icon, value, accent) {
        activeMode = "level";
        activeIcon = icon;
        activeValue = value;
        activeAccent = accent;
        activeToggleOn = false;
        show();
    }

    function showToggle(icon, isOn, forceShow) {
        activeMode = "toggle";
        activeIcon = icon;
        activeValue = 0;
        activeAccent = isOn ? Config.orange : Config.grey;
        activeToggleOn = isOn;
        if (forceShow)
            show();
    }

    Timer {
        id: hideTimer
        interval: osd.timeout
        onTriggered: osd.shouldShow = false
    }

    OsdKinds.Brightness {
        onLevelChanged: function (icon, value) {
            osd.showLevel(icon, value, Config.cyan);
        }
    }

    OsdKinds.Volume {
        onLevelChanged: function (icon, value, muted) {
            osd.showLevel(icon, value, muted ? Config.red : Config.cyan);
        }
    }

    OsdKinds.Nightlight {
        onToggleChanged: function (icon, isOn, forceShow) {
            osd.showToggle(icon, isOn, forceShow);
        }
    }

    LazyLoader {
        active: osd.shouldShow

        PanelWindow {
            anchors.bottom: true
            margins.bottom: screen.height / 5
            exclusiveZone: 0

            implicitWidth: osd.panelWidth
            implicitHeight: osd.panelHeight
            color: "transparent"
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: osd.panelRadius
                color: Config.bg

                Column {
                    anchors.centerIn: parent
                    spacing: 16

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: osd.activeIcon
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: osd.iconSize
                        color: osd.activeMode === "toggle" ? osd.activeAccent : Config.fg
                    }

                    Rectangle {
                        visible: osd.activeMode === "level"
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: osd.barWidth
                        height: osd.barHeight
                        radius: osd.barRadius
                        color: Config.bgHighlight

                        Rectangle {
                            width: osd.activeValue * parent.width
                            height: parent.height
                            radius: osd.barRadius
                            color: osd.activeAccent

                            Behavior on width {
                                NumberAnimation {
                                    duration: 80
                                }
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 80
                                }
                            }
                        }
                    }

                    Rectangle {
                        visible: osd.activeMode === "toggle"
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 44
                        height: osd.barHeight * 2.2
                        radius: osd.barRadius * 2
                        color: osd.activeToggleOn ? Qt.rgba(osd.activeAccent.r, osd.activeAccent.g, osd.activeAccent.b, 0.3) : Config.bgHighlight
                        border.width: 1
                        border.color: osd.activeToggleOn ? Qt.rgba(osd.activeAccent.r, osd.activeAccent.g, osd.activeAccent.b, 0.7) : Qt.rgba(Config.fg.r, Config.fg.g, Config.fg.b, 0.2)

                        Rectangle {
                            id: toggleKnob
                            width: parent.height - 6
                            height: parent.height - 6
                            radius: height / 2
                            y: 3
                            x: osd.activeToggleOn ? parent.width - width - 3 : 3
                            color: osd.activeToggleOn ? osd.activeAccent : Qt.rgba(Config.fg.r, Config.fg.g, Config.fg.b, 0.35)

                            Behavior on x {
                                id: knobBehavior
                                NumberAnimation {
                                    duration: 110
                                }
                            }

                            Component.onCompleted: {
                                knobBehavior.enabled = false
                                x = osd.activeToggleOn ? 3 : parent.width - width - 3
                                toggleDelay.start()
                            }
                        }

                        Timer {
                            id: toggleDelay
                            interval: 32
                            onTriggered: {
                                knobBehavior.enabled = true
                                toggleKnob.x = Qt.binding(function() { return osd.activeToggleOn ? toggleKnob.parent.width - toggleKnob.width - 3 : 3 })
                            }
                        }
                    }
                }
            }
        }
    }
}
