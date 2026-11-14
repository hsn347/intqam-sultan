local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local militaryRankCtrl = class("militaryRankCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function militaryRankCtrl:ctor(properties)
	militaryRankCtrl.super.ctor(self, properties)
	self.dataTable, militaryRankCtrl, self.handle_notify = militaryRankCtrl.super.ctor, militaryRankCtrl.super.ctor, nil
	militaryRankCtrl, self.militaryRankRead = include("militaryRankRead"), include("militaryRankRead")
	include("militaryRankRead")[gBuffEffect.TROOP_ATTACK_BOOST] = gMilitaryRankProperty.SOLDIER_ATTACK
	include("militaryRankRead")[gBuffEffect.TROOP_DEFENSE_BOOST] = gMilitaryRankProperty.SOLDIER_DEFENSE
	include("militaryRankRead")[gBuffEffect.TROOP_HP_BOOST] = gMilitaryRankProperty.SOLDIER_HP
	militaryRankCtrl, self.buffVsMilitaryLv, include("militaryRankRead")[gBuffEffect.TRANDFORM_WOUNDED] = include("militaryRankRead"), include("militaryRankRead"), gMilitaryRankProperty.TRANDFORM_WOUNDED
	militaryRankCtrl = gMilitaryRankProperty.TRANDFORM_WOUNDED
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_ATTACK_BOOST] = gMilitaryRankSkillProperty[1].SOLDIER_ATTACK
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_DEFENSE_BOOST] = gMilitaryRankSkillProperty[1].SOLDIER_DEFENSE
	include("militaryRankRead")[gPlayerBattleGround.CUR_KINGDOM], gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_HP_BOOST] = gMilitaryRankProperty.TRANDFORM_WOUNDED, gMilitaryRankSkillProperty[1].SOLDIER_HP
	militaryRankCtrl = gMilitaryRankProperty.TRANDFORM_WOUNDED
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_ATTACK_BOOST] = gMilitaryRankSkillProperty[2].SOLDIER_ATTACK
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_DEFENSE_BOOST] = gMilitaryRankSkillProperty[2].SOLDIER_DEFENSE
	include("militaryRankRead")[gPlayerBattleGround.CONQUEST_WAR_ENEMY_KINGDOM], gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_HP_BOOST] = gMilitaryRankProperty.TRANDFORM_WOUNDED, gMilitaryRankSkillProperty[2].SOLDIER_HP
	militaryRankCtrl = gMilitaryRankProperty.TRANDFORM_WOUNDED
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_ATTACK_BOOST] = gMilitaryRankSkillProperty[3].SOLDIER_ATTACK
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_DEFENSE_BOOST] = gMilitaryRankSkillProperty[3].SOLDIER_DEFENSE
	include("militaryRankRead")[gPlayerBattleGround.PYRAMID], gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_HP_BOOST] = gMilitaryRankProperty.TRANDFORM_WOUNDED, gMilitaryRankSkillProperty[3].SOLDIER_HP
	militaryRankCtrl = gMilitaryRankProperty.TRANDFORM_WOUNDED
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_ATTACK_BOOST] = gMilitaryRankSkillProperty[4].SOLDIER_ATTACK
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_DEFENSE_BOOST] = gMilitaryRankSkillProperty[4].SOLDIER_DEFENSE
	include("militaryRankRead")[gPlayerBattleGround.ATLANTIS], gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_HP_BOOST] = gMilitaryRankProperty.TRANDFORM_WOUNDED, gMilitaryRankSkillProperty[4].SOLDIER_HP
	militaryRankCtrl = gMilitaryRankProperty.TRANDFORM_WOUNDED
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_ATTACK_BOOST] = gMilitaryRankSkillProperty[5].SOLDIER_ATTACK
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_DEFENSE_BOOST] = gMilitaryRankSkillProperty[5].SOLDIER_DEFENSE
	include("militaryRankRead")[gPlayerBattleGround.RUINS], gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_HP_BOOST] = gMilitaryRankProperty.TRANDFORM_WOUNDED, gMilitaryRankSkillProperty[5].SOLDIER_HP
	militaryRankCtrl = gMilitaryRankProperty.TRANDFORM_WOUNDED
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_ATTACK_BOOST] = gMilitaryRankSkillProperty[6].SOLDIER_ATTACK
	gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_DEFENSE_BOOST] = gMilitaryRankSkillProperty[6].SOLDIER_DEFENSE
	self.buffVsMilitarySkill, include("militaryRankRead")[gPlayerBattleGround.NEBULA], gMilitaryRankProperty.TRANDFORM_WOUNDED[gBuffEffect.TROOP_HP_BOOST] = include("militaryRankRead"), gMilitaryRankProperty.TRANDFORM_WOUNDED, gMilitaryRankSkillProperty[6].SOLDIER_HP
