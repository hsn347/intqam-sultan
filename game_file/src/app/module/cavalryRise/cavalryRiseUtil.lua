local _ENV, cavalryRiseUtil
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local gametop = gModuleMgr.getObject("gametop")
local cavalryRiseCtrl = gametop.playertop_:getModule("cavalryRiseCtrl")
local cavalryRiseRead = include("cavalryRiseRead")
_ENV = "cavalryRiseRead"
;("cavalryRiseRead").CAVALRY_RISE_AWARD_TYPE_GOLD = 1
;("cavalryRiseRead").CAVALRY_RISE_AWARD_TYPE_NORMAL = 2
local _ENV, ("cavalryRiseRead").CAVALRY_RISE_AWARD_TYPE_SUPER, CAVALRY_RISE_AWARD_TYPE = nil, 3, "cavalryRiseRead"
;(nil).CAVALRY_RISE_ITEM_TYPE_NORMAL = 1
;(nil).CAVALRY_RISE_ITEM_TYPE_GET = 2
;(nil).CAVALRY_RISE_ITEM_TYPE_GOT = 3
local (nil).CAVALRY_RISE_ITEM_TYPE_NEED_ACTIVITY, CAVALRY_RISE_ITEM_TYPE = 4, nil
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
cavalryRiseUtil.CAVALRY_RISE_AWARD_TYPE = CAVALRY_RISE_AWARD_TYPE
cavalryRiseUtil.CAVALRY_RISE_ITEM_TYPE = CAVALRY_RISE_ITEM_TYPE
function cavalryRiseUtil:openShop(giftData)
	if giftData then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeID = tonumber(giftData.ID)
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
			panel:show()
		end
		print("打开商店", giftData.ID)
	else
		SoraDShowMsgTip(i18n("HeroVault_text_03"))
	end
end
local CAVALRY_RISE_ITEM_ID = 14382
_UPVALUE3_, cavalryRiseUtil.buyGolden = function(self)
	SoraDCreatePanel("cavalryRiseGift"):show()
end, function(self)
	SoraDCreatePanel("cavalryRiseGift"):show()
end
;(function(self)
	SoraDCreatePanel("cavalryRiseGift"):show()
end)[1] = 14383
;(function(self)
	SoraDCreatePanel("cavalryRiseGift"):show()
end)[2] = 14384
local (function(self)
	SoraDCreatePanel("cavalryRiseGift"):show()
end)[3], CAVALRY_RISE_EXP_ITEM_ID_LIST = 14385, function(self)
	SoraDCreatePanel("cavalryRiseGift"):show()
end
function cavalryRiseUtil:buyExp()
	for i, v in ipairs(CAVALRY_RISE_EXP_ITEM_ID_LIST) do
		local giftData = self:getRechargeGift(v)
		if giftData and tonumber(giftData.extraData) > 0 or i == #CAVALRY_RISE_EXP_ITEM_ID_LIST then
			self:openShop(giftData)
			break
		end
	end
end
function cavalryRiseUtil:skipTo(taskInfo, taskDes)
	print("任务跳转：", taskInfo.taskID)
	local guideId = taskInfo.guideId
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(taskDes))
	end
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function cavalryRiseUtil:getTaskStatus(taskId)
	local taskComponent = cavalryRiseCtrl:getTask()
	if taskComponent and taskComponent:isTaskClaimed(taskId) then
		return gBtnTargetStatusDef.GOT
	end
	if taskComponent and taskComponent:isTaskFinished(taskId) then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function cavalryRiseUtil:getTaskProgress(taskId)
	return cavalryRiseCtrl:getTask():getTaskProgress(taskId)
end
function cavalryRiseUtil:getTaskAmount(taskId)
	local taskCfg = cavalryRiseRead:getTaskCfg(taskId, cavalryRiseCtrl:getClassType())
	if taskCfg and taskCfg.aim then
		return taskCfg.aim
	end
	return 0
end
function cavalryRiseUtil:getGoldenRechargeGift()
	local giftData = self:getRechargeGift(CAVALRY_RISE_ITEM_ID)
	return giftData
end
function cavalryRiseUtil:getRechargeGift(id)
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local list = rechargeActivityCtrl:getHotActivityList()
	if list and next(list) then
		for _, v in pairs(list) do
			if v.ID == id then
				if not v.gift then
					_ENV = v.gift
				end
				local tmpList = SoraDStringSplit(v.gift, ",")
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				v.gift = serviceFunctions.tableFormat(tmpList, nil)
				return v
			end
		end
	end
end
function cavalryRiseUtil.addAward(levelList, awardType, awardList)
	if not (levelList and levelList.minlv) or not levelList.maxlv then
		error("levelList must be {minlv=,maxlv=}")
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
	if awardType == CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_NORMAL then
		for i = minlv, maxlv do
			local awardData = cavalryRiseRead:getLevelCfg(i, cavalryRiseCtrl:getClassType())
			if awardData and awardData.bronzeAward then
				insertAward(awardData.bronzeAward, i)
			end
		end
	elseif awardType == CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_GOLD then
		for i = minlv, maxlv do
			local awardData = cavalryRiseRead:getLevelCfg(i, cavalryRiseCtrl:getClassType())
			if awardData and awardData.goldAward then
				insertAward(awardData.goldAward, i)
			end
		end
	else
		error("cavalryRiseUtil.addAward type error" .. awardType)
	end
end
return cavalryRiseUtil
