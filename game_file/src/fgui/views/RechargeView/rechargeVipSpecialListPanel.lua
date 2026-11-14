local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local premiumStoreCtrl = gametop.playertop_:getModule("premiumStoreCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeVipSpecialListPanel = class("rechargeVipSpecialListPanel", baseFguiPanel)
function rechargeVipSpecialListPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargeVipSpecialListPanel:ctor", self.viewName)
end
function rechargeVipSpecialListPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargeVipSpecialListPanel:onInit()
	print("=======rechargeVipSpecialListPanel:onInit")
	self.dataList, _ENV = print, print
	self.fields.Text_subTitle:setString(i18n("enjoyable_store_08"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function rechargeVipSpecialListPanel:onItemRenderer(index, obj)
	obj:initData(index + 1, self.dataList[index + 1])
end
function rechargeVipSpecialListPanel:onShow()
	print("=======rechargeVipSpecialListPanel:onShow")
	self.index = self.param.index
	self:initData()
end
function rechargeVipSpecialListPanel:initData()
	_ENV = nil
	;(nil).num = self.index
	self.fields.Panel_bg:setString(i18n("enjoyable_store_07", nil))
	self.dataList, _ENV = self.fields.Panel_bg.setString, self.fields.Panel_bg.setString
	local ret = premiumStoreCtrl:getSuperInfoByIsoverflow(self.index)
	for k, v in ipairs(ret) do
		_ENV = i18n("enjoyable_store_07", nil)
		i18n("enjoyable_store_07", nil).id = v.commodityID
		i18n("enjoyable_store_07", nil).count = v.num
		table.insert(self.dataList, i18n("enjoyable_store_07", nil))
	end
	self.fields.List:setNumItems(#self.dataList)
end
return rechargeVipSpecialListPanel
