local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local preDownloadCtrl = class("preDownloadCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local preDownloadGame = require("app.game.updateModule.preDownloadGame")
function preDownloadCtrl:isActivityOpen()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local status = activityShowCtrl:getStateByID(self.activityID)
	if status == gActivityState.OPEN or status == gActivityState.PREPARE then
		return true
	end
	return false
end
function preDownloadCtrl:getActivityParam()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	return activityShowCtrl:getParamByID(self.activityID)
end
local getDeviceID = function()
	local deviceId = userSDKManager.deviceId or ""
	deviceId = tostring(deviceId) or "NONE"
	return deviceId
end
function preDownloadCtrl:isPlayerActive()
	local deviceList = self.data.deviceList
	if deviceList and next(deviceList) then
		local deviceId = getDeviceID()
		return deviceList[deviceId]
	end
	return self.data.activeFlag
end
function preDownloadCtrl:isPlayerPause()
	local deviceList = self.data.stop_deviceList
	if deviceList and next(deviceList) then
		local deviceId = getDeviceID()
		return deviceList[deviceId]
	end
	return false
end
function preDownloadCtrl:getActivieyRound()
	return self.data.round or 1
end
function preDownloadCtrl:isPlayerAward()
	return self.data.rewardFlag
end
function preDownloadCtrl:isPlayerDownloaded()
	local deviceList = self.data.finish_deviceList
	if deviceList and next(deviceList) then
		local deviceId = getDeviceID()
		return deviceList[deviceId]
	end
	return self.data.downloadFlag
end
function preDownloadCtrl:isPreFileDownloadComplete()
	if self._preDownloadGame then
		return self._preDownloadGame:isFileDownloaded()
	end
	return false
end
function preDownloadCtrl:getSizeDownloading()
	if self._preDownloadGame then
		return self._preDownloadGame:getSizeDownloading() or 0
	end
	return 0
end
function preDownloadCtrl:getSizeTotal()
	if self._preDownloadGame then
		return self._preDownloadGame:getSizeTotal() or 0
	end
	return 0
end
function preDownloadCtrl:isPreFileDownloading()
	if self._preDownloadGame then
		return self._preDownloadGame:isFileDownloading()
	end
	return false
end
function preDownloadCtrl:checkSendPredownloadOk()
	if not self:isActivityOpen() then
		return
	end
	if not self:isPlayerActive() then
		return
	end
	if not self:isPreFileDownloadComplete() then
		return
	end
	self:reqPredownloadOk()
end
function preDownloadCtrl:checkPreDownloadAutoStart()
	if self:isActivityOpen() and self:isPlayerActive() and not self:isPlayerDownloaded() and not self:isPlayerPause() then
		self:autoStartPreDownload()
	else
		self:autoStopPreDownload()
	end
end
function preDownloadCtrl:autoStartPreDownload()
	if not self:isPlayerActive() then
		return
	end
	if self:isPlayerDownloaded() then
		return
	end
	if self:isPreFileDownloadComplete() then
		return
	end
	if self:isPreFileDownloading() then
		return
	end
	if self._preDownloadGame then
		self._preDownloadGame:startPreDownload()
	end
end
function preDownloadCtrl:autoStopPreDownload()
	if not self._preDownloadGame then
		return
	end
	if self._preDownloadGame then
		self._preDownloadGame:stopPreDownload()
	end
end
function preDownloadCtrl:reqPredownloadOk()
	_ENV = nil
	;(nil).progress = 100
	userSDKManager.logEvent(gSDKDef.TDonEvent.pre_download_success, nil)
	print("preDownloadCtrl:reqPredownloadOk")
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_OK)
end
function preDownloadCtrl:reqPredownloadStart()
	print("preDownloadCtrl:reqPredownloadStart")
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_START)
end
function preDownloadCtrl:reqPredownloadStop()
	print("preDownloadCtrl:reqPredownloadStart")
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_STOP)
end
function preDownloadCtrl:ctor(properties)
	preDownloadCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.PREDOWNLOAD_REWARD_ACTIVITY
