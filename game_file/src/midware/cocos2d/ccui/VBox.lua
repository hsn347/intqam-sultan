local Layout = require("midware.cocos2d.Layout")
local VBox = class("VBox", Layout)
function VBox:create()
	local ret = VBox.new()
	ret.isLayout = true
	ret:setLayoutType(ccui.LayoutType.VERTICAL)
	return ret
end
return VBox
