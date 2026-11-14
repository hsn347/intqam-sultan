local Layout = require("midware.cocos2d.Layout")
local HBox = class("HBox", Layout)
function HBox:create()
	local ret = HBox.new()
	ret.isLayout = true
	ret:setLayoutType(ccui.LayoutType.HORIZONTAL)
	return ret
end
return HBox
