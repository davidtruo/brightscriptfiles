function MasterChannelBookmarks()
    this = {
        LoadBookmarks:          LoadBookmarks
        SaveBookmarks:          SaveBookmarks
        UpdateBookmarkForVideo: UpdateBookmarkForVideo
        GetBookmarkForVideo:    GetBookmarkForVideo
        RemoveBookmarkForVideo: RemoveBookmarkForVideo
        ClearBookmarks:         ClearBookmarks
    }
    return this
end function

sub LoadBookmarks()
    m.bookmarks = []
    raw = RegRead("bookmarks", "master_channel_bookmarks")
    if raw <> invalid
        m.bookmarks = ParseJson(raw)
    end if
end sub

sub SaveBookmarks()
    RegWrite("bookmarks", FormatJson(m.bookmarks), "master_channel_bookmarks")
end sub

sub UpdateBookmarkForVideo(video as Object, position as Integer)
    if position = invalid or position <= 0 or video.id = invalid or video.mediaType = "series"
        return
    end if
    if m.bookmarks = invalid
        m.LoadBookmarks()
    end if
    success = false
    for each bookmark in m.bookmarks
        if bookmark.id = video.id
            bookmark.position = position
            success = true
            exit for
        end if
    end for
    if not success
        m.bookmarks.Push({
            id:         video.id
            position:   position
        })
    end if
    m.SaveBookmarks()
end sub

function GetBookmarkForVideo(video)
    result = 0
    if m.bookmarks = invalid
        m.LoadBookmarks()
    end if
    for each bookmark in m.bookmarks
        if bookmark.id = video.id
          result = bookmark.position
          exit for
        end if
    end for
    return result
end function

sub RemoveBookmarkForVideo(id as String)
    if m.bookmarks = invalid
        m.LoadBookmarks()
    end if
    for i = 0 to m.bookmarks.Count() - 1
        bookmark = m.bookmarks[i]
        if bookmark.id = id
            m.bookmarks.Delete(i)
            exit for
        end if
    end for
    m.SaveBookmarks()
end sub

sub ClearBookmarks()
    m.bookmarks = []
    m.SaveBookmarks()
end sub
