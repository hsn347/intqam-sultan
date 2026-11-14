local _ENV, ancientReelUtil
local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local ancientReelRead = include("ancientReelRead")
local ancientReelDef = include("ancientReelDef")
local ANCIENT_REEL_AWARD_TYPE = ancientReelDef.ANCIENT_REEL_AWARD_TYPE
local ANCIENT_REEL_ITEM_TYPE = ancientReelDef.ANCIENT_REEL_ITEM_TYPE
ancientReelUtil.ANCIENT_REEL_AWARD_TYPE = ANCIENT_REEL_AWARD_TYPE
ancientReelUtil.ANCIENT_REEL_ITEM_TYPE = ANCIENT_REEL_ITEM_TYPE
local ANCIENT_REEL_ITEM_ID = 13918
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
function ancientReelUtil:getTaskExp(taskList)
	local cur = 0
	local max = 0
	for _, taskInfo in ipairs(taskList) do
		for _, itemInfo in ipairs(taskInfo.award) do
			if itemInfo.id == gIDType.ANCIENT_REEL_LV_EXP_POINT then
				max = max + itemInfo.count
				if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
					cur = cur + itemInfo.count
				end
			end
		end
	end
	return cur, max
end
function ancientReelUtil:openShop()
	local numGold = ancientReelCtrl:getAwardNum(true)
	local numNormal = ancientReelCtrl:getAwardNum()
	local num = numGold - numNormal
	if 10 <= num then
		SoraDCreatePanel("ancientReelGift"):show()
	elseif GLOBAL_GAME_RECHARGE_MODE then
		ancientReelCtrl = nil
		;(nil).rechargeID = ANCIENT_REEL_ITEM_ID
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToLimitNode(12, ANCIENT_REEL_ITEM_ID)
		panel:show()
	end
end
function ancientReelUtil.getRechargeGift()
	local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
	local list = rechargeActivityCtrl:getHotActivityList()
	if list and next(list) then
		for _, v in pairs(list) do
			if v.ID == ANCIENT_REEL_ITEM_ID then
				if not v.gift then
					gametop = v.gift
				end
				local tmpList = SoraDStringSplit(v.gift, ",")
				ANCIENT_REEL_ITEM_ID = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				v.gift = serviceFunctions.tableFormat(tmpList, nil)
				return v
			end
		end
	end
end
function ancientReelUtil.addAward(levelList, awardType, awardList)
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
	if awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_NORMAL then
		for v = minlv, maxlv do
			local awardData = ancientReelRead:getLevelList(v)
			if awardData and awardData.bronzeAward then
				insertAward(awardData.bronzeAward, v)
			end
		end
	elseif awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD then
		for v = minlv, maxlv do
			local awardData = ancientReelRead:getLevelList(v)
			if awardData and awardData.goldAward then
				insertAward(awardData.goldAward, v)
			end
		end
	elseif awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_SUPER then
		local awardData = ancientReelRead:getLevelMaxList()
		if awardData and awardData.award then
			local num = ancientReelCtrl:getAwardItemNum(minlv, maxlv)
			if 0 < num then
				insertAward(awardData.award, "50+", num)
			end
		end
	end
end
return ancientReelUtil
