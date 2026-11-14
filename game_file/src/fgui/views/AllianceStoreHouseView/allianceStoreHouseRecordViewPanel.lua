local allianceTreasureCtrl = SoraDGetCtrl("allianceTreasureCtrl")
local allianceTreasureltCtrl = include("allianceTreasureltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceStoreHouseRecordViewPanel = class("allianceStoreHouseRecordViewPanel", baseFguiPanel)
function allianceStoreHouseRecordViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceStoreHouseRecordViewPanel:ctor", self.viewName)
end
function allianceStoreHouseRecordViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceStoreHouseRecordViewPanel:onInit()
	print("=======allianceStoreHouseRecordViewPanel:onInit")
	self.recordList, _ENV, self.recordType = print, print, 1
	self.fields.Panel_bg:setString(i18n("common_text_836"))
	self.fields.Text_no_record:setString(i18n("common_text_1464"))
	self.fields.Text_no_record:setVisible(false)
	self.fields.Button_close:setString(i18n("common_text_247"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function allianceStoreHouseRecordViewPanel:onItemRenderer(index, obj)
	obj:initData(self.recordList[index + 1], self.recordType)
end
function allianceStoreHouseRecordViewPanel:onShow()
	print("=======allianceStoreHouseRecordViewPanel:onShow")
	self.recordType = self.param.recordType or 1
	allianceTreasureCtrl:reqRecord(self.recordType)
end
function allianceStoreHouseRecordViewPanel:reqInfoBack(event, data)
	if not data.nData then
		_ENV = data.nData
	end
	self.recordList = data.nData
	table.sort(self.recordList, function(a, b)
		return a.time > b.time
	end)
	self.fields.List:setNumItems(#self.recordList)
	self.fields.Text_no_record:setVisible(#self.recordList == 0)
end
return allianceStoreHouseRecordViewPanel
