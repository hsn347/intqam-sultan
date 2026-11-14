local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local intetiorUtil = include("intetiorUtil")
local intetiorDef = include("intetiorDef")
local intetiorTrickSkill = class("intetiorTrickSkill", include("intetiorPolicyBase"))
local gParliamentTrick = intetiorDef.gParliamentTrick
function intetiorTrickSkill:ctor(info)
	intetiorTrickSkill.super.ctor(self, info)
	self.trickData, intetiorTrickSkill = intetiorTrickSkill.super.ctor, intetiorTrickSkill.super.ctor
end
function intetiorTrickSkill:isSkillAllEffect()
	return self.config.ifAll ~= 1
end
function intetiorTrickSkill:getSkillCostOne()
	return self.config.buffCostOne or 100
end
function intetiorTrickSkill:getSkillBuffDes()
	return self.configView.textTips and i18n(self.configView.textTips) or ""
end
function intetiorTrickSkill:getSkillTrickPercent()
	local trickNum = self:getSkillPolicyNum()
	local trickNumTotal = self:getSkillCost()
	return trickNum / trickNumTotal * 100
end
function intetiorTrickSkill:checkSkillCanDo()
	if worldMapDefine.inInCrossWar() then
		local name = self:getTrickSkillName()
		_ENV = nil
		;(nil).name = name
		SoraDShowMsgTip(i18n("parliament_text_26", nil))
		return false
	end
	if not intetiorUtil:checkEnoughGold(self:getSkillCostOne()) then
		intetiorUtil:showGoldTips(self:getSkillCostOne())
		return false
	end
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local official = lordInfoCtrl:getSelfOfficial()
	if official then
		local officialInfoRead = include("officialInfoRead")
		local isGood = officialInfoRead.judgeGoodOrBad(official)
		if isGood then
			SoraDShowMsgTip(i18n("parliament_text_27"))
			return false
		end
	end
	if self:isSkillCD() then
		return false
	end
	local id = self:getSkillID()
	if id == gParliamentTrick.STEAL then
		local isCanSteal = intetiorCtrl:isCanStealGold()
		if not isCanSteal then
			SoraDShowMsgTip(i18n("parliament_text_145"))
			return false
		end
	end
	return true
end
function intetiorTrickSkill:doAction()
	local id = self:getSkillID()
	if id == gParliamentTrick.STEAL then
		intetiorCtrl:reqParliamentTrickSteal()
		return true
	elseif id == gParliamentTrick.RECALL_OFFICIAL or id == gParliamentTrick.MONITOR_EMBEZZLE then
		intetiorCtrl:reqParliamentTrickCharge(id, self:getSkillCostOne())
		return true
	end
	return false
end
return intetiorTrickSkill
