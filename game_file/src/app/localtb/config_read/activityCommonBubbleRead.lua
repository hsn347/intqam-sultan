local activityCommonBubbleRead = include("aAReadClass").new()
activityCommonBubbleRead:defineValue("activity_9001664_levelConfig", function()
	local config = require_data("bubble_fight_reward", true).data
	return activityCommonBubbleRead.getClassTypeConfig(config, "classType")
end)
function activityCommonBubbleRead.getLevelConfig(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001664 then
		return activityCommonBubbleRead.activity_9001664_levelConfig
	end
end
function activityCommonBubbleRead.getLevelRewardConfig(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(activityID)
	local config = activityCommonBubbleRead.getLevelConfig(activityID)
	return config[classType]
end
activityCommonBubbleRead:defineValue("activity_9001638_stageConfig", function()
	local config = require_data("edial_bubble_bobble_stage_rewar", true).data
	return activityCommonBubbleRead.getClassTypeConfig(config, "classType")
end)
function activityCommonBubbleRead.getStageConfig(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001638 then
		return activityCommonBubbleRead.activity_9001638_stageConfig
	end
end
function activityCommonBubbleRead.getStageRewardConfig(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(activityID)
	local config = activityCommonBubbleRead.getStageConfig(activityID)
	return config[classType]
end
function activityCommonBubbleRead.getStagePoint(activityID, index)
	local config = activityCommonBubbleRead.getStageRewardConfig(activityID)
	local cfg = config[index]
	return cfg and cfg.point or 0
end
function activityCommonBubbleRead.getStageReward(activityID, index)
	local config = activityCommonBubbleRead.getStageRewardConfig(activityID)
	local cfg = config[index]
	if cfg then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		if serviceFunctions.tableFormat(cfg.reward, nil) then
			goto lbl_18
		end
	end
	activityCommonBubbleRead = serviceFunctions.tableFormat(cfg.reward, nil)
	::lbl_18::
	return (serviceFunctions.tableFormat(cfg.reward, nil))
end
function activityCommonBubbleRead.getScoreList(activityID)
	local activityCommonBubbleRead, ret
	local config = activityCommonBubbleRead.getStageRewardConfig(activityID)
	for i, cfg in ipairs(config) do
		table.insert(ret, cfg.point)
	end
	return ret
end
function activityCommonBubbleRead.getSkin(activityID)
	local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
	return activityCommonBubbleCtrl:getSkin(activityID)
end
function activityCommonBubbleRead.getBallImageName(colorType, activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001664 then
		if activityCommonBubbleRead.getSkin(activityID) == 2 then
			return string.format("frame_9001693_ball_%02d.png", colorType)
		else
			return string.format("frame_9001664_ball_%02d.png", colorType)
		end
	else
		return string.format("frame_9001638_ball_%02d.png", colorType)
	end
end
function activityCommonBubbleRead.getLinePointURL(colorType, activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001664 then
		if activityCommonBubbleRead.getSkin(activityID) == 2 then
			return string.format("ui://Activity_9001638/frame_9001664_point_%02d", colorType)
		else
			return string.format("ui://Activity_9001638/frame_9001693_point_%02d", colorType)
		end
	else
		return string.format("ui://Activity_9001638/frame_9001638_point_%02d", colorType)
	end
end
function activityCommonBubbleRead.getShowFAQ(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001664 then
		if activityCommonBubbleRead.getSkin(activityID) == 2 then
			_ENV = nil
			;(nil).content = i18n("dessert_fight_text01")
			uiManager:show("RuleView", nil)
		else
			_ENV = nil
			;(nil).content = i18n("bubble_fight_text01")
			uiManager:show("RuleView", nil)
		end
	else
		_ENV = nil
		;(nil).content = i18n("Bubble_Bobble_text_01")
		uiManager:show("RuleView", nil)
	end
end
function activityCommonBubbleRead.getGuideStep(activityID)
	_ENV = nil
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001638] = 9991300
	_UPVALUE2_ = nil
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001664], (nil)[1] = nil, 9991400
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001664], (nil)[2] = nil, 9991410
	local config
	local cfg = config[activityID]
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001664 then
		local skin = activityCommonBubbleRead.getSkin(activityID)
		return cfg[skin]
	else
		return cfg
	end
end
return activityCommonBubbleRead
