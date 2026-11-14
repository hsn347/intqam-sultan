local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local intetiorUtil = include("intetiorUtil")
local intetiorPolicySkill = class("intetiorPolicySkill", include("intetiorPolicyBase"))
local mailFunctions = include("mailFunctions")
local intetiorDef = include("intetiorDef")
local gParliamentDecree = intetiorDef.gParliamentDecree
local gParliamentPolicy = intetiorDef.gParliamentPolicy
local buffDesRead = include("buffDesRead")
function intetiorPolicySkill:ctor(info)
	intetiorPolicySkill.super.ctor(self, info)
	self.skillType = info.skillType
end
function intetiorPolicySkill:getSkillType()
	return self.skillType
end
function intetiorPolicySkill:isBaseSkill()
	return 1 == self:getSkillType()
end
function intetiorPolicySkill:getSkillDes()
	if self.configView.text then
		local effectValue
		if not self:isBaseSkill() then
			local skillid = self:getSkillID()
			if gParliamentDecree.EMBEZZLE == skillid then
				local intetiorRead = include("intetiorRead")
				effectValue = intetiorRead:getIntetiorConst(intetiorDef.gIntetiorConst.DOATE_GOLD)
			elseif gParliamentDecree.FORBID_WAR_LORD == skillid or gParliamentDecree.OPEN_PROTECT_LORD == skillid then
				effectValue = 8
			end
		end
		if not effectValue then
			local buff = self.config.attribute
			if buff and buff[1] then
				effectValue = buffDesRead.getTitleValueWithValue(buff[1], buff[2] or 0, true)
			end
		end
		gParliamentDecree = buff[1]
		buff[1].num = effectValue
		return i18n(self.configView.text, buff[1])
	end
	return ""
end
function intetiorPolicySkill:isSkillTargetPersonal()
	return 2 == self.config.buffType
end
function intetiorPolicySkill:isPolicyPromise()
	if self.policyData and self.policyData.res and next(self.policyData.res) then
		return true
	end
	return false
end
function intetiorPolicySkill:isPolicyPolicy()
	return self.policyData and self:getSkillEffectTime() > 0
end
function intetiorPolicySkill:isPolicyGoldEnough()
	return self:getSkillPolicyNum() >= self:getSkillCost()
end
function intetiorPolicySkill:isSkillForbidden()
	return intetiorCtrl:isSelfInTrick_recallOfficial()
end
function intetiorPolicySkill:isSkillCD()
	if self:isBaseSkill() then
		return not self:isPolicyPromise() and self:getSkillCD() > 0
	else
		return self:getSkillCD() > 0
	end
end
function intetiorPolicySkill:isSkillEffect()
	if self:isBaseSkill() then
		return not self:isPolicyPromise() and self:getSkillEffectTime() > 0
	else
		return self:getSkillEffectTime() > 0
	end
end
function intetiorPolicySkill:isPolicyGoldEnough_Kingdom()
	local gold = intetiorCtrl:getKingdomGold()
	return gold + self:getSkillPolicyNum() >= self:getSkillCost()
end
function intetiorPolicySkill:checkSkillCanDo()
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_25"))
		return false
	end
	if not intetiorUtil:checkEnoughKingdomGold(self:getSkillCost()) then
		SoraDShowMsgTip(i18n("parliament_text_24"))
		return false
	end
	return true
end
function intetiorPolicySkill:isCanOpPromise_official()
	local position = self:getSkillIdentity()
	return intetiorUtil:isCanOpPromise_official(position)
end
function intetiorPolicySkill:isCanShowPromise()
	if not self:isCanOpPromise_official() then
		return false
	end
	if self:isPolicyPromise() then
		return false
	end
	if intetiorCtrl:isHasPolicyPormise() then
		return false
	end
	if self:isPolicyPolicy() then
		return false
	end
	if self:isSkillCD() then
		return false
	end
	return true
end
function intetiorPolicySkill:checkSkillCanDo_Promise()
	if not self:isCanOpPromise_official() then
		SoraDShowMsgTip(i18n("parliament_text_38"))
		return false
	end
	if intetiorCtrl:isHasPolicyPormise() then
		SoraDShowMsgTip(i18n("parliament_text_40"))
		return false
	end
	if self:isPolicyPolicy() then
		SoraDShowMsgTip(i18n("parliament_text_41"))
		return false
	end
	return true
end
function intetiorPolicySkill:doPromise()
	local id = self:getSkillID()
	intetiorCtrl:reqParliamentPolicyPromise(id)
end
function intetiorPolicySkill:isCanShowDoate()
	if self:isPolicyPromise() then
		return true
	end
	return false
end
function intetiorPolicySkill:checkSkillCanDo_Doate()
	if self:isPolicyGoldEnough() then
		SoraDShowMsgTip(i18n("parliament_text_43"))
		return false
	end
	return true
