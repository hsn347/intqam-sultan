local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local baseComponent = require("fgui.base.baseComponent")
local Com_lv = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001746/Com_lv", Com_lv)
local applyProgressState = function(self, level, value, maxValue, isMax)
	level = level or 0
	value = value or 0
	maxValue = maxValue or 0
	isMax = isMax == true
	self.fields.Label_lv:setString(level)
	self.fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	if isMax then
		self.fields.bar:setMax(1)
		self.fields.bar:setValue(1)
		self.fields.bar:getChild("title"):setString("MAX")
		return
	end
	maxValue = math.max(maxValue, 1)
	value = math.max(0, math.min(value, maxValue))
	self.fields.bar:setMax(maxValue)
	self.fields.bar:setValue(value)
end
function Com_lv:onInit()
	self.fields.Button_add:addClickListener(handler(self, self.onClick_Button_add))
	self.onAddHandler = nil
	self.progressHandle = nil
end
function Com_lv:onShow()
end
function Com_lv:stopProgressAnimation()
	if not self.progressHandle then
		return
	end
	schedulerTime.unscheduleGlobal(self.progressHandle)
	self.progressHandle = nil
end
function Com_lv:playProgressAnimation(fromLevel, fromValue, toLevel, toValue, maxValue)
	maxValue = math.max(maxValue or 0, 1)
	fromLevel = fromLevel or 0
	fromValue = math.max(0, math.min(fromValue or 0, maxValue))
	toLevel = toLevel or fromLevel
	toValue = math.max(0, math.min(toValue or 0, maxValue))
	if fromLevel > toLevel or toLevel == fromLevel and fromValue >= toValue then
		applyProgressState(self, toLevel, toValue, maxValue, false)
		return
	end
	_ENV, applyProgressState = self, applyProgressState
	self.level = fromLevel
	self.fromValue = fromValue
	self.toValue = fromLevel < toLevel and maxValue or toValue
	local applyProgressState[1], stageList = self, applyProgressState
	if fromLevel < toLevel and 0 < toValue then
		_ENV = toValue
		toValue.level = toLevel
		toValue.fromValue = 0
		toValue.toValue = toValue
		table.insert(stageList, toValue)
	end
	local stageIndex = 1
	local function playStage()
		local stage = stageList[stageIndex]
		if not stage then
			applyProgressState(self, toLevel, toValue, maxValue, false)
			return
		end
		local stageDelta = math.abs(stage.toValue - stage.fromValue)
		if stageDelta <= 0 then
			applyProgressState(self, stage.level, stage.toValue, maxValue, false)
			playStage()
			return
		end
		local elapsed = 0
		local duration = math.max(0.12, 0.28 * stageDelta / maxValue)
		applyProgressState(self, stage.level, stage.fromValue, maxValue, false)
		self.progressHandle = schedulerTime.scheduleGlobal(function(dt)
			local progress = math.min(elapsed / duration, 1)
			local value = stage.fromValue + (stage.toValue - stage.fromValue) * progress
			applyProgressState(self, stage.level, math.floor(value + 0.5), maxValue, false)
			if 1 <= progress then
				self:stopProgressAnimation()
				playStage()
			end
		end, 0.02)
	end
	playStage()
end
function Com_lv:initData(params)
	if not params then
		params, applyProgressState = nil, nil
	end
	self.onAddHandler = params.onAdd
	local level = params.level or 0
	local value = params.value or 0
	local maxValue = params.max or 0
	local isMax = params.isMax == true
	local fromLevel = params.fromLevel
	local fromValue = params.fromValue
	local shouldAnimate = params.animate == true and fromLevel ~= nil and fromValue ~= nil and not isMax
	self:stopProgressAnimation()
	if shouldAnimate then
		self:playProgressAnimation(fromLevel, fromValue, level, value, maxValue)
	else
		applyProgressState(self, level, value, maxValue, isMax)
	end
	self.fields.Button_add:setVisible(self.onAddHandler ~= nil)
	self.fields.Button_add:setEnabled(self.onAddHandler ~= nil)
end
function Com_lv:onHide()
	self:stopProgressAnimation()
end
function Com_lv:onClick_Button_add(context)
	SoraDPlaySound()
	if self.onAddHandler then
		self.onAddHandler()
	end
end
return Com_lv
