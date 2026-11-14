local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarframeStoreRoomPanel = class("WarframeStoreRoomPanel", baseFguiPanel)
function WarframeStoreRoomPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WarframeStoreRoomPanel:ctor", self.viewName)
end
function WarframeStoreRoomPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "bagView"
	end
	return self._packageList
end
local MAX_BAG_CAPACITY = 40
function WarframeStoreRoomPanel:onInit()
	print("=======WarframeStoreRoomPanel:onInit")
	self.fields.Com_title:initData(i18n("Soldiers_armor_text_4"), handler(self, self.onClickClose))
end
function WarframeStoreRoomPanel:onShow()
	print("=======WarframeStoreRoomPanel:onShow")
	self:initData()
end
function WarframeStoreRoomPanel:initData()
	self.tableItemsData = armorSystemCtrl:getArmorBagList()
	if #self.tableItemsData < MAX_BAG_CAPACITY then
		for i = #self.tableItemsData + 1, MAX_BAG_CAPACITY do
			self.tableItemsData[i], armorSystemCtrl = nil, nil
		end
	elseif #self.tableItemsData % 4 ~= 0 then
		for i = #self.tableItemsData + 1, math.ceil(#self.tableItemsData / 4) * 4 do
			self.tableItemsData[i], armorSystemCtrl = nil, nil
		end
	end
	self.fields.Scroll:initWarGemData(self.tableItemsData, 3)
end
return WarframeStoreRoomPanel
