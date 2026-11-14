local ramadanSurpriseltCtrl = include("ramadanSurpriseltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_progressBar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanSurprise/Com_progressBar", Com_progressBar)
function Com_progressBar:onInit()
	local count = ramadanSurpriseltCtrl.getSelectRewardGradeCount()
	ramadanSurpriseltCtrl = nil
	;(nil)[1] = 0
	;(nil)[2] = 0.13
	;(nil)[3] = 0.35
	;(nil)[4] = 0.6
	;(nil)[5] = 0.8
	self.lastStep, (nil)[6] = nil, 1
	self:fixChildrenPos()
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
	local curlevel = ramadanSurpriseltCtrl:getCurScoreLevel(curValue)
	local leftNum = ramadanSurpriseltCtrl.getLeftNum(curValue, curlevel)
	local curLevelNum = ramadanSurpriseltCtrl.getLevelNum(curlevel)
	local nextLevelNum = ramadanSurpriseltCtrl.getLevelNum(curlevel + 1)
	local per = self.lastStep[curlevel + 1] + leftNum / (nextLevelNum - curLevelNum) * (self.lastStep[curlevel + 2] - self.lastStep[curlevel + 1])
	self.fields.bar:setWidth(self.fields.line:getWidth() * (1 - per))
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
function Com_progressBar:onShow()
end
return Com_progressBar
