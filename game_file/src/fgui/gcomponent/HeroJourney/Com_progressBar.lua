local heroJourneyRead = include("heroJourneyRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_progressBar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroJourney/Com_progressBar", Com_progressBar)
function Com_progressBar:onInit()
	_UPVALUE0_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 0.1
	;(nil)[3] = 0.3
	;(nil)[4] = 0.5
	;(nil)[5] = 0.7
	self.lastStep, (nil)[6] = nil, 1
	self:fixChildrenPos()
	self.fields.bar:fix(false)
	self.fields.bg:fix(false)
end
function Com_progressBar:setValue(curValue, needValue)
	self.fields.bar:setFillAmount(curValue / needValue)
	if curValue == 0 then
		self.fields.bar:setFillAmount(0)
		return
	end
	if needValue <= curValue then
		self.fields.bar:setFillAmount(1)
		return
	end
	local curlevel = heroJourneyRead:getCurScoreLevel(curValue)
	local leftNum = heroJourneyRead.getLeftNum(curValue, curlevel)
	local curLevelNum = heroJourneyRead.getLevelNum(curlevel)
	local nextLevelNum = heroJourneyRead.getLevelNum(curlevel + 1)
	local per = self.lastStep[curlevel + 1] + leftNum / (nextLevelNum - curLevelNum) * (self.lastStep[curlevel + 2] - self.lastStep[curlevel + 1])
	self.fields.bar:setFillAmount(per)
	self:setReachPointPos(per)
end
function Com_progressBar:setReachPointPos(per)
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Com_reach:setPositionX(self:getWidth() * per - 5)
	else
		self.fields.Com_reach:setPositionX(self:getWidth() - (self:getWidth() * per + 7))
	end
end
function Com_progressBar:getCurScoreLevel(curScore)
	local curlevel = 0
	for i, v in ipairs(ramadanSurpriseltCtrl.ramadan_surprise_reward) do
		if curScore >= v.integral then
			curlevel = curlevel + 1
		else
			break
		end
	end
	return curlevel
end
return Com_progressBar
