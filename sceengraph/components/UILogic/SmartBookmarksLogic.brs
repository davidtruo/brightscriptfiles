function MasterChannelSmartBookmarks()
    this = {
        LoadSmartBookmarks: LoadSmartBookmarks
        SaveSmartBookmarks: SaveSmartBookmarks
        UpdateSmartBookmarkForSeries: UpdateSmartBookmarkForSeries
        GetSmartBookmarkForSeries: GetSmartBookmarkForSeries
        RemoveSmartBookmarkForSeries: RemoveSmartBookmarkForSeries
    }
    return this
end function

sub LoadSmartBookmarks()
    m.smartBookmarks = []
    raw = RegRead("smartBookmarks", "master_channel_bookmarks")
    if raw <> invalid
        m.smartBookmarks = ParseJson(raw)
    end if
end sub

sub SaveSmartBookmarks()
    RegWrite("smartBookmarks", FormatJson(m.smartBookmarks), "master_channel_bookmarks")
end sub

sub UpdateSmartBookmarkForSeries(id, episodeId)
    if id = invalid or episodeId = invalid
        return
    end if
    if m.smartBookmarks = invalid
        m.LoadSmartBookmarks()
    end if
    success = false
    for each bookmark in m.smartBookmarks
        if bookmark.id = id
            bookmark.episodeId = episodeId
            success = true
            exit for
        end if
    end for
    if not success
        m.smartBookmarks.Push({
            id: id
            episodeId: episodeId
        })
    end if
    m.SaveSmartBookmarks()
end sub

function GetSmartBookmarkForSeries(id as String) as String
    result = ""
    if m.smartBookmarks = invalid
        m.LoadSmartBookmarks()
    end if
    for each bookmark in m.smartBookmarks
        if bookmark.id = id
            result = bookmark.episodeId
            exit for
        end if
    end for
    return result
end function

sub RemoveSmartBookmarkForSeries(id as String)
    if m.smartBookmarks = invalid
        m.LoadSmartBookmarks()
    end if
    for i = 0 to m.smartBookmarks.Count() - 1
        bookmark = m.smartBookmarks[i]
        if bookmark.id = id
            m.smartBookmarks.Delete(i)
            exit for
        end if
    end for
    m.SaveSmartBookmarks()
end sub
