sub init()
    m.top.setFocus(true)
    m.mylabel = m.top.findNode("myLabel")
    m.mylabel.translation = [ 0 , 360 ]
    'Set the font size
    m.mylabel.font.size=92

    'Set the color to light blue
    m.mylabel.color="0x72D7EEFF"

    m.keyboard = m.top.findNode("keyboard")
    m.keyboard.text = "avawdwfSbWQ"

    m.sort = m.top.findNode("sort")
    m.sort.observeField("buttonSelected", "sort")

end sub


' When the user selects the button, the keyboard will clear the text.
sub sort()
    text = m.keyboard.text.split("")
    text.sort("i")
    m.mylabel.text = text.join("")
end sub

' This onKeyEvent will handle when the Keyboard component will lose
' focus and give focus to the button node, and vice versa.
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
