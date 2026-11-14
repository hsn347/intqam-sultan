local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SnowWolfLostTaskPanel = class("SnowWolfLostTaskPanel", baseFguiPanel)
local SnowWolfLostPanel = class("SnowWolfLostPanel", baseFguiPanel)
local snowWolfLostCtrl = SoraDGetCtrl("snowWolfLostCtrl")
local constantRead = include("constantRead")
local MAX_TASK = constantRead.getConstValue("LOST_RUINS_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("LOST_RUINS_SUMMON_ITEM_NUM", 5)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function SnowWolfLostTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("SnowWolfLostTaskPanel:ctor", self.viewName)
end
function SnowWolfLostTaskPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
	end
	return self._packageList
end
function SnowWolfLostTaskPanel:onInit()
	print("=======SnowWolfLostPanel:onInit")
	self.itemId = 833701
	print("=======SnowWolfLostTaskPanel:onInit")
end
function SnowWolfLostTaskPanel:onShow()
	local prama = self.proxy.param
	if prama then
		self:setTilePoint(prama.titlePoint)
		self:initData(prama.instanceID)
	end
	self:updateView()
	print("=======SnowWolfLostTaskPanel:onShow")
end
function SnowWolfLostTaskPanel:onHide()
	print("=======SnowWolfLostTaskPanel:onHide")
end
function SnowWolfLostTaskPanel:onDispose()
	print("=======SnowWolfLostTaskPanel:onDispose")
end
function SnowWolfLostTaskPanel:updateView()
	self.fields.com_task:initView(self.proxy.param)
end
function SnowWolfLostTaskPanel:initData(instanceID)
	_UPVALUE0_, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
end
function SnowWolfLostTaskPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function SnowWolfLostTaskPanel:getTilePoint()
	return self.tilePoint
end
function SnowWolfLostTaskPanel:close()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return SnowWolfLostTaskPanel
