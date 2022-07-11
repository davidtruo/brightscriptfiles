sub RunContentTask()
    m.contentTask = CreateObject("roSGNode", "MainLoaderTask") ' create task for feed retrieving
    m.contentTask.ObserveField("content", "OnMainContentLoaded")
    m.contentTask.control = "run"
    m.loadingIndicator.visible = true
end sub

sub OnMainContentLoaded()
    m.GridScreen.SetFocus(true)
    m.loadingIndicator.visible = false
    m.GridScreen.content = m.contentTask.content
    args = m.top.launchArgs
    if args <> invalid and ValidateDeepLink(args)
        DeepLink(m.contentTask.content, args.mediaType, args.contentId)
    end if
end sub
