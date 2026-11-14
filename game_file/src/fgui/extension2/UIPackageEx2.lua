local UIPackage = fgui.UIPackage
function UIPackage:createObject(...)
	return UIPackage.CreateObject(...)
end
function UIPackage:createObjectFromURL(...)
	return UIPackage.CreateObjectFromURL(...)
end
function UIPackage:getItemURL(...)
	return UIPackage.GetItemURL(...) or ""
end
