sub ShowVideoScreen(rowContent as Object, selectedItem as Integer, isSeries = false as Boolean)
    m.isSeries = isSeries
    m.videoPlayer = CreateObject("roSGNode", "Video")
    if selectedItem <> 0
        childrenClone = CloneChildren(rowContent, selectedItem)
        rowNode = CreateObject("roSGNode", "ContentNode")
        rowNode.Update({ children: childrenClone }, true)
        m.videoPlayer.content = rowNode
    else
        m.videoPlayer.content = rowContent.Clone(true)
    end if
    m.videoPlayer.contentIsPlaylist = true
    ShowScreen(m.videoPlayer)
    m.videoPlayer.control = "play"
    m.videoPlayer.ObserveField("state", "OnVideoPlayerStateChange")
    m.videoPlayer.ObserveField("visible", "OnVideoVisibleChange")
end sub

sub OnVideoPlayerStateChange()
    state = m.videoPlayer.state
    if state = "error" or state = "finished"
        CloseScreen(m.videoPlayer)
    end if
end sub

sub OnVideoVisibleChange()
    if m.videoPlayer.visible = false and m.top.visible = true
        currentIndex = m.videoPlayer.contentIndex
        m.videoPlayer.control = "stop"
        m.videoPlayer.content = invalid
        screen = GetCurrentScreen()
        screen.SetFocus(true)
        newIndex = m.selectedIndex[1]
        if m.isSeries = true
           m.isSeries = false
        else
           newIndex += currentIndex
        end if
        screen.jumpToItem = newIndex
    end if
end sub