end
function intetiorPolicySkill:isCanShowPolicy()
	if not self:isCanOpPromise_official() then
		return false
	end
	if self:isSkillCD() then
		return false
	end
	return true
end
function intetiorPolicySkill:checkSkillCanDo_Policy()
	if not self:isCanOpPromise_official() then
		SoraDShowMsgTip(i18n("parliament_text_38"))
		return false
	end
	if self:isSkillForbidden() then
		SoraDShowMsgTip(i18n("parliament_text_46"))
		return false
	end
	if intetiorCtrl:isHasPolicyPolicy() then
		SoraDShowMsgTip(i18n("parliament_text_47"))
		return false
	end
	if self:isSkillCD() then
		SoraDShowMsgTip(i18n("parliament_text_48"))
		return false
	end
	return true
end
function intetiorPolicySkill:doPolicy_sendMsg(view)
	local id = self:getSkillID()
	intetiorCtrl:reqParliamentPolicyExecute(id)
	SoraDShowLoading(view)
end
function intetiorPolicySkill:doPolicy_imp(view)
	if not self:isPolicyGoldEnough_Kingdom() then
		SoraDShowMsgTip(i18n("parliament_text_49"))
		return
	end
	local id = self:getSkillID()
	if id == gParliamentPolicy.RESOURCE_OUTPUT_BOOST then
		local time = os.date("!*t", serviceFunctions.systemTime())
		if time.hour < 13 then
			local showMsg = i18n("parliament_text_142")
			SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					self:doPolicy_sendMsg(view)
				end
			end)
		else
			self:doPolicy_sendMsg(view)
		end
	else
		self:doPolicy_sendMsg(view)
	end
end
function intetiorPolicySkill:doPolicy(view)
	local policyId = intetiorCtrl:getPolicyPormiseID()
	if policyId and policyId ~= self:getSkillID() then
		local showMsg = i18n("parliament_text_82")
		SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				self:doPolicy_imp(view)
			end
		end)
	else
		self:doPolicy_imp(view)
	end
end
function intetiorPolicySkill:isCanShowPublish()
	if not self:isCanOpPromise_official() then
		return false
	end
	if self:isSkillCD() then
		return false
	end
	return true
end
function intetiorPolicySkill:checkSkillCanDo_Publish()
	if not self:isCanOpPromise_official() then
		SoraDShowMsgTip(i18n("parliament_text_38"))
		return false
	end
	if self:isSkillForbidden() then
		SoraDShowMsgTip(i18n("parliament_text_54"))
		return false
	end
	if self:isSkillEffect() then
		SoraDShowMsgTip(i18n("parliament_text_56"))
		return false
	end
	if self:isSkillCD() then
		SoraDShowMsgTip(i18n("parliament_text_55"))
		return false
	end
	if not self:isPolicyGoldEnough_Kingdom() then
		SoraDShowMsgTip(i18n("parliament_text_49"))
		return false
	end
	if self:getSkillID() == gParliamentDecree.EMBEZZLE and intetiorCtrl:isSelfInTrick_monitorEmbezzle() then
		SoraDShowMsgTip(i18n("parliament_text_65"))
		return false
	end
	return true
end
function intetiorPolicySkill:doPublish(view)
	local id = self:getSkillID()
	if self:isSkillTargetPersonal() then
		local layer = uiManager:show("LordSelectView").view
		layer:initData(lordSearchType.PIGEON, 1, i18n("parliament_btn_19"))
		layer:setTitleText(i18n("common_text_2234"))
		layer:setIsSortPower(true)
		layer:setHandle(function(tableUID, num, target, tableData)
			local data = tableData[1]
			if data then
				dump(data, "sdlflskjflksjdf")
				local abbr
				if data.getProperty then
					local allianceMgr = gametop.playertop_:getModule("allianceMgr")
					abbr = allianceMgr:getAllianceProperty("abbr")
				else
					abbr = data.allianceAbbr
				end
				local name = data.getProperty and data:getProperty("nickName") or data.nickName
				local sourceKid = data.getProperty and data:getProperty("sourceKid") or data.sourceKid
				local nameStr = mailFunctions:getWrappedName(abbr, name)
				_ENV = name
				name.name = nameStr
				local showMsg = i18n("parliament_text_83", name)
				local kingId = lordInfoCtrl:getLordInfo().base.uid
				local targetId = data.minfo and data.minfo.uid or data.uid
				local warStatus = worldMapDefine.kingWarStatus
				if 0 < sourceKid then
					SoraDShowMsgTip(i18n("parliament_text_148"))
					return
				end
				if kingId == targetId then
					SoraDShowMsgTip(i18n("parliament_text_149"))
					return
				end
				SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						local uid = tableUID[1]
						intetiorCtrl:reqParliamentDecreeExecute(id, uid)
						SoraDShowLoading(view)
					end
				end)
			end
		end)
	else
		intetiorCtrl:reqParliamentDecreeExecute(id)
		SoraDShowLoading(view)
	end
end
return intetiorPolicySkill
