import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Clavis.Sysmon 1.0
import qs.Common
import qs.Components
import qs.Widgets.common

Item {
    id: root

    property bool popupOpen: false
    property string activeProfile: "balanced"
    readonly property int buttonSize: 36

    implicitWidth: buttonRow.implicitWidth + 16
    implicitHeight: buttonSize
    visible: SysmonPlugin.hasBattery

    function togglePopup() {
        root.popupOpen = !root.popupOpen;
        if (root.popupOpen)
            root.refreshProfile();
    }

    function setProfile(mode) {
        Quickshell.execDetached(["powerprofilesctl", "set", mode]);
        root.activeProfile = mode;
    }

    function refreshProfile() {
        profileReader.running = false;
        profileReader.running = true;
    }

    function updatePopupPosition() {
        var globalPos = root.mapToGlobal(0, 0);
        popupWindow.popupX = globalPos.x;
        popupWindow.popupY = globalPos.y + root.height + 4;
    }

    Process {
        id: profileReader
        command: ["powerprofilesctl", "get"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var profile = data.trim();
                if (profile)
                    root.activeProfile = profile;
            }
        }
    }

    Rectangle {
        id: bgRect
        anchors.fill: parent
        radius: height / 2
        color: SysmonPlugin.batteryPercent <= 15
            ? Appearance.colors.colErrorContainer
            : root.popupOpen
                ? Appearance.colors.colLayer1Hover
                : Appearance.colors.colLayer0

        Behavior on color { ColorAnimation { duration: 150 } }

        RowLayout {
            id: buttonRow
            anchors.centerIn: parent
            spacing: 4

            MaterialSymbol {
                iconSize: 16
                fill: 0
                color: {
                    if (SysmonPlugin.batteryPercent <= 15) return Appearance.colors.colOnErrorContainer
                    if (SysmonPlugin.batteryStatus === "Charging" || SysmonPlugin.batteryStatus === "Full")
                        return Appearance.colors.colPrimary
                    return Appearance.colors.colOnLayer0
                }

                text: {
                    var pct = SysmonPlugin.batteryPercent
                    if (SysmonPlugin.batteryStatus === "Charging")
                        return "battery_charging_full"
                    if (pct >= 90) return "battery_full"
                    if (pct >= 70) return "battery_6_bar"
                    if (pct >= 50) return "battery_5_bar"
                    if (pct >= 30) return "battery_4_bar"
                    if (pct >= 15) return "battery_3_bar"
                    if (pct >= 5)  return "battery_2_bar"
                    return "battery_1_bar"
                }
            }

            Text {
                text: Math.round(SysmonPlugin.batteryPercent) + "%"
                font.family: Sizes.fontFamilyMono
                font.pixelSize: 11
                color: {
                    if (SysmonPlugin.batteryPercent <= 15) return Appearance.colors.colOnErrorContainer
                    return Appearance.colors.colOnLayer0
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.togglePopup();
            if (root.popupOpen)
                Qt.callLater(root.updatePopupPosition);
        }
    }

    StyledToolTip {
        extraVisibleCondition: mouseArea.containsMouse && !root.popupOpen
        text: {
            var s = "电池: " + SysmonPlugin.batteryPercent.toFixed(1) + "%"
            if (SysmonPlugin.batteryStatus === "Charging") s += " · 充电中"
            else if (SysmonPlugin.batteryStatus === "Discharging") s += " · 放电中"
            else if (SysmonPlugin.batteryStatus === "Full") s += " · 已满"
            s += " · 健康度 " + SysmonPlugin.batteryHealth + "%"
            return s
        }
    }

    PanelWindow {
        id: popupWindow
        visible: root.popupOpen
        color: "transparent"
        implicitWidth: 280
        implicitHeight: 310
        exclusiveZone: -1

        property real popupX: 0
        property real popupY: 0

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "clavis-battery-popup"
        WlrLayershell.keyboardFocus: root.popupOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
        WlrLayershell.exclusionMode: ExclusionMode.Ignore

        WlrLayershell.anchors: WlrAnchor.Top | WlrAnchor.Left
        WlrLayershell.margins: Qt.margins(popupX, popupY, 0, 0)

        onVisibleChanged: {
            if (!visible) root.popupOpen = false;
            else Qt.callLater(() => keyScope.forceActiveFocus());
        }

        FocusScope {
            id: keyScope
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: root.popupOpen = false
        }

        Rectangle {
            anchors.fill: parent
            radius: Appearance.rounding.large
            color: Appearance.colors.colSurface
            border.color: Appearance.colors.colOutline
            border.width: 1

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Qt.alpha(Appearance.colors.colShadow, 0.5)
                shadowBlur: 1.2
                shadowVerticalOffset: 4
            }

            ColumnLayout {
                anchors { fill: parent; margins: 16 }
                spacing: 14

                Text {
                    text: "电源"
                    font.family: Sizes.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                    color: Appearance.colors.colOnSurface
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    MaterialSymbol {
                        iconSize: 24
                        fill: 0.5
                        color: {
                            if (SysmonPlugin.batteryPercent <= 15) return Appearance.colors.colError
                            if (SysmonPlugin.batteryStatus === "Charging" || SysmonPlugin.batteryStatus === "Full")
                                return Appearance.colors.colPrimary
                            return Appearance.colors.colOnSurface
                        }

                        text: {
                            if (SysmonPlugin.batteryStatus === "Charging") return "battery_charging_full"
                            var pct = SysmonPlugin.batteryPercent
                            if (pct >= 90) return "battery_full"
                            if (pct >= 50) return "battery_5_bar"
                            if (pct >= 15) return "battery_3_bar"
                            return "battery_1_bar"
                        }
                    }

                    ColumnLayout {
                        spacing: 2

                        Text {
                            text: Math.round(SysmonPlugin.batteryPercent) + "%"
                            font.family: Sizes.fontFamilyMono
                            font.pixelSize: 20
                            font.bold: true
                            color: {
                                if (SysmonPlugin.batteryPercent <= 15) return Appearance.colors.colError
                                return Appearance.colors.colOnSurface
                            }
                        }

                        Text {
                            text: {
                                switch (SysmonPlugin.batteryStatus) {
                                    case "Charging": return "充电中"
                                    case "Discharging": return "放电中"
                                    case "Full": return "已充满"
                                    default: return SysmonPlugin.batteryStatus || "未知"
                                }
                            }
                            font.family: Sizes.fontFamily
                            font.pixelSize: 12
                            color: Appearance.colors.colOnSurfaceVariant
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    MaterialSymbol { text: "favorite"; iconSize: 14; fill: 0; color: Appearance.colors.colOnSurfaceVariant }

                    Text {
                        text: "健康度"
                        font.family: Sizes.fontFamily
                        font.pixelSize: 12
                        color: Appearance.colors.colOnSurfaceVariant
                    }

                    Text {
                        text: SysmonPlugin.batteryHealth + "%"
                        font.family: Sizes.fontFamilyMono
                        font.pixelSize: 12
                        font.bold: true
                        color: {
                            var h = parseInt(SysmonPlugin.batteryHealth)
                            if (isNaN(h) || h < 80) return Appearance.colors.colError
                            return Appearance.colors.colOnSurface
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Appearance.colors.colOutlineVariant
                }

                Text {
                    text: "电源模式"
                    font.family: Sizes.fontFamily
                    font.pixelSize: 13
                    font.bold: true
                    color: Appearance.colors.colOnSurface
                }

                Repeater {
                    model: [
                        { label: "性能", mode: "performance", icon: "bolt" },
                        { label: "均衡", mode: "balanced", icon: "balance" },
                        { label: "省电", mode: "power-saver", icon: "energy_savings_leaf" }
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 34
                        radius: 8
                        color: modelData.mode === root.activeProfile
                            ? Appearance.colors.colPrimaryContainer
                            : "transparent"

                        required property var modelData

                        RowLayout {
                            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 8

                            MaterialSymbol {
                                text: modelData.icon
                                iconSize: 16
                                fill: modelData.mode === root.activeProfile ? 1 : 0
                                color: modelData.mode === root.activeProfile
                                    ? Appearance.colors.colOnPrimaryContainer
                                    : Appearance.colors.colOnSurface
                            }

                            Text {
                                text: modelData.label
                                font.family: Sizes.fontFamily
                                font.pixelSize: 13
                                color: modelData.mode === root.activeProfile
                                    ? Appearance.colors.colOnPrimaryContainer
                                    : Appearance.colors.colOnSurface
                                Layout.fillWidth: true
                            }

                            MaterialSymbol {
                                text: "check"
                                iconSize: 16
                                fill: 1
                                color: Appearance.colors.colOnPrimaryContainer
                                visible: modelData.mode === root.activeProfile
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.setProfile(modelData.mode)
                        }
                    }
                }
            }
        }
    }
}
