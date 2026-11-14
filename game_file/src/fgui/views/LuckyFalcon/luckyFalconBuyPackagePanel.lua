local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local luckyFalconRead = include("luckyFalconRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local luckyFalconBuyPackagePanel = class("luckyFalconBuyPackagePanel", baseFguiPanel)
function luckyFalconBuyPackagePanel:ctor(...)
	self.super.ctor(self, ...)
	print("luckyFalconBuyPackagePanel:ctor", self.viewName)
end
function luckyFalconBuyPackagePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function luckyFalconBuyPackagePanel:onInit()
	print("=======luckyFalconBuyPackagePanel:onInit")
	self.fields.Text_title:setString(i18n("luckyFalcon_text09"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRederer))
	self.packageInfo = luckyFalconRead.getPackgeInfo()
	_ENV = handler(self, self.onItemRederer)
	_ENV, _ENV, handler(self, self.onItemRederer).defaultClick = handler(self, self.onItemRederer)
	_ENV, handler(self, self.onItemRederer)[1], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	_ENV = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).item = include("publicRead").getName(TOKEN_ITEM)
	handler(self, self.onItemRederer).tabsetArray, handler(self, self.onItemRederer)[2], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onItemRederer))
	_ENV, _UPVALUE4_ = handler(self, self.onClickTab), handler(self, self.onItemRederer)
	_ENV, handler(self, self.onClickTab).rechargeID = self, 14234
	_ENV, self.rechargeID = self.onClickTab, 14235
	_ENV, self.onClickTab.rechargeID = "common_text_4618", 14236
	;("common_text_4618").rechargeID = 14237
	handler(self, self.onItemRederer)[1] = handler(self, self.onClickTab)
	handler(self, self.onItemRederer)[2] = self
	handler(self, self.onItemRederer)[3] = self.onClickTab
	handler(self, self.onItemRederer)[4] = "common_text_4618"
	self.fields.Com_rechargeGiftNode:initData(handler(self, self.onItemRederer))
end
function luckyFalconBuyPackagePanel:onShow()
	print("=======luckyFalconBuyPackagePanel:onShow")
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function luckyFalconBuyPackagePanel:updateScroll()
	local activeDataList = clone(rechargeActivityCtrl:getRechargeActivityListByType(gRechargeActivityType.LIMIT_GIFT))
	self.giftList, _ENV = rechargeActivityCtrl:getRechargeActivityListByType(gRechargeActivityType.LIMIT_GIFT)
	for i, v in ipairs(activeDataList) do
		if tonumber(v.ID) >= 14234 and tonumber(v.ID) <= 14237 then
			table.insert(self.giftList, v)
		end
	end
	table.sort(self.giftList, function(left, right)
		return tonumber(left.ID) < tonumber(right.ID)
	end)
	dump(self.giftList, "giftList")
	self.fields.List_item:setNumItems(math.min(#self.packageInfo, #self.giftList))
end
function luckyFalconBuyPackagePanel:onItemRederer(index, target)
	target:initData(self.packageInfo[index + 1].itemShow, self.giftList[index + 1], self.payType)
end
function luckyFalconBuyPackagePanel:endShow()
	local effectEagle = self.fields.effectEagle:getEffect()
	local Sprite_4 = SoraDGetChildByName(effectEagle, "Sprite_4")
	local XYLY_ying2_01_5 = SoraDGetChildByName(effectEagle, "XYLY_ying2_01_5")
	local Sprite_1 = SoraDGetChildByName(effectEagle, "Sprite_1")
	Sprite_4:setPosition(Sprite_4:getPositionX() - 5, Sprite_4:getPositionY() - 10)
	XYLY_ying2_01_5:setPosition(XYLY_ying2_01_5:getPositionX() - 10, XYLY_ying2_01_5:getPositionY() - 13)
	XYLY_ying2_01_5:setScale(0.9)
	XYLY_ying2_01_5:setVisible(false)
	Sprite_1:setPositionY(300)
end
function luckyFalconBuyPackagePanel:onClickTab(tag)
	self.payType = tag
	self:updateScroll()
end
return luckyFalconBuyPackagePanel
