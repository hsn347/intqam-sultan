local GameModule = include("GameModule")
local treasureMapCtrl = class("treasureMapCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function treasureMapCtrl:ctor(properties)
	treasureMapCtrl.super.ctor(self, properties)
end
function treasureMapCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TREASUREMAP_MODULE, gCmd.REQ_TREASUREMAP_REFRESH, handler(self, self.getRefreshResp))
	msgCtrl.register(gCmd.CMD_TREASUREMAP_MODULE, gCmd.REQ_TREASUREMAP_BLOCK, handler(self, self.getBlockResp))
	msgCtrl.register(gCmd.CMD_TREASUREMAP_MODULE, gCmd.REQ_TREASUREMAP_ADJUST, handler(self, self.getAdjustResp))
	self:registerNotify()
	self:initData()
end
function treasureMapCtrl:initData()
	serverproxy:Request(gCmd.CMD_TREASUREMAP_MODULE, gCmd.REQ_TREASUREMAP_ADJUST)
	serverproxy = gCmd.CMD_TREASUREMAP_MODULE
	gCmd.CMD_TREASUREMAP_MODULE.name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(gCmd.CMD_TREASUREMAP_MODULE)
	self:resetData()
end
function treasureMapCtrl:resetData()
	self.treasureMapData, _UPVALUE0_, self.handle_notify = nil, nil, nil
end
function treasureMapCtrl:Logout()
	treasureMapCtrl.super.Logout(self)
	self:resetData()
end
function treasureMapCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.TREASUREMAP, handler(self, self.notifyTreasureMap))
end
function treasureMapCtrl:addTreasureMap(item)
	for k, value in pairs(self.treasureMapData) do
		if value.index == item.index then
			return
		end
	end
	item.treasureMapType = self:getTypeByXY(item.x, item.y)
	self.treasureMapData[item.countIndex] = item
end
function treasureMapCtrl:delTreasureMap(indexArray)
	local findIndex = function(index)
		for i, delIndex in pairs(indexArray) do
			if delIndex == index then
				return true
			end
		end
		return false
	end
	local _ENV, data
	for k, value in pairs(self.treasureMapData) do
		if not findIndex(value.index) then
			table.insert(data, value)
		end
	end
	self.treasureMapData = data
end
function treasureMapCtrl:updateTreasureMap(item)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	for k, v in pairs(self.treasureMapData) do
		if v.index == item.index then
			item.treasureMapType = self:getTypeByXY(item.x, item.y)
			self.treasureMapData[k] = item
			return
		end
	end
end
function treasureMapCtrl:getTypeByXY(x, y)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local selfPoint = cityCtrl:getCurCityPos()
	local posX = tonumber(selfPoint.x)
	local posY = tonumber(selfPoint.y)
	local diffX = math.floor(x - posX)
	local diffY = math.floor(y - posY)
	if 0 <= diffX and 0 <= diffY then
		if diffX >= diffY then
			return 7
		end
		return 6
	elseif diffX < 0 and 0 <= diffY then
		if diffY <= 0 - diffX then
			return 4
		end
		return 5
	elseif diffX < 0 and diffY < 0 then
		if 0 - diffX >= 0 - diffY then
			return 3
		end
		return 2
	elseif 0 <= diffX and diffY < 0 then
		if diffX >= 0 - diffY then
			return 8
		end
		return 1
	end
	return 7
end
function treasureMapCtrl:notifyTreasureMap(event)
	local content = event.data[1]
	if content and content.param then
		if content.optype == TREASUREMAP_ITEM_OP.ADD then
			if type(content.param) == "table" and table.nums(content.param) > 0 then
				self:addTreasureMap(content.param)
			end
		elseif content.optype == TREASUREMAP_ITEM_OP.DEL then
			self:delTreasureMap(content.param)
			_ENV = self
			self.msg = "MESSAGE_ITEM_TREASUREMAP_DELETE_BACK"
			SoraDSendMessage(self)
		elseif content.optype == TREASUREMAP_ITEM_OP.CHANGE and type(content.param) == "table" and table.nums(content.param) > 0 then
			for k, value in pairs(content.param) do
				self:updateTreasureMap(value)
			end
			_ENV = pairs(content.param)
			pairs(content.param).msg = "MESSAGE_ITEM_TREASUREMAP_REFRESH_BACK"
			SoraDSendMessage(pairs(content.param))
		end
	end
end
function treasureMapCtrl:getRefreshResp(content)
	local item = content.item
	if gErrDef.Err_None == content.err then
		if item and self.treasureMapData then
			self:updateTreasureMap(item)
			_ENV = self
			self.msg = "MESSAGE_ITEM_TREASUREMAP_INFO_BACK"
			SoraDSendMessage(self)
		end
	elseif gErrDef.Err_TREASUREMAP_NOT_INTIME == content.err then
	elseif gErrDef.Err_TREASUREMAP_IN_MARCH == content.err then
	end
end
function treasureMapCtrl:getBlockResp(content)
	if gErrDef.Err_None == content.err then
		for k, value in pairs(content.data) do
			self:addTreasureMap(value)
		end
		_ENV = pairs(content.data)
		pairs(content.data).msg = "MESSAGE_ITEM_TREASUREMAP_INFO_BACK"
		SoraDSendMessage(pairs(content.data))
	elseif gErrDef.Err_TREASUREMAP_PARAM_ERROR == content.err then
	end
end
function treasureMapCtrl:getAdjustResp(content)
end
function treasureMapCtrl:getTreasureMapDataByIndex(countIndex)
	if not self.treasureMapData[countIndex] then
		print("treasureMapCtrl:getTreasureMapDataByIndex error countIndex =", countIndex, type(countIndex))
		return
	end
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local data = self.treasureMapData[countIndex]
	data.isMarch = kingdomMapCtrl:isLockByDigTreasure(data.x, data.y)
	data.disappearLeftTime = data.disappear - serviceFunctions.systemTime()
	if data.disappearLeftTime < 0 then
		data.disappearLeftTime = 0
	end
	data.refreshLeftTime = data.cd - serviceFunctions.systemTime()
	if 0 > data.refreshLeftTime then
		data.refreshLeftTime = 0
	end
	return data
end
function treasureMapCtrl:sendRefresh(countIndex)
	if not self.treasureMapData[countIndex] then
		print("treasureMapCtrl:sendRefresh error countIndex =", countIndex, type(countIndex))
		return
	end
	local index = self.treasureMapData[countIndex].index
	local _ENV, data = "treasureMapCtrl:sendRefresh error countIndex =", "treasureMapCtrl:sendRefresh error countIndex ="
	data.index = index
	serverproxy:Request(gCmd.CMD_TREASUREMAP_MODULE, gCmd.REQ_TREASUREMAP_REFRESH, data)
end
function treasureMapCtrl:sendTreasureMapByRange(beginIndex, endIndex)
	local serverproxy, data
	data.beginIndex = beginIndex
	data.endIndex = endIndex
	serverproxy:Request(gCmd.CMD_TREASUREMAP_MODULE, gCmd.REQ_TREASUREMAP_BLOCK, data)
end
return treasureMapCtrl
