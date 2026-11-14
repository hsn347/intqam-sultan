local _ENV, royalSummonsUtil
local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsRead = include("royalSummonsRead")
_ENV = "royalSummonsRead"
;("royalSummonsRead").ROYAL_SUMMONS_AWARD_TYPE_GOLD = 1
;("royalSummonsRead").ROYAL_SUMMONS_AWARD_TYPE_NORMAL = 2
local _ENV, ("royalSummonsRead").ROYAL_SUMMONS_AWARD_TYPE_SUPER, ROYAL_SUMMONS_AWARD_TYPE = nil, 3, "royalSummonsRead"
;(nil).ROYAL_SUMMONS_ITEM_TYPE_NORMAL = 1
;(nil).ROYAL_SUMMONS_ITEM_TYPE_GET = 2
;(nil).ROYAL_SUMMONS_ITEM_TYPE_AWARD = 3
local (nil).ROYAL_SUMMONS_ITEM_TYPE_ACTIVITY, ROYAL_SUMMONS_ITEM_TYPE = 4, nil
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
royalSummonsUtil.ROYAL_SUMMONS_AWARD_TYPE = ROYAL_SUMMONS_AWARD_TYPE
royalSummonsUtil.ROYAL_SUMMONS_ITEM_TYPE = ROYAL_SUMMONS_ITEM_TYPE
function royalSummonsUtil:getTaskStatus(taskId)
	local taskInfo = royalSummonsCtrl:getTask(taskId)
	if taskInfo and taskInfo.hasGotReward then
		return gBtnTargetStatusDef.GOT
	end
	local taskCfg = royalSummonsRead:getTaskCfg(taskId, royalSummonsCtrl:getClassType())
	if taskInfo and taskCfg and taskCfg.amount and taskInfo.progress >= taskCfg.amount then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function royalSummonsUtil:getTaskAwardNum()
	local taskList = royalSummonsRead:getTaskCfg(nil, royalSummonsCtrl:getClassType())
	local numToday = 0
	local numSeason = 0
	for _, taskCfg in pairs(taskList) do
		local taskInfo = royalSummonsCtrl:getTask(taskCfg.taskID)
		if taskInfo and not taskInfo.hasGotReward and taskCfg.amount and taskInfo.progress >= taskCfg.amount then
			if taskCfg.taskType == 1 then
				numToday = numToday + 1
			elseif taskCfg.taskType == 2 then
				numSeason = numSeason + 1
			end
		end
	end
	return numToday + numSeason, numToday, numSeason
end
function royalSummonsUtil:getTaskProgress(taskId)
	local taskInfo = royalSummonsCtrl:getTask(taskId)
	if taskInfo and taskInfo.progress then
		return taskInfo.progress
	end
	return 0
end
function royalSummonsUtil:getTaskAmount(taskId)
	local taskCfg = royalSummonsRead:getTaskCfg(taskId, royalSummonsCtrl:getClassType())
	if taskCfg and taskCfg.amount then
		return taskCfg.amount
	end
	return 0
end
_ENV, royalSummonsUtil.getTaskExp = function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end, function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).KILL_NPC = 4506801
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).COLL_RES = 4506802
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).WISH_RESOURCE = 4506803
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).ALLIANCE_DONATE = 4506804
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).TRAIN_ARMY = 4506805
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).SIGN_IN = 4506806
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).SCOUT = 4506807
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).KILL_ARMY_FC = 4506901
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).ARMY_ATTACK = 4506902
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).KILL_HERO_BATTLE_BOSS = 4506903
;(function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).LOGIN = 4506904
local (function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end).KILL_WASTELAND, RoyalSummonsActivityTaskId = 4506905, function(self, taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ROYAL_SUMMONS_EXP then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end
local taskSkipTo_worldmap = function(taskInfo, taskDes)
	if (taskInfo.taskID == RoyalSummonsActivityTaskId.KILL_NPC or taskInfo.taskID == RoyalSummonsActivityTaskId.COLL_RES) and worldMapDefine.isInWar() or (taskInfo.taskID == RoyalSummonsActivityTaskId.KILL_HERO_BATTLE_BOSS or taskInfo.taskID == RoyalSummonsActivityTaskId.KILL_WASTELAND) and worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	RoyalSummonsActivityTaskId = i18n("common_text_3302")
	i18n("common_text_3302").msg = i18n(taskDes)
	mildGuideManager:starToQuickToWorld(i18n("common_text_3302"))
end
local taskSkipTo_army = function(taskInfo, taskDes)
	SoraDRemoveAllPanelFromManager()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local bid = BUILDID.CHARIOT_PLANT
	_ENV = nil
	;(nil).bid = bid
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	SoraDShowMsgTip(i18n(taskDes))
end
local taskSkipTo_alliance_donate = function(taskInfo, taskDes)
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ESCORT)
end
local taskSkipTo_wish = function(taskInfo, taskDes)
	SoraDRemoveAllPanelFromManager()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH)
	SoraDShowMsgTip(i18n(taskDes))
