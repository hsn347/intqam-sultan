local ltBase = include("ltBase")
local mobilizationltCtrl = class("mobilizationltCtrl", ltBase, include("aAReadClass").new())
function mobilizationltCtrl:ctor()
	mobilizationltCtrl.super.ctor(self)
end
local isInited = false
local init = function()
	if isInited then
		return
	end
	mobilizationltCtrl:init()
end
function mobilizationltCtrl:init()
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_mobilize_stage_award"
	;(nil)[2] = true
	self:defineValue("stageaward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_mobilize_task_data"
	;(nil)[2] = true
	self:defineValue("taskdata", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_mobilize_rank_award"
	;(nil)[2] = true
	self:defineValue("rankaward", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "alliance_mobilize_describe"
	self:defineValue("describestb", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "alliance_mobilize_effect"
	self:defineValue("rewardEffect", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_mobilize_task_reset"
	;(nil)[2] = true
	self:defineValue("resetTb", nil)
	self:defineValue("mobilizationCfgTb", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).name = "common_text_3611"
		_UPVALUE0_, (nil)[1], (nil).icon = nil, nil, "icon_alliance_mobilization_lv01.png"
		;(nil).name = "common_text_3612"
		_UPVALUE0_, (nil)[2], (nil).icon = nil, nil, "icon_alliance_mobilization_lv02.png"
		;(nil).name = "common_text_3613"
		_UPVALUE0_, (nil)[3], (nil).icon = nil, nil, "icon_alliance_mobilization_lv03.png"
		;(nil).name = "common_text_3614"
		;(nil)[4], (nil).icon = nil, "icon_alliance_mobilization_lv04.png"
		return nil
	end)
end
init()
function mobilizationltCtrl:getStageAward()
	return self.stageaward
end
function mobilizationltCtrl:getTaskData()
	return self.taskdata
end
function mobilizationltCtrl:getStagesAwardByLv(matchlev)
	local _ENV, stageTB
	for k, v in ipairs(self.stageaward) do
		if v.matchlev == matchlev then
			table.insert(stageTB, v)
		end
	end
	return stageTB
end
function mobilizationltCtrl:translateStageAward()
	self.stageawardTrans, _ENV = nil, nil
	for k, v in pairs(self.stageaward) do
		if not self.stageawardTrans[v.matchlev] then
			_ENV = self.stageawardTrans[v.matchlev]
		end
		self.stageawardTrans[v.matchlev] = self.stageawardTrans[v.matchlev]
		self.stageawardTrans[v.matchlev][v.stage] = v
	end
end
function mobilizationltCtrl:getStageAwardInfo(matchlev, stage)
	if not self.stageawardTrans then
		self:translateStageAward()
	end
	if self.stageawardTrans[matchlev] and self.stageawardTrans[matchlev][stage] then
		return self.stageawardTrans[matchlev][stage]
	else
		return nil
	end
end
function mobilizationltCtrl:getTaskInfo(tasktypeid)
	for k, v in pairs(self.taskdata) do
		if v.tasktype == tasktypeid then
			return v
		end
	end
	_ENV = (for generator)
	return pairs(self.taskdata)
end
function mobilizationltCtrl:getRankAward()
	return self.rankaward
end
function mobilizationltCtrl:getAllianceRankAwardByLv(matchlev)
	local _ENV, rankTab
	for k, v in ipairs(self.rankaward) do
		if v.match_lev == matchlev then
			if v.rank[1] == v.rank[2] then
				local _ENV, data = v.rank[1], v.rank[1]
				data.rank = v.rank[1]
				data.reward = v.reward
				table.insert(rankTab, data)
			else
				for r = v.rank[1], v.rank[2] do
					local _ENV, data
					data.rank = r
					data.reward = v.reward
					table.insert(rankTab, data)
				end
			end
		end
	end
	return rankTab
end
function mobilizationltCtrl:getMobilizationNameByLv(lv)
	if lv > #self.mobilizationCfgTb then
		lv = #self.mobilizationCfgTb
	end
	local cfg = self.mobilizationCfgTb[lv]
	if cfg then
		return cfg.name
	else
		return self.mobilizationCfgTb[1].name
	end
end
function mobilizationltCtrl:getMobilizationIconByLv(lv)
	if lv > #self.mobilizationCfgTb then
		lv = #self.mobilizationCfgTb
	end
	local cfg = self.mobilizationCfgTb[lv]
	if cfg then
		return cfg.icon
	else
		return self.mobilizationCfgTb[1].icon
	end
end
function mobilizationltCtrl:getTaskName(tasktypeid)
	if self.describestb[tasktypeid] then
		return self.describestb[tasktypeid].name
	end
end
function mobilizationltCtrl:getTaskIcon(tasktypeid)
	if self.describestb[tasktypeid] then
		return self.describestb[tasktypeid].image or "NA.png"
	end
end
function mobilizationltCtrl:getTaskTurn(tasktypeid)
	if self.describestb[tasktypeid] then
		return self.describestb[tasktypeid].isTurn or "1"
	end
end
function mobilizationltCtrl:getTaskDes(tasktypeid)
	if self.describestb[tasktypeid] then
		return self.describestb[tasktypeid].describe or "NA"
	end
end
function mobilizationltCtrl:getTaskTarget(tasktypeid)
	if self.describestb[tasktypeid] then
		return self.describestb[tasktypeid].describe.num
	end
end
function mobilizationltCtrl:getTaskTargetLV(tasktypeid)
	if self.describestb[tasktypeid] then
		return self.describestb[tasktypeid].describe.lv
	end
end
function mobilizationltCtrl:getTaskCfg(tasktypeid)
	return self.describestb[tasktypeid]
end
function mobilizationltCtrl:getCurrentStageMax(current, matchlev)
	local curMaxStage = 0
	local curMaxScore = 0
	local maxStage = 0
	local maxScore = 0
	local bFind = false
	for i, v in ipairs(self.stageaward) do
		if v.matchlev == matchlev then
			if maxStage < v.stage then
				maxStage = v.stage
			end
			if maxScore < v.needscore then
				maxScore = v.needscore
			end
			if current < v.needscore then
				bFind = true
				if curMaxStage < v.stage then
					curMaxStage = v.stage
				end
				if curMaxScore < v.needscore then
					curMaxScore = v.needscore
				end
				break
			end
		end
	end
	if bFind then
		return curMaxStage, curMaxScore, false
	else
		return maxStage, maxScore, true
	end
end
function mobilizationltCtrl:getPrevStageMax(current, matchlev)
	local currentStage, currentStageMax = self:getCurrentStageMax(current, matchlev)
	if currentStage == 1 then
		return 0, 0
	else
		local stageInfo = self:getStageAwardInfo(matchlev, currentStage - 1)
		if stageInfo then
			return stageInfo.stage, stageInfo.needscore
		else
			return 0, 0
		end
	end
end
function mobilizationltCtrl:getCurrentStagePercent(current, matchlev)
	local currentStage, currentStageMax = self:getCurrentStageMax(current, matchlev)
	local prevStage, prevStageMax = self:getPrevStageMax(current, matchlev)
	return math.floor((current - prevStageMax) / (currentStageMax - prevStageMax) * 100), current - prevStageMax, currentStageMax - prevStageMax
end
function mobilizationltCtrl:getNeedPointToNextStage(current, matchlev)
	local needPoint = 0
	local stage, point = self:getCurrentStageMax(current, matchlev)
	needPoint = point - current
end
function mobilizationltCtrl:getActivitStage(score, matchlev)
	score = score or 0
	local retStage = 0
	for k, v in pairs(self.stageaward) do
		if v.matchlev == matchlev and score >= v.needscore and retStage < v.stage then
			retStage = v.stage
		end
	end
	return retStage
end
function mobilizationltCtrl:getGuideId(tasktypeid)
	if self.describestb[tasktypeid] then
		return self.describestb[tasktypeid].guideId
	else
	end
end
function mobilizationltCtrl:isNeedShowGood(itemid)
	if self.rewardEffect[itemid] then
		return true
	end
	return false
end
function mobilizationltCtrl:getResetGold(matchlv, times)
	local gold = 0
	for k, v in ipairs(self.resetTb) do
		if v.matchlev == matchlv and times >= v.num[1] and times <= v.num[2] then
			gold = v.coin[2]
			break
		end
	end
	return gold
end
return mobilizationltCtrl
