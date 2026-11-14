local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local ramadanAccuRechargeltCtrl = include("ramadanAccuRechargeltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_progressBar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarryNightJourney/Com_progressBar", Com_progressBar)
function Com_progressBar:onInit()
	activityShowCtrl = nil
	;(nil)[1] = 0
	;(nil)[2] = 0.12
	;(nil)[3] = 0.33
	;(nil)[4] = 0.53
	;(nil)[5] = 0.75
	self.lastStep, (nil)[6] = nil, 1
	self:fixChildrenPos()
	self.fields.nl:fix(false)
	self.fields.nr:fix(false)
	self.classType = activityShowCtrl:getParamByID(gActivityTimeActivityID.STARRY_NIGHT_JOURNEY).classtype
	self.configs = ramadanAccuRechargeltCtrl.getStarryNightJourneyReward(self.classType)
end
function Com_progressBar:setValue(curValue, needValue)
	if curValue == 0 then
		self.fields.bar:setWidth(self.fields.line:getWidth())
		return
	end
	if needValue <= curValue then
		self.fields.bar:setWidth(0)
		return
	end
	local curlevel = self:getCurScoreLevel(curValue)
	local leftNum = self:getLeftNum(curValue, curlevel)
	local curLevelNum = self:getLevelNum(curlevel)
	local nextLevelNum = self:getLevelNum(curlevel + 1)
	local per = self.lastStep[curlevel + 1] + leftNum / (nextLevelNum - curLevelNum) * (self.lastStep[curlevel + 2] - self.lastStep[curlevel + 1])
	self.fields.bar:setWidth(self.fields.line:getWidth() * (1 - per))
end
function Com_progressBar:getCurScoreLevel(curScore)
	local curlevel = 0
	for i, v in ipairs(self.configs) do
		if curScore >= v.score then
			curlevel = curlevel + 1
		else
			break
		end
	end
	return curlevel
end
function Com_progressBar:getLeftNum(curValue, curLevel)
	if 0 < curLevel then
		return curValue - self.configs[curLevel].score
	else
		return curValue
	end
end
function Com_progressBar:getLevelNum(level)
	if 0 < level then
		return self.configs[level].score
	else
		return 0
	end
end
function Com_progressBar:onShow()
end
return Com_progressBar
