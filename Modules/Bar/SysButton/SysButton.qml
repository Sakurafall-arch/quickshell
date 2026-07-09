import QtQuick
import Quickshell
import qs.Common
import qs.Widgets.common

Item {
    id: root

    property bool isHovered: mouseArea.containsMouse
    readonly property int buttonSize: 28
    readonly property int hoverButtonSize: 34

    implicitHeight: buttonSize
    implicitWidth: buttonSize

    Rectangle {
        id: background
        anchors.centerIn: parent
        width: root.isHovered ? root.hoverButtonSize : root.buttonSize
        height: width
        radius: height / 2
        color: "#ffffff"

        Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        Text {
            anchors.centerIn: parent
            text: "\uF313"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: root.isHovered ? 20 : 16
            color: "#000000"

            Behavior on font.pixelSize { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["rofi", "-show", "run"])
    }

    PopupToolTip {
        extraVisibleCondition: mouseArea.containsMouse
        text: "启动器"
    }
}
