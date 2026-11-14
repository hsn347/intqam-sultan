local m = fgui.PageView
function m:create()
	local pageView = fgui.UIPackage:createObject("Base", "CCPageView")
	print("pageView:", pageView:getName())
	return pageView
end
function m:addEventListener(param1, callback)
	if callback then
		fgui.GComponent.addEventListener(param1, callback)
		return
	end
	self:addTurnCallback(param1)
end