end
_ENV, preDownloadCtrl.EnterGame = function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_OK, handler(self, self.predownloadOkRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_START, handler(self, self.predownloadStartRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_STOP, handler(self, self.predownloadStopRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end, function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_OK, handler(self, self.predownloadOkRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_START, handler(self, self.predownloadStartRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_STOP, handler(self, self.predownloadStopRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end
;(function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_OK, handler(self, self.predownloadOkRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_START, handler(self, self.predownloadStartRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_STOP, handler(self, self.predownloadStopRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).questData, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_OK, handler(self, self.predownloadOkRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_START, handler(self, self.predownloadStartRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_STOP, handler(self, self.predownloadStopRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).round = nil, nil, 1
;(function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_OK, handler(self, self.predownloadOkRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_START, handler(self, self.predownloadStartRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_STOP, handler(self, self.predownloadStopRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).activeFlag = false
;(function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_OK, handler(self, self.predownloadOkRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_START, handler(self, self.predownloadStartRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_STOP, handler(self, self.predownloadStopRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).downloadFlag = false
local (function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_OK, handler(self, self.predownloadOkRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_START, handler(self, self.predownloadStartRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_STOP, handler(self, self.predownloadStopRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).rewardFlag, data_default = false, function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_OK, handler(self, self.predownloadOkRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_START, handler(self, self.predownloadStartRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PREDOWNLOAD_STOP, handler(self, self.predownloadStopRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end
data_default.__index = data_default
function preDownloadCtrl:resetData()
	preDownloadGame = nil
	self:setData(nil)
	if self._preDownloadGame then
		self._preDownloadGame:resetData()
		self._preDownloadGame = nil
	end
	self._preDownloadGame = preDownloadGame.new()
end
function preDownloadCtrl:setData(data, notify)
	if not data then
		data, _ENV = nil, nil
	end
	self.data = data
	setmetatable(self.data, data_default)
	if notify then
		_ENV = self.data
		self.data.msg = "MESSAGE_PRE_DOWNLOAD_REFRESH"
		SoraDSendMessage(self.data)
	end
end
function preDownloadCtrl:notifyHandler(content)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		local activityID = notifyMsg.activityID
		if tonumber(activityID) == self.activityID then
			self:updateData(notifyMsg.notifyData)
		end
	end
end
function preDownloadCtrl:updateData(data)
	if data.activeFlag then
		self.data.activeFlag = data.activeFlag
		_ENV = data.activeFlag
		data.activeFlag.msg = "MESSAGE_PRE_DOWNLOAD_REFRESH"
		SoraDSendMessage(data.activeFlag)
	end
end
function preDownloadCtrl:Logout()
	preDownloadCtrl.super.Logout(self)
	self:autoStopPreDownload()
	self:resetData()
end
function preDownloadCtrl:getReceiveStatusAndNum()
	local ret
	local retNum = 0
	if self:isActivityOpen() and not self:isPlayerAward() and not self:getShowPreDownloadRedCfg() then
		retNum = -1
	end
	ret = retNum < 0
	return ret, retNum
end
function preDownloadCtrl:setShowPreDownloadRedCfg(show)
	_ENV = nil
	;(nil).byUID = true
	local list = SoraDConfigGet("Game:preDownload:showRedCfg~table", nil)
	if not list then
		list, _ENV = "Game:preDownload:showRedCfg~table", "Game:preDownload:showRedCfg~table"
	end
	local round = self:getActivieyRound()
	local time = serviceFunctions.getWeehoursUTC()
	local key = string.format("%s-%s", round, time)
	list[key] = show
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:preDownload:showRedCfg~table", list, nil)
	_ENV = "Game:preDownload:showRedCfg~table"
	;("Game:preDownload:showRedCfg~table").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;("Game:preDownload:showRedCfg~table").eventID = self.activityID
	SoraDSendMessage("Game:preDownload:showRedCfg~table")
end
function preDownloadCtrl:getShowPreDownloadRedCfg()
	_ENV = nil
	;(nil).byUID = true
	local list = SoraDConfigGet("Game:preDownload:showRedCfg~table", nil)
	if list then
		local round = self:getActivieyRound()
		local time = serviceFunctions.getWeehoursUTC()
		local key = string.format("%s-%s", round, time)
		return list[key]
	end
	return false
end
function preDownloadCtrl:initClientData(data)
	if not data then
		return
	end
	local activityData = data[tostring(self.activityID)]
	self:setData(activityData)
end
function preDownloadCtrl:predownloadOkRSP(event)
	dump(event, "preDownloadCtrl:predownloadOkRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		if event.rspdata.initData then
			self:setData(event.rspdata.initData)
		end
		_ENV = self
		self.msg = "MESSAGE_PRE_DOWNLOAD_REFRESH"
		SoraDSendMessage(self)
	end
end
function preDownloadCtrl:predownloadStartRSP(event)
	dump(event, "preDownloadCtrl:predownloadStartRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		if event.rspdata.initData then
			self:setData(event.rspdata.initData)
		end
		_ENV = self
		self.msg = "MESSAGE_PRE_DOWNLOAD_REFRESH_DOWNLOAD"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_PRE_DOWNLOAD_REFRESH"
		SoraDSendMessage(self)
	end
end
function preDownloadCtrl:predownloadStopRSP(event)
	dump(event, "preDownloadCtrl:predownloadStopRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		if event.rspdata.initData then
			self:setData(event.rspdata.initData)
		end
		_ENV = self
		self.msg = "MESSAGE_PRE_DOWNLOAD_REFRESH_DOWNLOAD"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_PRE_DOWNLOAD_REFRESH"
		SoraDSendMessage(self)
	end
end
return preDownloadCtrl
