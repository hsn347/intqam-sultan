local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local baseComponent = require("fgui.base.baseComponent")
local intetiorGoldKingdomSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Intetior/intetiorGoldKingdomSingle", intetiorGoldKingdomSingle)
function intetiorGoldKingdomSingle:onInit()
	self.fields.Text_gold_title:setString(i18n("parliament_text_19"))
end
function intetiorGoldKingdomSingle:onShow()
	self:updateResourceInfo()
end
function intetiorGoldKingdomSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_RESOURCE_DATA", handler(self, self.updateResourceInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_GOLD_BAR_KINGDOM_CHANGE", handler(self, self.updateResourceInfo))
end
function intetiorGoldKingdomSingle:initSkill(skill)
	self.skill = skill
	self.fields.Text_gold_title:setString(i18n("parliament_text_44"))
	self:updateSkillInfo()
end
function intetiorGoldKingdomSingle:updateSkillInfo()
	if self.skill then
		local resCount = self.skill:getSkillPolicyNum()
		self:setString(string.formatnumberthousands(resCount))
	end
end
function intetiorGoldKingdomSingle:updateResourceInfo()
	local resCount = intetiorCtrl:getKingdomGold()
	self:setString(string.formatnumberthousands(resCount))
end
return intetiorGoldKingdomSingle
