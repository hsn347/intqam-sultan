local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_donateSkill = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaEmperor/Com_donateSkill", Com_donateSkill)
function Com_donateSkill:onInit()
	self.fields.icon:addClickListener(handler(self, self.onClickSkill))
end
function Com_donateSkill:onShow()
end
function Com_donateSkill:onClickSkill(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).donateLv = self.donateLv
	;(nil).activityID = self.activityID
	uiManager:show("NebulaEmperorDonateSkill", nil)
end
function Com_donateSkill:initData(activityID, donateLv)
	self.activityID = activityID
	self.donateLv = donateLv
	local _ENV, cfg
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		cfg = nebulaAllStarRead.getDonateSkillConfig()
	else
		cfg = nebulaEmperorRead.getDonateSkillConfig()
	end
	self.fields.icon:setURL(cfg.icon)
	local donateLvMax = 0
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		donateLvMax = nebulaAllStarRead.getDonateLvMax()
	else
		donateLvMax = nebulaEmperorRead.getDonateLvMax()
	end
	_ENV = nil
	;(nil).member = donateLv
	;(nil).total = donateLvMax
	self.fields.title:setString(i18n("common_text_155", nil))
	local textColor = cc.c3b(254, 232, 198)
	if donateLv == 0 then
		textColor = cc.c3b(255, 0, 0)
	elseif donateLv == donateLvMax then
		textColor = cc.c3b(0, 255, 0)
	end
	self.fields.title:setColor(textColor)
end
return Com_donateSkill
