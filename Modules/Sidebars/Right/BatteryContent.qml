import QtQuick
import QtQuick.Layouts
import Clavis.Sysmon 1.0
import qs.Common
import qs.Components
import qs.Widgets.common

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        // ── 标题 ──
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            MaterialSymbol {
                text: "arrow_back"
                iconSize: 22
                fill: 0.8
                color: Appearance.colors.colOnLayer0

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: WidgetState.qsOpen = false
                }
            }

            Text {
                text: "电源"
                font.family: Sizes.fontFamily
                font.pixelSize: 20
                font.bold: true
                color: Appearance.colors.colOnLayer0
                Layout.fillWidth: true
            }
        }

        Item { Layout.preferredHeight: 8 }

        // ── 电池状态卡片 ──
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: statusColumn.implicitHeight + 24
            radius: Appearance.rounding.large
            color: Appearance.colors.colLayer1

            ColumnLayout {
                id: statusColumn
                anchors { fill: parent; margins: 16 }
                spacing: 14

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    MaterialSymbol {
                        iconSize: 28
                        fill: 0.5
                        color: {
                            if (SysmonPlugin.batteryPercent <= 15) return Appearance.colors.colError
                            if (SysmonPlugin.batteryStatus === "Charging" || SysmonPlugin.batteryStatus === "Full")
                                return Appearance.colors.colPrimary
                            return Appearance.colors.colOnLayer1
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
                        spacing: 4

                        Text {
                            text: Math.round(SysmonPlugin.batteryPercent) + "%"
                            font.family: Sizes.fontFamilyMono
                            font.pixelSize: 28
                            font.bold: true
                            color: {
                                if (SysmonPlugin.batteryPercent <= 15) return Appearance.colors.colError
                                return Appearance.colors.colOnLayer1
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
                            font.pixelSize: 14
                            color: {
                                if (SysmonPlugin.batteryPercent <= 15) return Appearance.colors.colError
                                return Appearance.colors.colOnLayer1Inactive
                            }
                        }
                    }
                }

                // 进度条
                StyledProgressBar {
                    Layout.fillWidth: true
                    value: SysmonPlugin.batteryPercent / 100
                    barHeight: 6
                    color: {
                        if (SysmonPlugin.batteryPercent <= 15) return Appearance.colors.colError
                        if (SysmonPlugin.batteryStatus === "Charging") return Appearance.colors.colPrimary
                        return Appearance.colors.colPrimary
                    }
                    trackColor: Appearance.colors.colLayer2
                }
            }
        }

        // ── 详细参数 ──
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: detailColumn.implicitHeight + 24
            radius: Appearance.rounding.large
            color: Appearance.colors.colLayer1

            ColumnLayout {
                id: detailColumn
                anchors { fill: parent; margins: 16 }
                spacing: 12

                Text {
                    text: "详细信息"
                    font.family: Sizes.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                    color: Appearance.colors.colOnLayer1
                }

                // 健康度
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    MaterialSymbol { text: "favorite"; iconSize: 18; color: Appearance.colors.colOnLayer1 }

                    Text {
                        text: "电池健康度"
                        font.family: Sizes.fontFamily
                        font.pixelSize: 14
                        color: Appearance.colors.colOnLayer1
                        Layout.fillWidth: true
                    }

                    Text {
                        text: SysmonPlugin.batteryHealth + "%"
                        font.family: Sizes.fontFamilyMono
                        font.pixelSize: 14
                        font.bold: true
                        color: {
                            var h = parseInt(SysmonPlugin.batteryHealth)
                            if (isNaN(h) || h < 80) return Appearance.colors.colError
                            return Appearance.colors.colOnLayer1
                        }
                    }
                }

                // 功耗
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    MaterialSymbol { text: "bolt"; iconSize: 18; color: Appearance.colors.colOnLayer1 }

                    Text {
                        text: "当前功耗"
                        font.family: Sizes.fontFamily
                        font.pixelSize: 14
                        color: Appearance.colors.colOnLayer1
                        Layout.fillWidth: true
                    }

                    Text {
                        text: SysmonPlugin.batteryPowerW > 0
                            ? SysmonPlugin.batteryPowerW.toFixed(1) + " W"
                            : "—"
                        font.family: Sizes.fontFamilyMono
                        font.pixelSize: 14
                        color: Appearance.colors.colOnLayer1
                    }
                }
            }
        }

        // ── 电源设置 ──
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: actionColumn.implicitHeight + 24
            radius: Appearance.rounding.large
            color: Appearance.colors.colLayer1

            ColumnLayout {
                id: actionColumn
                anchors { fill: parent; margins: 16 }
                spacing: 12

                Text {
                    text: "操作"
                    font.family: Sizes.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                    color: Appearance.colors.colOnLayer1
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        radius: 10
                        color: Appearance.colors.colLayer2

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            MaterialSymbol { text: "power_settings_new"; iconSize: 16; color: Appearance.colors.colOnLayer2 }
                            Text {
                                text: "关机"
                                font.family: Sizes.fontFamily
                                font.pixelSize: 13
                                color: Appearance.colors.colOnLayer2
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.execDetached(["systemctl", "poweroff"])
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        radius: 10
                        color: Appearance.colors.colLayer2

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            MaterialSymbol { text: "refresh"; iconSize: 16; color: Appearance.colors.colOnLayer2 }
                            Text {
                                text: "重启"
                                font.family: Sizes.fontFamily
                                font.pixelSize: 13
                                color: Appearance.colors.colOnLayer2
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.execDetached(["systemctl", "reboot"])
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        radius: 10
                        color: Appearance.colors.colLayer2

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            MaterialSymbol { text: "lock"; iconSize: 16; color: Appearance.colors.colOnLayer2 }
                            Text {
                                text: "锁屏"
                                font.family: Sizes.fontFamily
                                font.pixelSize: 13
                                color: Appearance.colors.colOnLayer2
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.execDetached(["loginctl", "lock-session"])
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
