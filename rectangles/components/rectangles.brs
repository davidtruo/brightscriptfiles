sub init()
    m.top.setFocus(true)
    m.part1 = false
    m.x = 0

    m.label = m.top.findNode("label")
    m.label.font.size=92

    m.keyboard = m.top.findNode("keyboard")

    m.group = m.top.findNode("rectGroup")

    m.button = m.top.findNode("button")
    m.button.observeField("buttonSelected", "calculate")
end sub

sub calculate()
    if m.part1 = false
        m.label.text = "Number of Columns = ?"
        m.x = m.keyboard.text.toInt()
        m.part1 = true
    else
        m.keyboard.visible = false
        m.label.visible = false
        m.button.visible = false
        makeRectangles(m.x, m.keyboard.text.toInt())
    end if
end sub

sub makeRectangles(x as Integer, y as Integer)
    for cols = 0 to x - 1
        for rows = 0 to y - 1
            m.group.appendChild(randomColor(100, 100, cols * 120, rows * 120))
        end for
    end for
end sub

function randomColor(width as Integer, height as Integer, posX as Integer, posY as Integer) as Object
    rect = CreateObject("roSGNode", "Rectangle")
    rect.width = width
    rect.height = height
    rect.translation = [posX, posY]
    colorcode = "0123456789ABCDEF"
    color = "0x"
    for x = 1 to 8
        color += colorcode.mid(rnd(17),1)
    end for
    rect.color = color
    return rect
end function

function onKeyEvent(key as String, press as Boolean)
    handled = false
    if press
        if key = "down"
            m.button.setFocus(true)
            handled = true
        else if key = "up"
            m.keyboard.setFocus(true)
            handled = true
        end if
    end if

    return handled
end function
