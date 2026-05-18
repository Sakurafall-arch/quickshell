import QtQuick
import QtQuick.Layouts
import qs.Common

RowLayout {
    id: root

    property var model: []
    property string currentValue: ""
    property int buttonHeight: 36
    property int horizontalPadding: 24
    property int innerRadius: 6
    property int pressedExpansion: 10

    signal valueSelected(string value)

    spacing: 2

    Repeater {
        model: root.model

        delegate: Item {
            id: segment

            required property int index
            required property var modelData

            property bool isFirst: index === 0
            property bool isLast: index === root.model.length - 1
            property bool isActive: root.currentValue === modelData.value
            property real edgeRadius: root.buttonHeight / 2
            property real rLeft: (isActive || isFirst || btnMouse.pressed) ? edgeRadius : root.innerRadius
            property real rRight: (isActive || isLast || btnMouse.pressed) ? edgeRadius : root.innerRadius
            property color bgColor: isActive
                                    ? (btnMouse.pressed ? Appearance.colors.colPrimaryActive : btnMouse.containsMouse ? Appearance.colors.colPrimaryHover : Appearance.colors.colPrimary)
                                    : (btnMouse.pressed ? Appearance.colors.colSecondaryContainerActive : btnMouse.containsMouse ? Appearance.colors.colSecondaryContainerHover : Appearance.colors.colSecondaryContainer)

            Layout.preferredWidth: label.implicitWidth + root.horizontalPadding + (btnMouse.pressed ? root.pressedExpansion : 0)
            Layout.preferredHeight: root.buttonHeight
            scale: btnMouse.pressed ? 0.97 : 1

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.2
                }
            }

            Behavior on bgColor {
                ColorAnimation {
                    duration: 150
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 130
                    easing.type: Easing.OutSine
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: segment.rLeft > segment.rRight ? segment.rLeft : segment.rRight
                color: segment.bgColor

                Behavior on radius {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutSine
                    }
                }
            }

            Rectangle {
                anchors.left: segment.rLeft < segment.rRight ? parent.left : undefined
                anchors.right: segment.rRight < segment.rLeft ? parent.right : undefined
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width / 2 + 5
                visible: segment.rLeft !== segment.rRight
                radius: segment.rLeft < segment.rRight ? segment.rLeft : segment.rRight
                color: segment.bgColor

                Behavior on radius {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutSine
                    }
                }
            }

            Text {
                id: label

                anchors.centerIn: parent
                text: segment.modelData.label
                font.family: Sizes.fontFamily
                font.pixelSize: 14
                font.bold: segment.isActive
                color: segment.isActive ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
                z: 2

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }

            MouseArea {
                id: btnMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                z: 3
                onClicked: root.valueSelected(segment.modelData.value)
            }
        }
    }
}
