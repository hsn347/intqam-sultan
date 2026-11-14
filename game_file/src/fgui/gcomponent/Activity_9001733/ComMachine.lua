local baseComponent = require("fgui.base.baseComponent")
local ComMachine = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001733/ComMachine", ComMachine)
function ComMachine:onInit()
	self.currentFactoryStage = nil
	self.movieClips, _UPVALUE0_, self.currentEffectIndex = nil, nil, nil
	self:initMovieClipFrames()
end
function ComMachine:onShow()
	if self.currentFactoryStage then
		self:playStageEffect(self.currentFactoryStage, true)
	end
end
function ComMachine:getEffectIndex(factoryStage)
	factoryStage = tonumber(factoryStage) or 0
	if factoryStage <= 0 then
		return 0
	end
	factoryStage = math.min(factoryStage, 9)
	return 4 - math.min(3, math.ceil(factoryStage / 3))
end
function ComMachine:stopStageEffects()
	for index = 1, 3 do
		local transition = self.transitions[tostring(index)]
		if transition then
			transition:stop()
		end
	end
	return self
end
function ComMachine:playStageEffect(factoryStage, forcePlay)
	local effectIndex = self:getEffectIndex(factoryStage)
	if effectIndex <= 0 then
		self.currentEffectIndex = effectIndex
		return self:stopStageEffects()
	end
	if not forcePlay and self.currentEffectIndex == effectIndex then
		return self
	end
	self:stopStageEffects()
	local transition = self.transitions[tostring(effectIndex)]
	if transition then
		transition:play(-1, 0, 0, -1)
	end
	self.currentEffectIndex = effectIndex
	return self
end
function ComMachine:initData(factoryStage)
	factoryStage = tonumber(factoryStage) or 0
	self.currentFactoryStage = factoryStage
	self.fields.pb:initData(factoryStage)
	self:playStageEffect(factoryStage)
end
function ComMachine:initMovieClipFrames()
	self.movieClips, _ENV = nil, nil
	for _, obj in ipairs(self:getChildren()) do
		local frameName, startValue = self:getMovieClipFrameData(obj)
		if frameName then
			table.insert(self.movieClips, obj)
			obj:setAllFrameName(frameName, startValue)
		end
	end
	return self
end
function ComMachine:getMovieClipFrameData(obj)
	local customData = obj:getCustomData()
	if type(customData) ~= "string" or customData == "" then
		return nil
	end
	local baseName = string.gsub(customData, "%.png$", "")
	local prefix, digits = string.match(baseName, "^(.-)(%d+)$")
	if not prefix or not digits then
		return nil
	end
	return string.format("%s%%0%dd.png", prefix, string.len(digits)), tonumber(digits) or 0
end
return ComMachine
