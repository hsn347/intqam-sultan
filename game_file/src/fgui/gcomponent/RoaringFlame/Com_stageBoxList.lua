local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_stageBoxList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_stageBoxList", Com_stageBoxList)
function Com_stageBoxList:onInit()
	self.stageCfg = roaringFlameWarRead.getWarTimeCfg()
	self.stageNum = #self.stageCfg + 1
	self.stagePercent = 100 / #self.stageCfg
	self.Label_time = self.fields.Label_time:getChild("Label_time")
	self.fields.Bar:hideTitle()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_stageBoxList:onShow()
end
function Com_stageBoxList:onItemRenderer(index, obj)
	obj:initData(index)
end
function Com_stageBoxList:initData()
	local _ENV, stageList
	local curTime = serviceFunctions.systemTime()
	local warBeginTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	for i = 1, self.stageNum do
		if i == 1 then
			stageList[i] = warBeginTime
		else
			local cfg = roaringFlameWarRead.getWarTimeCfg(i - 1)
			stageList[i] = cfg.offset_time + warBeginTime
		end
	end
	self.fields.List:setNumItems(self.stageNum)
	local nextStageTime = stageList[2]
	local nextStageIndex = 2
	for k = 2, #stageList do
		if curTime < stageList[k] then
			nextStageTime = stageList[k]
			nextStageIndex = k
			break
		end
	end
	local tmp = nextStageTime - stageList[nextStageIndex - 1]
	self.Label_time:setTimeUpdateListener(function(time)
		local value = (nextStageIndex - 2) * self.stagePercent + math.max(tmp - time, 0) * self.stagePercent / tmp
		self.fields.Bar:setValue(value)
		self.fields.Label_time:setPositionX(SoraDFPosX(580 - value * 520 / 100, 640))
	end)
	self.Label_time:setTimeEndListener(function()
		self:initData()
	end)
	local leftTime = nextStageTime - curTime
	self.Label_time:beginTime(leftTime)
end
return Com_stageBoxList
