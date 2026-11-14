local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local treviFountainCtrl = class("treviFountainCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local treviFountainAuxiliary = include("treviFountainAuxiliary")
function treviFountainCtrl:ctor(properties)
	treviFountainCtrl.super.ctor(self, properties)
	self:resetData()
end
function treviFountainCtrl:resetData()
	self.treviFountainAuxiliary = nil
	self.treviFountainAuxiliary = treviFountainAuxiliary.new()
end
function treviFountainCtrl:Logout()
	treviFountainCtrl.super.Logout(self)
	self.handle_treviFountain_notify = nil
	self:resetData()
end
function treviFountainCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TREVIFOUNTAIN_MODULE, gCmd.REQ_INIT_TREVIFOUNTAIN_DATA, handler(self, self.getInitTreviFountainRsp))
	msgCtrl.register(gCmd.CMD_TREVIFOUNTAIN_MODULE, gCmd.REQ_MULTIPLE_DATA, handler(self, self.getMultipleRsp))
	msgCtrl.register(gCmd.CMD_TREVIFOUNTAIN_MODULE, gCmd.REQ_PRIVILEGE_MULTIPLE_DATA, handler(self, self.getPrivilegeMultipleRsp))
end
function treviFountainCtrl:updateTreviFountain()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_treviFountain_notify = notifyCtrl:register(gNotifyID.TREVIFOUNTAIN, handler(self, self.notifyTreviFountainData))
end
function treviFountainCtrl:notifyTreviFountainData(respone)
	local data = respone.data
	for i, v in ipairs(data) do
		if v.multipleTimes then
			self.originData.multipleTimes = v.multipleTimes
		end
		_ENV = v.multipleTimes
		v.multipleTimes.msg = "MESSAGE_TREVIFOUNTAIN_REFRESH_MULTIPLE"
		v.multipleTimes.bid = BUILDID.WISHING_WELL
		SoraDSendMessage(v.multipleTimes)
		_ENV = v.multipleTimes
		v.multipleTimes.msg = "MESSAGE_MAINCITYVIEW_UPDATE_WISHINGWELL_VIEW"
		SoraDSendMessage(v.multipleTimes)
	end
	_ENV = ipairs(data)
	ipairs(data).msg = "MESSAGE_UI_PANDECT_POOL"
	ipairs(data).bid = BUILDID.WISHING_WELL
	SoraDSendMessage(ipairs(data))
end
function treviFountainCtrl:initTreviFountainData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TREVIFOUNTAIN_MODULE, gCmd.REQ_INIT_TREVIFOUNTAIN_DATA, nil, ...)
end
function treviFountainCtrl:getInitTreviFountainRsp(respone)
	self.originData = respone.data
	self.originData.multipleTimes = self.originData.multipleTimes + self.originData.pornMultipleTimes
end
function treviFountainCtrl:getMultipleRsp(respone)
	if respone.err == gErrDef.Err_None then
		self.originData = respone.data
		self.originData.multipleTimes = self.originData.multipleTimes + self.originData.pornMultipleTimes
		_ENV = self.originData.multipleTimes + self.originData.pornMultipleTimes
		;(self.originData.multipleTimes + self.originData.pornMultipleTimes).msg = "MESSAGE_TREVIFOUNTAIN_MULTIPLE_SUCCESS"
		;(self.originData.multipleTimes + self.originData.pornMultipleTimes).data = self.treviFountainAuxiliary:handleData(self.originData)
		;(self.originData.multipleTimes + self.originData.pornMultipleTimes).respone = respone
		SoraDSendMessage(self.originData.multipleTimes + self.originData.pornMultipleTimes)
		_ENV = self.originData.multipleTimes + self.originData.pornMultipleTimes
		;(self.originData.multipleTimes + self.originData.pornMultipleTimes).msg = "MESSAGE_MAINCITYVIEW_UPDATE_WISHINGWELL_VIEW"
		SoraDSendMessage(self.originData.multipleTimes + self.originData.pornMultipleTimes)
		local drop = respone.data.drop
	elseif gErrDef.Err_TREVIFOUNTAIN_CAST_GOLD_TIMES_LIMIT == respone.err then
		local resourceType = respone.data.resourceType
		_ENV = self.treviFountainAuxiliary:handleData(self.originData)
		self.treviFountainAuxiliary:handleData(self.originData).msg = "MESSAGE_TREVIFOUNTAIN_MULTIPLE_SUCCESS"
		self.treviFountainAuxiliary:handleData(self.originData).err = gErrDef.Err_TREVIFOUNTAIN_CAST_GOLD_TIMES_LIMIT
		self.treviFountainAuxiliary:handleData(self.originData).resourceType = resourceType
		SoraDSendMessage((self.treviFountainAuxiliary:handleData(self.originData)))
	elseif gErrDef.Err_CMD_OPTING == respone.err then
		SoraDCloseLoading()
	end
