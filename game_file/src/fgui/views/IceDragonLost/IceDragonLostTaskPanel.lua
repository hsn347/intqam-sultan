local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceDragonLostTaskPanel = class("IceDragonLostTaskPanel", baseFguiPanel)
function IceDragonLostTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IceDragonLostTaskPanel:ctor", self.viewName)
end
function IceDragonLostTaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceDragonLostTaskPanel:onInit()
	print("=======IceDragonLostTaskPanel:onInit")
end
function IceDragonLostTaskPanel:onShow()
	print("=======IceDragonLostTaskPanel:onShow")
	local prama = self.proxy.param
	if prama then
		self:setTilePoint(prama.titlePoint)
		self:initData(prama.instanceID)
	end
	self:updateView()
end
function IceDragonLostTaskPanel:updateView()
	self.fields.com_task:initView(self.proxy.param, self)
end
function IceDragonLostTaskPanel:initData(instanceID)
	_UPVALUE0_, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
end
function IceDragonLostTaskPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function IceDragonLostTaskPanel:getTilePoint()
	return self.tilePoint
end
function IceDragonLostTaskPanel:close()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return IceDragonLostTaskPanel
