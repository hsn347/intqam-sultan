local GameModule = include("GameModule")
local godArmsRuneCtrl = class("godArmsRuneCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function godArmsRuneCtrl:ctor(properties)
	godArmsRuneCtrl.super.ctor(self, properties)
end
function godArmsRuneCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_GUIDE, handler(self, self.reqGuideRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_LOCK, handler(self, self.reqLockRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_WEAR, handler(self, self.reqWearRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_TAKEOFF, handler(self, self.reqTakeOffRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_STRENGTHEN, handler(self, self.reqStrengthenRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_ADVANCE, handler(self, self.reqAdvanceRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_EXTRA_STRENGTHEN, handler(self, self.reqExtraStrengthenRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_REMAKE, handler(self, self.reqRemakeRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_REMAKE_SAVE, handler(self, self.reqRemakeSaveRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_INHERIT, handler(self, self.reqInheritRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_REBORN, handler(self, self.reqRebornRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_GROUP_RENAMED, handler(self, self.reqGroupRenameRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_GROUP_COPY, handler(self, self.reqGroupCopyRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_GROUP_USE, handler(self, self.reqGroupUseRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_GROUP_RESET, handler(self, self.reqGroupResetRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_GROUP_SAVE, handler(self, self.reqGroupSaveRsp))
	self:resetData()
	self:registerNotify()
	self:sendInit()
end
function godArmsRuneCtrl:resetData()
	self.godArmsRuneList, _UPVALUE0_, self.expRuneList, _UPVALUE0_ = nil, nil, nil, nil
	self.wearRuneList, _UPVALUE0_, self.runeList, _UPVALUE0_, self.guide = nil, nil, nil, nil, false
end
function godArmsRuneCtrl:Logout()
	self:resetData()
	godArmsRuneCtrl.super.Logout(self)
end
function godArmsRuneCtrl:initClientData(data)
	if data and next(data) then
		if not data.expRuneList then
			_ENV = data.expRuneList
		end
		self.expRuneList = data.expRuneList
		if not data.newGodArmsRuneList then
			_ENV = data.newGodArmsRuneList
		end
		self.godArmsRuneList = data.newGodArmsRuneList
		self.guide = data.guide or false
		if not data.runeList then
			_ENV = data.runeList
		end
		self.runeList = data.runeList
		self:initWearRuneList()
	end
end
function godArmsRuneCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GOD_ARMS_RUNE, handler(self, self.notifyHandler))
end
function godArmsRuneCtrl:notifyHandler(event)
	dump(event.data, "godArmsRuneCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		if v.notifyType == "addExpRune" then
			if self.expRuneList[tostring(v.rid)] then
				self.expRuneList[tostring(v.rid)] = self.expRuneList[tostring(v.rid)] + v.count
			else
				self.expRuneList[tostring(v.rid)] = v.count
			end
		end
		if v.notifyType == "addRune" then
			if #v.property > 0 then
				for k, v in ipairs(v.property) do
					table.insert(self.runeList, v)
				end
			else
				table.insert(self.runeList, v.property)
			end
		end
		if v.notifyType == "delExpRune" and v.delExpRuneList and next(v.delExpRuneList) then
			for k, v in ipairs(v.delExpRuneList) do
				if self.expRuneList[tostring(v.rid)] then
					self.expRuneList[tostring(v.rid)] = self.expRuneList[tostring(v.rid)] - v.count
					if self.expRuneList[tostring(v.rid)] <= 0 then
						self.expRuneList[tostring(v.rid)] = nil
					end
				end
			end
		end
		if v.notifyType == "delRuneByBackStage" then
			if v.delRuneList and next(v.delRuneList) then
				local _ENV, runeList = next(v.delRuneList), next(v.delRuneList)
				for k, data in ipairs(self.runeList) do
					local isNeedDel = false
					for ki, vi in ipairs(v.delRuneList) do
						if tonumber(data.uid) == tonumber(vi) then
							isNeedDel = true
							break
						end
					end
					if not isNeedDel then
						table.insert(runeList, data)
					end
				end
				self.runeList = clone(runeList)
			end
			if v.newGodArmsRuneList then
				self.godArmsRuneList = v.newGodArmsRuneList
				self:initWearRuneList()
			end
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_RUNE_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function godArmsRuneCtrl:sendInit()
	print("godArmsRuneCtrl:sendInit()=======")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_INIT, nil)
end
function godArmsRuneCtrl:sendGuide()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_GUIDE, nil)
end
function godArmsRuneCtrl:sendLock(uid, lock)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).lock = lock or -1
	serverproxy:Request(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_LOCK, nil)
end
function godArmsRuneCtrl:sendWear(godArmsID, godArmsCell, uid, group)
	local group = group or self:getArmUsingGroup(godArmsID)
	if group == 1 then
		serverproxy = nil
		;(nil).godArmsID = godArmsID
		;(nil).godArmsCell = godArmsCell
		;(nil).uid = uid
		;(nil).group = group
		serverproxy:Request(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_WEAR, nil)
	else
		serverproxy = serverproxy
		serverproxy.msg = "MESSAGE_UI_RUNE_PREVIEW"
		serverproxy.godArmsID = godArmsID
		serverproxy.godArmsCell = godArmsCell
		serverproxy.uid = uid
		serverproxy.group = group
		SoraDSendMessage(serverproxy)
	end
end
function godArmsRuneCtrl:sendTakeoff(godArmsID, godArmsCell, group)
	local group = group or self:getArmUsingGroup(godArmsID)
	if group == 1 then
		serverproxy = nil
		;(nil).godArmsID = godArmsID
		;(nil).godArmsCell = godArmsCell
		;(nil).group = group
		serverproxy:Request(gCmd.CMD_GOD_ARMS_RUNE_MODULE, gCmd.REQ_GOD_ARMS_RUNE_TAKEOFF, nil)
	else
		serverproxy = serverproxy
		serverproxy.msg = "MESSAGE_UI_RUNE_PREVIEW"
		serverproxy.godArmsID = godArmsID
		serverproxy.godArmsCell = godArmsCell
		serverproxy.group = group
		SoraDSendMessage(serverproxy)
	end
end
function godArmsRuneCtrl:sendStrengthen(uid, uidList, expRidList)
