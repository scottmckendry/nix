import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    readonly property string nixRepoPath: "/home/scott/git/nix"
    readonly property string updateScriptPath: "/home/scott/scripts/nixos-update.sh"
    readonly property int checkInterval: 30

    property string state: "idle" // idle, behind, building, ready
    property var currentPr: null // { number, title, url }

    // Hide entirely when up-to-date
    Binding {
        target: root
        property: "_visibilityOverride"
        value: true
        when: true
    }
    Binding {
        target: root
        property: "_visibilityOverrideValue"
        value: root.state !== "idle"
        when: true
    }

    // Derived icon properties (avoid duplicating in both pills)
    readonly property string stateIcon: ({
        "building": "progress_activity",
        "ready": "update",
        "behind": "update"
    })[state] || "check_circle"

    readonly property color stateColor: ({
        "ready": Theme.primary,
        "behind": Theme.warning
    })[state] || Theme.surfaceVariantText

    // --- Processes ---

    Timer {
        id: pollTimer
        interval: root.checkInterval * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetchStatus.running = true
    }

    Process {
        id: fetchStatus
        command: [
            "gh", "pr", "list",
            "--repo", "scottmckendry/nix",
            "--label", "nix",
            "--state", "open",
            "--json", "number,title,url,labels",
            "--limit", "1"
        ]
        stdout: SplitParser {
            onRead: line => {
                if (!line.trim()) return;
                try {
                    var prs = JSON.parse(line);
                    if (Array.isArray(prs) && prs.length > 0) {
                        var pr = prs[0];
                        var labels = (pr.labels || []).map(function(l) { return l.name || ""; });
                        root.currentPr = { number: pr.number, title: pr.title, url: pr.url };
                        root.state = labels.indexOf("cachix-ready") >= 0 ? "ready" : "building";
                    } else {
                        root.currentPr = null;
                        checkBehind.running = true;
                    }
                } catch (e) {
                    console.error("nixUpdates: parse error:", e);
                }
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0)
                console.error("nixUpdates: gh pr list failed:", exitCode);
        }
    }

    // Single-process behind check: compare local vs remote HEAD
    Process {
        id: checkBehind
        command: ["sh", "-c",
            "LOCAL=$(git -C " + nixRepoPath + " rev-parse HEAD 2>/dev/null) && "
            + "REMOTE=$(gh api repos/scottmckendry/nix/git/ref/heads/main --jq .object.sha 2>/dev/null) && "
            + "[ \"$LOCAL\" != \"$REMOTE\" ]"]
        onExited: exitCode => {
            root.state = exitCode === 0 ? "behind" : "idle";
        }
    }

    Process {
        id: mergeProcess
        command: ["gh", "pr", "merge", root.currentPr ? root.currentPr.number.toString() : "0",
            "--repo", "scottmckendry/nix", "--rebase", "--delete-branch"]
        onExited: exitCode => {
            if (exitCode === 0) {
                ToastService.showInfo("Nix Updates", "PR #" + root.currentPr.number + " merged. Starting rebuild...");
                rebuildProcess.running = true;
            } else {
                ToastService.showError("Nix Updates", "Failed to merge PR");
            }
        }
    }

    Process {
        id: rebuildProcess
        command: ["sh", "-c",
            "kitty @ --to unix:/tmp/kitty-socket launch --type=tab zsh -c '"
            + updateScriptPath + "; exec zsh' 2>/dev/null || kitty -e zsh -c '"
            + updateScriptPath + "; exec zsh'"]
        onExited: exitCode => {
            if (exitCode !== 0)
                ToastService.showError("Nix Updates", "Failed to launch rebuild terminal");
            pollTimer.restart();
        }
    }

    // --- Actions ---

    function doMergeAndApply() {
        if (root.state === "ready") {
            mergeProcess.running = true;
        } else if (root.state === "behind") {
            rebuildProcess.running = true;
        }
    }

    function doOpenInGitHub() {
        Qt.openUrlExternally(root.currentPr ? root.currentPr.url : "https://github.com/scottmckendry/nix");
    }

    // --- Bar pills ---

    horizontalBarPill: Component {
        DankIcon {
            name: root.stateIcon
            size: root.iconSize
            color: root.stateColor
            anchors.verticalCenter: parent.verticalCenter

            NumberAnimation on rotation {
                from: 0; to: 360; duration: 1500; loops: Animation.Infinite
                running: root.state === "building"
            }
        }
    }

    verticalBarPill: Component {
        DankIcon {
            name: root.stateIcon
            size: root.iconSize
            color: root.stateColor
            anchors.horizontalCenter: parent.horizontalCenter

            NumberAnimation on rotation {
                from: 0; to: 360; duration: 1500; loops: Animation.Infinite
                running: root.state === "building"
            }
        }
    }

    // --- Popout ---

    popoutContent: Component {
        PopoutComponent {
            id: popout
            headerText: "Nix Updates"
            detailsText: {
                if (root.state === "ready")
                    return "PR #" + root.currentPr.number + " ready to merge";
                if (root.state === "building")
                    return "PR #" + root.currentPr.number + " building...";
                if (root.state === "behind")
                    return "Main branch is behind remote";
                return "No pending updates";
            }
            showCloseButton: true

            Column {
                width: parent.width
                spacing: Theme.spacingM

                // PR info card
                StyledRect {
                    width: parent.width
                    height: prCol.implicitHeight + Theme.spacingM * 2
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh
                    visible: root.currentPr !== null

                    Column {
                        id: prCol
                        anchors.fill: parent
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingS

                        Row {
                            spacing: Theme.spacingS
                            DankIcon {
                                name: root.state === "ready" ? "check_circle" : "hourglass_top"
                                size: Theme.iconSize
                                color: root.state === "ready" ? Theme.primary : Theme.surfaceVariantText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            StyledText {
                                text: "PR #" + root.currentPr.number
                                font.pixelSize: Theme.fontSizeMedium
                                font.weight: Font.Bold
                                color: Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            StyledText {
                                text: root.state === "ready" ? "(cachix-ready)" : "(building...)"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        StyledText {
                            text: root.currentPr.title
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }
                    }
                }

                // Status card (no PR)
                StyledRect {
                    width: parent.width
                    height: statusRow.implicitHeight + Theme.spacingM * 2
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh
                    visible: root.currentPr === null

                    Row {
                        id: statusRow
                        anchors.fill: parent
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingS
                        DankIcon {
                            name: root.state === "behind" ? "update" : "check_circle"
                            size: Theme.iconSize
                            color: root.state === "behind" ? Theme.warning : Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        StyledText {
                            text: root.state === "behind"
                                ? "Main branch is behind remote. Rebuild to sync."
                                : "System is up to date."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            wrapMode: Text.WordWrap
                            width: parent.width - statusRow.spacing - Theme.iconSize
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                // Action buttons
                Row {
                    id: buttonRow
                    width: parent.width
                    spacing: Theme.spacingS
                    property real bw: (width - spacing) / 2

                    DankButton {
                        width: buttonRow.bw
                        text: root.state === "ready" ? "Rebase & Build"
                            : root.state === "behind" ? "Rebuild Now" : "Up to Date"
                        iconName: root.state === "ready" ? "merge_type"
                            : root.state === "behind" ? "build" : "check"
                        enabled: root.state === "ready" || root.state === "behind"
                        onClicked: { root.doMergeAndApply(); popout.closePopout(); }
                    }

                    DankButton {
                        width: buttonRow.bw
                        text: root.currentPr ? "Open PR" : "Open Repo"
                        iconName: "open_in_new"
                        onClicked: { root.doOpenInGitHub(); popout.closePopout(); }
                    }
                }
            }
        }
    }
}
