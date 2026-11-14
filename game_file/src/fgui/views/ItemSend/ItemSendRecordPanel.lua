local mailCtrl = SoraDGetCtrl("mailCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ItemSendRecordPanel = class("ItemSendRecordPanel", baseFguiPanel)
function ItemSendRecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ItemSendRecordPanel:ctor", self.viewName)
end
function ItemSendRecordPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ItemSendRecordPanel:onInit()
	print("=======ItemSendRecordPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4694"))
	self.fields.Text_none:setString(i18n("god_beast_text_16"))
	self.fields.Text_ower:setString(i18n("solomon_text_09"))
	self.fields.Text_num:setString(i18n("common_text_2709"))
	self.fields.Text_time:setString(i18n("common_text_289"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	mailCtrl:getGiveHistoryNew()
	self.itemID = self.param and self.param.itemID or nil
	_ENV = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).name = self.itemID and publicRead.getName(self.itemID) or i18n("item_name_860601")
	self.fields.Text_tip:setString(i18n("common_text_4695", handler(self, self.onItemRenderer)))
	self.fields.Text_ower:fixPos()
	self.fields.Text_num:fixPos()
	self.fields.Text_time:fixPos()
end
function ItemSendRecordPanel:onItemRenderer(index, obj)
	obj:initData(self.recordList[index + 1], index + 1)
end
function ItemSendRecordPanel:onShow()
	print("=======ItemSendRecordPanel:onShow")
end
function ItemSendRecordPanel:updateView(target, data)
	self.recordList, _ENV = nil, nil
	if not data or not data.record then
		local _ENV, record = data.record, data.record
	end
	for i, v in ipairs(record) do
		if self.itemID == nil or self.itemID == v.itemId then
			table.insert(self.recordList, v)
		end
	end
	self.fields.Text_none:setVisible(#self.recordList == 0)
	self.fields.List:setNumItems(#self.recordList)
end
return ItemSendRecordPanel
