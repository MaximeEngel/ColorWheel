// creates color value from hue, saturation, brightness, alpha
function hsba(h, s, b, a) {
    var lightness = (2 - s)*b;
    var satHSL = s*b/((lightness <= 1) ? lightness : 2 - lightness);
    lightness /= 2;
    return Qt.hsla(h, satHSL, lightness, a);
}

function clamp(val, min, max){
    return Math.max(min, Math.min(max, val)) ;
}

function mix(x, y , a)
{
    return x * (1 - a) + y * a ;
}

function hsva2rgba(hsva) {
    var c = hsva.z * hsva.y ;
    var x = c * (1 - Math.abs( (hsva.x * 6) % 2 - 1 )) ;
    var m = hsva.z - c ;

    if (hsva.x < 1/6 )
        return Qt.vector4d(c+m, x+m, m, hsva.w) ;
    else if (hsva.x < 1/3 )
        return Qt.vector4d(x+m, c+m, m, hsva.w) ;
    else if (hsva.x < 0.5 )
        return Qt.vector4d(m, c+m, x+m, hsva.w) ;
    else if (hsva.x < 2/3 )
        return Qt.vector4d(m, x+m, c+m, hsva.w) ;
    else if (hsva.x < 5/6 )
        return Qt.vector4d(x+m, m, c+m, hsva.w) ;
    else
        return Qt.vector4d(c+m, m, x+m, hsva.w) ;

}

function rgba2hsva(rgba) {
    var cMax = Math.max(rgba.x, rgba.y, rgba.z) ;
    var cMin = Math.min(rgba.x, rgba.y, rgba.z) ;
    var delta = cMax - cMin ;
    var hsva = Qt.vector4d(0, 0, cMax, rgba.w);

    if (delta == 0)
        return hsva ;

    switch (cMax)
    {
        // in order to avoid negative value in hue when R = B
        case rgba.z :
            hsva.x = (((rgba.x - rgba.y) / delta) + 4 ) / 6.0 ;
            break;
        case rgba.x :
            hsva.x = (((rgba.y - rgba.z) / delta) % 6) / 6.0 ; // If we want degree * 60 instead of / 6
            break;
        case rgba.y :
            hsva.x = (((rgba.z - rgba.x) / delta) + 2 ) / 6.0 ;
            break;

    }

    if (cMax == 0)
        hsva.y = 0;
    else
        hsva.y = delta / cMax ;

    console.log("fonction appelée");

    return hsva;
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
    return intToHexa(Math.round(red * 255), 2)+intToHexa(Math.round(green * 255), 2)+intToHexa(Math.round(blue * 255), 2);
}
