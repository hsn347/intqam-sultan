local salesRoomAgCtrl = SoraDGetCtrl("salesRoomAgCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newTradeBoardRecordsViewPanel = class("newTradeBoardRecordsViewPanel", baseFguiPanel)
function newTradeBoardRecordsViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("newTradeBoardRecordsViewPanel:ctor", self.viewName)
end
function newTradeBoardRecordsViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function newTradeBoardRecordsViewPanel:onInit()
	print("=======newTradeBoardRecordsViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("auction_text_07"))
	self.fields.Text_noRecords:setString(i18n("common_text_1464"))
	self.fields.Text_noRecords:setVisible(false)
	self.fields.List_record:setItemRenderer(handler(self, self.onRecordRenderer))
end
function newTradeBoardRecordsViewPanel:onShow()
	print("=======newTradeBoardRecordsViewPanel:onShow")
	self.shopID = self.param.shopID
	self.itemInfo = self.param.itemInfo
	salesRoomAgCtrl:sendNewLogMsg(self.shopID)
end
function newTradeBoardRecordsViewPanel:onRecordRenderer(index, obj)
	obj:initDataEx(self.logInfo[index + 1], self.itemInfo)
end
function newTradeBoardRecordsViewPanel:initData(target, data)
	self.logInfo = data.logInfo
	self.fields.List_record:setNumItems(#self.logInfo)
	self.fields.Text_noRecords:setVisible(#self.logInfo == 0)
end
return newTradeBoardRecordsViewPanel
