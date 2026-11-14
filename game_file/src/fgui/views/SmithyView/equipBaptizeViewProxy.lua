local baseProxy = require("fgui.base.baseProxy")
local equipBaptizeViewProxy = class("equipBaptizeViewProxy", baseProxy)
function equipBaptizeViewProxy:onRegisterEvent()
	print("=======equipBaptizeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_BAPTIZE_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_BAPTIZE_SURE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_BAPTIZE_RESTORE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initStone))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.limitTimeOut))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_BAPTIZE_FREE_UPDATE", handler(self, self.initAttrLabel))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateSteel))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_DATA_UPDATE", handler(self, self.equipDataUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.initScouringActivity))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_BAPTIZE_BUFF_SELECT", handler(self, self.buffSelect))
end
function equipBaptizeViewProxy:initData(target, data)
	self.view:initData()
end
function equipBaptizeViewProxy:initStone(target, data)
	self.view:initStone()
end
function equipBaptizeViewProxy:limitTimeOut(target, data)
	self.view:limitTimeOut(target, data)
end
function equipBaptizeViewProxy:initAttrLabel(target, data)
	self.view:initAttrLabel()
end
function equipBaptizeViewProxy:updateSteel(target, data)
	if data.reslist[tostring(gIDDef.STEEL)] then
		self.view:updateSteel()
	end
end
function equipBaptizeViewProxy:equipDataUpdate(target, data)
	self.view:equipDataUpdate()
end
function equipBaptizeViewProxy:initScouringActivity(target, data)
	if data.activityID and data.activityID == gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY then
		self.view:initScouringActivity()
	end
end
function equipBaptizeViewProxy:buffSelect(target, data)
	self.view:buffSelect(target, data)
end
return equipBaptizeViewProxy
