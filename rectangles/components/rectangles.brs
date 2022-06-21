sub init()
    m.top.setFocus(true)
    m.x = 0
    m.y = 0
    m.row = false

    m.mylabel = m.top.findNode("myLabel")
    m.mylabel.translation = [ 0 , 360 ]
    m.mylabel.font.size=92
    m.mylabel.color="0x72D7EEFF"

    m.keyboard = m.top.findNode("keyboard")
    m.keyboard.text = "4"

    m.button = m.top.findNode("button")
    m.button.observeField("buttonSelected", "calculate")

    m.button2 = m.top.findNode("button2")
    m.button2.visible = false
    m.button2.observeField("buttonSelected", "calculatepart2")
end sub

sub calculate()
    m.mylabel.text = "Number of Columns = ?"
    m.x = m.keyboard.text.toInt()
    m.keyboard.text = "4"
    m.row = true
    m.button.visible = false
    m.button2.visible = true
end sub

sub calculatepart2()
    m.y = m.keyboard.text.toInt()
    m.keyboard.visible = false
    m.button2.visible = false
    m.mylabel.visible = false
    makeRectangles(m.x, m.y)
end sub

sub makeRectangles(x as Integer, y as Integer)
    rectArray = []
    for cols = 0 to x - 1
        for rows = 0 to y - 1
            rectArray.push(CreateObject("roSGNode", "Rectangle"))
            m.top.appendChild(rectArray.peek())
            randomColor(rectArray.peek(), 100, 100, cols * 120, rows * 120)
        end for
    end for
end sub

sub randomColor(rect, width as Integer, height as Integer, posX as Integer, posY as Integer)
    rect.width = width
    rect.height = height
    rect.translation = [posX, posY]
    colorcode = "0123456789ABCDEF"
    color = "0x"
    for x = 1 to 8
        color += colorcode.mid(rnd(17),1)
    end for
    rect.color = color
end sub

function onKeyEvent(key as String, press as Boolean)
    handled = false
    if m.row = false
        if press
            if key = "down"
                m.button.setFocus(true)
                handled = true
            else if key = "up"
                m.keyboard.setFocus(true)
                handled = true
            end if
        end if
    else
        if press
            if key = "down"
                m.button2.setFocus(true)
                handled = true
            else if key = "up"
                m.keyboard.setFocus(true)
                handled = true
            end if
        end if
    end if

    return handled
end function
