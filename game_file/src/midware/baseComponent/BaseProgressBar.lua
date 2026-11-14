local _ENV, BaseProgressBar
function BaseProgressBar:create(sp)
	local obj = fgui.UIPackage.CreateObject1("Base", "BaseProgressBar")
	obj.isCocos = true
	obj:setPosition(0, 0)
	obj:setScale9Enabled(true)
	local bar = obj:getChildByName("bar")
	bar.isCocos = false
	if sp ~= nil then
		local url = sp.IconObject and sp.IconObject:getURL() or sp:getURL()
		local size = sp:getContentSize()
		bar:setURL(url)
		obj:setContentSize(size)
		obj:setScale(sp:getScale())
		bar:setContentSize(size)
	end
	return obj
end
return BaseProgressBar
