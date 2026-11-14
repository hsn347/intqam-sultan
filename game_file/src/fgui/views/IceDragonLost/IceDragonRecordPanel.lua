local eventQuestRead = include("eventQuestRead")
local iceDragonLostCtrl = SoraDGetCtrl("iceDragonLostCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceDragonRecordPanel = class("IceDragonRecordPanel", baseFguiPanel)
function IceDragonRecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IceDragonRecordPanel:ctor", self.viewName)
end
function IceDragonRecordPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceDragonRecordPanel:onInit()
	print("=======IceDragonRecordPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("lost_ruins_text_23"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.txt_nodesc:setString(i18n("icedragon_lost_12"))
end
function IceDragonRecordPanel:onShow()
	print("=======IceDragonRecordPanel:onShow")
	iceDragonLostCtrl:reqIceDragonLostClearNewNum()
	self.records = iceDragonLostCtrl:getRecordList()
	self.fields.scroll:setNumItems(#self.records)
	self.fields.txt_nodesc:setVisible(#self.records == 0)
end
function IceDragonRecordPanel:onItemRenderer(index, obj)
	obj:initData(self.records[index + 1])
end
return IceDragonRecordPanel
