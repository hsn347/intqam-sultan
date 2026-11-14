local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorGiftPanel = class("NebulaEmperorGiftPanel", baseFguiPanel)
function NebulaEmperorGiftPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorGiftPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaEmperorGiftPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "StarsTower"
		self._packageList, self._packageList[2] = self._packageList, "NebulaAllStar"
	end
	return self._packageList
end
function NebulaEmperorGiftPanel:onInit()
	print("=======NebulaEmperorGiftPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
	self.fields.Com_title:initData(i18n("nebulaemperor_text_245"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_noData:setString(i18n("sudanGift_text_02"))
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		self.controllers.c1:setSelectedIndex(1)
		self.giftList = nebulaAllStarRead.getGiftList()
	else
		self.controllers.c1:setSelectedIndex(0)
		self.giftList = nebulaEmperorRead.getGiftList()
	end
	self.fields.List:setNumItems(#self.giftList)
	self.fields.Text_noData:setVisible(#self.giftList == 0)
end
function NebulaEmperorGiftPanel:onShow()
	print("=======NebulaEmperorGiftPanel:onShow")
end
function NebulaEmperorGiftPanel:onItemRenderer(index, obj)
	local data = self.giftList[index + 1]
	obj:initDataWithActivityID(data, self.activityID)
end
function NebulaEmperorGiftPanel:onMsgRechargeUpdate(...)
	self.fields.List:setNumItems(#self.giftList)
end
return NebulaEmperorGiftPanel
