local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_warInfosingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWorldMap/Com_warInfosingle", Com_warInfosingle)
function Com_warInfosingle:onInit()
	self.fields.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	self.fields.Text_time:setTimeUpdateListener(function(timeNumber)
		self.fields.bar:setValue(timeNumber)
		self.occupyTime = timeNumber
	end)
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.bar:getChild("bar"):fixPos()
	end
end
function Com_warInfosingle:onShow()
end
function Com_warInfosingle:initCamp(camp)
	self.camp = camp
	local campName = roaringFlameWarRead.getCampName(camp)
	self.fields.Text_name:setString(campName)
	local campColor = roaringFlameWarRead.getCampColor(camp)
	self.fields.Text_name:setColor(campColor)
	local maxTime = roaringFlameWarUtil.getWarStateDuration()
	self.fields.bar:setMax(maxTime)
	local barImage = roaringFlameWarRead.getCampWarInfoBarImage(camp)
	self.fields.bar:getChild("bar"):setURL(barImage)
end
function Com_warInfosingle:updateOccupyTime(...)
	local occupyTime = roaringFlameWarCtrl:getOccupyPalaceSecs(self.camp)
	local owner = roaringFlameWarUtil.getPalaceOwner()
	if owner and owner.camp == self.camp then
		local time = serviceFunctions.systemTime() - owner.beginOccupyTime
		occupyTime = occupyTime + math.max(0, time)
		self.fields.Text_time:beginTime(occupyTime, true)
	else
		self.fields.Text_time:endTime()
		self.fields.Text_time:updateLabel(occupyTime)
		self.fields.bar:setValue(occupyTime)
	end
	self.occupyTime = occupyTime
end
function Com_warInfosingle:getCamp(...)
	return self.camp
end
function Com_warInfosingle:getOccupyTime(...)
	return self.occupyTime or 0
end
return Com_warInfosingle
