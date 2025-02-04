import QtQuick 2.5
import QtQuick.Controls 1.4

Roi {
    id: root
    property alias roiX: roi.x
    property alias roiY: roi.y
    property alias roiWidth: roi.width
    property alias roiHeight: roi.height
    property color drawingColor: 'Yellow'
    property alias points: canvas.path

    function setRoiPosition(xPosition, yPosition){
        canvas.resetPath();
        roi.mouseX = xPosition;
        roi.mouseY = yPosition;
        canvas.lastX = xPosition;
        canvas.lastY = yPosition;
        canvas.clearCanvas();
    }

    function resizeRoi(xPosition, yPosition){
        roi.mouseX = xPosition;
        roi.mouseY = yPosition;
        canvas.requestPaint();
        canvas.path.push(Qt.point(canvas.lastX, canvas.lastY));
    }

    function releasedCallback() {
        canvas.path = canvas.path.slice(1, canvas.path.length);
        var coords = getMinMaxCoords();
        root.roiX = coords[0];
        root.roiY = coords[1];
        root.roiWidth = coords[2] - coords[0];
        root.roiHeight = coords[3] - coords[1];
    }
    function getMinMaxCoords() {
        var minX = 1000000;
        var minY = 1000000;
        var maxX = 0;
        var maxY = 0;

        var pt;
        var curX;
        var curY

        var idx;
        for (idx in canvas.path) {
            pt = canvas.path[idx];
            curX = pt.x;
            curY = pt.y;
            if (curX < minX) {
                minX = curX;
            }
            if (curY < minY) {
                minY = curY;
            }
            if (curX > maxX) {
                maxX = curX;
            }
            if (curY > maxY) {
                maxY = curY;
            }
        }
        return [minX, minY, maxX, maxY];
    }

    Rectangle {
        id: roi

        width: 60
        height: width
        radius: width / 2

        visible: false
        color: "transparent"
        border.color: "transparent"
        border.width: 3

        onVisibleChanged: {
            if (visible) {
                canvas.drawingColor = root.drawingColor;
                if (canvas.path.length > 0) {
                    canvas.drawPath();
                }
            } else {
                canvas.drawingColor = 'transparent';
                canvas.clearCanvas();
            }
        }

        property real mouseX
        property real mouseY
    }
    Canvas {
        id: canvas
        property color drawingColor: 'transparent'
        anchors.fill: parent

        visible: roi.visible

        property real lastX
        property real lastY

        property var path: []

        function resetPath() {
            canvas.path = [];
        }

        function drawPath() {
            var currentPoint = path[0];
            lastX = currentPoint.x;
            lastY = currentPoint.y;

            var ctx = getContext('2d');
            ctx.lineWidth = 3;
            ctx.strokeStyle = drawingColor;
            ctx.beginPath();

            for (var i=1; i < path.length; i++) {
                currentPoint = path[i];
                roi.mouseX = currentPoint.x;
                roi.mouseY = currentPoint.y;

                ctx.moveTo(lastX, lastY);
                ctx.lineTo(roi.mouseX, roi.mouseY);

                lastX = currentPoint.x;
                lastY = currentPoint.y;
            }
            ctx.stroke();
        }

        onPaint: {
            var ctx = getContext('2d');
            ctx.lineWidth = 3;
            ctx.strokeStyle = canvas.drawingColor;
            ctx.beginPath();

            ctx.moveTo(lastX, lastY);
            ctx.lineTo(roi.mouseX, roi.mouseY);
            canvas.lastX = roi.mouseX;
            canvas.lastY = roi.mouseY;

            ctx.stroke();
        }
        function clearCanvas() {
            var ctx = getContext("2d");
            try {
                ctx.reset();
            } catch (err) {
                //  FIXME:
            }
        }
    }
}



