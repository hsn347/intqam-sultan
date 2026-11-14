local salesRoomAgCtrl = SoraDGetCtrl("salesRoomAgCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newTradeBoardSelfRecordPanel = class("newTradeBoardSelfRecordPanel", baseFguiPanel)
function newTradeBoardSelfRecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("newTradeBoardSelfRecordPanel:ctor", self.viewName)
end
function newTradeBoardSelfRecordPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function newTradeBoardSelfRecordPanel:onInit()
	print("=======newTradeBoardSelfRecordPanel:onInit")
	self.logInfo, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("auction_text_33"))
	self.fields.Text_noRecords:setString(i18n("common_text_1464"))
	self.fields.Text_noRecords:setVisible(false)
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function newTradeBoardSelfRecordPanel:onItemRenderer(index, obj)
	obj:initData(self.logInfo[index + 1])
end
function newTradeBoardSelfRecordPanel:onShow()
	print("=======newTradeBoardSelfRecordPanel:onShow")
	self:initData()
end
function newTradeBoardSelfRecordPanel:initData()
	if not salesRoomAgCtrl:getSuccessInfo() then
		salesRoomAgCtrl = salesRoomAgCtrl:getSuccessInfo()
	end
	self.logInfo = salesRoomAgCtrl:getSuccessInfo()
	self.fields.Text_noRecords:setVisible(#self.logInfo == 0)
	self.fields.List:setNumItems(#self.logInfo)
end
function newTradeBoardSelfRecordPanel:btnClick()
	SoraDPlaySound()
	self:close()
end
return newTradeBoardSelfRecordPanel
