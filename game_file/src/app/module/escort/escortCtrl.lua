local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local escortDataMgr = include("escortDataMgr")
local escortCtrl = class("escortCtrl", GameModule)
function escortCtrl:ctor(properties)
	escortCtrl.super.ctor(self, properties)
end
function escortCtrl:EnterGame()
	escortCtrl.super.EnterGame(self)
	self.dataMgr = escortDataMgr.new()
	msgCtrl.register(gCmd.CMD_ESCORT_MODULE, gCmd.REQ_ESCORT_GET_ROB_RECOMMEND, handler(self, self.onRspGetRobRecommend))
	msgCtrl.register(gCmd.CMD_ESCORT_MODULE, gCmd.REQ_ESCORT_GET_CLOSEST_BUILD, handler(self, self.onRspGetClosestBuild))
	self:reqUpdateData()
end
function escortCtrl:Logout()
	escortCtrl.super.Logout(self)
	self.dataMgr = nil
end
function escortCtrl:initClientData(data)
	if not data then
		return
	end
	self.dataMgr.closestBuild = data.closestBuild
	self.dataMgr.escortCount = data.escortCount
	self.dataMgr.assistCount = data.assistCount
	self.dataMgr.robCount = data.robCount
	self.dataMgr.t = data.t
	self.dataMgr.ESCORT_CITYLEVEL_MIN = data.ESCORT_CITYLEVEL_MIN
	self.dataMgr.ESCORT_DAY_MAX = data.ESCORT_DAY_MAX
	self.dataMgr.ESCORT_ASSIST_DAY_MAX = data.ESCORT_ASSIST_DAY_MAX
	self.dataMgr.ESCORT_ROB_DAY_MAX = data.ESCORT_ROB_DAY_MAX
	self.dataMgr.ESCORT_ALLOW_ROBBED_ONCE_MAX = data.ESCORT_ALLOW_ROBBED_ONCE_MAX
end
function escortCtrl:reqGetRobRecommend(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ESCORT_MODULE, gCmd.REQ_ESCORT_GET_ROB_RECOMMEND, nil, ...)
end
function escortCtrl:reqGetClosestBuild(...)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	_ENV = i18n("common_text_3302")
	serverproxy:Request(gCmd.CMD_ESCORT_MODULE, gCmd.REQ_ESCORT_GET_CLOSEST_BUILD, i18n("common_text_3302"))
end
function escortCtrl:onRspGetRobRecommend(rsp)
	if rsp.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_ESCORT_GET_ROB_RECOMMAND_SUCCESS"
		gErrDef.Err_None.data = rsp.data
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_ESCORT_GET_ROB_RECOMMAND_FAILED"
		gErrDef.Err_None.err = rsp.err
		gErrDef.Err_None.data = rsp.data
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function escortCtrl:onRspGetClosestBuild(rsp)
	dump(rsp, "escortCtrl:onRspGetClosestBuild", 10)
	if rsp.err == gErrDef.Err_None then
		self.dataMgr:setClosestBuild(rsp.data.closestBuild)
		_ENV = self.dataMgr
		self.dataMgr.msg = "MESSAGE_SERVER_ESCORT_REQ_CLOSEST_BUILD"
		self.dataMgr.data = rsp.data
		SoraDSendMessage(self.dataMgr)
	else
		_ENV = self.dataMgr
		self.dataMgr.msg = "MESSAGE_SERVER_ESCORT_REQ_CLOSEST_BUILD_FAILED"
		self.dataMgr.err = rsp.err
		self.dataMgr.data = rsp.data
		SoraDSendMessage(self.dataMgr)
	end
