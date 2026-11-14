local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SnowWolfLostPanel = class("SnowWolfLostPanel", baseFguiPanel)
local snowWolfLostCtrl = SoraDGetCtrl("snowWolfLostCtrl")
local constantRead = include("constantRead")
local MAX_TASK = constantRead.getConstValue("LOST_RUINS_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("LOST_RUINS_SUMMON_ITEM_NUM", 5)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function SnowWolfLostPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("SnowWolfLostPanel:ctor", self.viewName)
end
function SnowWolfLostPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function SnowWolfLostPanel:onInit()
	print("=======SnowWolfLostPanel:onInit")
	self.itemId = 843701
end
function SnowWolfLostPanel:onShow()
	self.fields.com_main:initView()
	self:updateView()
end
function SnowWolfLostPanel:onHide()
	print("=======SnowWolfLostPanel:onHide")
end
function SnowWolfLostPanel:onDispose()
	print("=======SnowWolfLostPanel:onDispose")
end
function SnowWolfLostPanel:updateView()
	self.fields.com_main:updateView()
end
return SnowWolfLostPanel
