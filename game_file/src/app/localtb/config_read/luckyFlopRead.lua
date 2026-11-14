local luckyFlopRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	luckyFlopRead:defineValue("config", "app." .. LocalTblPath .. ".config_server.lucky_flip_config")
	luckyFlopRead:defineValue("showRankAward", "app." .. LocalTblPath .. ".config_client.lucky_flip_show")
	luckyFlopRead:defineValue("RechargeConfig", "app." .. LocalTblPath .. ".config_server.lucky_flip_gift")
	luckyFlopRead:defineValue("luckyNumConfig", "app." .. LocalTblPath .. ".config_server.lucky_flip_num")
	luckyFlopRead:defineValue("rankRewardConfig", "app." .. LocalTblPath .. ".config_server.lucky_flip_reward")
end
init()
function luckyFlopRead.getLuckyNumConfig()
	if not luckyFlopRead.luckyNumConfig then
		luckyFlopRead = luckyFlopRead.luckyNumConfig
	end
	return luckyFlopRead.luckyNumConfig
end
function luckyFlopRead.getStageCoin(stage, isPrivilege)
	local info
	stage = 7 < stage and 7 or stage
	for k, v in pairs(luckyFlopRead.TaskConfig) do
		if v.stage == stage then
			if isPrivilege then
				return v.priCoin
			else
				return v.coin
			end
		end
	end
	return 0
end
function luckyFlopRead.getGiftConfig()
	if not luckyFlopRead.RechargeConfig then
		luckyFlopRead = luckyFlopRead.RechargeConfig
	end
	return luckyFlopRead.RechargeConfig
end
function luckyFlopRead.getRankAward(type)
	local _ENV, tmp
	for k, v in ipairs(luckyFlopRead.rankRewardConfig) do
		if v.type == type then
			if v.type == 2 then
				v.needShowInfo = luckyFlopRead.getNeedShowInfo()
			end
			table.insert(tmp, v)
		end
	end
	return tmp
end
function luckyFlopRead.isScoreEnough(scoreHave, times)
	local flipNum = luckyFlopRead.config[1].filpNum
	return scoreHave >= tonumber(times) * flipNum
end
function luckyFlopRead.getFlipNum()
	local flipNum = luckyFlopRead.config[1].filpNum
	return flipNum or 0
end
function luckyFlopRead.getNeedShowInfo()
	local luckyFlopRead, tmp
	local info = luckyFlopRead.config[1]
	tmp.charmNum = info.charmNum
	tmp.num = info.num
	tmp.i18nkey = "luckyFlip_text_12"
	return tmp
end
function luckyFlopRead.getCharmNum()
	return luckyFlopRead.config[1].charmNum or 0
end
function luckyFlopRead.getShowRankAward(rankType)
	for i, v in ipairs(luckyFlopRead.showRankAward) do
		if v.type == rankType then
			return v.rewardShow
		end
	end
end
function luckyFlopRead.getExtraAward(specialType)
	for i, v in ipairs(luckyFlopRead.luckyNumConfig) do
		if v.type == 1 and v.specialType == specialType then
			return v.reward
		end
	end
end
return luckyFlopRead
