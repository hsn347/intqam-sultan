local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local treasureCrystalCtrl = class("treasureCrystalCtrl", GameModule)
function treasureCrystalCtrl:ctor(properties)
	treasureCrystalCtrl.super.ctor(self, properties)
end
function treasureCrystalCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TREASURE_CRYSTAL_MODULE, gCmd.REQ_REFRESH_TASK, handler(self, self.sendReqRefreshRsp))
	self:resetData()
	self:registerNotify()
end
function treasureCrystalCtrl:Logout()
	self:resetData()
	treasureCrystalCtrl.super.Logout(self)
end
function treasureCrystalCtrl:initClientData(content)
	dump(content, "==treasureCrystalCtrl:initClientData==", 20)
	if not content then
		return
	end
	self.itemData = content
end
function treasureCrystalCtrl:resetData()
	self.itemData, _UPVALUE0_ = nil, nil
end
function treasureCrystalCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.TREASURE_CRYSTAL, handler(self, self.notifyCallback))
end
function treasureCrystalCtrl:notifyCallback(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			dump(content, "==treasureCrystalCtrl:notifyCallback==", 20)
			self.itemData = content.data
			_ENV = content
			content.msg = "MESSAGE_TREASURECRYSTAL_REFRESH"
			content.infoData = nil
			SoraDSendMessage(content)
			_ENV = content
			content.msg = "MESSAGE_ITEM_UES_FROM_BAG_BACK"
			SoraDSendMessage(content)
		end
	end
end
function treasureCrystalCtrl:sendReqRefreshRsp(content)
	dump(content, "==treasureCrystalCtrl:sendReqRefreshRsp==", 20)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_TREASURECRYSTAL_REFRESH"
		gErrDef.Err_None.infoData = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function treasureCrystalCtrl:sendReqRefresh(data)
	serverproxy:Request(gCmd.CMD_TREASURE_CRYSTAL_MODULE, gCmd.REQ_REFRESH_TASK, data)
end
function treasureCrystalCtrl:getTaskInfo(itemID, taskEndTime)
	if self.itemData and self.itemData[tostring(itemID)] then
		for i, v in ipairs(self.itemData[tostring(itemID)]) do
			if taskEndTime == v.taskEndTime then
				return v
			end
		end
	end
	_ENV = (for generator)
	return ipairs(self.itemData[tostring(itemID)])
end
return treasureCrystalCtrl
