sub ShowVideoScreen(content as Object, itemIndex as Integer)
    m.videoPlayer = CreateObject("roSGNode", "Video")
    if itemIndex <> 0
        numOfChildren = content.GetChildCount()
        
        children = content.GetChildren(numOfChildren - itemIndex, itemIndex)

        childrenClone = []

        for each child in children
            childrenClone.Push(child.Clone(false))
        end for

        node = CreateObject("roSGNode", "ContentNode")
        node.Update({
            children: childrenClone
        }, true)
        m.videoPlayer.content = node
    else
        m.videoPlayer.content = content.Clone(true)
    end if
    m.videoPlayer.contentIsPlaylist = true
    Showscreen(m.videoplayer)
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
        m.GridScreen.SetFocus(true)
        m.GridScreen.jumpToRowItem = [m.selectedIndex[0], currentIndex + m.selectedIndex[1]]
    end if
end sub
