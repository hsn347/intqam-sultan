local ccsView = class("ccsView", function(ccsFile, viewSize)
	if not ccsFile then
		return nil
	end
	local typeView = type(ccsFile)
	local view
	if "string" == typeView then
		view = cc.uiloader:load(ccsFile)
		view.__ccsFile = ccsFile
	elseif "userdata" == typeView then
		view = ccsFile
		view = ccsFile
	end
	viewSize = viewSize or view:getContentSize()
	local baseView = include("baseView")
	local bgView = baseView.new(viewSize, false)
	view:setName("ccsView")
	bgView:addChild(view, 1)
	view:setAnchorPoint(0, 0)
	view:setPosition(0, 0)
	bgView._ccsView = view
	return bgView
end)
function ccsView:ctor()
end
return ccsView
