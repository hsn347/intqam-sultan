local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local activity_9001703_Read = include("activity_9001703_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001703_FinishPanel = class("Activity_9001703_FinishPanel", baseFguiPanel)
function Activity_9001703_FinishPanel:ctor(...)
	self.isLRU = true
	Activity_9001703_FinishPanel.super.ctor(self, ...)
	print("Activity_9001703_FinishPanel:ctor", self.viewName)
	self.isCantCloseByReturn = true
end
function Activity_9001703_FinishPanel:onInit()
	print("=======Activity_9001703_FinishPanel:onInit")
	self.fields.title:setString(i18n("surprise_box_035"))
	self.fields.title:enableGradient(cc.c3b(230, 219, 197), cc.c3b(178, 140, 68))
	self.fields.title:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
	_ENV = cc.size(2, -2)
	cc.size(2, -2).num = ""
	self.fields.Text_tip:setString(i18n("balloon_hunter_046", cc.size(2, -2)))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.List:setItemRenderer(handler(self, self.onSkillRenderer))
end
function Activity_9001703_FinishPanel:onSkillRenderer(index, obj)
	obj:fixChildrenPos()
	local skillID = self.skillData[index + 1]
	local showCfg = activity_9001703_Read.getSkillShow(skillID)
	obj:setIcon(showCfg.skillIcon)
	local lv = activity_9001703_Ctrl:getSkillLv(skillID)
	activity_9001703_Read = nil
	;(nil).buff = i18n(showCfg.skillName)
	;(nil).lv = lv
	obj:setTitle(i18n("gemEnchant_text_20", nil))
end
function Activity_9001703_FinishPanel:endShow()
	print("=======Activity_9001703_FinishPanel:endShow")
	local score = activity_9001703_Ctrl:getScore()
	self.fields.Label_score:setString(score)
	self.skillData, _ENV = self.fields.Label_score.setString, self.fields.Label_score.setString
	local skillShowCfg = activity_9001703_Read.getSkillShowCfg()
	for _, v in ipairs(skillShowCfg) do
		if activity_9001703_Ctrl:getSkillLv(v.skillId) > 0 then
			table.insert(self.skillData, v.skillId)
		end
	end
	self.fields.List:setNumItems(#self.skillData)
	local line = math.ceil(#self.skillData / 2)
	self.fields.List:setHeight(line * 98 + (line - 1) * 25)
	self.fields.n12:setVisible(#self.skillData > 1)
end
function Activity_9001703_FinishPanel:btnOkClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ACTIVITY_9001703_ENDGAME"
	SoraDSendMessage(nil)
	self:close()
end
return Activity_9001703_FinishPanel
