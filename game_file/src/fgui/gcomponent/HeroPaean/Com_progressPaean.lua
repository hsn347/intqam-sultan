local heroPaeanCtrl = SoraDGetCtrl("heroPaeanCtrl")
local heroPaeanRead = include("heroPaeanRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_progressPaean = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroPaean/Com_progressPaean", Com_progressPaean)
function Com_progressPaean:onInit()
	_UPVALUE0_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 0.15
	;(nil)[3] = 0.35
	;(nil)[4] = 0.58
	;(nil)[5] = 0.8
	self.lastStep, (nil)[6] = nil, 1
	self:fixChildrenPos()
	self.fields.bar:fix(false)
	self.fields.nl:fix(false)
	self.fields.nr:fix(false)
end
function Com_progressPaean:setValue(curValue, needValue)
	if curValue == 0 then
		self.fields.bar:setWidth(self.fields.line:getWidth())
		return
	end
	if needValue <= curValue then
		self.fields.bar:setWidth(0)
		return
	end
	local curlevel = heroPaeanRead:getCurScoreLevel(curValue)
	local leftNum = heroPaeanRead.getLeftNum(curValue, curlevel)
	local curLevelNum = heroPaeanRead.getLevelNum(curlevel)
	local nextLevelNum = heroPaeanRead.getLevelNum(curlevel + 1)
	local per = self.lastStep[curlevel + 1] + leftNum / (nextLevelNum - curLevelNum) * (self.lastStep[curlevel + 2] - self.lastStep[curlevel + 1])
	self.fields.bar:setWidth(self.fields.line:getWidth() * (1 - per))
end
function Com_progressPaean:setReachPointPos(per)
end
function Com_progressPaean:getCurScoreLevel(curScore)
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
return Com_progressPaean
