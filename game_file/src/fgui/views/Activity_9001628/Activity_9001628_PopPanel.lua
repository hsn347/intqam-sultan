local activity_9001628_Read = include("activity_9001628_Read")
local activity_9001628_Ctrl = SoraDGetCtrl("activity_9001628_Ctrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001628_PopPanel = class("Activity_9001628_PopPanel", baseFguiPanel)
function Activity_9001628_PopPanel:ctor(...)
	Activity_9001628_PopPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001628_PopPanel:ctor", self.viewName)
end
function Activity_9001628_PopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001628_PopPanel:onInit()
	print("=======Activity_9001628_PopPanel:onInit")
	self.rechargeIDList, _ENV = print, print
	self.fields.text_saohua:setString(i18n("anniversary_dice_text_15"))
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
function Activity_9001628_PopPanel:onShow()
	print("=======Activity_9001628_PopPanel:onShow")
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
	self:initData()
end
function Activity_9001628_PopPanel:onItemRederer(index, target)
	local giftData = self.packageInfo[index + 1]
	local curPackageInfo = activity_9001628_Read:getTreasureHuntPackageInfo(giftData.packageID)
	target:initData(self.packageInfo[index + 1], self.payType)
	local curPrice = paymentManager.judgePrice(curPackageInfo.index, curPackageInfo.price)
	activity_9001628_Read = nil
	;(nil).price = curPrice
	;(nil).rechargeID = curPackageInfo.index
	table.insert(self.rechargeIDList, index + 1, nil)
end
function Activity_9001628_PopPanel:initData()
	local packageInfo = activity_9001628_Ctrl:getMerchantGridInfo()
	if not next(packageInfo) then
		print("======= Activity_9001628_PopPanel:initData")
		return
	end
	self:updateScroll()
	if G_IS_UNITY then
		SoraDCreateRechargeGiftNode(self.rechargeIDList, self.fields.NodeGift, cc.p(-140, 0))
	else
		SoraDCreateRechargeGiftNode(self.rechargeIDList, self.fields.NodeGift:displayObject():getChildren()[1], cc.p(-140, 0))
	end
end
function Activity_9001628_PopPanel:updateScroll()
	self.rechargeIDList, _ENV = nil, nil
	self.packageInfo = self:getPackageInfo()
	dump(self.packageInfo, "self.packageInfo")
	self.fields.List_item:setNumItems(#self.packageInfo)
end
function Activity_9001628_PopPanel:onClickClose()
	SoraDPlaySound()
	self:close()
end
function Activity_9001628_PopPanel:onClickTab(tag)
	self.payType = tag
	self:updateScroll()
end
function Activity_9001628_PopPanel:getPackageInfo()
	local packageInfo = activity_9001628_Ctrl:getMerchantGridInfo()
	dump(packageInfo, "packageInfo")
	local activity_9001628_Ctrl, curInfo = dump, dump
	local roundIndex = 1
	for k, v in pairs(packageInfo) do
		table.insert(curInfo, v)
		curInfo[roundIndex].level = tonumber(k)
		roundIndex = roundIndex + 1
	end
	table.sort(curInfo, function(a, b)
		return a.packageID < b.packageID
	end)
	return curInfo
end
function Activity_9001628_PopPanel:checkAllBuy()
	for i, v in ipairs(self.packageInfo) do
		if not v.purchased then
			return false
		end
	end
	return true
end
return Activity_9001628_PopPanel