end
local taskSkipTo_openshop = function(taskInfo, taskDes)
	local des = royalSummonsCtrl:getClassType() == 1 and "summoned_text_50" or "summoned_text_70"
	SoraDShowMsgBox(i18n(des), i18n("common_text_477"), nil, function(eventType)
		if MSGBOX_CALLBACK_YES == eventType then
			SoraDRemoveAllPanelFromManager()
			royalSummonsUtil:openShop()
		end
	end)
end
_ENV = nil
;(nil)[RoyalSummonsActivityTaskId.KILL_NPC] = taskSkipTo_worldmap
;(nil)[RoyalSummonsActivityTaskId.COLL_RES] = taskSkipTo_worldmap
;(nil)[RoyalSummonsActivityTaskId.WISH_RESOURCE] = taskSkipTo_wish
;(nil)[RoyalSummonsActivityTaskId.ALLIANCE_DONATE] = taskSkipTo_alliance_donate
;(nil)[RoyalSummonsActivityTaskId.TRAIN_ARMY] = taskSkipTo_army
;(nil)[RoyalSummonsActivityTaskId.SIGN_IN] = taskSkipTo_openshop
;(nil)[RoyalSummonsActivityTaskId.SCOUT] = taskSkipTo_worldmap
;(nil)[RoyalSummonsActivityTaskId.KILL_ARMY_FC] = taskSkipTo_worldmap
;(nil)[RoyalSummonsActivityTaskId.ARMY_ATTACK] = taskSkipTo_worldmap
;(nil)[RoyalSummonsActivityTaskId.KILL_HERO_BATTLE_BOSS] = taskSkipTo_worldmap
local (nil)[RoyalSummonsActivityTaskId.KILL_WASTELAND], TaskSkipTo = taskSkipTo_worldmap, nil
function royalSummonsUtil:isSpiceilTask(taskInfo)
	local taskType = taskInfo.taskID
	return taskType == RoyalSummonsActivityTaskId.LOGIN
end
function royalSummonsUtil:skipTo(taskInfo, taskDes)
	local taskType = taskInfo.taskID
	local skipToFun = TaskSkipTo[taskType]
	if skipToFun then
		skipToFun(taskInfo, taskDes)
	end
end
local ROYAL_SUMMONS_ITEM_ID = royalSummonsCtrl:getClassType() == 1 and (IsArClient and 13303 or 13157) or 13789
function royalSummonsUtil:openShop()
	local numGold = royalSummonsCtrl:getAwardNum(true)
	local numNormal = royalSummonsCtrl:getAwardNum()
	local num = numGold - numNormal
	if 10 <= num then
		SoraDCreatePanel("royalSummonsGift"):show()
	elseif GLOBAL_GAME_RECHARGE_MODE then
		royalSummonsCtrl = nil
		;(nil).rechargeID = ROYAL_SUMMONS_ITEM_ID
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToLimitNode(12, ROYAL_SUMMONS_ITEM_ID)
		panel:show()
	end
end
function royalSummonsUtil.getRechargeGift()
	local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
	local list = rechargeActivityCtrl:getHotActivityList()
	dump(list, "royalSummonsUtil.getRechargeGift")
	if list and next(list) then
		for _, v in pairs(list) do
			if v.ID == ROYAL_SUMMONS_ITEM_ID then
				if not v.gift then
					gametop = v.gift
				end
				local tmpList = SoraDStringSplit(v.gift, ",")
				ROYAL_SUMMONS_ITEM_ID = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				v.gift = serviceFunctions.tableFormat(tmpList, nil)
				return v
			end
		end
	end
end
function royalSummonsUtil.addAward(levelList, awardType, awardList)
	if not (levelList and levelList.minlv) or not levelList.maxlv then
		return
	end
	local insertAward = function(data, lv, count)
		for _, v in ipairs(data) do
			local c = clone(v)
			c.lv = lv
			if count then
				c.count = c.count * count
			end
			awardList[#awardList + 1] = c
		end
	end
	local minlv = levelList.minlv
	local maxlv = levelList.maxlv
	if awardType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL then
		for v = minlv, maxlv do
			local awardData = royalSummonsRead:getLevelList(v, royalSummonsCtrl:getClassType())
			if awardData and awardData.bronzeAward then
				insertAward(awardData.bronzeAward, v)
			end
		end
	elseif awardType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD then
		for v = minlv, maxlv do
			local awardData = royalSummonsRead:getLevelList(v, royalSummonsCtrl:getClassType())
			if awardData and awardData.goldAward then
				insertAward(awardData.goldAward, v)
			end
		end
	elseif awardType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_SUPER then
		local awardData = royalSummonsRead:getLevelMaxList(royalSummonsCtrl:getClassType())
		if awardData and awardData.award then
			local num = royalSummonsCtrl:getAwardItemNum(minlv, maxlv)
			if 0 < num then
				insertAward(awardData.award, "50+", num)
			end
		end
	end
end
return royalSummonsUtil
