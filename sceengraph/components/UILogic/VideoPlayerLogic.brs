sub ShowVideoScreen(rowContent as Object, selectedItem as Integer, isSeries = false as Boolean)
    videoScreen = CreateObject("roSGNode", "VideoScreen")
    videoScreen.observeField("close", "OnVideoScreenClose")
    videoScreen.isSeries = isSeries
    videoScreen.content = rowContent
    videoScreen.startIndex = selectedItem
    ShowScreen(videoScreen)
end sub

sub OnVideoScreenClose(event as Object)
    videoScreen = event.GetRoSGNode()
    close = event.GetData()
    if close = true
        CloseScreen(videoScreen)
        screen = GetCurrentScreen()
        screen.SetFocus(true)
        if m.deepLinkDetailsScreen <> invalid
            content = videoScreen.content
            if videoScreen.isSeries = true
                content = content.GetChild(videoScreen.lastIndex)
            end if
            if content <> invalid
                m.deepLinkDetailsScreen.content = content.clone(true)
            end if
        else
            if videoScreen.isSeries = false
                screen.jumpToItem = videoScreen.lastIndex
            end if
        end if
    end if
end sub
