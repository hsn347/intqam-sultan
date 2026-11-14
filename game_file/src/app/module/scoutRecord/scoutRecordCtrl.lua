local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local scoutRecordDataMgr = include("scoutRecordDataMgr")
local scoutRecordCtrl = class("scoutRecordCtrl", GameModule)
local SCOUT_RECORD_EXPIRE_INTERVAL = 600
function scoutRecordCtrl:ctor(properties)
	scoutRecordCtrl.super.ctor(self, properties)
end
function scoutRecordCtrl:EnterGame()
	scoutRecordCtrl.super.EnterGame(self)
	self.dataMgr = scoutRecordDataMgr.new()
	self.hasGetAllScoutRecord = false
	msgCtrl.register(gCmd.CMD_SCOUT_RECORD_MODULE, gCmd.REQ_SCOUT_RECORD_GET_ALL, handler(self, self.onRspGetAllScoutRecord))
	self:registerNotify()
end
function scoutRecordCtrl:Logout()
	scoutRecordCtrl.super.Logout(self)
	self.dataMgr = nil
	self.hasGetAllScoutRecord = false
end
function scoutRecordCtrl:reqGetAllScoutRecord(...)
	if self.hasGetAllScoutRecord then
		return false
	end
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SCOUT_RECORD_MODULE, gCmd.REQ_SCOUT_RECORD_GET_ALL, nil, ...)
	return true
end
function scoutRecordCtrl:onRspGetAllScoutRecord(rsp)
	if rsp.err == gErrDef.Err_None then
		if rsp.data then
			self.dataMgr:setRecordMap(rsp.data.scoutRecordMap)
		end
		self.hasGetAllScoutRecord = true
	elseif rsp.err == gErrDef.Err_SCOUT_RECORD_ALREADY_GET_ALLL then
		self.hasGetAllScoutRecord = true
	end
end
function scoutRecordCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.SCOUT_RECORD, handler(self, self.onNotifyScoutRecordChanged))
end
function scoutRecordCtrl:onNotifyScoutRecordChanged(notification)
	print("scoutRecordCtrl:onNotifyScoutRecordChanged")
	for i = 1, #notification.data do
		local msg = notification.data[i]
		local record = msg.data.record
		if msg.data.uid and record then
			if msg.data.isDelete then
				self:delScoutRecord(msg.data.uid, record.mailId, record.mapCellId)
			else
				self:addScoutRecord(msg.data.uid, record.name, record.x, record.y, record.mailId, record.t, record.mapCellId, record.kid)
			end
		end
	end
end
function scoutRecordCtrl:addScoutRecord(uid, name, x, y, mailId, t, mapCellId, kid)
	gametop = nil
	;(nil).name = name
	;(nil).x = x
	;(nil).y = y
	;(nil).mailId = mailId
	;(nil).t = t
	;(nil).mapCellId = mapCellId
	local (nil).kid, record = kid, nil
	self.dataMgr:addRecord(uid, record)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:noticeScoutRecordChanged2UI(mapCellId, uid, x, y, true)
end
function scoutRecordCtrl:delScoutRecord(uid, mailId, mapCellId)
	local record = self.dataMgr:delRecord(uid, mailId)
	if record and mapCellId then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:noticeScoutRecordChanged2UI(mapCellId, uid, record.x, record.y, false)
	end
end
function scoutRecordCtrl:getScoutRecord(uid, name, x, y, kid)
	local record = self.dataMgr:findRecord(uid)
	if record and self:isScoutRecordInvalid(record, name, x, y, kid) then
		self:delScoutRecord(uid, record.mailId, record.mapCellId)
		return
	end
	return record
end
function scoutRecordCtrl:isScoutRecordInvalid(record, name, x, y, kid)
	if serviceFunctions.systemTime() > record.t + SCOUT_RECORD_EXPIRE_INTERVAL or name and name ~= record.name or x and y and (x ~= record.x or y ~= record.y) or kid and record.kid and kid ~= record.kid then
		return true
	end
	return false
end
return scoutRecordCtrl
