local baseFguiPanel = require("fgui.base.baseFguiPanel")
local eventQuestRead = include("eventQuestRead")
local snowWolfLostCtrl = SoraDGetCtrl("snowWolfLostCtrl")
local SnowWolfRecordPanel = class("SnowWolfRecordPanel", baseFguiPanel)
function SnowWolfRecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SnowWolfRecordPanel:ctor", self.viewName)
	self.debug = true
end
function SnowWolfRecordPanel:getPackageList()
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
function SnowWolfRecordPanel:onInit()
	print("=======SnowWolfRecordPanel:onInit")
	self.fields.Panel_bg1:setTitle(i18n("lost_ruins_text_23"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function SnowWolfRecordPanel:onShow()
	print("=======SnowWolfRecordPanel:onShow")
	snowWolfLostCtrl:reqSnowWolfLostClearNewNum()
	self.records = snowWolfLostCtrl:getRecordList()
	self.fields.scroll:setNumItems(#self.records)
	self.fields.txt_nodesc:setVisible(#self.records == 0)
	self.fields.txt_nodesc:setString(i18n("snowWolfLost_015"))
end
function SnowWolfRecordPanel:onHide()
	print("=======SnowWolfRecordPanel:onHide")
end
function SnowWolfRecordPanel:onDispose()
	print("=======SnowWolfRecordPanel:onDispose")
end
function SnowWolfRecordPanel:onItemRenderer(index, obj)
	local record = self.records[index + 1]
	obj:initData(record)
end
return SnowWolfRecordPanel
