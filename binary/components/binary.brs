sub init()
    m.top.setFocus(true)

    m.mylabel = m.top.findNode("myLabel")
    m.mylabel.font.size=92

    m.keyboard = m.top.findNode("keyboard")

    m.binary = m.top.findNode("binary")

    m.binary.observeField("buttonSelected", "tobinary")
end sub

sub toBinary()
    number = m.keyboard.text.toint()
    count = 0
    text = 0
    while number > 0
      text += (number mod 2) * 10^count
      number -= number mod 2
      number /= 2
      count++
    end while
    m.mylabel.text = text
end sub


function onKeyEvent(key as String, press as Boolean)
    handled = false

    if press
        if key = "down"
            m.binary.setFocus(true)
            handled = true
        else if key = "up"
            m.keyboard.setFocus(true)
            handled = true
        end if
    end if

    return handled
end function
