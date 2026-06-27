import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    // Settings
    readonly property string nixRepoPath: "/home/scott/git/nix"
    readonly property string updateScriptPath: "/home/scott/scripts/nixos-update.sh"
    readonly property int checkInterval: 30

    // State
    property string state: "idle" // idle, behind, building, ready
    property int prNumber: 0
    property string prTitle: ""
    property string prUrl: ""

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
                        root.prNumber = pr.number || 0;
                        root.prTitle = pr.title || "";
                        root.prUrl = pr.url || "";
                        var labels = (pr.labels || []).map(function(l) { return l.name || ""; });
                        root.state = labels.indexOf("cachix-ready") >= 0 ? "ready" : "building";
                    } else {
                        root.prNumber = 0;
                        root.prTitle = "";
                        root.prUrl = "";
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

    Process {
        id: checkBehind
        command: ["git", "-C", nixRepoPath, "rev-parse", "HEAD"]
        property string localSha: ""
        stdout: SplitParser {
            onRead: line => { if (line.trim()) checkBehind.localSha = line.trim(); }
        }
        onExited: exitCode => {
            if (exitCode === 0) remoteShaCheck.running = true;
            else root.state = "idle";
        }
    }

    Process {
        id: remoteShaCheck
        command: ["gh", "api", "repos/scottmckendry/nix/git/ref/heads/main", "--jq", ".object.sha"]
        property string remoteSha: ""
        stdout: SplitParser {
            onRead: line => { if (line.trim()) remoteShaCheck.remoteSha = line.trim(); }
        }
        onExited: exitCode => {
            if (exitCode === 0 && checkBehind.localSha !== remoteSha)
                root.state = "behind";
            else
                root.state = "idle";
        }
    }

    Process {
        id: mergeProcess
        command: ["gh", "pr", "merge", root.prNumber.toString(),
            "--repo", "scottmckendry/nix", "--rebase", "--delete-branch"]
        onExited: exitCode => {
            if (exitCode === 0) {
                ToastService.showInfo("Nix Updates", "PR #" + root.prNumber + " merged. Starting rebuild...");
                rebuildProcess.running = true;
            } else {
                ToastService.showError("Nix Updates", "Failed to merge PR #" + root.prNumber);
            }
        }
    }

    Process {
        id: rebuildProcess
        command: ["sh", "-c",
            "kitty @ --to unix:/tmp/kitty-socket launch --type=tab zsh -c '"
            + updateScriptPath
            + "; exec zsh' 2>/dev/null || kitty -e zsh -c '"
            + updateScriptPath
            + "; exec zsh'"]
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
            root.prNumber = 0;
            rebuildProcess.running = true;
        }
    }

    function doOpenInGitHub() {
        if (root.prUrl)
            Qt.openUrlExternally(root.prUrl);
        else
            Qt.openUrlExternally("https://github.com/scottmckendry/nix");
    }

    // --- Bar pills ---

    horizontalBarPill: Component {
        DankIcon {
            name: {
                if (root.state === "building") return "sync";
                if (root.state === "ready") return "cloud_download";
                if (root.state === "behind") return "cloud_download";
                return "check_circle";
            }
            size: root.iconSize
            color: {
                if (root.state === "ready") return Theme.primary;
                if (root.state === "behind") return Theme.warning;
                if (root.state === "building") return Theme.surfaceVariantText;
                return Theme.surfaceVariantText;
            }
            anchors.verticalCenter: parent.verticalCenter

            NumberAnimation on rotation {
                from: 0; to: 360; duration: 1500; loops: Animation.Infinite
                running: root.state === "building"
            }
        }
    }

    verticalBarPill: Component {
        DankIcon {
            name: {
                if (root.state === "building") return "sync";
                if (root.state === "ready") return "system_update";
                if (root.state === "behind") return "cloud_download";
                return "check_circle";
            }
            size: root.iconSize
            color: {
                if (root.state === "ready") return Theme.primary;
                if (root.state === "behind") return Theme.warning;
                if (root.state === "building") return Theme.surfaceVariantText;
                return Theme.surfaceVariantText;
            }
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
                    return "PR #" + root.prNumber + " ready to merge";
                if (root.state === "building")
                    return "PR #" + root.prNumber + " building...";
                if (root.state === "behind")
                    return "Main branch is behind remote";
                return "No pending updates";
            }
            showCloseButton: true

            Column {
                width: parent.width
                spacing: Theme.spacingM

                // PR info card (when a PR exists)
                StyledRect {
                    width: parent.width
                    height: prInfoColumn.implicitHeight + Theme.spacingM * 2
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh
                    visible: root.prNumber > 0

                    Column {
                        id: prInfoColumn
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
                                text: "PR #" + root.prNumber
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
                            text: root.prTitle
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }
                    }
                }

                // Status card (idle / behind, no PR)
                StyledRect {
                    width: parent.width
                    height: statusRow.implicitHeight + Theme.spacingM * 2
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh
                    visible: root.prNumber === 0

                    Row {
                        id: statusRow
                        anchors.fill: parent
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingS

                        DankIcon {
                            name: root.state === "behind" ? "cloud_download" : "check_circle"
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

                // Action buttons (side by side)
                Row {
                    id: buttonRow
                    width: parent.width
                    spacing: Theme.spacingS
                    property real buttonWidth: (width - spacing) / 2

                    DankButton {
                        width: buttonRow.buttonWidth
                        text: root.state === "ready"
                            ? "Rebase & Build"
                            : root.state === "behind"
                                ? "Rebuild Now"
                                : "Up to Date"
                        iconName: root.state === "ready"
                            ? "merge_type"
                            : root.state === "behind"
                                ? "build"
                                : "check"
                        enabled: root.state === "ready" || root.state === "behind"
                        onClicked: {
                            root.doMergeAndApply();
                            popout.closePopout();
                        }
                    }

                    DankButton {
                        width: buttonRow.buttonWidth
                        text: root.prNumber > 0 ? "Open PR" : "Open Repo"
                        iconName: "open_in_new"
                        onClicked: {
                            root.doOpenInGitHub();
                            popout.closePopout();
                        }
                    }
                }
            }
        }
    }
}