end
function militaryRankCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MILITARY_RANK_MODULE, gCmd.REQ_MILITARY_RANK_GET_REWARD, handler(self, self.getRewardRsp))
	msgCtrl.register(gCmd.CMD_MILITARY_RANK_MODULE, gCmd.REQ_MILITARY_RANK_LEARN_SKILL, handler(self, self.getLearnSkillRsp))
	msgCtrl.register(gCmd.CMD_MILITARY_RANK_MODULE, gCmd.REQ_MILITARY_RANK_EXCHANGE_TOOL, handler(self, self.getExchangeToolRsp))
	msgCtrl.register(gCmd.CMD_MILITARY_RANK_MODULE, gCmd.REQ_MILITARY_OPEN_PAGE, handler(self, self.getOpenPageRsp))
	msgCtrl.register(gCmd.CMD_MILITARY_RANK_MODULE, gCmd.REQ_MILITARY_MARSHAL_TIP, handler(self, self.getMarshalSetRsp))
	msgCtrl.register(gCmd.CMD_MILITARY_RANK_MODULE, gCmd.REQ_MILITARY_MARSHAL_FINISH_LOGIN, handler(self, self.getMarshalLoginRsp))
	self:updateMilitaryRankDataChangeInfo()
end
function militaryRankCtrl:sendGetReward()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_MILITARY_RANK_MODULE
	local (nil).subcmd, msg = gCmd.REQ_MILITARY_RANK_GET_REWARD, nil
	serverproxy:SendMsg(msg)
end
function militaryRankCtrl:sendLearnSkill(mSkill)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_MILITARY_RANK_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_MILITARY_RANK_LEARN_SKILL, gCmd.REQ_MILITARY_RANK_LEARN_SKILL
	;(nil).data, gCmd.REQ_MILITARY_RANK_LEARN_SKILL.skilltype = gCmd.REQ_MILITARY_RANK_LEARN_SKILL, mSkill
	local msg
	serverproxy:SendMsg(msg)
end
function militaryRankCtrl:sendExchangeTool(mGoodID, mCount)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_MILITARY_RANK_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_MILITARY_RANK_EXCHANGE_TOOL, gCmd.REQ_MILITARY_RANK_EXCHANGE_TOOL
	gCmd.REQ_MILITARY_RANK_EXCHANGE_TOOL.goodid = mGoodID
	;(nil).data, gCmd.REQ_MILITARY_RANK_EXCHANGE_TOOL.goodcount = gCmd.REQ_MILITARY_RANK_EXCHANGE_TOOL, mCount
	local msg
	serverproxy:SendMsg(msg)
end
function militaryRankCtrl:sendOpenPage()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_MILITARY_RANK_MODULE
	local (nil).subcmd, msg = gCmd.REQ_MILITARY_OPEN_PAGE, nil
	serverproxy:SendMsg(msg)
end
function militaryRankCtrl:sendMarshalTip(marshalTip)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_MILITARY_RANK_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_MILITARY_MARSHAL_TIP, gCmd.REQ_MILITARY_MARSHAL_TIP
	;(nil).data, gCmd.REQ_MILITARY_MARSHAL_TIP.marshalTip = gCmd.REQ_MILITARY_MARSHAL_TIP, marshalTip
	local msg
	serverproxy:SendMsg(msg)
end
local SHOW_MARSHAL_MARQUEE_KEY = "Game:militaryRank:showMarshalMarquee~bool"
function militaryRankCtrl:getShowMarshalMarquee()
	_ENV = nil
	;(nil).byUID = true
	return SoraDConfigGet(SHOW_MARSHAL_MARQUEE_KEY, nil)
end
function militaryRankCtrl:setShowMarshalMarquee(show)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet(SHOW_MARSHAL_MARQUEE_KEY, show and true or false, nil)
end
function militaryRankCtrl:sendMarshalLoginTip()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_MILITARY_RANK_MODULE
	local (nil).subcmd, msg = gCmd.REQ_MILITARY_MARSHAL_FINISH_LOGIN, nil
	serverproxy:SendMsg(msg)
end
function militaryRankCtrl:resetData()
	self.dataTable, _UPVALUE0_ = nil, nil
end
function militaryRankCtrl:getData()
	return self.dataTable
