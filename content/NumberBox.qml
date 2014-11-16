import QtQuick 2.0

Row {
    id: numberBox
    property string caption: ""
    property string value: "0"
    property real min: 0
    property real max: 255
    property int decimals: 2

    signal valueUpdated

    width: parent.width * 0.8;
    height: 20
    spacing: 0
    anchors.margins: 5
    Text {
        id: captionBox
        text: numberBox.caption
        width: 18; height: parent.height
        color: "#AAAAAA"
        font.pixelSize: 16; font.bold: true
        horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignBottom
        anchors.bottomMargin: 3
    }
    PanelBorder {
        height: parent.height
        anchors.leftMargin: 4;
        anchors.left: captionBox.right; anchors.right: parent.right
        TextInput {
            id: inputBox
            text: numberBox.value
            anchors.leftMargin: 4; anchors.topMargin: 1; anchors.fill: parent
            color: "#AAAAAA"; selectionColor: "#FF7777AA"
            font.pixelSize: 14
            focus: true
            maximumLength: 10
            validator: DoubleValidator {
                id: numValidator
                bottom: numberBox.min
                top: numberBox.max
                decimals: numberBox.decimals
                notation: DoubleValidator.StandardNotation
            }
            onTextChanged: valueUpdated()
        }
    }
}


