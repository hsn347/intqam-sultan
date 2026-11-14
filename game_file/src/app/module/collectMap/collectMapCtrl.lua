local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local collectMapCtrl = class("collectMapCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local collectMapAuxiliary = include("collectMapAuxiliary")
function collectMapCtrl:ctor(properties)
	collectMapCtrl.super.ctor(self, properties)
	self:resetData()
end
function collectMapCtrl:resetData()
	self.allianceMarkTranslate, collectMapAuxiliary, self.allianceMarkData, collectMapAuxiliary, self.collectMapData, collectMapAuxiliary = nil, nil, nil, nil, nil, nil
	self.collectMapAuxiliary = nil
	self.collectPos, collectMapAuxiliary, self.collectMapAuxiliary = collectMapAuxiliary.new(), collectMapAuxiliary.new(), collectMapAuxiliary.new()
end
function collectMapCtrl:Logout()
	collectMapCtrl.super.Logout(self)
	self:resetData()
end
function collectMapCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_COLLECTMAP_MODULE, gCmd.REQ_INIT_COLLECTMAPDATA, handler(self, self.getCollectMapDataRsp))
	msgCtrl.register(gCmd.CMD_COLLECTMAP_MODULE, gCmd.REQ_COLLECT_MAP, handler(self, self.getAddCollectMapDataRsp))
	msgCtrl.register(gCmd.CMD_COLLECTMAP_MODULE, gCmd.REQ_EDIT_COLLECT_MAP, handler(self, self.getEditCollectMapDataRsp))
	msgCtrl.register(gCmd.CMD_COLLECTMAP_MODULE, gCmd.REQ_DELETE_COLLECT_MAP, handler(self, self.getDeleteCollectMapDataRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MARK_MODULE, gCmd.REQ_ALLIANCE_MARK_INIT, handler(self, self.reqInitAllianceMarkRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MARK_MODULE, gCmd.REQ_ALLIANCE_MARK_ADD, handler(self, self.reqAddAllianceMarkRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MARK_MODULE, gCmd.REQ_ALLIANCE_MARK_DEL, handler(self, self.reqDelAllianceMarkRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MARK_MODULE, gCmd.REQ_ALLIANCE_MARK_SHARE, handler(self, self.reqShareAllianceMarkRsp))
	self:registerNotify()
	self:initCollectMapData()
	self:reqInitAllianceMark()
	self.collectPos, msgCtrl = self.reqInitAllianceMark, self.reqInitAllianceMark
end
function collectMapCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ALLIANCE_MARK, handler(self, self.notifyHandler))
end
function collectMapCtrl:notifyHandler(event)
	dump(event.data, "collectMapCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if not v.allianceMarkData then
			_ENV = v.allianceMarkData
		end
		self.allianceMarkData = v.allianceMarkData
		for i, markType in ipairs(v.markTypes) do
			self.allianceMarkTranslate[markType], _ENV = nil, nil
		end
		for markType, v in pairs(self.allianceMarkTranslate) do
			if not self.allianceMarkData[tostring(markType)] then
				self.allianceMarkTranslate[markType], _ENV = tostring(markType), tostring(markType)
			end
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_ALLIANCE_MARK_REFRESH"
	SoraDSendMessage(ipairs(event.data))
end
function collectMapCtrl:initCollectMapData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COLLECTMAP_MODULE, gCmd.REQ_INIT_COLLECTMAPDATA, nil, ...)
end
function collectMapCtrl:getCollectMapDataRsp(respone)
