local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local checknumber = _G.checknumber
local RW_CAMP = _G.RW_CAMP
local remainsWarUIWidget = class("remainsWarUIWidget", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarUIWidget")
	end
	return target
end)
local SoraDConvertSecondToStringNoDayNoHour = function(second)
	local mNum = math.floor(second % 3600 / 60)
	if mNum < 10 then
		mNum = "0" .. mNum
	end
	local sNum = math.floor(second % 60)
	if sNum < 10 then
		sNum = "0" .. sNum
	end
	local hNum = math.floor(second / 3600)
	if hNum <= 0 then
		local text = mNum .. ":" .. sNum
		return text
	elseif hNum < 10 then
		hNum = "0" .. hNum
	end
	local text = hNum .. ":" .. mNum .. ":" .. sNum
	return text
end
function remainsWarUIWidget:ctor()
	self.northPoint = 0
	self.southPoint = 0
	self.maxPoints = 20000
	self.lab_points_south = SoraDGetChildByName(self, "Text_point_south")
	self.progress_south = SoraDGetChildByName(self, "LoadingBar_point_south")
	self.lab_points_north = SoraDGetChildByName(self, "Text_point_north")
	self.progress_north = SoraDGetChildByName(self, "LoadingBar_point_north")
	self.labProtectTime = SoraDGetChildByName(self, "Text_protect_time")
	self.labProtectTime = SoraDCreateTimerLabel(self, self.labProtectTime)
	self.labProtectTime:setTimeLast(function(str, tick)
		local reText = SoraDConvertSecondToStringNoDayNoHour(tick)
		return reText
	end)
	self.nodeTip = SoraDGetChildByName(self, "Node_tip")
	self.txtTime = SoraDGetChildByName(self, "Text_tip")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeLast(function(str, tick)
		_ENV = nil
		;(nil).time = str
		local reText = i18n("remains_text_83", nil)
		return reText
	end)
	self.txtTime:setTimeEndListener(function()
		self.nodeTip:setVisible(false)
	end)
	self:updateTeamStatus()
	self:updatePointData()
	self:updateStatus()
	self:updateMoveCityCDTime()
	self:initEffect()
end
function remainsWarUIWidget:initEffect()
	local remainsWarUtil = include("remainsWarUtil")
	self.nodeVS = SoraDGetChildByName(self, "Node_VS")
	remainsWarUtil.addVSEffect(self.nodeVS)
	self.spVSBG = SoraDGetChildByName(self, "Sprite_VS_BG")
	remainsWarUtil.addVSAnimation(self, self.spVSBG)
end
function remainsWarUIWidget:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_POINT_DATA", handler(self, self.updatePointData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.updateStatus))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_MOVECITYCDTIME", handler(self, self.updateMoveCityCDTime))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_CAMP_DATA", handler(self, self.updateTeamStatus))
end
function remainsWarUIWidget:updatePointData()
	local data = remainsWarCtrl:getRemainsWarPointData()
	dump(data, "getRemainsWarPointData")
	self.southPoint = checknumber(data[RW_CAMP.SOUTH_KEY])
	self.northPoint = checknumber(data[RW_CAMP.NORTH_KEY])
	local point_south = self.southPoint
	local point_north = self.northPoint
	self.lab_points_south:setString(tostring(point_south))
	self.progress_south:setPercent(point_south * 100 / self.maxPoints)
	self.lab_points_north:setString(tostring(point_north))
	self.progress_north:setPercent(point_north * 100 / self.maxPoints)
end
function remainsWarUIWidget:updateTeamStatus()
	local data = remainsWarCtrl:getRemainsWarCampData()
	dump(data, "getRemainsWarCampData")
	if not data[RW_CAMP.SOUTH_KEY] then
		remainsWarCtrl = data[RW_CAMP.SOUTH_KEY]
	end
	self.southData = data[RW_CAMP.SOUTH_KEY]
	if not data[RW_CAMP.NORTH_KEY] then
		remainsWarCtrl = data[RW_CAMP.NORTH_KEY]
	end
	self.northData = data[RW_CAMP.NORTH_KEY]
end
function remainsWarUIWidget:updateStatus()
	local warStatus = remainsWarCtrl:getWarStatus()
	print("warStatus=", warStatus)
	if warStatus and warStatus == gKingdomWarStatusType.inWar then
		self:setVisible(true)
	else
		self:setVisible(false)
	end
	self:updateStatusTime()
end
function remainsWarUIWidget:updateStatusTime()
	local warTime = remainsWarCtrl:getStatusTime()
	if 0 < warTime then
		self.labProtectTime:beginTime(warTime)
	end
end
function remainsWarUIWidget:updateMoveCityCDTime()
	local time = remainsWarCtrl:getMoveCityCDEndTime()
	if 0 < time then
		self.nodeTip:setVisible(true)
		self.txtTime:beginTime(time)
	else
		self.nodeTip:setVisible(false)
	end
end
function remainsWarUIWidget:updateTeamFlag(node, flag)
	if flag then
		if flag <= 0 then
			flag = 1
		end
		node:removeAllChildren()
		SoraDGetAllianceFlagByFid(flag):addTo(node)
	end
end
return remainsWarUIWidget
