sub init()
    m.top.setFocus(true)
    m.topLeft = m.top.findNode("topLeft")
    m.topMiddle = m.top.findNode("topMiddle")
    m.topRight = m.top.findNode("topRight")
    m.left = m.top.findNode("left")
    m.middle = m.top.findNode("middle")
    m.right = m.top.findNode("right")
    m.bottomLeft = m.top.findNode("bottomLeft")
    m.bottomMiddle = m.top.findNode("bottomMiddle")
    m.bottomRight = m.top.findNode("bottomRight")
    colorcode = "0123456789ABCDEF"

    m.topLeft.color = randomColor()
    m.topMiddle.color = randomColor()
    m.topRight.color = randomColor()
    m.left.color = randomColor()
    m.middle.color = randomColor()
    m.right.color = randomColor()
    m.bottomLeft.color = randomColor()
    m.bottomMiddle.color = randomColor()
    m.bottomRight.color = randomColor()
end sub

function randomColor() as String
    colorcode = "0123456789ABCDEF"
    color = "0x"
    for x = 1 to 8
        color += colorcode.mid(rnd(17),1)
    end for
    return color
end function
