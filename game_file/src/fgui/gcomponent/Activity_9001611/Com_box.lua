local activity_9001611_Ctrl = SoraDGetCtrl("activity_9001611_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_box = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001611/Com_box", Com_box)
function Com_box:onInit()
	self.fields.btn_icon:addClickListener(handler(self, self.OnClick))
end
function Com_box:onShow()
end
function Com_box:initData(data)
	self.data = data
	local point = activity_9001611_Ctrl:getPoint()
	self.fields.Text_score:setString(self.data.target)
	local status = 0
	if point >= self.data.target then
		if activity_9001611_Ctrl:isRewarded(self.data.rewardtype, self.data.target) then
			status = 2
		else
			status = 1
		end
	else
		status = 0
	end
	self.controllers.c1:setSelectedIndex(status)
end
function Com_box:OnClick()
	SoraDPlaySound()
	local point = activity_9001611_Ctrl:getPoint()
	if point < self.data.target then
		_ENV = nil
		;(nil).num = self.data.target
		SoraDShowMsgTip(i18n("Player_Return_test07", nil))
		return
	end
	if activity_9001611_Ctrl:isRewarded(self.data.rewardtype, self.data.target) then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
	else
		_ENV = i18n("Stellar_Odyssey_text_03")
		i18n("Stellar_Odyssey_text_03").data = self.data
		uiManager:show("Activity_9001611_treasure", i18n("Stellar_Odyssey_text_03"))
	end
end
return Com_box
