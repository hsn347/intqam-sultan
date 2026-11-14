local baseComponent = require("fgui.base.baseComponent")
local com_FlagImage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/com_FlagImage", com_FlagImage)
function com_FlagImage:onInit()
end
function com_FlagImage:onShow()
end
function com_FlagImage:setTextNameStr(str)
	self.fields.Text_Me:setString(str)
end
function com_FlagImage:myControllFix(isFix)
	if isFix then
		self:fixChildrenPos(true, true)
	end
end
return com_FlagImage
