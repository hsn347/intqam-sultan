local _ENV, petraRareTreasureUtil
local petraRareTreasureDef = include("petraRareTreasureDef")
local petraRareTreasureRead = include("petraRareTreasureRead")
local gametop = gModuleMgr.getObject("gametop")
local petraRareTreasureCtrl = gametop.playertop_:getModule("petraRareTreasureCtrl")
function petraRareTreasureUtil:getBestTreasureGold()
	local gold = 0
	local times = petraRareTreasureCtrl:getBestTreasureTimes() + 1
	local config = petraRareTreasureRead:getRefreshCfg(times)
	if config then
		gold = config.gold or 0
	end
	return gold
end
function petraRareTreasureUtil:getAwardByIndex(index)
	if index <= 0 then
		return
	end
	if index == petraRareTreasureDef.BEST_TREASURE then
		index = petraRareTreasureCtrl:getBestTreasureID()
		if index <= 0 then
			return
		end
		local config = petraRareTreasureRead:getSelectItem(index)
		if config and config.id then
			return config
		end
	else
		local config = petraRareTreasureRead:getItemCfg(index)
		if config and config.id then
			return config
		end
	end
end
function petraRareTreasureUtil:showAwardLuckey(unlockedLuckyCoin)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_PETRA_RARE_TREASURE_EFFECT"
	;(nil).unlockedLuckyCoin = unlockedLuckyCoin
	SoraDSendMessage(nil)
end
function petraRareTreasureUtil:showAward(indexList, unlockedLuckyCoin)
	if indexList and #indexList <= 0 then
		return
	end
	if #indexList == 1 then
		local index = indexList[1]
		if index ~= petraRareTreasureDef.LUCKY_KEY then
			petraRareTreasureDef = nil
			;(nil).msg = "MESSAGE_SERVER_PETRA_RARE_TREASURE_EFFECT_ITEM"
			;(nil).index = index
			SoraDSendMessage(nil)
		else
			self:showAwardLuckey(unlockedLuckyCoin)
		end
	else
		local petraRareTreasureDef, itemList = indexList[1], indexList[1]
		local hasLuck = false
		for i, index in ipairs(indexList) do
			local config = self:getAwardByIndex(index)
			if config then
				petraRareTreasureDef = nil
				;(nil).index = i
				;(nil).itemIndex = index
				;(nil).id = config.id
				;(nil).count = config.count
				table.insert(itemList, nil)
			end
			if index == petraRareTreasureDef.LUCKY_KEY then
				hasLuck = true
			end
		end
		if 0 < #itemList then
			local panel = SoraDCreatePanel("petraRareTreasureAwardView")
			panel:initData(itemList, hasLuck, unlockedLuckyCoin)
			panel:show()
		elseif hasLuck then
			self:showAwardLuckey()
		end
	end
end
return petraRareTreasureUtil
