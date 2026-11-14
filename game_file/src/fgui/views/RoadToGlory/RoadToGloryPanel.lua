local baseFguiPanel = require("fgui.base.baseFguiPanel")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local roadToGloryRead = include("roadToGloryRead")
local RoadToGloryPanel = class("RoadToGloryPanel", baseFguiPanel)
function RoadToGloryPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RoadToGloryPanel:ctor", self.viewName)
end
function RoadToGloryPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RoadToGloryPanel:onInit()
	print("=======RoadToGloryPanel:onInit")
	self.fields.title:initData(i18n("activity_name_9001321"), handler(self, self.onClickClose), handler(self, self.clickFAQBtn))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.createTaskItem))
	self.fields.Text_Tips:setString(i18n("ramadan_text_20"))
	self.fields.button_Item:initData(836401)
end
function RoadToGloryPanel:onShow()
	print("=======RoadToGloryPanel:onShow")
	SoraDShowLoading()
	activityTaskComponentCtrl:sendReqInit()
	self.fields.title:initCommonActivityTime(self.proxy.activityID)
end
function RoadToGloryPanel:itemChange()
	self.fields.button_Item:itemChange()
end
function RoadToGloryPanel:canExchange()
	self.fields.button_Item:canExchange()
end
function RoadToGloryPanel:updataInfoData(info)
	self.castleLv = info.castleLv
	self.starLv = info.starLv
	self:reflashScroll()
end
function RoadToGloryPanel:reflashScroll()
	if self.castleLv == nil then
		return
	end
	local serverData = activityTaskComponentCtrl:getQuestData(self.proxy.activityID)
	self.taskInfoData = roadToGloryRead.getSortList(self.castleLv, self.starLv, serverData)
	self.actType = roadToGloryRead.getActType(self.castleLv, self.starLv)
	self.controllers.c1:setSelectedIndex(self.actType - 1)
	self.fields.List:setNumItems(#self.taskInfoData)
end
function RoadToGloryPanel:createTaskItem(index, target)
	target:initData(self.taskInfoData[index + 1])
end
function RoadToGloryPanel:clickFAQBtn()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("gloryRoad_text_01")
	uiManager:show("RuleView", nil)
end
return RoadToGloryPanel