end
function escortCtrl:reqUpdateData()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ESCORT, handler(self, self.onNotifyMsg))
end
function escortCtrl:onNotifyMsg(notification)
	print("[INFO] escortCtrl:onNotifyMsg")
	for i = 1, #notification.data do
		local msg = notification.data[i]
		if msg.type == gEscortNotifyType.RESET_CLOSEST_BUILD then
			self:onNotifyResetClosestBuild(msg)
		elseif msg.type == gEscortNotifyType.RESET_ESCORT_COUNT then
			self:onNotifyResetEscortCount(msg)
		elseif msg.type == gEscortNotifyType.RESET_ASSIST_COUNT then
			self:onNotifyResetAssistCount(msg)
		elseif msg.type == gEscortNotifyType.RESET_ROB_COUNT then
			self:onNotifyResetRobCount(msg)
		end
	end
	_ENV = #notification.data
	;(#notification.data).msg = "MESSAGE_SERVER_ESCORT_REFRESH"
	SoraDSendMessage(#notification.data)
	_ENV = #notification.data
	;(#notification.data).msg = "MESSAGE_UI_PANDECT_CAR"
	SoraDSendMessage(#notification.data)
end
function escortCtrl:onNotifyResetClosestBuild(msg)
	if msg.closestBuild then
		self.dataMgr:setClosestBuild(msg.closestBuild)
	end
end
function escortCtrl:onNotifyResetEscortCount(msg)
	if msg.escortCount then
		self.dataMgr:setEscortCount(msg.escortCount, msg.t)
	end
end
function escortCtrl:onNotifyResetAssistCount(msg)
	if msg.assistCount then
		self.dataMgr:setAssistCount(msg.assistCount, msg.t)
	end
end
function escortCtrl:onNotifyResetRobCount(msg)
	if msg.robCount then
		self.dataMgr:setRobCount(msg.robCount, msg.t)
	end
end
function escortCtrl:getClosestBuild()
	local closestBuild = self.dataMgr:getClosestBuild()
	if not closestBuild then
		self:reqGetClosestBuild()
	else
		print("本地有数据-------")
		_ENV = "本地有数据-------"
		_ENV, ("本地有数据-------").msg = nil, "MESSAGE_SERVER_ESCORT_REQ_CLOSEST_BUILD"
		;("本地有数据-------").data, (nil).closestBuild = nil, closestBuild
		SoraDSendMessage("本地有数据-------")
	end
end
function escortCtrl:getEscortCityLevelMin()
	return self.dataMgr:getEscortCityLevelMin()
end
function escortCtrl:isReachEscortLimit()
	return self.dataMgr:getEscortCount() >= self.dataMgr:getEscortDayMax()
end
function escortCtrl:isReachAssistLimit()
	return self.dataMgr:getAssistCount() >= self.dataMgr:getEscortAssistDayMax()
end
function escortCtrl:isReachRobLimit()
	return self.dataMgr:getRobCount() >= self.dataMgr:getEscortRobDayMax()
end
function escortCtrl:getEscortAllowRobbedOnceMax()
	return self.dataMgr:getEscortAllowRobbedOnceMax()
end
function escortCtrl:hasEscortQueue()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	return kingdomMapCtrl:hasEscortQueue()
end
function escortCtrl:hasAssistQueue()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	return kingdomMapCtrl:hasEscortAssistQueue()
end
function escortCtrl:getStat()
	local _UPVALUE0_, stat
	stat.escortCount = self.dataMgr.escortCount
	stat.assistCount = self.dataMgr.assistCount
	stat.robCount = self.dataMgr.robCount
	stat.t = self.dataMgr.t
	stat.ESCORT_CITYLEVEL_MIN = self.dataMgr.ESCORT_CITYLEVEL_MIN
	stat.ESCORT_DAY_MAX = self.dataMgr.ESCORT_DAY_MAX
	stat.ESCORT_ASSIST_DAY_MAX = self.dataMgr.ESCORT_ASSIST_DAY_MAX
	stat.ESCORT_ROB_DAY_MAX = self.dataMgr.ESCORT_ROB_DAY_MAX
	stat.ESCORT_ALLOW_ROBBED_ONCE_MAX = self.dataMgr.ESCORT_ALLOW_ROBBED_ONCE_MAX
	return stat
end
return escortCtrl
