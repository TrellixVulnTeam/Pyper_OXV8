import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import "../basic_types"
import "../style"

Frame {
    id: roiLayout
    height: roiLayoutColumn.height + anchors.margins *2

    anchors.margins: 5

    property string name

    property int idx

    property variant pythonObject
    property variant roiColorDialog

    property variant parentWindow

    property alias drawingColor: roi.drawingColor
    property alias drawingType: roi.drawingType

    property alias roiActive: roiActive.checked
    property alias shapeBtn: shapeBtn

    property var sourceRoi

    signal pressed()
    signal shapeRequest()
    property bool checked: false

    property ExclusiveGroup exclusiveGroup: null

    onDrawingTypeChanged: {
        shapeBtn.iconSource = "../../../resources/icons/" + drawingType + ".png";
        changeRoiClass(sourceRoi, drawingType);
    }
    onDrawingColorChanged: {
        sourceRoi.drawingColor = drawingColor;
    }

    function changeRoiClass(roi, roiShape) {
        if (roiShape === "ellipse") {
            roi.source = "EllipseRoi.qml";
        } else if (roiShape === 'rectangle') {
            roi.source = "RectangleRoi.qml";
        } else if (roiShape === 'freehand') {
            roi.source = "FreehandRoi.qml";
        } else {
            console.log("Unrecognised drawing mode: " + roiShape);
        }
    }

    onExclusiveGroupChanged: {
        if (exclusiveGroup)
            exclusiveGroup.bindCheckable(roiLayout)
    }

    Column {
        id: roiLayoutColumn
        anchors.margins: 10
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 25

        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Label {
                width: contentWidth
                height: roiActive.height

                text: roiLayout.name
                verticalAlignment: Text.AlignVCenter
                // help: a callback function will be triggered when the object enters this ROI
            }
            CheckBox {
                id: roiActive
                text: ""
                onCheckedChanged: {
                    roiLayout.sourceRoi.roiActive = checked;
                }
            }
        }

        Row {
            id: roi
            spacing: 5

            property int btnsWidth: 50

            property color drawingColor: theme.roiDefault
            onDrawingColorChanged: {
                colorBtn.paint();
            }

            property string drawingType: 'ellipse'

            CustomButton {
                id: colorBtn
                width: parent.btnsWidth
                height: width

                tooltip: "Select ROI color"

                iconSource: "../../../resources/icons/pick_color.png"  // FIXME: change upon selection

                function paint() {
                    canvas.requestPaint();
                }

                onClicked: {
                    roiLayout.checked = true;
                    roiActive.checked = true;
                    roiColorDialog.visible = true;
                }
                Canvas {
                    id: canvas
                    anchors.margins: 10
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    onPaint: {
                        var ctx = getContext('2d');
                        ctx.fillStyle = roi.drawingColor;
                        ctx.fillRect(0, 0, parent.width - 20, parent.height - 20);
                    }
                }
            }
            CustomButton {
                id: shapeBtn

                width: parent.btnsWidth
                height: width
                label: ""

                iconSource: "../../../resources/icons/ellipse.png"

                onClicked: {
                    roiLayout.checked = true;
                    roiActive.checked = true;
                    roiLayout.shapeRequest();
                }
            }
            CustomLabeledButton {
                id: drawBtn
                width: 60
                height: 30

                anchors.verticalCenter: parent.verticalCenter

                label: "Draw"
                property bool isDown: false

                onClicked: {
                    roiLayout.checked = true;
                    roiActive.checked = true;
                    if (isDown) { // already active -> revert
                        roiLayout.pythonObject.restore_cursor();
                        isDown = false;
                        sourceRoi.finalise();
                    } else {  // activate
                        roiLayout.pythonObject.chg_cursor();
                        isDown = true;
                        roiLayout.pressed();
                    }
                    roiLayout.parentWindow.drawingMode = isDown;
                }
            }
        }
        Grid {
            anchors.left: parent.left
            anchors.right: parent.right

            columns: 2
            rows: 2

            spacing: 5
            IntLabel {
                label: "x:"
                value: sourceRoi.roiX
            }
            IntLabel {
                label: "y:"
                value: sourceRoi.roiX
            }
            IntLabel {
                label: "width:"
                value: sourceRoi.roiWidth
            }
            IntLabel {
                label: "height:"
                value: sourceRoi.roiHeight
            }
        }
    }
}
