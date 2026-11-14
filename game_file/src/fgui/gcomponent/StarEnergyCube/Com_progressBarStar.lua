local starEnergyCubeRead = include("starEnergyCubeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_progressBarStar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_progressBarStar", Com_progressBarStar)
function Com_progressBarStar:onInit()
	_UPVALUE0_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 0.1
	;(nil)[3] = 0.31
	;(nil)[4] = 0.55
	;(nil)[5] = 0.77
	self.reach, (nil)[6] = nil, 1
end
function Com_progressBarStar:setValue(curValue, needValue)
	if curValue == 0 then
		self.fields.bar:setHeight(self.fields.bg:getHeight())
		return
	end
	if needValue <= curValue then
		self.fields.bar:setHeight(0)
		return
	end
	local curlevel = starEnergyCubeRead:getCurScoreLevel(curValue)
	local leftNum = starEnergyCubeRead.getLeftNum(curValue, curlevel)
	local curLevelNum = starEnergyCubeRead.getLevelNum(curlevel)
	local nextLevelNum = starEnergyCubeRead.getLevelNum(curlevel + 1)
	_UPVALUE4_ = self.fields.bg:getHeight()
	self.fields.bg:getHeight()[1] = curlevel
	self.fields.bg:getHeight()[2] = leftNum
	self.fields.bg:getHeight()[3] = curLevelNum
	self.fields.bg:getHeight()[4] = nextLevelNum
	dump(self.fields.bg:getHeight())
	local per = self.reach[curlevel + 1] + leftNum / (nextLevelNum - curLevelNum) * (self.reach[curlevel + 2] - self.reach[curlevel + 1])
	dump(per, "fjkdsjfkdjfkjdk")
	self.fields.bar:setHeight(self.fields.bg:getHeight() * (1 - per))
end
function Com_progressBarStar:setReachPointPos(per)
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Com_reach:setPositionX(self:getWidth() * per - 5)
	else
		self.fields.Com_reach:setPositionX(self:getWidth() - (self:getWidth() * per + 7))
	end
end
function Com_progressBarStar:getCurScoreLevel(curScore)
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
return Com_progressBarStarcom_pro
