local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001602_TaskPanel = class("Activity_9001602_TaskPanel", baseFguiPanel)
function Activity_9001602_TaskPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001602_TaskPanel:ctor", self.viewName)
end
function Activity_9001602_TaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001602_TaskPanel:onInit()
	print("=======Activity_9001602_TaskPanel:onInit")
	self.fields.Usm_1:setPrivewImage("#activity_9001602_02_first.png", cc.size(852, 1136), true, true)
end
function Activity_9001602_TaskPanel:onShow()
	local prama = self.proxy.param
	if prama then
		self.activityID = prama.activityID
		self:setTilePoint(prama.titlePoint)
		self:initData(prama.instanceID)
	end
	self:updateView()
	print("=======Activity_9001602_TaskPanel:onShow")
end
function Activity_9001602_TaskPanel:onHide()
	print("=======Activity_9001602_TaskPanel:onHide")
end
function Activity_9001602_TaskPanel:onDispose()
	print("=======Activity_9001602_TaskPanel:onDispose")
end
function Activity_9001602_TaskPanel:updateView()
	self.fields.com_task:initView(self.proxy.param, nil, self.activityID)
end
function Activity_9001602_TaskPanel:initData(instanceID)
	_UPVALUE0_, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
end
function Activity_9001602_TaskPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function Activity_9001602_TaskPanel:getTilePoint()
	return self.tilePoint
end
function Activity_9001602_TaskPanel:close()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return Activity_9001602_TaskPanel
