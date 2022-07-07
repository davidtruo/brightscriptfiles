function GetSupportedMediaTypes() as Object
    return {
        "series": "series"
        "season": "episode"
        "episode": "episode"
        "movie": "movies"
        "shortFormVideo": "shortFormVideos"
    }
end function

sub OnInputDeepLinking(event as Object)
    args = event.getData()
    if args <> invalid and ValidateDeepLink(args)
        DeepLink(m.GridScreen.content, args.mediaType, args.contentId)
    end if
end sub

function ValidateDeepLink(args as Object) as Boolean
   mediaType = args.mediaType
   contentId = args.contentId
   types = GetSupportedMediaTypes()
   return mediaType <> invalid and contentId <> invalid and types[mediaType] <> invalid
end function

sub DeepLink(content as Object, mediaType as String, contentId as String)
    playableItem = FindNodeById(content, contentId)
    types = GetSupportedMediaTypes()
    if playableItem <> invalid and playableItem.mediaType = types[mediaType]
        ClearScreenStack()
        if mediaType = "episode" or mediaType = "shortFormVideo" or mediaType = "movie"
            HandlePlayableMediaTypes(playableItem)
        else if mediaType = "season"
            HandleSeasonMediaType(playableItem)
        else if mediaType = "series"
            HandleSeriesMediaType(playableItem)
        end if
    end if
end sub

sub HandleSeasonMediaType(content as Object)
    itemIndex = content.numEpisodes
    series = content.getParent().getParent()
    episodes = ShowEpisodesScreen(series, itemIndex)
    episodes.ObserveField("visible", "OnDeepLinkDetailsScreenVisibilityChanged")
end sub

sub HandlePlayableMediaTypes(content as Object)
    PrepareDetailsScreen(content)
    CheckSubscriptionAndStartPlayback(content)
end sub

sub HandleSeriesMediaType(content as Object)
    children = []
    for each season in content.getChildren(-1, 0)
        children.Append(CloneChildren(season))
    end for
    node = CreateObject("roSGNode", "ContentNode")
    node.id = content.id
    node.Update({ children: children }, true)
    smartBookmarks = MasterChannelSmartBookmarks()
    episodeId = smartBookmarks.GetSmartBookmarkForSeries(content.id)
    index = 0
    if episodeId <> invalid and episodeId <> ""
        episode = FindNodeById(content, episodeId)
        if episode <> invalid
            index = episode.numEpisodes
        end if
    end if
    PrepareDetailsScreen(node.getChild(index))
    CheckSubscriptionAndStartPlayback(node, index, true)
end sub

sub PrepareDetailsScreen(content as Object)
    m.deepLinkDetailsScreen = CreateObject("roSGNode", "DetailsScreen")
    m.deepLinkDetailsScreen.content = content
    m.deepLinkDetailsScreen.ObserveField("visible", "OnDeepLinkDetailsScreenVisibilityChanged")
    m.deepLinkDetailsScreen.ObserveField("buttonSelected", "OnDeepLinkDetailsScreenButtonSelected")
    AddScreen(m.deepLinkDetailsScreen)
end sub

sub OnDeepLinkDetailsScreenVisibilityChanged(event as Object)
    visible = event.GetData()
    screen = event.GetRoSGNode()
    if visible = false and IsScreenInScreenStack(screen) = false
        content = screen.content
        if content <> invalid
            m.GridScreen.jumpToRowItem = [content.homeRowIndex, content.homeItemIndex]
            if m.deepLinkDetailsScreen <> invalid
                m.deepLinkDetailsScreen = invalid
            end if
        end if
    end if
end sub

sub OnDeepLinkDetailsScreenButtonSelected(event as Object)
    buttonIndex = event.getData()
    details = event.GetRoSGNode()
    button = details.buttons.getChild(buttonIndex)
    content = m.deepLinkDetailsScreen.content.clone(true)
    if button.id = "play"
        content.bookmarkPosition = 0
    end if
    CheckSubscriptionAndStartPlayback(content)
end sub
