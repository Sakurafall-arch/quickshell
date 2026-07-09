import QtQuick
import QtQuick.Layouts
import Clavis.Sysmon 1.0
import qs.Common
import qs.Components
import qs.Widgets.common

Item {
    id: root

    implicitWidth: 36
    implicitHeight: 36
    visible: SysmonPlugin.hasBattery

    Rectangle {
        id: bgRect
        anchors.fill: parent
        radius: height / 2
        color: SysmonPlugin.batteryPercent <= 15
            ? Appearance.colors.colErrorContainer
            : Appearance.colors.colLayer0

        RowLayout {
            anchors.centerIn: parent
            spacing: 2

            MaterialSymbol {
                iconSize: 14
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

    // 点击打开电池详情
    MouseArea {
        id: clickArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            WidgetState.qsView = "battery";
            WidgetState.qsOpen = true;
        }
    }

    StyledToolTip {
        extraVisibleCondition: clickArea.containsMouse
        text: {
            var s = "电池: " + SysmonPlugin.batteryPercent.toFixed(1) + "%"
            if (SysmonPlugin.batteryStatus === "Charging") s += " · 充电中"
            else if (SysmonPlugin.batteryStatus === "Discharging") s += " · 放电中"
            else if (SysmonPlugin.batteryStatus === "Full") s += " · 已满"
            s += " · 健康度 " + SysmonPlugin.batteryHealth + "%"
            return s
        }
    }
}
