import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Scope {
    id: powerMenu
    property bool isOpen: false

    IpcHandler {
        target: "powermenu"

        function toggle(): void {
            powerMenu.isOpen = !powerMenu.isOpen;
        }
    }

    Process {
        id: logoutProc
        command: ["niri", "msg", "action", "quit"]
        running: false
    }
    Process {
        id: rebootProc
        command: ["reboot"]
        running: false
    }
    Process {
        id: suspendProc
        command: ["systemctl", "suspend"]
        running: false
    }
    Process {
        id: shutdownProc
        command: ["shutdown", "now"]
        running: false
    }
    Process {
        id: hibernateProc
        command: ["systemctl", "hibernate"]
        running: false
    }
    property var lockscreen: null

    function executeAction(action: string): void {
        powerMenu.isOpen = false;
        switch (action) {
        case "logout":
            logoutProc.running = true;
            break;
        case "reboot":
            rebootProc.running = true;
            break;
        case "suspend":
            suspendProc.running = true;
            break;
        case "shutdown":
            shutdownProc.running = true;
            break;
        case "hibernate":
            hibernateProc.running = true;
            break;
        case "lock":
            if (lockscreen) lockscreen.locked = true;
            break;
        }
    }

    LazyLoader {
        active: powerMenu.isOpen

        PanelWindow {
            id: window
            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true
            exclusiveZone: 0
            color: Config.bg
            focusable: true

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                focus: true

                Keys.onPressed: event => {
                    switch (event.key) {
                    case Qt.Key_Escape:
                        powerMenu.isOpen = false;
                        break;
                    case Qt.Key_Q:
                        powerMenu.executeAction("logout");
                        break;
                    case Qt.Key_R:
                        powerMenu.executeAction("reboot");
                        break;
                    case Qt.Key_S:
                        powerMenu.executeAction("suspend");
                        break;
                    case Qt.Key_P:
                        powerMenu.executeAction("shutdown");
                        break;
                    case Qt.Key_H:
                        powerMenu.executeAction("hibernate");
                        break;
                    case Qt.Key_L:
                        powerMenu.executeAction("lock");
                        break;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: powerMenu.isOpen = false
                }
            }

            GridLayout {
                id: grid
                anchors.centerIn: parent
                columns: 2
                columnSpacing: 16
                rowSpacing: 16

                Repeater {
                    model: ListModel {
                        ListElement {
                            action: "logout"
                            icon: "󰍃"
                            label: "Logout"
                            clr: "#ffbd5e"
                            key: "Q"
                        }
                        ListElement {
                            action: "reboot"
                            icon: ""
                            label: "Reboot"
                            clr: "#f1ff5e"
                            key: "R"
                        }
                        ListElement {
                            action: "suspend"
                            icon: "󰤄"
                            label: "Suspend"
                            clr: "#5ea1ff"
                            key: "S"
                        }
                        ListElement {
                            action: "shutdown"
                            icon: "⏻"
                            label: "Shutdown"
                            clr: "#ff6e5e"
                            key: "P"
                        }
                        ListElement {
                            action: "hibernate"
                            icon: "󰜗"
                            label: "Hibernate"
                            clr: "#bd5eff"
                            key: "H"
                        }
                        ListElement {
                            action: "lock"
                            icon: ""
                            label: "Lock"
                            clr: "#5ef1ff"
                            key: "L"
                        }
                    }

                    delegate: Item {
                        Layout.preferredWidth: 320
                        Layout.preferredHeight: 200

                        Rectangle {
                            anchors.fill: parent
                            radius: 18
                            color: hoverArea.containsMouse ? Qt.rgba(Qt.color(model.clr).r, Qt.color(model.clr).g, Qt.color(model.clr).b, 0.15) : Config.bgAlt
                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            scale: hoverArea.containsMouse ? 1.06 : 1.0
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 180
                                    easing.type: Easing.OutQuad
                                }
                            }

                            Rectangle {
                                width: 28
                                height: 28
                                radius: 8
                                anchors.top: parent.top
                                anchors.topMargin: 10
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                color: hoverArea.containsMouse ? Qt.rgba(Qt.color(model.clr).r, Qt.color(model.clr).g, Qt.color(model.clr).b, 0.25) : Qt.rgba(1, 1, 1, 0.06)
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: model.key
                                    font.family: Config.fontFamily
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    color: hoverArea.containsMouse ? model.clr : Qt.rgba(Config.fg.r, Config.fg.g, Config.fg.b, 0.5)
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 16

                                Rectangle {
                                    width: 96
                                    height: 96
                                    radius: 48
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: hoverArea.containsMouse ? model.clr : Qt.rgba(Qt.color(model.clr).r, Qt.color(model.clr).g, Qt.color(model.clr).b, 0.15)
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: model.icon
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 42
                                        color: hoverArea.containsMouse ? "#ff000000" : model.clr
                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 150
                                            }
                                        }
                                    }
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: model.label
                                    font.family: Config.fontFamily
                                    font.pixelSize: Config.fontSize + 4
                                    font.weight: Font.Medium
                                    color: hoverArea.containsMouse ? Config.fg : Qt.rgba(Config.fg.r, Config.fg.g, Config.fg.b, 0.7)
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }
                            }
                        }

                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: powerMenu.executeAction(model.action)
                        }
                    }
                }
            }
        }
    }
}
