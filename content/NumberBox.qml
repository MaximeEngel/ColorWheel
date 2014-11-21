import QtQuick 2.2

Row {
    id: root // toujorus root à la racine
    property string caption: ""
    property real value: 0
    property real min: 0
    property real max: 255
    property int decimals: 2

    width: 150;
    height: 20
    spacing: 0
    anchors.margins: 5

    signal accepted(var boxValue)

    Text {
        id: captionBox
        text: root.caption
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
            text: root.value
            anchors.leftMargin: 4; anchors.topMargin: 1; anchors.fill: parent
            color: "#AAAAAA"; selectionColor: "#FF7777AA"
            font.pixelSize: 14
            focus: true
            maximumLength: 10
//            validator: DoubleValidator { // remettre int ?
//                bottom: min
//                top: max
//                decimals: decimals

//            }

//            onTextChanged: {

//            }
            onEditingFinished: {
                var newText = parseFloat(inputBox.text).toString()
                root.accepted(newText)
                console.log("editing finish") ;
            }
        }
    }
}