end
function militaryRankCtrl:getMilitaryEffectData()
	local ret.skills, _ENV, ret.effect, _ENV, _ENV, ret
	for k, v in pairs(self.dataTable.skills) do
		local tmpSkillType = tonumber(k)
		local tmpSKillLevel = v.level
		local tmpSkillEffect = v.effect
		local effectCfg = self.militaryRankRead.getSkillEffect(tmpSkillEffect)
		if effectCfg then
			local tmpSkillID = self:getSkillBuffInBuffSystem(effectCfg.effectType)
			if tmpSkillID then
				local tmpCfg = self.militaryRankRead.getSkillCfgByTypeAndLv(tmpSkillType, tmpSKillLevel)
				if #effectCfg.effect >= 2 and tmpCfg then
					_ENV = nil
					;(nil).id = tmpSkillType
					;(nil).lv = tmpSKillLevel
					;(nil).cfgID = tmpCfg.skillIndex
					;(nil).skillID = tmpSkillID
					;(nil).skillValue = effectCfg.effect[2]
					;(nil).valueType = effectCfg.effect[1]
					;(nil).effectCfgID = tmpSkillEffect
					table.insert(ret.skills, nil)
				end
			end
		end
	end
	for k, v in pairs(self.dataTable.effects) do
		local tmpEffectType = tonumber(k)
		local tmpEffectValue = tonumber(v)
		local myEffectType = self:getBuffType(tmpEffectType)
		if myEffectType then
			_ENV = self.militaryRankRead.getSkillCfgByTypeAndLv(tmpSkillType, tmpSKillLevel)
			self.militaryRankRead.getSkillCfgByTypeAndLv(tmpSkillType, tmpSKillLevel).id = myEffectType
			self.militaryRankRead.getSkillCfgByTypeAndLv(tmpSkillType, tmpSKillLevel).num = tmpEffectValue
			table.insert(ret.effect, (self.militaryRankRead.getSkillCfgByTypeAndLv(tmpSkillType, tmpSKillLevel)))
		end
	end
	if type(ret.skills) == "table" then
		table.sort(ret.skills, function(a, b)
			if a.cfgID and b.cfgID then
				return a.cfgID > b.cfgID
			end
		end)
	end
	return ret
end
function militaryRankCtrl:getMilitaryExchangeData()
	local _ENV, ret
	for k, v in pairs(self.militaryRankRead.shop) do
		local tmpIsLock = false
		if self.dataTable.level and self.dataTable.level < tonumber(v.needRank) then
			tmpIsLock = true
		end
		if self.dataTable.exploit and math.floor(self.dataTable.exploit * 100000) < math.floor(tonumber(v.needPoint) * 100000) then
			tmpIsLock = true
		end
		local leftCount = self:getLeftBuyCount(k, v.count)
		_ENV = v.count
		v.count.id = v.Effect
		v.count.itemType = v.Type
		v.count.needPoint = v.needPoint
		v.count.qlv = v.quality
		v.count.needRank = v.needRank
		v.count.lock = tmpIsLock
		v.count.cfgID = tonumber(k)
		v.count.leftCount = leftCount
		v.count.exchange = v.exchange
		table.insert(ret, v.count)
	end
	table.sort(ret, function(l, r)
		if l.itemType ~= r.itemType then
			return l.itemType > r.itemType
		elseif l.needRank ~= r.needRank then
			return l.needRank < r.needRank
		elseif l.needPoint ~= r.needPoint then
			return l.needPoint < r.needPoint
		else
			return l.cfgID > r.cfgID
		end
	end)
	return ret
end
function militaryRankCtrl:getMilitarySkillData()
	local _ENV, ret
	local skillsTypeCfg = self.militaryRankRead.getSkillsByType()
	for k, v in pairs(skillsTypeCfg) do
		local skillType = tonumber(k)
		local tmpMaxSkillLv = #v
		local tmpLv = 1
		local isFull = false
		if self:isLearnedSkill(skillType) then
			tmpLv = self.dataTable.skills[tostring(skillType)].level + 1
			if tmpMaxSkillLv < tmpLv then
				isFull = true
				tmpLv = tmpMaxSkillLv
			end
		end
		local tmpCfg = self.militaryRankRead.getSkillCfgByTypeAndLv(skillType, tmpLv)
		if tmpCfg then
			local tmpIsLock = false
			if self.dataTable.level and self.dataTable.level < tonumber(tmpCfg.needLevel) then
				tmpIsLock = true
			end
			if self.dataTable.exploit and math.floor(self.dataTable.exploit * 100000) < math.floor(tonumber(tmpCfg.needPoint) * 100000) then
				tmpIsLock = true
			end
			_ENV = tonumber(tmpCfg.needPoint) * 100000
			;(tonumber(tmpCfg.needPoint) * 100000).isFull = isFull
			;(tonumber(tmpCfg.needPoint) * 100000).id = skillType
			;(tonumber(tmpCfg.needPoint) * 100000).lv = tmpLv
			;(tonumber(tmpCfg.needPoint) * 100000).needPoint = tmpCfg.needPoint
			;(tonumber(tmpCfg.needPoint) * 100000).needRank = tmpCfg.needLevel
			;(tonumber(tmpCfg.needPoint) * 100000).lock = tmpIsLock
			;(tonumber(tmpCfg.needPoint) * 100000).cfgID = tmpCfg.skillIndex
			table.insert(ret, tonumber(tmpCfg.needPoint) * 100000)
		end
	end
	return ret
