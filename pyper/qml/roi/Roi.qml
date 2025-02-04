import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    id: root
    property bool isActive
    property bool isDrawn
    property bool drawingMode

    signal released(real xPosition, real yPosition)
    signal pressed(real xPosition, real yPosition)
    signal dragged(real xPosition, real yPosition)

    onPressed: {
        if (isActive) {
            setRoiPosition(xPosition, yPosition);
            drawRoi();
        }
    }
    onDragged: {
        if (isActive) {
            resizeRoi(xPosition, yPosition);
        }
    }
    onIsActiveChanged: {
        if (isActive == false) {
            eraseRoi();
        } else {
            drawRoi();
        }
    }

    function setRoiPosition(xPosition, yPosition) {}  // These functions have to be implemented in the derived classes
    function resizeRoi(xPosition, yPosition) {}  // These functions have to be implemented in the derived classes

    function drawRoi() {
        roi.visible = true;
        isDrawn = true;
    }
    function eraseRoi() {
        roi.visible = false;
        isDrawn = false;
    }
    function releasedCallback() { }

    MouseArea {
        id: behavior
        anchors.fill: parent

        enabled: root.drawingMode

        onReleased: {
            releasedCallback();
            parent.released(mouse.x, mouse.y);
        }
        onPressed: { parent.pressed(mouse.x, mouse.y) }
        onPositionChanged: { parent.dragged(mouse.x, mouse.y) }
    }
}
