sub init()
    m.top.setFocus(true)
    m.label = m.top.findNode("Label")
    m.label.font.size=92

    m.keyboard = m.top.findNode("keyboard")

    m.sort = m.top.findNode("sort")
    m.sort.observeField("buttonSelected", "sort")

end sub


sub sort()
    text = m.keyboard.text.split("")
    for x = 0 to text.count() - 1
        location = x
        curr = text[x]
        for y = x + 1 to text.count() - 1
            if (curr > text[y])
                curr = text[y]
                location = y
            end if
        end for
        temp = text[x]
        text[x] = text[location]
        text[location] = temp
    end for

    m.label.text = text.join("")
end sub

function onKeyEvent(key as String, press as Boolean)
    handled = false

    if press
        if key = "down"
            m.sort.setFocus(true)
            handled = true
        else if key = "up"
            m.keyboard.setFocus(true)
            handled = true
        end if
    end if

    return handled
end function
