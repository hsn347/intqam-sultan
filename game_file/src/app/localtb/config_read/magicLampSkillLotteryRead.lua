local magicLampSkillLotteryRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "magic_draw_config"
;(nil)[2] = true
magicLampSkillLotteryRead:defineValue("magic_draw_config", nil)
_UPVALUE1_ = nil
;(nil)[1] = "magic_pool_view"
magicLampSkillLotteryRead:defineValue("magic_pool_view", nil)
_UPVALUE2_ = nil
;(nil)[1] = "magic_pool_draw"
;(nil)[2] = true
magicLampSkillLotteryRead:defineValue("magic_pool_draw", nil)
_UPVALUE2_ = nil
;(nil)[1] = "magic_draw_stage_reward"
;(nil)[2] = true
magicLampSkillLotteryRead:defineValue("magic_draw_stage_reward", nil)
magicLampSkillLotteryRead:defineValue("showCfg", function()
	magicLampSkillLotteryRead.showCfg, magicLampSkillLotteryRead = nil, nil
	for i, v in ipairs(magicLampSkillLotteryRead.magic_pool_draw) do
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil)[3] = "weight"
		v.drawReward = serviceFunctions.tableFormat(v.drawReward, nil)
		magicLampSkillLotteryRead.showCfg[v.magicPoolID] = v
	end
	return magicLampSkillLotteryRead.showCfg
end)
magicLampSkillLotteryRead:defineValue("previewCfg", function()
	magicLampSkillLotteryRead.previewCfg, magicLampSkillLotteryRead = nil, nil
	for i, v in ipairs(magicLampSkillLotteryRead.magic_pool_view) do
		magicLampSkillLotteryRead.previewCfg[v.magicPoolID] = v
	end
	return magicLampSkillLotteryRead.previewCfg
end)
magicLampSkillLotteryRead:defineValue("unlockSkillCfg", function()
	magicLampSkillLotteryRead.unlockSkillCfg, magicLampSkillLotteryRead = nil, nil
	for i, v in ipairs(magicLampSkillLotteryRead.magic_draw_config) do
		if not magicLampSkillLotteryRead.unlockSkillCfg[v.poolID] then
			magicLampSkillLotteryRead.unlockSkillCfg[v.poolID], magicLampSkillLotteryRead = nil, nil
		end
		magicLampSkillLotteryRead.unlockSkillCfg[v.poolID][v.data[1]] = v
	end
	return magicLampSkillLotteryRead.unlockSkillCfg
end)
magicLampSkillLotteryRead:defineValue("stageRewardCfg", function()
	magicLampSkillLotteryRead.stageRewardCfg, magicLampSkillLotteryRead = nil, nil
	for i, v in ipairs(magicLampSkillLotteryRead.magic_draw_stage_reward) do
		if not magicLampSkillLotteryRead.stageRewardCfg[v.magicPoolID] then
			magicLampSkillLotteryRead.stageRewardCfg[v.magicPoolID], magicLampSkillLotteryRead = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(magicLampSkillLotteryRead.stageRewardCfg[v.magicPoolID], v)
	end
	return magicLampSkillLotteryRead.stageRewardCfg
end)
function magicLampSkillLotteryRead.getShowCfgList()
	return magicLampSkillLotteryRead.magic_pool_draw
end
function magicLampSkillLotteryRead.getShowCfgByID(magicPoolID)
	return magicLampSkillLotteryRead.showCfg[magicPoolID]
end
function magicLampSkillLotteryRead.getStageReward(magicPoolID)
	return magicLampSkillLotteryRead.stageRewardCfg[magicPoolID]
end
function magicLampSkillLotteryRead.getPreviewCfgList()
	return magicLampSkillLotteryRead.magic_pool_view
end
function magicLampSkillLotteryRead.getPreviewCfgByID(magicPoolID)
	return magicLampSkillLotteryRead.previewCfg[magicPoolID]
end
function magicLampSkillLotteryRead.getUnlockSkillCfgByType(magicPoolID, skillType)
	local unlockSkillCfgs = magicLampSkillLotteryRead.unlockSkillCfg[magicPoolID]
	if unlockSkillCfgs then
		return unlockSkillCfgs[skillType]
	end
	return nil
end
return magicLampSkillLotteryRead
