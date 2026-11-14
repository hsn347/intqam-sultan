local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LegendOfPegasusTaskPanel = class("LegendOfPegasusTaskPanel", baseFguiPanel)
local LegendOfPegasusPanel = class("LegendOfPegasusPanel", baseFguiPanel)
local legendOfPegasusCtrl = SoraDGetCtrl("legendOfPegasusCtrl")
local constantRead = include("constantRead")
local MAX_TASK = constantRead.getConstValue("LEGEND_OF_PEGASUS_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("LEGEND_OF_PEGASUS_SUMMON_ITEM_NUM", 5)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function LegendOfPegasusTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("LegendOfPegasusTaskPanel:ctor", self.viewName)
end
function LegendOfPegasusTaskPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "LegendOfPegasus"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
	end
	return self._packageList
end
function LegendOfPegasusTaskPanel:onInit()
	print("=======LegendOfPegasusTaskPanel:onInit")
end
function LegendOfPegasusTaskPanel:onShow()
	local prama = self.proxy.param
	if prama then
		self:setTilePoint(prama.titlePoint)
		self:initData(prama.instanceID)
	end
	self:updateView()
	print("=======LegendOfPegasusTaskPanel:onShow")
end
function LegendOfPegasusTaskPanel:onHide()
	print("=======LegendOfPegasusTaskPanel:onHide")
end
function LegendOfPegasusTaskPanel:onDispose()
	print("=======LegendOfPegasusTaskPanel:onDispose")
end
function LegendOfPegasusTaskPanel:updateView()
	self.fields.com_task:initView(self.proxy.param)
end
function LegendOfPegasusTaskPanel:initData(instanceID)
	_UPVALUE0_, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
end
function LegendOfPegasusTaskPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function LegendOfPegasusTaskPanel:getTilePoint()
	return self.tilePoint
end
function LegendOfPegasusTaskPanel:close()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return LegendOfPegasusTaskPanel