end
function militaryRankCtrl:isLearnedSkill(mSkillType)
	if self.dataTable.skills[tostring(mSkillType)] then
		return true
	end
	return false
end
function militaryRankCtrl:getBuffType(mSelfDefBuffType)
	for k, v in pairs(self.buffVsMilitaryLv) do
		if tonumber(v) == tonumber(mSelfDefBuffType) then
			return tonumber(k)
		end
	end
	return nil
end
function militaryRankCtrl:getLeftBuyCount(mCfgID, canBuyCount)
	for k, v in pairs(self.dataTable.gotTools) do
		if tonumber(v.id) == tonumber(mCfgID) then
			return math.max(0, canBuyCount - v.buyCount)
		end
	end
	return canBuyCount
end
function militaryRankCtrl:getTotalBuffValue(mEffectType)
	local tmpLvBuffValue = self:getLvBuffValue(mEffectType)
	local tmpSkillBuffValue = self:getSkillBuffValue(mEffectType)
	if tmpLvBuffValue then
		if tmpSkillBuffValue then
			return tmpLvBuffValue + tmpSkillBuffValue
		end
		return tmpLvBuffValue
	end
	return tmpSkillBuffValue
end
function militaryRankCtrl:getLvBuffValue(mEffectType)
	if nil == self.dataTable or nil == self.dataTable.effects then
		return nil
	end
	local tmpBuffValue
	if self.buffVsMilitaryLv[mEffectType] then
		local tmpBuffType = self.buffVsMilitaryLv[mEffectType]
		for k, v in pairs(self.dataTable.effects) do
			local tmpLvEffectType = tonumber(k)
			if tmpBuffType == tmpLvEffectType then
				if nil == tmpBuffValue then
					tmpBuffValue = 0
				end
				tmpBuffValue = tmpBuffValue + tonumber(v)
			end
		end
	end
	return tmpBuffValue
end
function militaryRankCtrl:getSkillBuffValue(mEffectType)
	if nil == self.dataTable or nil == self.dataTable.skills then
		return nil
	end
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if nil == lordInfoCtrl then
		return nil
	end
	local tmpBuffValue
	local warType = lordInfoCtrl:getPlayerBattleGround()
	for k, v in pairs(self.dataTable.skills) do
		local tmpSkillTypeKey = tonumber(k)
		local tmpLinkRelation = self.buffVsMilitarySkill[warType]
		if tmpLinkRelation then
			local tmpItem = self.militaryRankRead.skillbuff[v.effect]
			if tmpItem and tonumber(tmpLinkRelation[mEffectType]) == tonumber(tmpItem.effectType) then
				if nil == tmpBuffValue then
					tmpBuffValue = 0
				end
				if #tmpItem.effect >= 2 then
					tmpBuffValue = tmpBuffValue + tonumber(tmpItem.effect[2])
				end
			end
		end
	end
	return tmpBuffValue
end
function militaryRankCtrl:getSkillBuffInBuffSystem(mEffectType)
	for k, v in pairs(self.buffVsMilitarySkill) do
		for kBuff, vBuff in pairs(v) do
			if tonumber(vBuff) == mEffectType then
				return tonumber(kBuff)
			end
		end
	end
	return nil
