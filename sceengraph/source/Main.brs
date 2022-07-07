sub Main(args as Object)
    ShowChannelRSGScreen(args)
end sub

sub ShowChannelRSGScreen(args as Object)
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.SetMessagePort(m.port)
    scene = screen.CreateScene("MainScene")
    screen.Show() ' Init method in MainScene.brs is invoked
    sceneLaunchArgs = args
    inputObjet = createObject("roInput")
    inputObject.SetMessagePort(m.port)

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.IsScreenClosed() then return
        else if msgType = "roInputEvent"
            inputData = msg.getInfo()
            ? "input"
            if inputData.DoesExist("mediaType") and inputData.DoesExist("contentId")
                deepLink = {
                    contentId: inputData.contentId
                    mediaType: inputData.mediaType
                }
                scene.inputArgs = deepLink
            end if
        end if
    end while
end sub
