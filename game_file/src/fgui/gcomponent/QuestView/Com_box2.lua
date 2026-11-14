local everydayTaskCtrl = SoraDGetCtrl("everydayTaskCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_box2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://QuestView/Com_box2", Com_box2)
function Com_box2:onInit()
	self:addClickListener(handler(self, self.OnClick))
end
function Com_box2:onShow()
end
function Com_box2:initWithData(data)
	self.data = data
	self.fields.text_score:setString(data.goal)
	local status = 0
	if data.curGoal < data.goal then
		status = 0
	else
		status = data.isReceived and 2 or 1
	end
	self.controllers.c1:setSelectedIndex(status)
end
function Com_box2:OnClick()
	SoraDPlaySound()
	if self.data.curGoal >= self.data.goal and not self.data.isReceived then
		everydayTaskCtrl:sendReceiveNormalMsg(self.data.index)
	else
		local btnStatus = gBtnTargetStatusDef.GO
		local btnStr = i18n("common_text_2139")
		if self.data.curGoal and self.data.curGoal < self.data.goal then
			btnStr = i18n("common_text_2139")
			btnStatus = gBtnTargetStatusDef.GO
		else
			local isReceived = everydayTaskCtrl:isReceiveNormalReward(self.data.index)
			if isReceived == true then
				btnStatus = gBtnTargetStatusDef.GOT
				btnStr = i18n("common_text_1892")
			else
				btnStatus = gBtnTargetStatusDef.GET
				btnStr = i18n("common_text_854")
			end
		end
		_ENV = nil
		;(nil).title = i18n("mail_title_89")
		;(nil).awardList = everydayTaskCtrl:getNormalRewardByIndex(self.data.index)
		;(nil).btnStatus = btnStatus
		;(nil).btnStr = btnStr
		;(nil).handle = function()
			everydayTaskCtrl:sendReceiveNormalMsg(self.data.index)
		end
		uiManager:show("Panel_gainView", nil)
	end
end
return Com_box2
