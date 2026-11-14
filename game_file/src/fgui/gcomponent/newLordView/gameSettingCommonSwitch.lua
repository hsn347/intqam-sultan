local baseComponent = require("fgui.base.baseComponent")
local gameSettingCommonSwitch = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/gameSettingCommonSwitch", gameSettingCommonSwitch)
function gameSettingCommonSwitch:onInit()
	self.val = 0
	self:addClickListener(handler(self, self.btnClickCallBack))
end
function gameSettingCommonSwitch:onShow()
end
function gameSettingCommonSwitch:setVal(ret)
	self.val = ret and 1 or 0
	self.controllers.button:setSelectedIndex(self.val)
end
function gameSettingCommonSwitch:getVal()
	return self.val == 1
end
function gameSettingCommonSwitch:btnClickCallBack()
	SoraDPlaySound()
	self.val = 1 - self.val
	self.controllers.button:setSelectedIndex(self.val)
	if self.handlCall then
		self.handlCall(self.val == 1)
	end
end
function gameSettingCommonSwitch:setCallBack(handl)
	self.handlCall = handl
end
return gameSettingCommonSwitch
