local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
local palaceInfoRead = include("palaceInfoRead")
local allianceDesRead = include("allianceDesRead")
local queueTimeUtil = include("queueTimeUtil")
local kingdomMapUtil = include("kingdomMapUtil")
local socket = require("socket")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl", gametop)
local AllianceWarListRallyMgr = class("AllianceWarListRallyMgr")
function AllianceWarListRallyMgr:ctor()
	self.indexID = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.timer = nil
	self.tableHead, _ENV, self.tableMainData = nil, nil, nil
	self.attackType = gAWarViewMemberType.DEFENDER
	self.viewType = gAWarViewMemberType.NONE
	self.showPlus = true
	self.showClose = false
	self.hasCapture = false
	self.targetData = nil
	self.maxCount = 0
	self.hasMyArmy = false
end
function AllianceWarListRallyMgr:initData(indexID, warHallData)
	self.indexID = indexID
	self.queueRoot = kingdomMapCtrl:getQueueRootByWar()
	local warHallQueues
	if warHallData then
		warHallQueues = warHallData
	else
		warHallData = self.queueRoot:getWarHallData(self.indexID)
		if warHallData then
			warHallQueues, kingdomMapCtrl = warHallData.queues, warHallData.queues
			warHallQueues = warHallData and warHallData.queues or warHallData
		end
	end
	local tableMainData
	if warHallQueues then
		local index, queue = next(warHallQueues)
		if index and queue then
			tableMainData = queue
		end
	end
	if not tableMainData then
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		return
	end
	self.tableMainData = tableMainData
	local memberAttack = self.queueRoot:getMassQueuesAttacker(self.tableMainData)
	local memberDefend = self.queueRoot:getMassQueuesDefender(self.tableMainData)
	local memberData
	self.viewType = gAWarViewMemberType.NONE
	self.hasMyArmy = false
	self.hasCapture = false
	self.showClose = false
	self.isWar = self.queueRoot:isWarQueueRoot()
	local targetData = self:getShowTarget()
	self.targetData = targetData
	local uid = lordInfoCtrl:getLordInfo().base.uid
	local fromAid = self.tableMainData:getAid()
	local selfAid = self.queueRoot:getOwnTeamID()
	local toAid = kingdomMapUtil.getTargetAid(targetData, fromAid, selfAid)
	if fromAid == toAid then
		local memberAttackQueue = self.queueRoot:getMassQueuesAttackQueues(self.tableMainData)
		self:updateMassNum(memberAttackQueue)
		self.attackType = gAWarViewMemberType.HELPER
		if uid == self.tableMainData.from.uid and self.tableMainData.status ~= gMapMoveLineStatusType.moveLineStatusTypeMoving then
			self.viewType = gAWarViewMemberType.ATTACKER
			self.showClose = self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeRally
		end
		memberData = memberAttack
	elseif fromAid == selfAid then
		local memberAttackQueue = self.queueRoot:getMassQueuesAttackQueues(self.tableMainData)
		self:updateMassNum(memberAttackQueue)
		self.attackType = gAWarViewMemberType.ATTACKER
		if uid == self.tableMainData.from.uid and self.tableMainData.status ~= gMapMoveLineStatusType.moveLineStatusTypeMoving then
			self.viewType = gAWarViewMemberType.ATTACKER
			self.showClose = self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeRally
		end
		memberData = memberAttack
	elseif toAid == selfAid then
		local memberDefendQueue = self.queueRoot:getMassQueuesDefendQueues(self.tableMainData)
		self:updateMassNum(memberDefendQueue)
		self.attackType = gAWarViewMemberType.DEFENDER
		if uid ~= targetData.uid then
			self.viewType = gAWarViewMemberType.ALLY
			self.showPlus = self.massNum < self.tableMainData.maxMassNum
			if not self.showPlus and self.tableMainData.maxHelpNum then
				self.maxCount = self.tableMainData.maxHelpNum - self.massNum
				self.showPlus = self.massNum < self.tableMainData.maxHelpNum
			end
		else
			self.viewType = gAWarViewMemberType.DEFENDER
			if self.tableMainData.to.objType == gMapObjTypeDef.mapObjTypePlayer then
				self.showClose = true
			end
		end
		memberData = memberDefend
	end
	for _, v in ipairs(memberData) do
		if uid == v.uid then
			self.hasMyArmy = true
			break
		end
	end
	if self.maxCount < 0 then
		self.maxCount = 0
	end
	self.isShowHeroPlus = true
	local totalMember = allianceMgr:getAllianceBattlePeopleCount()
	if (self.viewType == gAWarViewMemberType.NONE or self.viewType == gAWarViewMemberType.ALLY) and totalMember <= #memberData then
		self.isShowHeroPlus = false
	end
