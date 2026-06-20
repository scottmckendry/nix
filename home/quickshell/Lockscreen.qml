import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import Quickshell.Wayland

Scope {
    id: root

    property bool locked: false
    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false
    readonly property string wallpaperPath: "file:///tmp/current_wallpaper"

    signal unlocked

    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            root.locked = true;
        }
    }

    // Monitor power-off while locked
    Process {
        id: powerOffProc
        command: ["niri", "msg", "action", "power-off-monitors"]
    }

    Timer {
        id: initialPowerOffTimer
        interval: 30000
        running: root.locked
        onTriggered: {
            powerOffProc.running = true;
            repeatPowerOffTimer.start();
        }
    }

    Timer {
        id: repeatPowerOffTimer
        interval: 60000
        repeat: true
        running: root.locked
        onTriggered: powerOffProc.running = true
    }

    PamContext {
        id: pam
        config: "quickshell"

        onPamMessage: {
            if (this.responseRequired) {
                if (root.currentText !== "") {
                    this.respond(root.currentText);
                } else {
                    root.unlockInProgress = false;
                    this.abort();
                }
            }
        }

        onCompleted: result => {
            root.unlockInProgress = false;
            if (result == PamResult.Success) {
                root.locked = false;
                root.currentText = "";
                root.unlocked();
            } else if (root.currentText !== "") {
                root.currentText = "";
                root.showFailure = true;
            }
        }
    }

    onCurrentTextChanged: showFailure = false

    function tryUnlock(): void {
        unlockInProgress = true;
        pam.start();
    }

    onLockedChanged: {
        if (locked) {
            currentText = "";
            showFailure = false;
            tryUnlock();
        }
    }

    WlSessionLock {
        id: lock
        locked: root.locked

        WlSessionLockSurface {
            color: Config.bg

            Image {
                anchors.fill: parent
                source: root.wallpaperPath
                fillMode: Image.PreserveAspectCrop
            }

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.5)
            }

            Column {
                visible: Config.primaryDisplays.includes(screen.name)
                anchors {
                    left: parent.left
                    top: parent.top
                    leftMargin: 60
                    topMargin: 50
                }
                spacing: 8

                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }

                Text {
                    text: Qt.formatDateTime(clock.date, "HH:mm")
                    color: Config.fg
                    font.family: "Geist"
                    font.pixelSize: 96
                    font.weight: Font.Light
                    font.letterSpacing: -2
                }

                Text {
                    text: Qt.formatDateTime(clock.date, "dddd · MMMM d").toUpperCase()
                    color: Config.grey
                    font.family: "Geist"
                    font.pixelSize: 12
                    font.letterSpacing: 3
                    font.weight: Font.Light
                }
            }

            Item {
                visible: Config.primaryDisplays.includes(screen.name)
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    rightMargin: 60
                    bottomMargin: 160
                }
                width: 200
                height: 66

                Item {
                    anchors.fill: parent
                    visible: root.currentText.length > 0

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Config.cyan
                    }
                }

                TextInput {
                    id: passwordField
                    anchors.fill: parent
                    horizontalAlignment: TextInput.AlignRight
                    verticalAlignment: TextInput.AlignVCenter
                    echoMode: TextInput.Password
                    passwordCharacter: "\u00B7"
                    color: Config.fg
                    font.family: "Geist"
                    font.pixelSize: 50
                    font.letterSpacing: 1
                    focus: true
                    clip: true
                    cursorVisible: false
                    cursorDelegate: Item {
                        width: 0
                        height: 0
                    }
                    onTextChanged: root.currentText = this.text
                    onAccepted: root.tryUnlock()

                    Connections {
                        target: root
                        function onCurrentTextChanged() {
                            passwordField.text = root.currentText;
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                    onClicked: passwordField.forceActiveFocus()
                }

                // Error text
                Text {
                    anchors.right: parent.right
                    anchors.top: parent.bottom
                    visible: root.showFailure
                    text: "Password Incorrect"
                    color: Config.red
                    font.family: "Inter"
                    font.pixelSize: 11
                }
            }
        }
    }
}
