// creates color value from hue, saturation, brightness, alpha
function hsba(h, s, b, a) {
    var lightness = (2 - s)*b;
    var satHSL = s*b/((lightness <= 1) ? lightness : 2 - lightness);
    lightness /= 2;
    return Qt.hsla(h, satHSL, lightness, a);
}

// extracts integer color channel value [0..255] from color value
function getChannelStr(clr, channelIdx) {
    return parseInt(clr.toString().substr(channelIdx*2 + 1, 2), 16);
}

//convert to hexa with nb char
function intToHexa(val , nb)
{
    var hexaTmp = val.toString(16) ;
    var hexa = "";
    var size = hexaTmp.length
    if (size < nb )
    {
        for(var i = 0 ; i < nb - size ; ++i)
        {
            hexa += "0"
        }
    }
    return hexa + hexaTmp
}

function hexaFromRGBA(red, green, blue, alpha)
{
    return "#"+intToHexa(alpha)+intToHexa(red)+intToHexa(green)+intToHexa(blue)
}
