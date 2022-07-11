sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://jonathanbduval.com/roku/feeds/roku-developers-feed-v1.json")
    rsp = xfer.GetToString()
    rootChildren = []
    rows = {}

    json = ParseJson(rsp)
    if json <> invalid
        homeRowIndex = 0
        for each category in json
            value = json.Lookup(category)
            if Type(value) = "roArray"
                row = {}
                row.title = category
                row.children = []
                homeItemIndex = 0
                for each item in value
                    seasons = GetSeasonData(item.seasons, homeRowIndex, homeItemIndex, item.id)
                    itemData = GetItemData(item)
                    itemData.homeRowIndex = homeRowIndex
                    itemData.homeItemIndex = homeItemIndex
                    itemData.mediaType = category
                    if seasons <> invalid and seasons.Count() > 0
                        itemData.children = seasons
                    end if
                    row.children.Push(itemData)
                    homeItemIndex ++
                end for
                rootChildren.Push(row)
                homeRowIndex ++
            end if
        end for
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        m.top.content = contentNode
    end if
end sub

function GetItemData(video as Object) as Object
    item = {}
    if video.longDescription <> invalid
        item.description = video.longDescription
    else
        item.description = video.shortDescription
    end if
    item.hdPosterURL = video.thumbnail
    item.title = video.title
    item.releaseDate = video.releaseDate
    item.categories = video.genres
    item.id = video.id
    if video.episodeNumber <> invalid
        item.episodePosition = video.episodeNumber.ToStr()
    end if
    if video.content <> invalid
        item.length = video.content.duration
        item.url = video.content.videos[0].url
        item.streamFormat = video.content.videos[0].videoType
    end if
    return item
end function

function GetSeasonData(seasons as Object, homeRowIndex as Integer, homeItemIndex as Integer, seriesId as String) as Object
    seasonsArray = []
    if seasons <> invalid
        episodeCounter = 0
        for each season in seasons
            if season.episodes <> invalid
                episodes = []
                for each episode in season.episodes
                    episodeData = GetItemData(episode)
                    episodeData.titleSeason = season.title
                    episodeData.numEpisodes = episodeCounter
                    episodeData.mediaType = "episode"
                    episodeData.homeRowIndex = homeRowIndex
                    episodeData.homeItemIndex = homeItemIndex
                    episodeData.seriesId = seriesId
                    episodes.Push(episodeData)
                    episodeCounter ++
                end for
                seasonData = GetItemData(season)
                seasonData.children = episodes
                seasonData.contentType = "section"
                seasonsArray.Push(seasonData)
            end if
        end for
    end if
    return seasonsArray
end function
