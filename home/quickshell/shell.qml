import QtQuick
import Quickshell

Scope {
    Lockscreen {
        id: lockscreen
    }
    OSD {
        id: osd
    }
    PowerMenu {
        lockscreen: lockscreen
    }
}
