local gametop = gModuleMgr.getObject("gametop")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local WorldMapLegendLordProgressBar = class("worldMapLegendLordProgressBar", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapLegendLordProgressBar")
	end
	return target
end)
function WorldMapLegendLordProgressBar:ctor()
	self.timeData, _ENV, self.fadeFlag = nil, nil, true
	self.progressBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtTime = SoraDGetChildByName(self, "Text_num")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.buildID = 0
	self.maxOccupyTime = 21600
	self.txtTime:setTimeLast(function(str, tick)
		local curtick = self.maxOccupyTime - tick
		if curtick < 0 then
			curtick = 0
		end
		local percent = curtick / self.maxOccupyTime * 100
		self.progressBar:setPercent(percent)
		return SoraDConvertSecondToString(curtick)
	end)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
	end)
end
function WorldMapLegendLordProgressBar:setBuildID(bID)
	self.buildID = bID
	self.maxOccupyTime = legendLordWarCtrl:getLegendOccupyMaxTime(self.buildID)
end
function WorldMapLegendLordProgressBar:beginTime(time)
	local remainTime = self.maxOccupyTime - time
	self:setVisible(true)
	self.txtTime:beginTime(remainTime)
end
function WorldMapLegendLordProgressBar:endTime()
	self.txtTime:endTime()
	self:setVisible(false)
end
return WorldMapLegendLordProgressBar
