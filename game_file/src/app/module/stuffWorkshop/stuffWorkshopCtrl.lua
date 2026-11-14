local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local stuffWorkshopCtrl = class("stuffWorkshopCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function stuffWorkshopCtrl:ctor(properties)
	stuffWorkshopCtrl.super.ctor(self, properties)
	self.dataTable, stuffWorkshopCtrl = stuffWorkshopCtrl.super.ctor, stuffWorkshopCtrl.super.ctor
	self.doneID = 0
	self.discount = 1
end
function stuffWorkshopCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STUFF_WORKSHOP_MODULE, gCmd.REQ_REFRESH, handler(self, self.getRefreshRsp))
	msgCtrl.register(gCmd.CMD_STUFF_WORKSHOP_MODULE, gCmd.REQ_REFINERY, handler(self, self.getRefineryRsp))
	msgCtrl.register(gCmd.CMD_STUFF_WORKSHOP_MODULE, gCmd.REQ_CANCEL_REFINERY, handler(self, self.getCancelRefineryRsp))
	msgCtrl.register(gCmd.CMD_STUFF_WORKSHOP_MODULE, gCmd.REQ_GET_STUFF, handler(self, self.getGetStuffRsp))
	msgCtrl.register(gCmd.CMD_STUFF_WORKSHOP_MODULE, gCmd.REQ_OPEN_POS, handler(self, self.getOpenPosRsp))
	msgCtrl.register(gCmd.CMD_STUFF_WORKSHOP_MODULE, gCmd.REQ_SWITCH_QUALITY, handler(self, self.getSwitchQualityRsp))
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:addEventListener(tostring(gQueueTypeDef.stuff_workshop), handler(self, self.refineryQueueCallback))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_refinery_notify = notifyCtrl:register(gNotifyID.STUFFWORKSHOP_REFINERY, handler(self, self.notifyRefinery))
end
function stuffWorkshopCtrl:refineryQueueCallback(event)
	local eventname = event.name
	local data = event.data
end
function stuffWorkshopCtrl:notifyRefinery(respone)
	local tmpRetData = respone.data[1]
	self.dataTable = clone(tmpRetData.data)
	self.doneID = self.dataTable.doneID
	if self.dataTable.discount then
		self.discount = tonumber(self.dataTable.discount)
	end
	if nil ~= tmpRetData.activityOpen then
		print("event activityOpen === ", tmpRetData.activityOpen)
	elseif tmpRetData.hasRefinery then
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local isSuccess = queueCtrl:removeQueue(gQueueTypeDef.stuff_workshop)
		_ENV = queueCtrl
		queueCtrl.ID = tmpRetData.ID
		local queueCtrl.endtime, queueData = tmpRetData.begintime + tmpRetData.totaltime, queueCtrl
		queueCtrl:addQueue(gQueueTypeDef.stuff_workshop, tmpRetData.begintime, tmpRetData.totaltime, tmpRetData.second, queueData)
		_ENV = queueCtrl
		queueCtrl.msg = "MESSAGE_UI_PANDECT_ALCHEMY"
		queueCtrl.queueType = gQueueTypeDef.stuff_workshop
		SoraDSendMessage(queueCtrl)
		local cityBuildConstDef = include("cityBuildConstDef")
		_ENV = gQueueTypeDef.stuff_workshop
		gQueueTypeDef.stuff_workshop.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
		gQueueTypeDef.stuff_workshop.buildIndex = cityBuildConstDef.buildIndexDef.index_Material_WorkShop
		SoraDSendMessage(gQueueTypeDef.stuff_workshop)
		_ENV = gQueueTypeDef.stuff_workshop
		gQueueTypeDef.stuff_workshop.msg = "MESSAGE_BUILD_WORKING"
		gQueueTypeDef.stuff_workshop.buildID = cityBuildConstDef.buildIndexDef.index_Material_WorkShop
		gQueueTypeDef.stuff_workshop.buildCfgID = BUILDID.MATERIAL_WORKSHOP
		SoraDSendMessage(gQueueTypeDef.stuff_workshop)
	else
		local cityBuildConstDef = include("cityBuildConstDef")
		_ENV = queueCtrl
		queueCtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
		queueCtrl.buildIndex = cityBuildConstDef.buildIndexDef.index_Material_WorkShop
		SoraDSendMessage(queueCtrl)
	end
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_SERVER_MATERIAL_FACTORY_UPDATE"
	SoraDSendMessage.bid = BUILDID.MATERIAL_WORKSHOP
	SoraDSendMessage.list = self.dataTable.list
	SoraDSendMessage.count = self.dataTable.count
	SoraDSendMessage.haveNew = true
	SoraDSendMessage(SoraDSendMessage)
