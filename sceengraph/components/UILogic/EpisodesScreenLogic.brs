function ShowEpisodesScreen(content as Object, itemIndex = 0 as Integer) as Object
    episodesScreen = CreateObject("roSGNode", "EpisodesScreen")
    episodesScreen.ObserveField("selectedItem", "OnEpisodesScreenItemSelected")
    episodesScreen.content = content
    episodesScreen.jumpToItem = itemIndex
    ShowScreen(episodesScreen)
end sub

sub OnEpisodesScreenItemSelected(event as Object)
    episodesScreen = event.GetRoSGNode()
    selectedIndex = event.GetData()
    rowContent = episodesScreen.content.GetChild(selectedIndex[0])
    ShowDetailsScreen(rowContent, selectedIndex[1])
end sub