end
function treviFountainCtrl:getPrivilegeMultipleRsp(respone)
	dump(respone, "treviFountainCtrl:getPrivilegeMultipleRsp")
	if respone.err == gErrDef.Err_None then
		self.originData = respone.data
		self.originData.multipleTimes = self.originData.multipleTimes + self.originData.pornMultipleTimes
		_ENV = self.originData.multipleTimes + self.originData.pornMultipleTimes
		;(self.originData.multipleTimes + self.originData.pornMultipleTimes).msg = "MESSAGE_TREVIFOUNTAIN_MULTIPLE_SUCCESS"
		;(self.originData.multipleTimes + self.originData.pornMultipleTimes).data = self.treviFountainAuxiliary:handleData(self.originData)
		;(self.originData.multipleTimes + self.originData.pornMultipleTimes).respone = respone
		SoraDSendMessage(self.originData.multipleTimes + self.originData.pornMultipleTimes)
		_ENV = self.originData.multipleTimes + self.originData.pornMultipleTimes
		;(self.originData.multipleTimes + self.originData.pornMultipleTimes).msg = "MESSAGE_MAINCITYVIEW_UPDATE_WISHINGWELL_VIEW"
		SoraDSendMessage(self.originData.multipleTimes + self.originData.pornMultipleTimes)
	elseif gErrDef.Err_TREVIFOUNTAIN_CAST_GOLD_TIMES_LIMIT == respone.err then
		local resourceType = respone.data.resourceType
		_ENV = self.treviFountainAuxiliary:handleData(self.originData)
		self.treviFountainAuxiliary:handleData(self.originData).msg = "MESSAGE_TREVIFOUNTAIN_MULTIPLE_SUCCESS"
		self.treviFountainAuxiliary:handleData(self.originData).err = gErrDef.Err_TREVIFOUNTAIN_CAST_GOLD_TIMES_LIMIT
		self.treviFountainAuxiliary:handleData(self.originData).resourceType = resourceType
		SoraDSendMessage((self.treviFountainAuxiliary:handleData(self.originData)))
	elseif gErrDef.Err_CMD_OPTING == respone.err then
		SoraDCloseLoading()
	end
end
function treviFountainCtrl:multiple(type, ...)
	local err = self.treviFountainAuxiliary:validate(self.originData, type)
	if err == gErrDef.Err_None then
		_ENV = nil
		;(nil).resourceType = type
		serverproxy:Request(gCmd.CMD_TREVIFOUNTAIN_MODULE, gCmd.REQ_MULTIPLE_DATA, nil, ...)
	end
end
function treviFountainCtrl:privilegeMultiple(type, ...)
	local err = self.treviFountainAuxiliary:validate(self.originData, type, true)
	if err == gErrDef.Err_None then
		_ENV = nil
		;(nil).resourceType = type
		serverproxy:Request(gCmd.CMD_TREVIFOUNTAIN_MODULE, gCmd.REQ_PRIVILEGE_MULTIPLE_DATA, nil, ...)
	end
end
function treviFountainCtrl:getTreviFountainData()
	if self.originData then
		self.treviFountainData = self.treviFountainAuxiliary:handleData(self.originData)
		return self.treviFountainData
	end
end
function treviFountainCtrl:getTreviFountainMultipleTimes()
	if self.originData then
		return self.originData.multipleTimes or 0
	else
		return 0
	end
end
function treviFountainCtrl:initClientData(data)
	self.originData = data
	self.originData.multipleTimes = self.originData.multipleTimes + self.originData.pornMultipleTimes
	self:updateTreviFountain()
end
return treviFountainCtrl
