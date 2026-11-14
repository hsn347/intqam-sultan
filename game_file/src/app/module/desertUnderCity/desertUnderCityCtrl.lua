local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local desertUnderCityCtrl = class("desertUnderCityCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function desertUnderCityCtrl:ctor(properties)
	desertUnderCityCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.DESERT_UNDERGROUND_CITY_ACTIVITY
end
function desertUnderCityCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_INIT, handler(self, self.reqDesertUndergroundCityInitRsp))
	msgCtrl.register(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_CHOOSE, handler(self, self.reqDesertUndergroundCityChooseRsp))
	msgCtrl.register(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_OPEN, handler(self, self.reqDesertUndergroundCityOpenRsp))
	msgCtrl.register(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_NEXT, handler(self, self.reqDesertUndergroundCityNextRsp))
	msgCtrl.register(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_OPEN_ALL_LEFT, handler(self, self.reqDesertUndergroundCityOpenAllLeftRsp))
	self:registerNotify()
end
function desertUnderCityCtrl:Logout()
	desertUnderCityCtrl.super.Logout(self)
	self:resetData()
end
function desertUnderCityCtrl:resetData()
end
function desertUnderCityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DESERT_UNDERGROUND_CITY, handler(self, self.notifyHandler))
end
function desertUnderCityCtrl:notifyHandler(event)
	dump(event.data, "desertUnderCityCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local content
		if content then
			self.clientData = content.fireSecretOrderData
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_DESERT_UNDER_CITY_BACK"
	SoraDSendMessage(ipairs(event.data))
end
function desertUnderCityCtrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_INIT, nil)
end
function desertUnderCityCtrl:reqChoose(chooseID)
	serverproxy = nil
	;(nil).chooseID = chooseID
	serverproxy:Request(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_CHOOSE, nil)
end
function desertUnderCityCtrl:reqOpen(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_OPEN, nil)
end
function desertUnderCityCtrl:reqNext()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_NEXT, nil)
end
function desertUnderCityCtrl:reqAllOpen(closeTips)
	serverproxy = nil
	;(nil).closeTips = closeTips
	serverproxy:Request(gCmd.CMD_FIRE_SECRET_ORDER_MODULE, gCmd.REQ_DESERT_UNDERGROUND_CITY_OPEN_ALL_LEFT, nil)
end
function desertUnderCityCtrl:reqDesertUndergroundCityInitRsp(content)
	dump(content, "desertUnderCityCtrl:reqDesertUndergroundCityInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.clientData = content.rspdata.fireSecretOrderData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_DESERT_UNDER_CITY_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function desertUnderCityCtrl:reqDesertUndergroundCityChooseRsp(content)
	dump(content, "desertUnderCityCtrl:reqDesertUndergroundCityChooseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.clientData = content.rspdata.fireSecretOrderData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_DESERT_UNDER_CITY_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function desertUnderCityCtrl:reqDesertUndergroundCityOpenRsp(content)
	dump(content, "desertUnderCityCtrl:reqDesertUndergroundCityOpenRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.clientData = content.rspdata.fireSecretOrderData
		local isBigPrize = false
		if self.clientData and next(self.clientData.floorInfo) then
			for k, v in pairs(self.clientData.floorInfo) do
				if next(v.item) and v.item.id == content.rspdata.reward.id and v.item.count == content.rspdata.reward.count and v.isGreate then
					isBigPrize = true
					break
				end
			end
		end
		if content.rspdata.reward and not isBigPrize then
			SoraDPopGainItem(content.rspdata.reward.id, content.rspdata.reward.count, true, true)
		end
		_ENV = content.rspdata.reward.id
		content.rspdata.reward.id.msg = "MESSAGE_DESERT_UNDER_CITY_BACK"
		content.rspdata.reward.id.isBigPrize = isBigPrize
		content.rspdata.reward.id.index = content.data.index
		content.rspdata.reward.id.reward = content.rspdata.reward
		SoraDSendMessage(content.rspdata.reward.id)
	end
end
function desertUnderCityCtrl:reqDesertUndergroundCityNextRsp(content)
	dump(content, "desertUnderCityCtrl:reqDesertUndergroundCityNextRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.oldFloorInfo = self.clientData
		self.clientData = content.rspdata.fireSecretOrderData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_DESERT_UNDER_CITY_BACK"
		gErrDef.Err_None.subMsg = "next"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function desertUnderCityCtrl:reqDesertUndergroundCityOpenAllLeftRsp(content)
	dump(content, "desertUnderCityCtrl:reqDesertUndergroundCityOpenAllLeftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.clientData = content.rspdata.fireSecretOrderData
		if content.rspdata.itemList then
			SoraDMailGainItems(content.rspdata.itemList, true)
		end
		_ENV = content.rspdata.itemList
		content.rspdata.itemList.msg = "MESSAGE_DESERT_UNDER_CITY_BACK"
		SoraDSendMessage(content.rspdata.itemList)
	end
end
function desertUnderCityCtrl:getFloor()
	local floor = 1
	if self.clientData and self.clientData.floor then
		floor = self.clientData.floor
	end
	return floor
end
function desertUnderCityCtrl:getOldFloorInfo(index)
	local _ENV, floorInfo
	if self.oldFloorInfo and next(self.oldFloorInfo.floorInfo) and self.oldFloorInfo.floorInfo[tostring(index)] then
		floorInfo = self.oldFloorInfo.floorInfo[tostring(index)]
	end
	return floorInfo
end
function desertUnderCityCtrl:getChooseID()
	local chooseID
	if self.clientData and self.clientData.chooseID then
		chooseID = self.clientData.chooseID
	end
	return chooseID
end
function desertUnderCityCtrl:isFirstTimeOneKeyOpen()
	local isFirstTime = true
	if self.clientData then
		isFirstTime = self.clientData.isFirstTime
	end
	return isFirstTime
end
function desertUnderCityCtrl:isAlreadyChosen()
	local isChosen = false
	if self.clientData and next(self.clientData.floorInfo) then
		isChosen = true
	end
	return isChosen
end
function desertUnderCityCtrl:getFloorInfo(index)
	local _ENV, floorInfo
	if self.clientData and next(self.clientData.floorInfo) and self.clientData.floorInfo[tostring(index)] then
		floorInfo = self.clientData.floorInfo[tostring(index)]
	end
	return floorInfo
end
function desertUnderCityCtrl:getFreeTime()
	local freeTime = include("constantRead").getConstValue("DESERT_DUNGEONS_FREE")
	local leftCount = freeTime
	if self.clientData and self.clientData.todayCount then
		leftCount = math.max(0, freeTime - self.clientData.todayCount)
	end
	return leftCount
end
function desertUnderCityCtrl:getRemainGrids()
	local remainNum = 16
	if self.clientData and next(self.clientData.floorInfo) then
		for k, v in pairs(self.clientData.floorInfo) do
			if v.finishTime > 0 then
				remainNum = remainNum - 1
			end
		end
	end
	return remainNum
end
return desertUnderCityCtrl
