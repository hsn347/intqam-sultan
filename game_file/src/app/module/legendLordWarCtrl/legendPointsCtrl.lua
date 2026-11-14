local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local legendPointsCtrl = class("legendPointsCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function legendPointsCtrl:ctor(properties)
	legendPointsCtrl.super.ctor(self, properties)
	self:resetData()
end
function legendPointsCtrl:EnterGame()
	self:registerNotify()
end
function legendPointsCtrl:Logout()
	legendPointsCtrl.super.Logout(self)
	self:resetData()
end
function legendPointsCtrl:resetData()
	self.legendPoints = 0
	self.hegemonPoints = 0
end
function legendPointsCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LEGEND_POINTS, handler(self, self.notifyHandler))
end
function legendPointsCtrl:notifyHandler(event)
	dump(event.data, "legendPointsCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.legendPoints = v.data.legendLord and math.floor(v.data.legendLord.points) or 0
		self.hegemonPoints = v.data.legendHegemon and math.floor(v.data.legendHegemon.points) or 0
		self.kingStarPoints = v.data.legendLordForSep and math.floor(v.data.legendLordForSep.points) or 0
		self.kingStarPoints1 = v.data["9001646"] and math.floor(v.data["9001646"].points) or 0
		self.kingStarPoints2 = v.data["9001647"] and math.floor(v.data["9001647"].points) or 0
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH"
	SoraDSendMessage(ipairs(event.data))
end
function legendPointsCtrl:initClientData(retdata)
	dump(retdata, "legendLordCtrl:initClientData", 10)
	if not retdata then
		return
	end
	self.legendPoints = retdata.legendLord and math.floor(retdata.legendLord.points) or 0
	self.kingStarPoints = retdata.legendLordForSep and math.floor(retdata.legendLordForSep.points) or 0
	self.hegemonPoints = retdata.legendHegemon and math.floor(retdata.legendHegemon.points) or 0
	self.kingStarPoints1 = retdata["9001646"] and math.floor(retdata["9001646"].points) or 0
	self.kingStarPoints2 = retdata["9001647"] and math.floor(retdata["9001647"].points) or 0
end
function legendPointsCtrl:getLegenPoint()
	return self.legendPoints
end
function legendPointsCtrl:getKingStarPoint(activityID)
	if activityID == gActivityTimeActivityID.LEGEND_LORD_9001646 then
		return self.kingStarPoints1
	end
	if activityID == gActivityTimeActivityID.LEGEND_LORD_9001647 then
		return self.kingStarPoints2
	end
	return self.kingStarPoints
end
function legendPointsCtrl:getHegemonPoint()
	return self.hegemonPoints
end
return legendPointsCtrl
