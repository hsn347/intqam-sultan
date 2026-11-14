local activity_9001611_Ctrl = SoraDGetCtrl("activity_9001611_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_box2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001611/Com_box2", Com_box2)
function Com_box2:onInit()
	self:addClickListener(handler(self, self.OnClick))
end
function Com_box2:onShow()
end
function Com_box2:initData(data)
	self.data = data
	self.fields.text_score:setString(self.data.target)
	local status = 0
	if activity_9001611_Ctrl:getPoint() < data.target then
		status = 0
	else
		status = activity_9001611_Ctrl:isRewarded(self.data.rewardtype, self.data.target) and 2 or 1
	end
	self.controllers.c1:setSelectedIndex(status)
end
function Com_box2:OnClick()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 1 then
		activity_9001611_Ctrl:sendRewardMsg(self.data.rewardtype, self.data.target)
	else
		local btnStatus = gBtnTargetStatusDef.GO
		local btnStr = i18n("common_text_2139")
		if self.controllers.c1:getSelectedIndex() == 0 then
			btnStr = i18n("common_text_2139")
			btnStatus = gBtnTargetStatusDef.GO
		elseif self.controllers.c1:getSelectedIndex() == 2 then
			btnStatus = gBtnTargetStatusDef.GOT
			btnStr = i18n("common_text_1892")
		end
		_ENV = nil
		;(nil).title = i18n("Player_Return_test08")
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil).awardList = serviceFunctions.tableFormat(self.data.dropitem, nil)
		;(nil).btnStatus = btnStatus
		;(nil).btnStr = btnStr
		uiManager:show("Panel_gainView", nil)
	end
end
return Com_box2
