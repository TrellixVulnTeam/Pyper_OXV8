import QtQuick 2.5
import QtQuick.Controls 1.4

import "../basic_types"
import "../style"
import "../config"

Item{
    id: controls
    width: 160
    height: 280

    property int sliderValue: slider.value

    signal playClicked()
    signal pauseClicked()
    signal forwardClicked(int step)
    signal backwardClicked(int step)
    signal startClicked()
    signal endClicked()

    Frame {
        anchors.fill: parent
        enabled: parent.enabled

        Column {
            width: parent.width - 2*10
            height: parent.height - 2*10

            anchors.margins: 10
            anchors.left: parent.left
            anchors.top: parent.top

            enabled: parent.enabled

            spacing: 10

            Grid {
                id: grid
                width: parent.width
                height: parent.height * 0.55  // FIXME: should invert relationship (function of btns)

                anchors.left: parent.left
                anchors.right: parent.right

                enabled: parent.enabled

                columns: 2
                rows: 3
                spacing: 3
                CustomButton {
                    iconSource: IconHandler.getPath("play.png")
                    pressedSource: IconHandler.getPath("play_pressed.png")
                    enabled: parent.enabled
                    tooltip: "Starts the video playback"
                    width: parent.width/2 - parent.spacing/2
                    height: parent.height/3
                    onClicked: { controls.playClicked() }
                }
                CustomButton {
                    iconSource: IconHandler.getPath("pause.png")
                    pressedSource: IconHandler.getPath("pause_pressed.png")
                    tooltip: "Pause playback"
                    enabled: parent.enabled
                    width: parent.width/2 - parent.spacing/2
                    height: parent.height/3
                    onClicked: { controls.pauseClicked() }
                }
                CustomButton {
                    iconSource: IconHandler.getPath("backward.png")
                    pressedSource: IconHandler.getPath("backward_pressed.png")
                    tooltip: "Fast rewind"
                    enabled: parent.enabled
                    width: parent.width/2 - parent.spacing/2
                    height: parent.height/3
                    onClicked: { controls.backwardClicked(slider.value) }
                }
                CustomButton {
                    iconSource: IconHandler.getPath("forward.png")
                    pressedSource: IconHandler.getPath("forward_pressed.png")
                    tooltip: "Fast forward"
                    enabled: parent.enabled
                    width: parent.width/2 - parent.spacing/2
                    height: parent.height/3
                    onClicked: { controls.forwardClicked(slider.value) }
                }
                CustomButton {
                    iconSource: IconHandler.getPath("jump_backward.png")
                    pressedSource: IconHandler.getPath("jump_backward_pressed.png")
                    tooltip: "Go to start"
                    enabled: parent.enabled
                    width: parent.width/2 - parent.spacing/2
                    height: parent.height/3
                    onClicked: { controls.startClicked() }
                }
                CustomButton {
                    iconSource: IconHandler.getPath("jump_forward.png")
                    pressedSource: IconHandler.getPath("jump_forward_pressed.png")
                    tooltip: "Go to end"
                    enabled: parent.enabled
                    width: parent.width/2 - parent.spacing/2
                    height: parent.height/3
                    onClicked: { controls.endClicked() }
                }
            }
            LabeledSlider{
                id: slider
                height: parent.height * 0.3

                anchors.left: parent.left
                anchors.right: parent.right
            }
            IntInput {
                id: playbackSpeed

                anchors.left: parent.left
                anchors.right: parent.right
                enabled: parent.enabled

                label: "Spd"
                tooltip: "Playback speed (period) in ms (1/FPS)"
                value: py_iface.get_timer_period()
                minimumValue: 8  // > 120 FPS
                // boxWidth: 45
                onEdited: {
                    py_iface.set_timer_period(value);
                    reload();
                }
                function reload(){
                    value = py_iface.get_timer_period();
                    //root.updateTracker();
                }
            }
        }
    }
}
