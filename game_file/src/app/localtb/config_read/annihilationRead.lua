local annihilationRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "annihilation_scoreconf"
	;(nil)[2] = true
	annihilationRead:defineValue("scoreconf", nil)
	_ENV = nil
	;(nil)[1] = "annihilation_score_reward"
	;(nil)[2] = true
	annihilationRead:defineValue("scorereward", nil)
	annihilationRead:defineValue("boxreward", function()
		local _ENV, boxreward
		local boxrewardCfg = require_once("app." .. LocalTblPath .. ".config_server.annihilation_box_reward")
		for k, v in ipairs(boxrewardCfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			v.index = k
			boxreward[k] = v
		end
		return boxreward
	end)
end
init()
function annihilationRead.getRankReward()
	return annihilationRead.scorereward
end
function annihilationRead.getRewardBoxInfo(index)
	return index and annihilationRead.boxreward[index] or annihilationRead.boxreward
end
function annihilationRead.getMaxRewardBoxScore()
	return annihilationRead.boxreward[#annihilationRead.boxreward].num
end
function annihilationRead.getRewardBoxPlan(score)
	local maxScore = annihilationRead.getMaxRewardBoxScore()
	return math.floor(math.min(100, score * 100 / maxScore))
end
return annihilationRead
