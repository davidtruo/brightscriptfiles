function Init()
    m.top.ObserveField("visible", "OnVisibleChange")
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")
    m.buttons =   m.top.FindNode("buttons")
    m.poster = m.top.FindNode("poster")
    m.description = m.top.FindNode("descriptionLabel")
    m.timeLabel = m.top.FindNode("timeLabel")
    m.titleLabel = m.top.FindNode("titleLabel")
    m.releaseLabel = m.top.FindNode("releaseLabel")
end function

sub onVisibleChange()
    if m.top.visible = true
        m.buttons.SetFocus(true)
    end if
end sub

sub SetButtons(buttons as Object)
    result = []
    for each button in buttons
        result.push({title : button, id: LCase(button)})
    end for
    m.buttons.content = ContentListToSimpleNode(result)
end sub

sub OnContentChange(event as Object)
    content = event.getData()
    if content <> invalid
        m.isContentList = content.GetChildCount() > 0
        if m.isContentList = false
            SetDetailsContent(content)
            m.buttons.SetFocus(true)
        end if
    end if
end sub


sub SetDetailsContent(content as Object)
    m.description.text = content.description
    m.poster.uri = content.hdPosterUrl
    if content.length <> invalid and content.length <> 0
        m.timeLabel.text = getTime(content.length)
    end if
    m.titleLabel.text = content.title
    m.releaseLabel.text = Left(content.releaseDate, 10)
    buttonList = ["Play"]
    if content.mediaType = "series"
        smartBookmarks = MasterChannelSmartBookmarks()
        episodeId = smartBookmarks.GetSmartBookmarkForSeries(content.id)
        if episodeId <> invalid and episodeId <> ""
            episode = FindNodeById(content, episodeId)
            if episode <> invalid
                episode.bookmarkPosition = MasterChannelBookmarks().GetBookmarkForVideo(episode)
                buttonList.Push("Continue")
            end if
        end if

        buttonList.Push("See all episodes")
    else
        content.bookmarkPosition = MasterChannelBookmarks().GetBookmarkForVideo(content)
        if content.bookmarkPosition > 0
            buttonList.Push("Continue")
        end if
    end if
    SetButtons(buttonList)
end sub

sub OnJumpToItem()
    content = m.top.content
    if content <> invalid and m.top.jumpToItem >= 0 and content.GetChildCount() > m.top.jumpToItem
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub

sub OnItemFocusedChanged(event as Object)
    focusedItem = event.GetData()
    if m.top.content.GetChildCount() > 0
        content = m.top.content.GetChild(focusedItem)
        SetDetailsContent(content)
    end if
end sub

function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        currentItem = m.top.itemFocused
        if key = "left" and m.isContentList = true
            m.top.jumpToItem = currentItem - 1
            result = true
        else if key = "right" and m.isContentList = true
            m.top.jumpToItem = currentItem + 1
            result = true
        end if
    end if
    return result
end function
