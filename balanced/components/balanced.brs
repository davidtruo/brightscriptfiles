sub init()
    m.top.setFocus(true)
    m.mylabel = m.top.findNode("myLabel")
    m.mylabel.font.size=92

    m.keyboard = m.top.findNode("keyboard")

    m.balanced = m.top.findNode("balanced")
    m.balanced.observeField("buttonSelected", "balanced")
end sub

sub balanced()
    m.mylabel.text = "Balanced"
    temp = m.keyboard.text.split("")
    leftArray = []

    for x = 0 to temp.count()
        curr = temp[x]
        if curr = "(" or curr = "[" or curr = "{"
            leftArray.push(curr)
        else if curr = ")" or curr = "]" or curr = "}"
            if leftArray.count() > 0 and ((leftArray.peek() = "(" and curr = ")") or (leftArray.peek() = "{" and curr = "}") or (leftArray.peek() = "[" and curr = "]"))
                leftArray.pop()
            else
                m.mylabel.text = "Not Balanced"
            end if
        end if
    end for

    if leftArray.count() > 0
        m.mylabel.text = "Not Balanced"
    end if
end sub

function onKeyEvent(key as String, press as Boolean)
    handled = false

    if press
        if key = "down"
            m.balanced.setFocus(true)
            handled = true
        else if key = "up"
            m.keyboard.setFocus(true)
            handled = true
        end if
    end if

    return handled
end function
