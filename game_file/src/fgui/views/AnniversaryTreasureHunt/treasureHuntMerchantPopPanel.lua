local anniversaryTreasureHuntRead = include("anniversaryTreasureHuntRead")
local anniversaryTreasureHuntCtrl = SoraDGetCtrl("anniversaryTreasureHuntCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local treasureHuntMerchantPopPanel = class("treasureHuntMerchantPopPanel", baseFguiPanel)
function treasureHuntMerchantPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("treasureHuntMerchantPopPanel:ctor", self.viewName)
end
function treasureHuntMerchantPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function treasureHuntMerchantPopPanel:onInit()
	print("=======treasureHuntMerchantPopPanel:onInit")
	self.rechargeIDList, _ENV = print, print
	self.fields.text_saohua:setString(i18n("anniversary_dice_text_15"))
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(1717)
	self.fields.Spine_Hero1717:setEffectPath(spineCfg)
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRederer))
	_ENV = handler(self, self.onItemRederer)
	_ENV, _ENV, handler(self, self.onItemRederer).defaultClick = handler(self, self.onItemRederer)
	_ENV, handler(self, self.onItemRederer)[1], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	_ENV = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).item = include("publicRead").getName(TOKEN_ITEM)
	handler(self, self.onItemRederer).tabsetArray, handler(self, self.onItemRederer)[2], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onItemRederer))
end
function treasureHuntMerchantPopPanel:onShow()
	print("=======treasureHuntMerchantPopPanel:onShow")
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
	self:initData()
end
function treasureHuntMerchantPopPanel:onItemRederer(index, target)
	local giftData = self.packageInfo[index + 1]
	local curPackageInfo = anniversaryTreasureHuntRead:getTreasureHuntPackageInfo(giftData.packageID)
	target:initData(self.packageInfo[index + 1], self.payType)
	local curPrice = paymentManager.judgePrice(curPackageInfo.index, curPackageInfo.price)
	anniversaryTreasureHuntRead = nil
	;(nil).price = curPrice
	;(nil).rechargeID = curPackageInfo.index
	table.insert(self.rechargeIDList, index + 1, nil)
end
function treasureHuntMerchantPopPanel:initData()
	local packageInfo = anniversaryTreasureHuntCtrl:getMerchantGridInfo()
	if not next(packageInfo) then
		return
	end
	self:updateScroll()
	SoraDCreateRechargeGiftNode(self.rechargeIDList, self.fields.NodeGift, cc.p(SoraDFPosX(-140, 0), 0))
end
function treasureHuntMerchantPopPanel:updateScroll()
	self.rechargeIDList, _ENV = nil, nil
	self.packageInfo = self:getPackageInfo()
	dump(self.packageInfo, "self.packageInfo")
	self.fields.List_item:setNumItems(#self.packageInfo)
end
function treasureHuntMerchantPopPanel:onClickClose()
	SoraDPlaySound()
	if self:checkAllBuy() then
		anniversaryTreasureHuntCtrl:reqCancelBuyPackageMsg()
		SoraDShowLoading()
	else
		SoraDShowMsgBox(i18n("anniversary_text_11"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				anniversaryTreasureHuntCtrl:reqCancelBuyPackageMsg()
				SoraDShowLoading()
			end
		end)
	end
end
function treasureHuntMerchantPopPanel:onClickTab(tag)
	self.payType = tag
	self:updateScroll()
end
function treasureHuntMerchantPopPanel:getPackageInfo()
	local packageInfo = anniversaryTreasureHuntCtrl:getMerchantGridInfo()
	local anniversaryTreasureHuntCtrl, curInfo = anniversaryTreasureHuntCtrl, anniversaryTreasureHuntCtrl
	local roundIndex = 1
	for k, v in pairs(packageInfo) do
		table.insert(curInfo, v)
		curInfo[roundIndex].level = tonumber(k)
		roundIndex = roundIndex + 1
	end
	return curInfo
end
function treasureHuntMerchantPopPanel:checkAllBuy()
	for i, v in ipairs(self.packageInfo) do
		if not v.purchased then
			return false
		end
	end
	return true
end
return treasureHuntMerchantPopPanel