end
function AllianceWarListRallyMgr:onPlusClick()
	if not self.isShowHeroPlus then
		SoraDShowMsgTip(i18n("assembled_text_05"))
	elseif not self.showPlus then
		SoraDShowMsgTip(i18n("assembled_text_06"))
	elseif self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeMoving then
		SoraDShowMsgTip(i18n("assembled_text_03"))
	elseif self.showClose then
		SoraDShowMsgTip(i18n("assembled_text_04"))
	elseif self.hasMyArmy then
		SoraDShowMsgTip(i18n("common_text_652"))
	elseif self.viewType == gAWarViewMemberType.NONE then
		local worldMapWarDef = include("worldMapWarDef")
		_ENV = i18n("common_text_652")
		i18n("common_text_652").massData = self.tableMainData.from
		if not worldMapWarDef.checkCanJoinMass(i18n("common_text_652")) then
			return
		end
		local panel = uiManager:show("AllianceWarRallyView")
		panel:initData(self.indexID, self.tableMainData, self.queueRoot)
	elseif self.viewType == gAWarViewMemberType.ALLY then
		local worldMapWarDef = include("worldMapWarDef")
		_ENV = panel.initData
		panel.initData.massData = self.tableMainData.to
		if not worldMapWarDef.checkCanJoinMass(panel.initData) then
			return
		end
		if not kingdomMapCtrl:hasArmyHelpQueue2Player(self.tableMainData.to.uid) then
			local instanceID = self.tableMainData.to.id
			if self.tableMainData.to.objType == gMapObjTypeDef.mapObjTypeAllianceBuild then
				if kingdomMapCtrl:hasArmyHelpQueue2Object(instanceID) then
					SoraDShowMsgTip(i18n("common_text_704"))
				elseif SoraDEnoughTroops() then
					local panel = uiManager:show("AllianceWarRallyView")
					panel:initData(self.indexID, self.tableMainData, self.queueRoot)
				end
			else
				_ENV = uiManager:show("AllianceWarRallyView")
				uiManager:show("AllianceWarRallyView").uid = self.tableMainData.to.uid
				uiManager:show("AllianceWarRallyView").dispatchType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
				local uiManager:show("AllianceWarRallyView").instanceID, cityArmyData = instanceID, uiManager:show("AllianceWarRallyView")
				_ENV = self.tableMainData
				self.tableMainData.cityArmyData = cityArmyData
				uiManager:show("ReinforcementsMsgBox", self.tableMainData)
			end
		else
			SoraDShowMsgTip(i18n("common_text_704"))
		end
	end
