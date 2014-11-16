import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import "content"
import "content/ColorUtils.js" as ColorUtils

Window {
    width: 600
    height: 400
    color: "#3C3C3C"

    QtObject {
        id: colorObject
        property int _RGBAred: ColorUtils.getChannelStr(_hexadecimal, 1)
        property int _RGBAgreen: ColorUtils.getChannelStr(_hexadecimal, 2)
        property int _RGBAblue: ColorUtils.getChannelStr(_hexadecimal, 3)
        property int _RGBAalpha: parseInt(alphaSlider.getValueSlider() * 255)

        property double _HSBAhue: wheel.getHue()
        property double _HSBAsaturation: wheel.getSaturation()
        property double _HSBAbrightness: brigthnessSlider.getValueSlider()
        property double _HSBAalpha: alphaSlider.getValueSlider()

        property string _hexadecimal: "#"+ColorUtils.intToHexa(_RGBAalpha, 2) + ColorUtils.hsba(_HSBAhue, _HSBAsaturation, _HSBAbrightness, _HSBAalpha).toString().substr(1, 6);
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
                        color: ColorUtils.hsba(colorObject._HSBAhue,
                                               colorObject._HSBAsaturation, 1,
                                               1)
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
                        color: ColorUtils.hsba(colorObject._HSBAhue,
                                               colorObject._HSBAsaturation, colorObject._HSBAbrightness,
                                               1)
                    }
                    GradientStop {
                        position: 1.0
                        color: "#00000000"
                    }
                }
            }
            VerticalSlider {
                id: alphaSlider
                anchors.fill: parent
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
                    color:  ColorUtils.hsba(colorObject._HSBAhue,
                                            colorObject._HSBAsaturation, colorObject._HSBAbrightness,
                                            colorObject._HSBAalpha)
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
                    text: colorObject._hexadecimal
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
                    value: colorObject._HSBAhue
                    decimals: 2
                    max: 1
                    min: 0
                }
                NumberBox {
                    id: sat
                    caption: "S"
                    value: colorObject._HSBAsaturation
                    decimals: 2
                    max: 1
                    min: 0
                }
                NumberBox {
                    id: brightness
                    caption: "B"
                    value: colorObject._HSBAbrightness
                    decimals: 2
                    max: 1
                    min: 0
                }
                NumberBox {
                    id: hsbAlpha
                    caption: "A"
                    value: colorObject._HSBAalpha
                    decimals: 2
                    onValueUpdated:  alphaSlider.setValueSlider(value)
                    max: 1
                    min: 0
                }
            }

            // R, G, B color values boxes
            Column {
                Layout.minimumWidth: 80
                Layout.minimumHeight: 25
                NumberBox {
                    id: red
                    caption: "R"
                    value: colorObject._RGBAred
                    min: 0
                    max: 255
                    decimals: 0
                }
                NumberBox {
                    id: green
                    caption: "G"
                    value: colorObject._RGBAgreen
                    min: 0
                    max: 255
                    decimals: 0
                }
                NumberBox {
                    id: blue
                    caption: "B"
                    value: colorObject._RGBAblue
                    min: 0
                    max: 255
                    decimals: 0
                }
                NumberBox {
                    id: rgbAlpha
                    caption: "A"
                    value: colorObject._RGBAalpha
                    min: 0
                    max: 255
                    decimals: 0
                    onValueUpdated: alphaSlider.setValueSlider(value)
                }
            }
        }
    }
}
