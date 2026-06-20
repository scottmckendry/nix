import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: nightlight

    signal toggleChanged(string glyph, bool isOn, bool forceShow)

    property string state: "off"
    property string activePreset: "default"
    property string presetToApply: "night"

    readonly property string iconGlyph: "󰖔"

    function _isOnState(nextState) {
        return nextState === "on" || nextState === "transitioning";
    }

    function _emit(nextState, forceShow) {
        nightlight.state = nextState;
        if (nextState === "transitioning") {
            nightlight.toggleChanged(nightlight.iconGlyph, true, forceShow);
            return;
        }

        if (nextState === "on") {
            nightlight.toggleChanged(nightlight.iconGlyph, true, forceShow);
            return;
        }

        nightlight.toggleChanged(nightlight.iconGlyph, false, forceShow);
    }

    function stateFromStatus(status) {
        if (status.active_preset === "night")
            return "on";
        if (status.active_preset === "day")
            return "off";
        if (status.state === "transitioning")
            return "transitioning";
        return (status.period === "night" || status.period === "sunset") ? "on" : "off";
    }

    function parseStatus(raw) {
        try {
            const status = JSON.parse(raw);
            return {
                active_preset: status.active_preset || "default",
                period: status.period || "day",
                state: status.state || "stable"
            };
        } catch (e) {
            return null;
        }
    }

    function requestToggle() {
        const currentlyOn = nightlight._isOnState(nightlight.state);
        const optimisticState = currentlyOn ? "off" : "on";

        nightlight._emit(optimisticState, true);

        if (nightlight.activePreset !== "default") {
            nightlight.presetToApply = nightlight.activePreset;
            nightlight.activePreset = "default";
        } else {
            nightlight.presetToApply = currentlyOn ? "day" : "night";
            nightlight.activePreset = nightlight.presetToApply;
        }

        applyProcess.running = false;
        applyProcess.running = true;
    }

    IpcHandler {
        target: "nightlight"

        function toggle() {
            nightlight.requestToggle();
        }
    }

    Process {
        id: initialStatus
        command: ["sunsetr", "status", "--json"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const status = nightlight.parseStatus(this.text);
                if (!status)
                    return;
                nightlight.activePreset = status.active_preset;
                nightlight._emit(nightlight.stateFromStatus(status), false);
            }
        }
    }

    Process {
        id: applyProcess
        command: ["sunsetr", "preset", nightlight.presetToApply]
    }
}