end
function AllianceWarListRallyMgr:onAddArmy()
	if self.hasMyArmy then
		SoraDShowMsgTip(i18n("common_text_652"))
		return
	end
	if self.maxCount <= 0 then
	end
	_ENV = self.maxCount
	self.maxCount.data = self.tableMainData.from
	self.maxCount.id = self.tableMainData.id
	self.maxCount.mainObjType = self.tableMainData.to.objType
	self.maxCount.mainObjId = self.tableMainData.to.objId
	self.maxCount.isManuPlace = self.tableMainData.to.isManuPlace
	self.maxCount.attr = self.tableMainData.attr
	self.maxCount.massSlaveForbidArmyClass = self.tableMainData:getMassSlaveForbidArmyClass()
	self.maxCount.massSlaveArmyMinLv = self.tableMainData:getMassSlaveArmyMinLv()
	self.maxCount.massSlaveArmyMinNum = self.tableMainData:getMassSlaveArmyMinNum()
	self.maxCount.massSlaveArmyMaxNum = self.tableMainData:getMassSlaveArmyMaxNum()
	self.tableMemberData, self.maxCount.isForbidSpeed = self.maxCount, self.tableMainData:getIsForbidSpeed()
	if SoraDEnoughTroops() then
		_ENV = SoraDEnoughTroops()
		_ENV, SoraDEnoughTroops().toPoint = cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y), cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y)
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massId = self.tableMemberData.id
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveForbidArmyClass = self.tableMemberData.massSlaveForbidArmyClass
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMinLv = self.tableMemberData.massSlaveArmyMinLv
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).endTime = queueTimeUtil.getFinishTime(self.tableMainData)
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMinNum = self.tableMemberData.massSlaveArmyMinNum
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMaxNum = self.tableMemberData.massSlaveArmyMaxNum
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).isForbidSpeed = self.tableMemberData.isForbidSpeed
		SoraDEnoughTroops().otherData, cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).mainInstanceType = cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y), self.tableMemberData.mainObjType
		SoraDEnoughTroops().instanceID = self.tableMemberData.data.mapObjId
		SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_xuanZhan
		SoraDEnoughTroops().instanceType = gMapObjTypeDef.mapObjTypePlayer
		SoraDEnoughTroops().maxCount = self.maxCount
		SoraDEnoughTroops().isJoinMass = true
		local SoraDEnoughTroops().attr, dispatchData = self.tableMemberData.attr, SoraDEnoughTroops()
		local dispatchFun = function(callType)
			if callType == nil or callType == MSGBOX_CALLBACK_YES then
				if not self.__cname then
					print("对象已经被释放")
					return
				end
				dispatchData.maxCount = self.maxCount
				self.dispatchPanel = uiManager:show("WorldDispatchArmyView")
				self.dispatchPanel:initData(dispatchData)
			end
		end
		if kingdomMapCtrl:reqIsSafe() and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapObjTypeBoss and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeHeroBattleBoss1 and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeHeroBattleBoss2 and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeATBuilding and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeWerewolf and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeWrathBeast and self.tableMemberData.mainObjType ~= gMapObjTypeDef.wastelandBoss and self.tableMemberData.mainObjType ~= gMapObjTypeDef.sweetMeatRobber and self.tableMemberData.mainObjType == gMapObjTypeDef.mapObjTypeAllianceBuild and self.tableMemberData.mainObjId ~= gMapAllianceBuildType.subTypeAllianceAltar then
			local showMsg = i18n("notice_0160")
			SoraDShowMsgBox(showMsg, i18n("common_text_490"), i18n("common_text_185"), dispatchFun)
		elseif self.tableMemberData.mainObjType == gMapObjTypeDef.mapObjTypeBoss or self.tableMemberData.mainObjType == gMapObjTypeDef.mapTypeWerewolf or self.tableMemberData.mainObjType == gMapObjTypeDef.mapTypeHuntFair or self.tableMemberData.mainObjType == gMapObjTypeDef.wastelandBoss then
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local bossType = self.tableMainData.to.bossType
			local limitType = _G.gBossType2LimitType[bossType] or bossType
			if self.tableMemberData.mainObjType == gMapObjTypeDef.mapTypeWerewolf then
				limitType = gBossType.werewolf
			elseif self.tableMainData.to.bossType == gBossType.huntFairBoss then
				limitType = gBossType.huntFairBoss
			end
			local isAttackReward = kingdomMapCtrl:canGetBossAttackRewards(limitType)
			local isKillReward = kingdomMapCtrl:canGetBossKillRewards(limitType)
			print("集结啦！！！", self.tableMemberData.mainObjType, isAttackReward, isKillReward, limitType)
			if not isAttackReward then
				local maxAttack = activityShowCtrl:getBossMaxAttackNum(limitType)
				if limitType == gBossType.heroBattleBoss1 or limitType == gBossType.endlessTrialBoss1 then
					_ENV = isKillReward
					isKillReward.maxAttack = maxAttack
					SoraDShowMsgBox(i18n("herobattle_text_19", isKillReward), i18n("common_text_204"), nil, dispatchFun)
				else
					_ENV = nil
					;(nil).maxAttack = maxAttack
					SoraDShowMsgBox(i18n("common_text_2151", nil), i18n("common_text_204"), nil, dispatchFun)
				end
			elseif not isKillReward then
				local maxKill = activityShowCtrl:getBossMaxKillNum(limitType)
				if limitType == gBossType.heroBattleBoss1 or limitType == gBossType.endlessTrialBoss1 then
					_ENV = nil
					;(nil).maxKill = maxKill
					SoraDShowMsgBox(i18n("herobattle_text_20", nil), i18n("common_text_204"), nil, dispatchFun)
				else
					_ENV = nil
					;(nil).maxKill = maxKill
					SoraDShowMsgBox(i18n("common_text_2152", nil), i18n("common_text_204"), nil, dispatchFun)
				end
			else
				dispatchFun()
			end
		else
			dispatchFun()
		end
	end
end
local isSelfIn = function(data)
	local id = lordInfoCtrl:getLordInfo().base.uid
	for _, v in ipairs(data) do
		if v.uid and v.uid == id then
			return true
		end
	end
end
function AllianceWarListRallyMgr:getShowTarget()
	if self.tableMainData:isTargetCapture() then
		local queuesFix = self.queueRoot:getWorkingCaptainQueue(self.tableMainData)
		if queuesFix then
			self.hasCapture = true
			return queuesFix:getFrom()
		end
	end
	self.hasCapture = false
	return self.tableMainData.to
end
function AllianceWarListRallyMgr:updateMassNum(memberQueueData)
	self.maxCount = 0
	local massNum = 0
	for i, v in ipairs(memberQueueData) do
		if 1 < i then
			massNum = massNum + v.totalNum
		end
	end
	self.massNum = massNum
	self.maxCount = self.tableMainData.maxMassNum - self.massNum
	self.showPlus = self.massNum < self.tableMainData.maxMassNum
end
return AllianceWarListRallyMgr
