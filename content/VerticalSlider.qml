import QtQuick 2.0

Item {

    QtObject
    {
        id: valueSliderObject
        property real _value: (1 - pickerCursor.y/height)
    }

    function getValueSlider() {
        return valueSliderObject._value
    }

    function setValueSlider(value) {
        if (value >= 0 && value <= 1)
            pickerCursor.y = (1 - value)*height ;
    }

    width: 15; height: 200
    id: root

    // Cursor
    Item {
        id: pickerCursor
        width: parent.width
        height : 8
        Rectangle {
            id: cursor
            x: -4; y: -height*0.5
            width: parent.width + -2*x; height: parent.height
            border.color: "black"; border.width: 1
            color: "transparent"
            Rectangle {
                anchors.fill: parent; anchors.margins: 2
                border.color: "white"; border.width: 1
                color: "transparent"
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        drag.target: pickerCursor
        drag.axis: Drag.YAxis
        drag.minimumY: 0
        drag.maximumY: root.height
        onClicked: pickerCursor.y = mouseY
    }
}
