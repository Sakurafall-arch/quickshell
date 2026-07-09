import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets.common
import qs.Components

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
                text: "设置"
                font.family: Sizes.fontFamily
                font.pixelSize: 20
                font.bold: true
                color: Appearance.colors.colOnLayer0
                Layout.fillWidth: true
            }
        }

        Item { Layout.preferredHeight: 8 }

        // ── 外观 ──
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: appearanceColumn.implicitHeight + 24
            radius: Appearance.rounding.large
            color: Appearance.colors.colLayer1

            ColumnLayout {
                id: appearanceColumn
                anchors { fill: parent; margins: 16 }
                spacing: 14

                Text {
                    text: "外观"
                    font.family: Sizes.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                    color: Appearance.colors.colOnLayer1
                }

                // 深色模式
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    MaterialSymbol {
                        text: UiPreferences.darkMode ? "dark_mode" : "light_mode"
                        iconSize: 20
                        color: Appearance.colors.colOnLayer1
                    }

                    Text {
                        text: "深色模式"
                        font.family: Sizes.fontFamily
                        font.pixelSize: 14
                        color: Appearance.colors.colOnLayer1
                        Layout.fillWidth: true
                    }

                    StyledSwitch {
                        scale: 0.65
                        checked: UiPreferences.darkMode
                        onCheckedChanged: UiPreferences.toggleDarkMode()
                    }
                }

                // 透明效果
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    MaterialSymbol {
                        text: "blur_on"
                        iconSize: 20
                        color: Appearance.colors.colOnLayer1
                    }

                    Text {
                        text: "透明效果"
                        font.family: Sizes.fontFamily
                        font.pixelSize: 14
                        color: Appearance.colors.colOnLayer1
                        Layout.fillWidth: true
                    }

                    StyledSwitch {
                        id: transparencySwitch
                        scale: 0.65
                        property bool modelChecked: false
                        checked: modelChecked
                        onCheckedChanged: {
                            modelChecked = checked
                            Appearance.backgroundTransparency = checked ? 0.12 : 0
                            Appearance.contentTransparency = checked ? 0.57 : 0.9
                            Appearance.reloadColors()
                        }
                    }
                }
            }
        }

        // ── 免打扰 ──
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: dndColumn.implicitHeight + 24
            radius: Appearance.rounding.large
            color: Appearance.colors.colLayer1

            ColumnLayout {
                id: dndColumn
                anchors { fill: parent; margins: 16 }
                spacing: 14

                Text {
                    text: "通知"
                    font.family: Sizes.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                    color: Appearance.colors.colOnLayer1
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    MaterialSymbol {
                        text: UiPreferences.dndEnabled ? "notifications_paused" : "notifications"
                        iconSize: 20
                        color: Appearance.colors.colOnLayer1
                    }

                    Text {
                        text: "免打扰"
                        font.family: Sizes.fontFamily
                        font.pixelSize: 14
                        color: Appearance.colors.colOnLayer1
                        Layout.fillWidth: true
                    }

                    StyledSwitch {
                        scale: 0.65
                        checked: UiPreferences.dndEnabled
                        onCheckedChanged: UiPreferences.toggleDnd()
                    }
                }
            }
        }

        // ── 关于 ──
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: aboutColumn.implicitHeight + 24
            radius: Appearance.rounding.large
            color: Appearance.colors.colLayer1

            ColumnLayout {
                id: aboutColumn
                anchors { fill: parent; margins: 16 }
                spacing: 8

                Text {
                    text: "关于"
                    font.family: Sizes.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                    color: Appearance.colors.colOnLayer1
                }

                Text {
                    text: "Quickshell · Niri"
                    font.family: Sizes.fontFamilyMono
                    font.pixelSize: 12
                    color: Appearance.colors.colOnLayer1Inactive
                }

                Text {
                    text: "组件来源：end4/illogical-impulse"
                    font.family: Sizes.fontFamilyMono
                    font.pixelSize: 12
                    color: Appearance.colors.colOnLayer1Inactive
                }

                RowLayout {
                    spacing: 8
                    Layout.topMargin: 8

                    Rectangle {
                        width: 100; height: 30
                        radius: 8
                        color: Appearance.colors.colPrimary

                        Text {
                            anchors.centerIn: parent
                            text: "重启 Shell"
                            font.family: Sizes.fontFamily
                            font.pixelSize: 12
                            color: Appearance.colors.colOnPrimary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.reload(true)
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
