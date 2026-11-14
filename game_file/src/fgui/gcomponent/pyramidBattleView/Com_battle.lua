local pyramidBuildingRead = include("pyramidBuildingRead")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_battle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://pyramidBattleView/Com_battle", Com_battle)
function Com_battle:onInit()
	self.fields.Text_red:setString(i18n("common_text_3220"))
	self.fields.Text_blue:setString(i18n("common_text_3221"))
	self.fields.ani_blue:setAllFrameName("dh_xmdk_lanse_%02d.png", 1)
	self.fields.ani_blue:setPlaySettings(0, -1, -1)
	self.fields.ani_red:setAllFrameName("dh_xmdk_hongse_%02d.png", 1)
	self.fields.ani_red:setPlaySettings(0, -1, -1)
	local cfgN = pyramidBuildingRead.getBuildConfigS(135)
	self.posN = cc.p(cfgN.x, cfgN.y)
	local cfgS = pyramidBuildingRead.getBuildConfigS(136)
	self.posS = cc.p(cfgS.x, cfgS.y)
	self.disTance = self:getDistance(self.posN, self.posS)
	self.deg = math.rad(math.deg(math.atan(self.posN.x / self.posS.y)))
	self.speed = constantRead.getConstValue("ALLIANCEWAR_CARRIAGE_SPEED", 300)
	self.fields.Label_time:setTimeUpdateListener(handler(self, self.updateBar))
	self.fields.Label_time:setTimeEndListener(function()
		self:setVisible(false)
	end)
end
function Com_battle:onShow()
end
function Com_battle:updateBar(time)
	local tDistance = self.moveSpeed * (self.totalTime - time)
	local tX = tDistance * math.cos(self.deg)
	local tY = -tDistance * math.sin(self.deg)
	local curPN = math.min(1, self:getDistance(cc.p(self.beginPos.x + self.dir * tX, self.beginPos.y + self.dir * tY), self.posN) / self.disTance)
	local showPN = SoraDPreciseDecimal(curPN, 4)
	self.fields.Text_score_blue:setString(showPN * 100 .. "%")
	self.fields.Text_score_red:setString((1 - showPN) * 100 .. "%")
	self.fields.progress:initData(showPN)
end
function Com_battle:initData(queueData)
	self.queueData = queueData
	self.beginPos = cc.p(self.queueData.from.x, self.queueData.from.y)
	self.toCampType = self.queueData.toTeamId
	self.dir = self.toCampType == gAllianceWarCampType.blue and 1 or -1
	self.tDis = self:getDistance(self.beginPos, self.toCampType == gAllianceWarCampType.blue and self.posN or self.posS)
	local startTime = queueData.statusStartTime
	local endTime = self.queueData.statusEndTime
	local curTime = serviceFunctions.systemTime()
	self.totalTime = endTime - startTime
	self.moveSpeed = self.disTance * 2 / self.speed
	local leftTime = endTime - curTime
	if 0 < leftTime then
		self.fields.Label_time:beginTime(leftTime)
	else
		self.fields.progress:initData(0.5)
	end
end
function Com_battle:getDistance(p1, p2)
	return math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
end
return Com_battle
