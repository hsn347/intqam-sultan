local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorDonateSkillPanel = class("NebulaEmperorDonateSkillPanel", baseFguiPanel)
function NebulaEmperorDonateSkillPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorDonateSkillPanel:ctor", self.viewName)
end
function NebulaEmperorDonateSkillPanel:onInit()
	print("=======NebulaEmperorDonateSkillPanel:onInit")
	self.activityID = self.param.activityID or gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
	local cfg = self:getRead().getDonateSkillConfig()
	self.fields.Text_skill:setString(i18n(cfg.name))
	local donateLv = self.param.donateLv
	self.fields.Com_skill:initData(self.activityID, donateLv)
	if donateLv == 0 then
		self:initDonateLv(self.fields.Com_curLv, donateLv + 1, true)
		self.fields.Com_nextLv:setVisible(false)
	else
		self:initDonateLv(self.fields.Com_curLv, donateLv)
		if self:getRead().isDonateLvMax(donateLv) then
			self.fields.Com_nextLv:setVisible(false)
		else
			self:initDonateLv(self.fields.Com_nextLv, donateLv + 1, true)
		end
	end
end
function NebulaEmperorDonateSkillPanel:onShow()
	print("=======NebulaEmperorDonateSkillPanel:onShow")
end
function NebulaEmperorDonateSkillPanel:initDonateLv(obj, showLv, isNextLv)
	local _fields = fguiHelper.get_fields(obj)
	if isNextLv then
		_ENV = nil
		;(nil).lv = showLv
		_fields.Text_lv:setString(i18n("nebulaemperor_text_83", nil))
	else
		_ENV = i18n("nebulaemperor_text_83", nil)
		i18n("nebulaemperor_text_83", nil).lv = showLv
		_fields.Text_lv:setString(i18n("commandhall_text_39", i18n("nebulaemperor_text_83", nil)))
	end
	_fields.Text_des:setString(self:getRead().getDonateSkillDes(showLv))
end
function NebulaEmperorDonateSkillPanel:getRead(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		return nebulaAllStarRead
	else
		return nebulaEmperorRead
	end
end
return NebulaEmperorDonateSkillPanel
