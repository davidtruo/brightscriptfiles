sub init()
    m.OneButton = m.top.findNode("OneButton")

    m.TwoButton = m.top.findNode("TwoButton")
    m.OneButton.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean)
    if press
        if key = "left" or key = "right"
            if m.OneButton.hasFocus() = true
                m.OneButton.uri = "pkg:/images/ButtonUnFocused.9.png"
                m.TwoButton.uri = "pkg:/images/ButtonFocused.9.png"
                m.TwoButton.setFocus(true)
            else
                m.OneButton.uri = "pkg:/images/ButtonFocused.9.png"
                m.TwoButton.uri = "pkg:/images/ButtonUnFocused.9.png"
                m.OneButton.setFocus(true)
            end if
        else if key = "OK"
            if m.OneButton.hasFocus() = true
                m.TwoButton.translation = [ 100 + rnd(601) , 100 + rnd(401) ]
            else
                m.OneButton.translation = [ 100 + rnd(601) , 100 + rnd(401) ]
            end if
        end if
    end if
end function