end
function stuffWorkshopCtrl:initClientData(data)
	self.doneID = data.doneID
	if data.discount then
		self.discount = tonumber(data.discount)
	end
	self:sendRefresh()
end
function stuffWorkshopCtrl:sendRefresh()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STUFF_WORKSHOP_MODULE
	local (nil).subcmd, msg = gCmd.REQ_REFRESH, nil
	serverproxy:SendMsg(msg)
end
function stuffWorkshopCtrl:sendRefinery(mID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STUFF_WORKSHOP_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_REFINERY, gCmd.REQ_REFINERY
	;(nil).data, gCmd.REQ_REFINERY.id = gCmd.REQ_REFINERY, mID
	local msg
	serverproxy:SendMsg(msg)
end
function stuffWorkshopCtrl:sendCancelRefinery(mPos)
	if mPos <= 0 then
		return
	end
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STUFF_WORKSHOP_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_CANCEL_REFINERY, gCmd.REQ_CANCEL_REFINERY
	;(nil).data, gCmd.REQ_CANCEL_REFINERY.pos = gCmd.REQ_CANCEL_REFINERY, mPos
	local msg
	serverproxy:SendMsg(msg)
end
function stuffWorkshopCtrl:sendGetStuff()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STUFF_WORKSHOP_MODULE
	local (nil).subcmd, msg = gCmd.REQ_GET_STUFF, nil
	serverproxy:SendMsg(msg)
end
function stuffWorkshopCtrl:sendOpenPos(mPos)
	if mPos <= 0 then
		return
	end
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STUFF_WORKSHOP_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_OPEN_POS, gCmd.REQ_OPEN_POS
	;(nil).data, gCmd.REQ_OPEN_POS.pos = gCmd.REQ_OPEN_POS, mPos
	local msg
	serverproxy:SendMsg(msg)
end
function stuffWorkshopCtrl:sendSwitchQualityPos()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STUFF_WORKSHOP_MODULE
	local (nil).subcmd, msg = gCmd.REQ_SWITCH_QUALITY, nil
	serverproxy:SendMsg(msg)
end
function stuffWorkshopCtrl:resetData()
	self.dataTable, _UPVALUE0_ = nil, nil
end
function stuffWorkshopCtrl:getDoneID()
	return self.doneID
end
function stuffWorkshopCtrl:getDiscount()
	return self.discount
end
function stuffWorkshopCtrl:Logout()
	stuffWorkshopCtrl.super.Logout(self)
	self:resetData()
end
function stuffWorkshopCtrl:getRefreshRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		self.doneID = self.dataTable.doneID
		if self.dataTable.discount then
			self.discount = tonumber(self.dataTable.discount)
		else
		end
	end
	_ENV = self.dataTable.discount
	self.dataTable.discount.msg = "MESSAGE_SERVER_MATERIAL_FACTORY_UPDATE"
	self.dataTable.discount.bid = BUILDID.MATERIAL_WORKSHOP
	self.dataTable.discount.list = self.dataTable.list
	self.dataTable.discount.count = self.dataTable.count
	SoraDSendMessage(self.dataTable.discount)
end
function stuffWorkshopCtrl:getRefineryRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		self.doneID = self.dataTable.doneID
		if self.dataTable.discount then
			self.discount = tonumber(self.dataTable.discount)
		else
		end
	end
	_ENV = self.dataTable.discount
	self.dataTable.discount.msg = "MESSAGE_SERVER_MATERIAL_FACTORY_UPDATE"
	self.dataTable.discount.bid = BUILDID.MATERIAL_WORKSHOP
	self.dataTable.discount.list = self.dataTable.list
	self.dataTable.discount.count = self.dataTable.count
	SoraDSendMessage(self.dataTable.discount)
end
function stuffWorkshopCtrl:getCancelRefineryRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_MATERIAL_FACTORY_UPDATE"
	content.err.bid = BUILDID.MATERIAL_WORKSHOP
	content.err.list = self.dataTable.list
	content.err.count = self.dataTable.count
	SoraDSendMessage(content.err)
end
function stuffWorkshopCtrl:getGetStuffRsp(content)
	if gErrDef.Err_None == content.err then
		self.doneID = content.doneID
		local tmpRetData = content.result
		print("------function stuffWorkshopCtrl:getGetStuffRsp(content)")
		local cityBuildConstDef = include("cityBuildConstDef")
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_SHOW_HARVEST_ARMY_RESULT"
		;(nil).index = cityBuildConstDef.buildIndexDef.index_Material_WorkShop
		;(nil).bid = BUILDID.MATERIAL_WORKSHOP
		;(nil).items = tmpRetData
		SoraDSendMessage(nil)
		local _ENV, itemList = SoraDSendMessage, SoraDSendMessage
		local itemNames = ""
		local itemDesRead = include("itemDesRead")
		if tmpRetData then
			for i, v in ipairs(tmpRetData) do
				_ENV = nil
				;(nil).id = v.id
				;(nil).num = v.count
				table.insert(itemList, i, nil)
				if 1 < i then
					itemNames = itemNames .. "," .. (itemDesRead.getName(v.id) or "")
				else
					itemNames = itemNames .. (itemDesRead.getName(v.id) or "")
				end
			end
		end
		_ENV = ipairs(tmpRetData)
		ipairs(tmpRetData).msg = "MESSAGE_MAINCITYVIEW_SHOW_COLLECTITEMS"
		ipairs(tmpRetData).items = itemList
		ipairs(tmpRetData).actType = cityBuildConstDef.itemActType.default
		SoraDSendMessage(ipairs(tmpRetData))
		local iconSprite = display.newSprite("#icon_equip_box.png")
		_ENV = nil
		;(nil).itemID = itemNames
		SoraDShowMsgTip(i18n("common_text_2124", nil), iconSprite)
	else
	end
end
function stuffWorkshopCtrl:getOpenPosRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_MATERIAL_FACTORY_UPDATE"
	content.err.bid = BUILDID.MATERIAL_WORKSHOP
	content.err.list = self.dataTable.list
	content.err.count = self.dataTable.count
	SoraDSendMessage(content.err)
end
function stuffWorkshopCtrl:getSwitchQualityRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_MATERIAL_FACTORY_UPDATE"
	content.err.bid = BUILDID.MATERIAL_WORKSHOP
	content.err.list = self.dataTable.list
	content.err.count = self.dataTable.count
	SoraDSendMessage(content.err)
end
function stuffWorkshopCtrl:getOpenListCount()
	local curCount = 0
	local totalCount = 0
	if self.dataTable and self.dataTable.list then
		for _, value in pairs(self.dataTable.list) do
			if value.mid then
				curCount = curCount + 1
			end
			if value.type == 0 then
				totalCount = totalCount + 1
			end
		end
	end
	return curCount, totalCount, self.dataTable
end
return stuffWorkshopCtrl
