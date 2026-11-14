local baseComponent = require("fgui.base.baseComponent")
local allianceActiveStageBox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceActiveView/allianceActiveStageBox", allianceActiveStageBox)
function allianceActiveStageBox:onInit()
	self.fields.Button_touch:addClickListener(handler(self, self.onTouchClick))
end
function allianceActiveStageBox:onShow()
end
function allianceActiveStageBox:initData(info, curPoint)
	self.info = info
	curPoint = curPoint or 0
	self.fields.Text_score:setString(self.info.activeNum)
	if curPoint >= self.info.activeNum then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function allianceActiveStageBox:onTouchClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("allianceActiveGiftView")
	panel:initData(self.info.reward)
	panel:show()
end
return allianceActiveStageBox
