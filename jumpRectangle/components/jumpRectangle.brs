sub init()
    m.rect = m.top.findNode("rect")
    m.top.setFocus(true)

end sub

sub move()
    m.rect.blendcolor = randomColor()
    x = 100 + rnd(601)
    y = 100 + rnd(401)

    m.rect.translation = [ x , y ]
end sub

function randomColor() as String
    colorcode = "0123456789ABCDEF"
    color = "0x"
    for x = 1 to 8
        color += colorcode.mid(rnd(17),1)
    end for
    return color
end function

sub onKeyEvent(key as String, press as Boolean)
    if press and key = "OK"
        move()
    end if
end sub
