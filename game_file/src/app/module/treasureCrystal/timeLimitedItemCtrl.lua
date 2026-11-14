local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timeLimitedItemCtrl = class("timeLimitedItemCtrl", GameModule)
function timeLimitedItemCtrl:ctor(properties)
	timeLimitedItemCtrl.super.ctor(self, properties)
end
function timeLimitedItemCtrl:EnterGame()
	self:resetData()
	self:registerNotify()
end
function timeLimitedItemCtrl:Logout()
	self:resetData()
	timeLimitedItemCtrl.super.Logout(self)
end
function timeLimitedItemCtrl:initClientData(content)
	dump(content, "==timeLimitedItemCtrl:initClientData==", 20)
	if not content then
		return
	end
	self.backpackItem = content.backpackItem
	self.inUseItem = content.inUseItem
	self.pandoraBox = content.pandoraBox
	self:resetIndex()
end
function timeLimitedItemCtrl:resetData()
	self.tmpPandoraBox, _UPVALUE0_, self.pandoraBox, _UPVALUE0_, self.inUseIndex, _UPVALUE0_, self.backpackIndex, _UPVALUE0_, self.tmpSpaceUItem, _UPVALUE0_, self.tmpSpaceBItem, _UPVALUE0_, self.inUseItem, _UPVALUE0_, self.backpackItem, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function timeLimitedItemCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LIMITED_ITEM, handler(self, self.notifyCallback))
end
function timeLimitedItemCtrl:notifyCallback(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			dump(content, "==timeLimitedItemCtrl:notifyCallback==", 20)
			self.backpackItem = content.data.backpackItem
			self.inUseItem = content.data.inUseItem
			self.pandoraBox = content.data.pandoraBox
			self:resetIndex()
			_ENV = self
			self.msg = "MESSAGE_ITEM_UES_FROM_BAG_BACK"
			SoraDSendMessage(self)
		end
	end
end
function timeLimitedItemCtrl:getLimitedItem(itemId)
	if self.tmpSpaceBItem[tostring(itemId)] and #self.tmpSpaceBItem[tostring(itemId)] > 0 then
		singleItem = table.remove(self.tmpSpaceBItem[tostring(itemId)])
		return singleItem
	else
		return false
	end
end
function timeLimitedItemCtrl:getInUseLimitedItem(itemId)
	if self.tmpSpaceUItem[tostring(itemId)] and #self.tmpSpaceUItem[tostring(itemId)] > 0 then
		singleItem = table.remove(self.tmpSpaceUItem[tostring(itemId)])
		return singleItem
	else
		return false
	end
end
function timeLimitedItemCtrl:addtInUseLimitedItem(itemId, usedLimitedTime)
	if not self.tmpSpaceUItem[tostring(itemId)] then
		self.tmpSpaceUItem[tostring(itemId)], _ENV = itemId, itemId
	end
	table.insert(self.tmpSpaceUItem[tostring(itemId)], usedLimitedTime)
end
function timeLimitedItemCtrl:addtLimitedItem(itemId, limitedTime)
	if not self.tmpSpaceBItem[tostring(itemId)] then
		self.tmpSpaceBItem[tostring(itemId)], _ENV = itemId, itemId
	end
	table.insert(self.tmpSpaceBItem[tostring(itemId)], limitedTime)
end
function timeLimitedItemCtrl:addtBoxIndex(itemId, index)
	if self.tmpPandoraBox[tostring(itemId)] and self.pandoraBox[tostring(itemId)] and index then
		self.tmpPandoraBox[tostring(itemId)][index] = self.pandoraBox[tostring(itemId)][index]
	end
end
function timeLimitedItemCtrl:resetIndex()
	self.tmpPandoraBox, _ENV, self.tmpSpaceUItem, _ENV, self.tmpSpaceBItem, _ENV = nil, nil, nil, nil, nil, nil
	self.tmpSpaceBItem = serviceFunctions.table_copy_table(self.backpackItem)
	self.tmpSpaceUItem = serviceFunctions.table_copy_table(self.inUseItem)
	self.tmpPandoraBox = serviceFunctions.table_copy_table(self.pandoraBox)
end
function timeLimitedItemCtrl:getNewLimitedTime(itemID)
	if not self.backpackItem[tostring(itemID)] then
		local _ENV, itemTbl = self.backpackItem[tostring(itemID)], self.backpackItem[tostring(itemID)]
	end
	return itemTbl[table.nums(itemTbl)]
end
function timeLimitedItemCtrl:getNewInUseLimitedItem(itemID)
	local itemTbl = self.inUseItem[tostring(itemID)]
	return itemTbl[table.nums(itemTbl)]
end
function timeLimitedItemCtrl:getPandoraBoxIndex(itemID, time)
	if not self.tmpPandoraBox[tostring(itemID)] then
		local _ENV, itemTbl = self.tmpPandoraBox[tostring(itemID)], self.tmpPandoraBox[tostring(itemID)]
	end
	for k, v in ipairs(itemTbl) do
		if v.time == time then
			itemTbl[k], _ENV = v.time, v.time
			return k
		end
	end
end
function timeLimitedItemCtrl:getPandoraBoxData(itemID, time, index)
	if not self.pandoraBox[tostring(itemID)] then
		local _ENV, itemTbl = self.pandoraBox[tostring(itemID)], self.pandoraBox[tostring(itemID)]
	end
	for k, v in pairs(itemTbl) do
		if v.time == time and k == tonumber(index) then
			return v
		end
	end
	_ENV = (for generator)
	return pairs(itemTbl)
end
return timeLimitedItemCtrl
