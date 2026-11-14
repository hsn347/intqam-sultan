local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local premiumStoreCtrl = gametop.playertop_:getModule("premiumStoreCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeVipSpecialViewPanel = class("rechargeVipSpecialViewPanel", baseFguiPanel)
function rechargeVipSpecialViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargeVipSpecialViewPanel:ctor", self.viewName)
end
function rechargeVipSpecialViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargeVipSpecialViewPanel:onInit()
	print("=======rechargeVipSpecialViewPanel:onInit")
	self.data, _ENV = print, print
	self.fields.Text_title:setString(i18n("enjoyable_store_04"))
	self.fields.Text_title:enableGradient(cc.c3b(254, 253, 242), cc.c3b(247, 210, 63))
	self.fields.Text_title:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
	self.fields.Text_des1:setString(i18n("enjoyable_store_02"))
	self.fields.Text_des2:setString(i18n("enjoyable_store_05"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function rechargeVipSpecialViewPanel:onItemRenderer(index, obj)
	obj:initData(self.data[index + 1])
end
function rechargeVipSpecialViewPanel:onShow()
	print("=======rechargeVipSpecialViewPanel:onShow")
	self:initData()
	self:updateTime()
end
function rechargeVipSpecialViewPanel:initData()
	self.data = premiumStoreCtrl:getData().superInfo
	self.fields.List:setNumItems(#self.data)
end
function rechargeVipSpecialViewPanel:updateTime()
	self.fields.timer:beginTime(serviceFunctions.getTodayRemainTime())
end
function rechargeVipSpecialViewPanel:msgBackData(target, data)
	SoraDCloseLoading()
	local redata = data.redata
	if redata then
		self:initData()
	end
end
return rechargeVipSpecialViewPanel
