sub ShowDetailsScreen(content as Object, selectedItem as Integer)
    detailsScreen = CreateObject("roSGNode", "DetailsScreen")
    detailsScreen.content = content
    detailsScreen.jumpToItem = selectedItem
    detailsScreen.ObserveField("visible", "OnDetailsScreenVisibilityChanged")
    detailsScreen.ObserveField("buttonSelected", "OnButtonSelected")
    ShowScreen(detailsScreen)
end sub

sub OnDetailsScreenVisibilityChanged(event as Object)
    visible = event.GetData()
    detailsScreen = event.GetRoSGNode()
    currentScreen = GetCurrentScreen()
    screenType = currentScreen.SubType()
    if visible = false
        if screenType = "GridScreen"
            currentScreen.jumpToRowItem = [m.selectedIndex[0], detailsScreen.itemFocused]
        else if screenType = "EpisodesScreen"
            content = detailsScreen.content.GetChild(detailsScreen.itemFocused)
            currentScreen.jumpToItem = content.numEpisodes
        end if
    end if
end sub

sub OnButtonSelected(event)
    details = event.GetRoSGNode()
    content = details.content
    buttonIndex = event.getData()
    button = details.buttons.getChild(buttonIndex)
    selectedItem = details.itemFocused
    if button.id = "play"
        HandlePlayButton(content, selectedItem)
    else if button.id = "see all episodes"
        ShowEpisodesScreen(content.GetChild(selectedItem))
    else if button.id = "continue"
        HandlePlayButton(content, selectedItem, true)
    end if
end sub

sub HandlePlayButton(content as Object, selectedItem as Integer, isResume = false as Boolean)
    itemContent = content.GetChild(selectedItem)
    if itemContent.mediaType = "series"
        children = []
        for each season in itemContent.getChildren(-1, 0)
            children.Append(CloneChildren(season))
        end for
        node = CreateObject("roSGNode", "ContentNode")
        node.id = itemContent.id
        node.Update({ children: children }, true)
        if isResume = true
            smartBookmarks = MasterChannelSmartBookmarks()
            episodeId = smartBookmarks.GetSmartBookmarkForSeries(itemContent.id)
            if episodeId <> invalid and episodeId <> ""
                episode = FindNodeById(content, episodeId)
            end if
        else
            episode = node.getChild(0)
            episode.bookmarkPosition = 0
        end if
    else
        if isResume = false
            itemContent.bookmarkPosition = 0
        end if
    end if
    if m.selectedIndex = invalid
        m.selectedIndex = [0, 0]
    end if
    m.selectedIndex[1] = selectedItem
end sub
