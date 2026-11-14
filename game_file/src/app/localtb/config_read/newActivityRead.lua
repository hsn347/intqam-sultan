local newActivityRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "world_boss_rank_rewards"
	;(nil)[2] = true
	newActivityRead:defineValue("heroBossAward", nil)
	_ENV = nil
	;(nil)[1] = "development_army_stage"
	;(nil)[2] = true
	newActivityRead:defineValue("developArmyStage", nil)
	_ENV = nil
	;(nil)[1] = "development_personal_stage"
	;(nil)[2] = true
	newActivityRead:defineValue("developPersonStage", nil)
	_ENV = nil
	;(nil)[1] = "development_army_rank"
	;(nil)[2] = true
	newActivityRead:defineValue("developArmyRankData", nil)
	_ENV = nil
	;(nil)[1] = "development_army_personal_rank"
	;(nil)[2] = true
	newActivityRead:defineValue("armyPersonRankData", nil)
	_ENV = nil
	;(nil)[1] = "development_army_config"
	;(nil)[2] = true
	newActivityRead:defineValue("armyConfig", nil)
	_ENV = nil
	;(nil)[1] = "development_army_score"
	;(nil)[2] = true
	newActivityRead:defineValue("armyScore", nil)
	_ENV = nil
	;(nil)[1] = "crazy_score_point"
	;(nil)[2] = true
	newActivityRead:defineValue("crazyScorePoint", nil)
	_ENV = nil
	;(nil)[1] = "crazy_score_stage_reward"
	;(nil)[2] = true
	newActivityRead:defineValue("crazyScoreStageReward", nil)
	_ENV = nil
	;(nil)[1] = "crazy_score_rank_reward"
	;(nil)[2] = true
	newActivityRead:defineValue("crazyScoreRankReward", nil)
	newActivityRead = nil
	;(nil)[1] = "crazy_score_des"
	newActivityRead:defineValue("crazyScoreDes", nil)
	newActivityRead = nil
	;(nil)[1] = "crazy_score_special_gift"
	newActivityRead:defineValue("crazyScoreSpecialReward", nil)
	_ENV = nil
	;(nil)[1] = "floweractivity_award"
	;(nil)[2] = true
	newActivityRead:defineValue("flowerActivityReward", nil)
	_ENV = nil
	;(nil)[1] = "floweractivity_rank_award"
	;(nil)[2] = true
	newActivityRead:defineValue("flowerActivityRankReward", nil)
	newActivityRead = nil
	;(nil)[1] = "activity_dialogue"
	newActivityRead:defineValue("dialogue", nil)
	newActivityRead:defineValue("dialogueMap", function()
		newActivityRead.dialogueMap, newActivityRead = nil, nil
		for k, v in pairs(newActivityRead.dialogue) do
			local dialogueID = v.dialogue
			if not newActivityRead.dialogueMap[dialogueID] then
				newActivityRead.dialogueMap[dialogueID], newActivityRead = nil, nil
			end
			table.insert(newActivityRead.dialogueMap[dialogueID], v)
		end
		for k, v in pairs(newActivityRead.dialogueMap) do
			table.sort(v, function(a, b)
				return a.order < b.order
			end)
		end
		return newActivityRead.dialogueMap
	end)
end
init()
function newActivityRead.getFlowerActivityAward(contenttype)
	local _ENV, ret
	for k, v in ipairs(newActivityRead.flowerActivityReward) do
		if v.content and contenttype == v.content then
			table.insert(ret, v)
		end
	end
	return ret
end
function newActivityRead.getFlowerActivityAllAwardData()
	return newActivityRead.flowerActivityReward
end
function newActivityRead.getFlowerActivityRankAward(contenttype)
	local _ENV, ret
	for k, v in ipairs(newActivityRead.flowerActivityRankReward) do
		if v.content and contenttype == v.content then
			table.insert(ret, v)
		end
	end
	return ret
end
function newActivityRead.getDevelopArmyStage()
	return newActivityRead.developArmyStage
end
function newActivityRead.getDevelopPersonStage()
	return newActivityRead.developPersonStage
end
function newActivityRead.getDevelopArmyRankData()
	return newActivityRead.developArmyRankData
end
function newActivityRead.getArmyPersonRankData()
	return newActivityRead.armyPersonRankData
end
function newActivityRead.getArmyConfig(activityID)
	local _ENV, ret
	for key, value in pairs(newActivityRead.armyConfig) do
		if tonumber(value.activityID) == tonumber(activityID) then
			table.insert(ret, value)
		end
	end
	return ret
end
function newActivityRead.getDevelopArmyInfo()
	local _ENV, ret
	for key, value in pairs(newActivityRead.armyScore) do
		table.insert(ret, value)
	end
	return ret
end
function newActivityRead.getCrazyScorePoint()
	return newActivityRead.crazyScorePoint
end
function newActivityRead.getCrazyScoreDes()
	return newActivityRead.crazyScoreDes
end
function newActivityRead.getCrazySpecialRewardByID(id)
	id = tonumber(id)
	return newActivityRead.crazyScoreSpecialReward[id]
end
function newActivityRead.getCrazyScoreStageReward()
	return newActivityRead.crazyScoreStageReward
end
function newActivityRead.getCrazyScoreRankReward()
	return newActivityRead.crazyScoreRankReward
end
function newActivityRead.getHeroBossAward()
	return newActivityRead.heroBossAward
end
function newActivityRead:getDialogues(dialogueID)
	return newActivityRead.dialogueMap[dialogueID]
end
return newActivityRead
