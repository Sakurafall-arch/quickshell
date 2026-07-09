import qs.Common
import QtQuick

/**
 * Material 3 linear progress bar. Can be determinate or indeterminate.
 */
Item {
    id: root

    property real value: 0
    property bool indeterminate: false
    property color color: Appearance?.colors?.colPrimary ?? "#685496"
    property color trackColor: Appearance?.colors?.colSecondaryContainer ?? "#45464F"
    property real barHeight: 4
    property real radius: barHeight / 2

    implicitWidth: 120
    implicitHeight: barHeight

    Rectangle {
        id: track
        anchors.fill: parent
        radius: root.radius
        color: root.trackColor
    }

    Rectangle {
        id: bar
        height: parent.height
        radius: root.radius
        color: root.color

        anchors {
            top: parent.top
            left: parent.left
        }
    }

    states: [
        State {
            name: "determinate"
            when: !root.indeterminate

            PropertyChanges {
                target: bar
                width: parent.width * Math.min(root.value, 1)
            }
        },
        State {
            name: "indeterminate"
            when: root.indeterminate

            PropertyChanges {
                target: bar
                width: parent.width * 0.3
            }
        }
    ]

    transitions: [
        Transition {
            to: "determinate"
            PropertyAnimation {
                target: bar
                properties: "width"
                duration: 300
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1]
            }
        }
    ]

    // Indeterminate animation
    NumberAnimation on x {
        running: root.indeterminate
        from: -parent.width * 0.3
        to: parent.width
        duration: 1500
        loops: Animation.Infinite
    }
}
