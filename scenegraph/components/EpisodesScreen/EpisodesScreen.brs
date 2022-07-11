function Init()
    m.top.ObserveField("visible", "OnVisibleChange")
    m.categoryList = m.top.FindNode("categoryList")
    m.categoryList.ObserveField("itemFocused", "OnCategoryItemFocused")
    m.itemsList = m.top.FindNode("itemsList")
    m.itemsList.ObserveField("itemFocused", "OnListItemFocused")
    m.itemsList.ObserveField("itemSelected", "OnListItemSelected")
    m.top.ObserveField("content", "OnContentChange")
end function

sub OnListItemFocused(event as Object)
    focusedItem = event.GetData()
    categoryIndex = m.itemToSection[focusedItem]
    if (categoryIndex - 1) = m.categoryList.jumpToItem
        m.categoryList.animateToItem = categoryIndex
    else if not m.categoryList.IsInFocusChain()
        m.categoryList.jumpToItem = categoryIndex
    end if
end sub

sub InitSections(content as Object)
    m.firstItemInSection = [0]
    m.itemToSection = []
    sections = []
    sectionCount = 0
    for each section in content.GetChildren(- 1, 0)
        itemsPerSection = section.GetChildCount()
        for each child in section.GetChildren(- 1, 0)
            m.itemToSection.Push(sectionCount)
        end for
        sections.push({title : section.title})
        m.firstItemInSection.Push(m.firstItemInSection.Peek() + itemsPerSection)
        sectionCount++
    end for
    m.firstItemInSection.Pop()
    m.categoryList.content = ContentListToSimpleNode(sections)
end sub

sub OnCategoryItemFocused(event as Object)
    if m.categoryListGainFocus = true
        m.categoryListGainFocus = false
    else
        focusedItem = event.GetData()
        m.itemsList.jumpToItem = m.firstItemInSection[focusedItem]
    end if
end sub

sub OnJumpToItem(event as Object)
    itemIndex = event.GetData()
    m.itemsList.jumpToItem = itemIndex
end sub

sub OnContentChange()
    content = m.top.content
    InitSections(content)
    m.itemsList.content = content
end sub

sub OnVisibleChange()
    if m.top.visible = true
        m.itemsList.setFocus(true)
    end if
end sub

sub OnListItemSelected(event as Object)
    itemSelected = event.GetData()
    sectionIndex = m.itemToSection[itemSelected]
    m.top.selectedItem = [sectionIndex, itemSelected - m.firstItemInSection[sectionIndex]]
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        if key = "left" and m.itemsList.HasFocus()
            m.categoryListGainFocus = true
            m.categoryList.SetFocus(true)
            m.itemsList.drawFocusFeedback = false
            result = true
        else if key = "right" and m.categoryList.HasFocus()
            m.itemsList.drawFocusFeedback = true
            m.itemsList.SetFocus(true)
            result = true
        end if
    end if
    return result
end function
