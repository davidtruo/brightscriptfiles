function ContentListToSimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
    result = CreateObject("roSGNode", nodeType)
    if result <> invalid
        for each itemAA in contentList
            item = CreateObject("roSGNode", nodeType)
            item.SetFields(itemAA)
            result.AppendChild(item)
        end for
    end if
    return result
end function

function GetTime(length as Integer) as String
    minutes = (length \ 60).ToStr()
    seconds = length MOD 60
    if seconds < 10
       seconds = "0" + seconds.ToStr()
    else
       seconds = seconds.ToStr()
    end if
    return minutes + ":" + seconds
end function

function CloneChildren(node as Object, startItem = 0 as Integer)
    numOfChildren = node.GetChildCount()
    children = node.GetChildren(numOfChildren - startItem, startItem)
    childrenClone = []
    for each child in children
        childrenClone.Push(child.Clone(false))
    end for
    return childrenClone
end function

function FindNodeById(content as Object, contentId as String) as Object
    for each element in content.GetChildren(-1, 0)
        if element.id = contentId
            return element
        else if element.getChildCount() > 0
            result = FindNodeById(element, contentId)
            if result <> invalid
                return result
            end if
        end if
    end for
    return invalid
end function

function RegRead(key as String, section = invalid As Dynamic) As Dynamic
    If section = invalid Then section = "Default"
    reg = CreateObject("roRegistrySection", section)
    If reg.Exists(key) Then return reg.Read(key)
    return invalid
end function

sub RegWrite(key as String, val as String, section = invalid As Dynamic)
    If section = invalid Then section = "Default"
    reg = CreateObject("roRegistrySection", section)
    reg.Write(key, val)
    reg.Flush()
end sub

sub RegDelete(key as String, section = invalid As Dynamic)
    If section = invalid Then section = "Default"
    reg = CreateObject("roRegistrySection", section)
    reg.Delete(key)
    reg.Flush()
end sub
