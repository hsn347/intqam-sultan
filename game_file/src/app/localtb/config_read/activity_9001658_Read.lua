local activity_9001658_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "bubble_legend_story"
;(nil)[2] = false
activity_9001658_Read:defineValue("bubble_legend_story", nil)
activity_9001658_Read:defineValue("storyConfig", function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)
function activity_9001658_Read.getStoryConfig(storyID)
	return activity_9001658_Read.storyConfig[storyID]
end
function _UPVALUE2_()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)[1] = "bubble_legend_character"
;(function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)[2] = false
activity_9001658_Read:defineValue("bubble_legend_character", function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)
function activity_9001658_Read.getCharacterName(characterID)
	local cfg = activity_9001658_Read.bubble_legend_character[characterID]
	return i18n(cfg.Name)
end
function activity_9001658_Read.getCharacterBust(characterID)
	local cfg = activity_9001658_Read.bubble_legend_character[characterID]
	return cfg.Bust
end
function activity_9001658_Read.getCharacterSmallBust(characterID)
	local cfg = activity_9001658_Read.bubble_legend_character[characterID]
	return cfg.smallBust
end
function _UPVALUE2_()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)[1] = "bubble_legend_schedule_relation"
;(function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)[2] = false
activity_9001658_Read:defineValue("bubble_legend_schedule_relation", function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)
function activity_9001658_Read.getChapterMax(...)
	return #activity_9001658_Read.bubble_legend_schedule_relation
end
function activity_9001658_Read.getChapterConfig(chapter)
	return activity_9001658_Read.bubble_legend_schedule_relation[chapter]
end
function activity_9001658_Read.getChapterName(chapter)
	local cfg = activity_9001658_Read.getChapterConfig(chapter)
	return cfg and i18n(cfg.chapterName)
end
function activity_9001658_Read.getChapterIcon(chapter)
	local cfg = activity_9001658_Read.getChapterConfig(chapter)
	return cfg and cfg.chapterIcon
end
function _UPVALUE2_()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)[1] = "bubble_legend_schedule"
;(function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)[2] = true
activity_9001658_Read:defineValue("bubble_legend_schedule", function()
	local _ENV, ret
	for i, v in ipairs(activity_9001658_Read.bubble_legend_story) do
		if not ret[v.storyID] then
			_ENV = ret[v.storyID]
		end
		ret[v.storyID] = ret[v.storyID]
		table.insert(ret[v.storyID], v)
	end
	return ret
end)
function activity_9001658_Read.getStageConfig(stage)
	return activity_9001658_Read.bubble_legend_schedule[stage]
end
function activity_9001658_Read.getStageTime(stage)
	local cfg = activity_9001658_Read.getStageConfig(stage)
	return cfg.time
end
function activity_9001658_Read.getStageActivityID(stage)
	local cfg = activity_9001658_Read.getStageConfig(stage)
	return cfg.activityID
end
function activity_9001658_Read.getStageSignName(stage)
	local cfg = activity_9001658_Read.getStageConfig(stage)
	return i18n(cfg.signName)
end
function activity_9001658_Read.getCurStage(...)
	local stageMax = activity_9001658_Read.getStageMax()
	for stage = stageMax, 1, -1 do
		local activityID = activity_9001658_Read.getStageActivityID(stage)
		if clientEventMgr.judgeIsOpen(activityID) then
			return stage
		end
	end
	return 1
end
function activity_9001658_Read.getStageMax(...)
	return #activity_9001658_Read.bubble_legend_schedule
end
function activity_9001658_Read.getRandomHeroChat(stage)
	local cfg = activity_9001658_Read.getStageConfig(stage)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "rate"
	local heroLine = serviceFunctions.tableFormat(cfg.heroLine, nil)
	local ret = serviceFunctions.getRandomReward(heroLine)
	return ret and ret.id or 1
end
function activity_9001658_Read.getRandomMonsterChat(stage)
	local cfg = activity_9001658_Read.getStageConfig(stage)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "rate"
	local monsterLine = serviceFunctions.tableFormat(cfg.monsterLine, nil)
	local ret = serviceFunctions.getRandomReward(monsterLine)
	return ret and ret.id or 1
end
activity_9001658_Read:defineValue("activityID2stage", function()
	local _ENV, ret
	for __, cfg in ipairs(activity_9001658_Read.bubble_legend_schedule) do
		ret[cfg.activityID] = cfg.stage
	end
	return ret
end)
function activity_9001658_Read.IsBubbleLegendActivity(activityID)
	local stage = activity_9001658_Read.getActivityIDStage(activityID)
	return stage ~= nil
end
function activity_9001658_Read.getActivityIDStage(activityID)
	return activity_9001658_Read.activityID2stage[activityID]
end
function _UPVALUE2_()
	local _ENV, ret
	for __, cfg in ipairs(activity_9001658_Read.bubble_legend_schedule) do
		ret[cfg.activityID] = cfg.stage
	end
	return ret
end
;(function()
	local _ENV, ret
	for __, cfg in ipairs(activity_9001658_Read.bubble_legend_schedule) do
		ret[cfg.activityID] = cfg.stage
	end
	return ret
end)[1] = "bubble_legend_text"
;(function()
	local _ENV, ret
	for __, cfg in ipairs(activity_9001658_Read.bubble_legend_schedule) do
		ret[cfg.activityID] = cfg.stage
	end
	return ret
end)[2] = false
activity_9001658_Read:defineValue("bubble_legend_text", function()
	local _ENV, ret
	for __, cfg in ipairs(activity_9001658_Read.bubble_legend_schedule) do
		ret[cfg.activityID] = cfg.stage
	end
	return ret
end)
function activity_9001658_Read.getChatWord(index)
	local cfg = activity_9001658_Read.bubble_legend_text[index]
	return i18n(cfg.textKey)
end
return activity_9001658_Read
