import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import "content"
import "content/ColorUtils.js" as ColorUtils

Item {
    id: root
    width: 600
    height: 400
    focus: true

    // Color value in RGBA with floating point values between 0.0 and 1.0.
    property vector4d colorRGBA: Qt.vector4d(1,1,1,1) ;
    QtObject{
        id: m
        // Color value in HSVA with floating point values between 0.0 and 1.0.
        property vector4d colorHSVA: ColorUtils.rgba2hsva(colorRGBA);
    }


    signal accepted

    onAccepted: {
        console.debug("DATA => accepted")
    }

    RowLayout {
        spacing: 20
        anchors.fill: parent

        Wheel {
            id: wheel
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 200
            Layout.minimumHeight: 200

            hue: m.colorHSVA.x
            saturation: m.colorHSVA.y
            onHueChanged: {
                colorRGBA = ColorUtils.hsva2rgba( Qt.vector4d(hue, m.colorHSVA.y, m.colorHSVA.z, m.colorHSVA.w) )
            }
            onSaturationChanged: {
                colorRGBA = ColorUtils.hsva2rgba( Qt.vector4d(m.colorHSVA.x, saturation, m.colorHSVA.z, m.colorHSVA.w) )
            }
            onAccepted: {
                root.accepted()
            }
        }

        // brightness picker slider
        Item {
            Layout.fillHeight: true
            Layout.minimumWidth: 20
            Layout.minimumHeight: 200

            //Brightness background
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop {
                        id: brightnessBeginColor
                        position: 0.0
                        color: {
                            var hsva = Qt.vector4d(m.colorHSVA.x, m.colorHSVA.y, m.colorHSVA.z, m.colorHSVA.w)
                            hsva.z = 1
                            hsva.w = 1
                            var rgba = ColorUtils.hsva2rgba(hsva)
                            return Qt.rgba(rgba.x, rgba.y, rgba.z, rgba.w)
                        }
                    }
                    GradientStop {
                        position: 1.0
                        color: "#000000"
                    }
                }
            }

            VerticalSlider {
                id: brigthnessSlider
                anchors.fill: parent
                value: m.colorHSVA.z
                onValueChanged: {
                    colorRGBA = ColorUtils.hsva2rgba(Qt.vector4d(m.colorHSVA.x, m.colorHSVA.y, value, m.colorHSVA.w))
                }
                onAccepted: {
                    root.accepted()
                }
            }
        }

        // Alpha picker slider
        Item {
            Layout.fillHeight: true
            Layout.minimumWidth: 20
            Layout.minimumHeight: 200
            CheckerBoard {
                cellSide: 4
            }
            //  alpha intensity gradient background
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(colorRGBA.x, colorRGBA.y, colorRGBA.z, 1)
                    }
                    GradientStop {
                        position: 1.0
                        color: "#00000000"
                    }
                }
            }
            VerticalSlider {
                id: alphaSlider
                value: colorRGBA.w
                anchors.fill: parent
                onValueChanged: {
                    colorRGBA.w = value
                }
                onAccepted: {
                    root.accepted()
                }
            }
        }

        // text inputs
        ColumnLayout {
            Layout.fillHeight: true
            Layout.minimumWidth: 150
            Layout.minimumHeight: 200
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            // current color display
            Rectangle {
                Layout.minimumWidth: 150
                Layout.minimumHeight: 50
                CheckerBoard {
                    cellSide: 5
                }
                Rectangle {
                    id: colorDisplay
                    width: parent.width
                    height: parent.height
                    border.width: 1
                    border.color: "black"
                    color:  Qt.rgba(colorRGBA.x, colorRGBA.y, colorRGBA.z, colorRGBA.w)
                }
            }

            // current color value
            PanelBorder {
                Layout.minimumWidth: 120
                Layout.minimumHeight: 25
                TextInput {
                    id: currentColor
                    color: "#AAAAAA"
                    selectionColor: "#FF7777AA"
                    font.pixelSize: 20
                    font.capitalization: "AllUppercase"
                    maximumLength: 9
                    focus: true
                    text: Qt.rgba(colorRGBA.x, colorRGBA.y, colorRGBA.z, colorRGBA.w)
                    font.family: "TlwgTypewriter"
                    anchors.verticalCenterOffset: 0
                    anchors.verticalCenter: parent.verticalCenter
                    selectByMouse: true
                    validator: RegExpValidator {
                        regExp: /^([A-Fa-f0-9]{8})$/
                    }
                }
            }

            // H, S, B color value boxes
            Column {
                Layout.minimumWidth: 80
                Layout.minimumHeight: 25
                NumberBox {
                    id: hue
                    caption: "H"
                    value: Math.round(m.colorHSVA.x*100)/100 // 2 Decimals
                    decimals: 2
                    max: 1
                    min: 0
                    onAccepted: {
                        colorRGBA = ColorUtils.hsva2rgba( Qt.vector4d(boxValue, m.colorHSVA.y, m.colorHSVA.z, m.colorHSVA.w) )
                        root.accepted()
                    }
                }
                NumberBox {
                    id: sat
                    caption: "S"
                    value: Math.round(m.colorHSVA.y*100)/100 // 2 Decimals
                    decimals: 2
                    max: 1
                    min: 0
                    onAccepted: {
                        colorRGBA = ColorUtils.hsva2rgba( Qt.vector4d(m.colorHSVA.x, boxValue, m.colorHSVA.z, m.colorHSVA.w) )
                        root.accepted()
                    }
                }
                NumberBox {
                    id: brightness
                    caption: "B"
                    value: Math.round(m.colorHSVA.z*100)/100 // 2 Decimals
                    decimals: 2
                    max: 1
                    min: 0
                    onAccepted: {
                        colorRGBA = ColorUtils.hsva2rgba( Qt.vector4d(m.colorHSVA.x, m.colorHSVA.y, boxValue, m.colorHSVA.w) )
                        root.accepted()
                    }
                }
                NumberBox {
                    id: hsbAlpha
                    caption: "A"
                    value: Math.round(m.colorHSVA.w*100)/100 // 2 Decimals
                    decimals: 2
                    max: 1
                    min: 0
                    onAccepted: {
                        colorRGBA.w = boxValue
                        root.accepted()
                    }
                }
            }

            // R, G, B color values boxes
            Column {
                Layout.minimumWidth: 80
                Layout.minimumHeight: 25
                NumberBox {
                    id: red
                    caption: "R"
                    value:  Math.round(root.colorRGBA.x * 255)
                    min: 0
                    max: 255
                    decimals: 0
                    onAccepted: {
                        colorRGBA.x = boxValue/255
                        root.accepted()
                    }
                }
                NumberBox {
                    id: green
                    caption: "G"
                    value:  Math.round(root.colorRGBA.y * 255)
                    min: 0
                    max: 255
                    decimals: 0
                    onAccepted: {
                        root.colorRGBA.y = boxValue/255
                        root.accepted()
                    }
                }
                NumberBox {
                    id: blue
                    caption: "B"
                    value:  Math.round(root.colorRGBA.z * 255)
                    min: 0
                    max: 255
                    decimals: 0
                    onAccepted: {
                        root.colorRGBA.z = boxValue/255
                        root.accepted()
                    }
                }
                NumberBox {
                    id: rgbAlpha
                    caption: "A"
                    value: Math.round(root.colorRGBA.w * 255)
                    min: 0
                    max: 255
                    decimals: 0
                    onAccepted: {
                        root.colorRGBA.w = boxValue/255
                        root.accepted()
                    }
                }
            }
        }
    }
}
