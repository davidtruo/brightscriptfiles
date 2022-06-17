sub init()
    m.top.setFocus(true)
    m.mylabel = m.top.findNode("myLabel")
    m.mylabel.translation = [ 0 , 360 ]
    'Set the font size
    m.mylabel.font.size=92

    'Set the color to light blue
    m.mylabel.color="0x72D7EEFF"

    m.keyboard = m.top.findNode("keyboard")
    m.keyboard.text = "[[{{((3123))}}]]"

    m.balanced = m.top.findNode("balanced")
    m.balanced.observeField("buttonSelected", "balanced")

end sub


' When the user selects the button, the keyboard will clear the text.
sub balanced()
    m.mylabel.text = "Balanced"
    temp = m.keyboard.text.split("")
    charCount = m.keyboard.text.len()
    leftArray = []
    curr = ""
    curr2 = ""
    count = 0

    for x = 1 to charCount
        curr = temp.shift()
        if curr = "(" or curr = "[" or curr = "{"
            leftArray.push(curr)
            count += 1
        else if curr = ")" or curr = "]" or curr = "}"
            if count <> 0
                temp2 = leftArray.pop()
                count -= 1
                if temp2 = "("
                    if curr <> ")"
                        m.mylabel.text = "Not Balanced"
                        exit for
                    end if
                else if temp2 = "["
                    if curr <> "]"
                        m.mylabel.text = "Not Balanced"
                        exit for
                    end if
                else if temp2 = "{"
                    if curr <> "}"
                        m.mylabel.text = "Not Balanced"
                        exit for
                    end if
                end if
            else
                m.mylabel.text = "Not Balanced"
                exit for
            end if
        end if
    end for
    if count > 0
        m.mylabel.text = "Not Balanced"
    end if
end sub

' This onKeyEvent will handle when the Keyboard component will lose
' focus and give focus to the button node, and vice versa.
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