end
function militaryRankCtrl:updateMilitaryRankDataChangeInfo()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MILITARY_RANK_DATA_CHANGE, handler(self, self.notifyMilitaryRankDataChange))
end
function militaryRankCtrl:notifyMilitaryRankDataChange(respone)
	local tmpData = respone.data[1]
	if tmpData then
		self.dataTable = tmpData
		self:updateMilitaryRankInfo(tmpData.lastRank)
		if tmpData.hasNewEffect then
			for k, v in pairs(self.dataTable.effects) do
				local tmpLvEffectType = tonumber(k)
				local tmpBuffValue = tonumber(v)
				local tmpBuffType = self:getBuffType(tmpLvEffectType)
				if tmpBuffType then
					local gametop = gModuleMgr.getObject("gametop")
					local buffCtrl = gametop.playertop_:getModule("buffCtrl")
					print("militaryRankCtrl:notifyMilitaryRankDataChange == ", tmpBuffType, tmpLvEffectType, tmpBuffValue)
					buffCtrl:dispatchBuffEvent(tmpBuffType, gBuffSource.MILITARY)
				end
			end
		end
	end
end
function militaryRankCtrl:initClientData(data)
	self.dataTable = data
end
function militaryRankCtrl:updateMilitaryRankInfo(mLastRank)
	local _ENV, updateLordInfoData
	updateLordInfoData.gotReward = self.dataTable.gotReward
	updateLordInfoData.exploit = math.floor(self.dataTable.exploit)
	updateLordInfoData.points = math.floor(self.dataTable.points)
	updateLordInfoData.level = self.dataTable.level
	updateLordInfoData.totalpoints = math.floor(self.dataTable.totalpoints)
	updateLordInfoData.curRank = self.dataTable.curRank
	updateLordInfoData.lastRank = self.dataTable.lastRank
	updateLordInfoData.lastLevel = self.dataTable.lastLevel
	updateLordInfoData.gotReward = self.dataTable.gotReward
	updateLordInfoData.isMax = self.dataTable.isMax
	if mLastRank then
		updateLordInfoData.lastRank = mLastRank
	end
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if lordInfoCtrl then
		lordInfoCtrl:updateMilitaryRankInfo(updateLordInfoData)
	end
end
function militaryRankCtrl:Logout()
	militaryRankCtrl.super.Logout(self)
	self:resetData()
end
function militaryRankCtrl:getRewardRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		local _ENV, rewards = content.result, content.result
		for i, v in ipairs(content.rewards) do
			rewards[v.id] = v.count
		end
		SoraDMailGainItems(rewards)
		self:updateMilitaryRankInfo()
	else
	end
	_ENV = self.updateMilitaryRankInfo
	self.updateMilitaryRankInfo.msg = "MESSAGE_LORDMILITARY_GET_REWARD"
	SoraDSendMessage(self.updateMilitaryRankInfo)
end
function militaryRankCtrl:getLearnSkillRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		self:updateMilitaryRankInfo()
		local tmpSkillChange = content.skillChange
		if tmpSkillChange then
			local gametop = gModuleMgr.getObject("gametop")
			local buffCtrl = gametop.playertop_:getModule("buffCtrl")
			local effectCfg = self.militaryRankRead.getSkillEffect(tmpSkillChange.effect)
			if effectCfg then
				local buffType = self:getSkillBuffInBuffSystem(effectCfg.effectType)
				if buffType then
					buffCtrl:dispatchBuffEvent(buffType, gBuffSource.MILITARY)
				end
			end
		end
	else
	end
	_ENV = gModuleMgr.getObject("gametop")
	gModuleMgr.getObject("gametop").msg = "MESSAGE_LORDMILITARY_SKILL_STUDY"
	SoraDSendMessage((gModuleMgr.getObject("gametop")))
end
function militaryRankCtrl:getExchangeToolRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		self:updateMilitaryRankInfo()
		local toolData = self.militaryRankRead.getShopCfg(content.data.goodid)
		if toolData.Type == gRechargeVipDef.normalItem then
			SoraDPopGainItem(toolData.id, content.data.goodcount or 1)
		end
	else
	end
	_ENV = SoraDPopGainItem
	SoraDPopGainItem.msg = "MESSAGE_LORDMILITARY_TOOL_EXCHANGE"
	SoraDSendMessage(SoraDPopGainItem)
end
function militaryRankCtrl:getOpenPageRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		self:updateMilitaryRankInfo()
	else
	end
end
function militaryRankCtrl:getMarshalSetRsp(content)
	if gErrDef.Err_MILITARY_STATUS_ERROR == content.err then
		SoraDShowMsgTip(i18n("common_text_4132"))
	elseif gErrDef.Err_None == content.err then
		if self.dataTable and content.data then
			self.dataTable.marshalTip = content.data.marshalTip
		end
		SoraDShowMsgTip(i18n("common_text_4131"))
	end
end
function militaryRankCtrl:getMarshalLoginRsp(content)
	dump(content, "militaryRankCtrl:getMarshalLoginRsp", 5)
	if gErrDef.Err_None == content.err then
	end
end
return militaryRankCtrl
