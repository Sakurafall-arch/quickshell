import QtQuick
import QtQuick.Shapes
import qs.Common

/**
 * Material 3 circular progress indicator.
 */
Item {
    id: root

    property int implicitSize: 30
    property int lineWidth: 2
    property real value: 0
    property color colPrimary: Appearance?.m3colors?.m3onSecondaryContainer ?? "#FFFFFF"
    property color colSecondary: Appearance?.colors?.colSecondaryContainer ?? "#45464F"
    property real gapAngle: 360 / 18
    property bool fill: false
    property int fillOverflow: 2
    property bool enableAnimation: true
    property int animationDuration: 800
    property var easingType: Easing.OutCubic

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    property real degree: value * 360
    property real centerX: root.width / 2
    property real centerY: root.height / 2
    property real arcRadius: root.implicitSize / 2 - root.lineWidth
    property real startAngle: -90

    Behavior on degree {
        enabled: root.enableAnimation
        NumberAnimation {
            duration: root.animationDuration
            easing.type: root.easingType
        }
    }

    Loader {
        active: root.fill
        anchors.fill: parent

        sourceComponent: Rectangle {
            radius: 9999
            color: root.colSecondary
        }
    }

    Canvas {
        id: canvasBackground
        anchors.fill: parent
        visible: !root.fill

        onPaint: {
            var ctx = canvasBackground.getContext("2d");
            ctx.reset();

            ctx.beginPath();
            ctx.arc(root.centerX, root.centerY, root.arcRadius, 0, Math.PI * 2);
            ctx.lineWidth = root.lineWidth;
            ctx.strokeStyle = root.colSecondary;
            ctx.stroke();
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = canvas.getContext("2d");
            ctx.reset();

            var v = Math.min(root.value, 1);
            var endAngle = root.startAngle + root.degree - root.gapAngle;

            ctx.beginPath();
            ctx.arc(root.centerX, root.centerY, root.arcRadius, 
                     root.startAngle * Math.PI / 180,
                     endAngle * Math.PI / 180);
            ctx.lineWidth = root.lineWidth;
            ctx.lineCap = "round";
            ctx.strokeStyle = root.colPrimary;
            ctx.stroke();
        }

        Connections {
            target: root
            function onDegreeChanged() { canvas.requestPaint() }
            function onWidthChanged() { canvas.requestPaint() }
            function onHeightChanged() { canvas.requestPaint() }
        }
    }

    Shape {
        id: overflowShape
        anchors.fill: parent
        visible: root.fill

        ShapePath {
            fillColor: "transparent"
            strokeColor: root.colPrimary
            strokeWidth: root.lineWidth * 2 + root.fillOverflow * 2
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.startAngle + root.gapAngle / 2
                sweepAngle: Math.min(360 - root.gapAngle, root.degree)
            }
        }

        Connections {
            target: root
            function onDegreeChanged() { overflowShape.requestPaint() }
        }
    }
}
