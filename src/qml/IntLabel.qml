import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    height: 25
    width: 110

    property alias label: label.text
    property alias tooltip: label.help
    property alias text: textField.text
    property alias readOnly: textField.readOnly

    Row {
        anchors.fill: parent
        spacing: 5

        LabelWTooltip {
            id: label
            width: (parent.width -5) /2
            height: parent.height
            text: "Label"
        }

        TextEdit {
            id: textField
            width: (parent.width -5) /2
            height: parent.height
            color: "white"
            horizontalAlignment: Text.AlignHCenter
//            validator: IntValidator{}
            readOnly: true
        }
    }
}
