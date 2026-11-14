local baseFguiPanel = require("fgui.base.baseFguiPanel")
local caracalUpgradePanel = class("caracalUpgradePanel", baseFguiPanel)
local newServerPetRead = include("newServerPetRead")
local newServerPetCtrl = SoraDGetCtrl("newServerPetCtrl")
function caracalUpgradePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("caracalUpgradePanel:ctor", self.viewName)
end
function caracalUpgradePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function caracalUpgradePanel:onInit()
	print("=======caracalUpgradePanel:onInit")
	local rewardConfing = newServerPetRead.getReturnCatRewardConfig()
	self.rechargeID = 19035
	paymentManager.OnemtOpenGiftUI(self.rechargeID, gRechargeActiveFromEnum.ROAD13)
	self.fields.Panel_bg:setTitle(i18n("return_lcks_text_030"))
	self.fields.Text_name2:setString(i18n("pet_name_14"))
	self.fields.Text_name1:setString(i18n("pet_name_13"))
	self.fields.Text_reward1:setString(i18n("return_lcks_text_031"))
	self.fields.Text_des1:setString(i18n("return_lcks_text_032"))
	self.fields.Text_des2:setString(i18n("return_lcks_text_033"))
	self.fields.Text_reward2:setString(i18n("return_lcks_text_034"))
	self.fields.Text_lockCondi:setString(i18n("return_lcks_text_014"))
	self.fields.Text_unlock:setString(i18n("return_lcks_text_030"))
	self.fields.Button_unlock:addClickListener(handler(self, self.onClickUnlock))
	self.fields.scroll_1:setVirtual()
	self.fields.scroll_1:setItemRenderer(handler(self, self.cellRender1))
	self.fields.scroll_2:setVirtual()
	self.fields.scroll_2:setItemRenderer(handler(self, self.cellRender2))
	self.fields.scroll_3:setVirtual()
	self.fields.scroll_3:setItemRenderer(handler(self, self.cellRender3))
end
function caracalUpgradePanel:onShow()
	print("=======caracalUpgradePanel:onShow")
	self.curPetLv = newServerPetCtrl:getInitData().curPetLv
	self.configs = self:getRewardConfig()
	self.fields.scroll_1:setNumItems(#self.configs[1])
	self.fields.scroll_2:setNumItems(#self.configs[2])
	self.fields.scroll_3:setNumItems(#self.configs[3])
	if SoraDFIsRA() then
		self.fields.scroll_1:scrollToView(#self.configs[1] - 1)
		self.fields.scroll_2:scrollToView(#self.configs[2] - 1)
		self.fields.scroll_3:scrollToView(#self.configs[3] - 1)
	end
	self.controllers.c1:setSelectedIndex(self.curPetLv < 2 and 0 or 1)
	self.controllers.c3:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
	if self.curPetLv >= 2 then
		local info = paymentManager.getPaymentBullets(self.rechargeID)
		local priceStr, __ = paymentManager.getRealPrice(info and info.pid, 9.99)
		self.fields.Text_price:setString(priceStr)
		self.priceStr = priceStr
		_ENV, newServerPetCtrl = priceStr, self.fields.Text_price
		priceStr.rechargeID = self.rechargeID
		self.fields.Text_price[1] = priceStr
		SoraDCreateRechargeGiftNode(self.fields.Text_price, self.fields.Node_bottom, cc.p(SoraDFPosX(-190, 0), 8))
	end
	_ENV = paymentManager.getRealPrice(info and info.pid, 9.99)
	paymentManager.getRealPrice(info and info.pid, 9.99).rid = self.rechargeID
	paymentManager.getRealPrice(info and info.pid, 9.99).nowPrice = self.priceStr
	_ENV, paymentManager.getRealPrice(info and info.pid, 9.99).hideDicountLine = self.priceStr, true
	paymentManager.getRealPrice(info and info.pid, 9.99).logInfo, self.priceStr.fromCenter = self.priceStr, gRechargeActiveFromEnum.ROAD13
	paymentManager.getRealPrice(info and info.pid, 9.99).oriPrice = i18n("return_lcks_text_030")
	paymentManager.getRealPrice(info and info.pid, 9.99).handleBuyClick = handler(self, self.onClickUnlock)
	paymentManager.getRealPrice(info and info.pid, 9.99).handlePurchaseBack = handler(self, self.close)
	self.fields.Com_OutAppPurchaseButtons:initData(paymentManager.getRealPrice(info and info.pid, 9.99))
end
function caracalUpgradePanel:onHide()
	print("=======caracalUpgradePanel:onHide")
end
function caracalUpgradePanel:onDispose()
	print("=======caracalUpgradePanel:onDispose")
end
function caracalUpgradePanel:cellRender1(index, obj)
	local data = self.configs[1][index + 1]
	obj:initData(data.id, data.count)
	obj:setEffectShow(true)
end
function caracalUpgradePanel:cellRender2(index, obj)
	local data = self.configs[2][index + 1]
	obj:initData(data.id, data.count)
end
function caracalUpgradePanel:cellRender3(index, obj)
	local data = self.configs[3][index + 1]
	obj:initData(data.id, data.count)
	obj:setEffectShow(true)
end
function caracalUpgradePanel:onClickUnlock()
	SoraDPlaySound()
	paymentManager.OnemtReadyBuy(self.rechargeID, gRechargeActiveFromEnum.ROAD13)
	paymentManager.normalGiftBuyClassify(self.rechargeID)
end
function caracalUpgradePanel:getRewardConfig(...)
	local expConfig = newServerPetRead.getReturnCatExpConfig()
	local newServerPetRead, allReward
	local newServerPetRead, curReward
	local newServerPetRead, tempTab
	for i, v in ipairs(expConfig) do
		if not v.highReward then
			newServerPetRead = v.highReward
		end
		for m, n in ipairs(v.highReward) do
			local index = tempTab[tostring(n.id)]
			if index then
				allReward[index].count = allReward[index].count + n.count
				if v.lv <= self.curPetLv then
					curReward[index].count = curReward[index].count + n.count
				end
			else
				newServerPetRead = n.count
				n.count.id = n.id
				n.count.count = n.count
				table.insert(allReward, n.count)
				if v.lv <= self.curPetLv then
					newServerPetRead = n.count
					n.count.id = n.id
					n.count.count = n.count
					table.insert(curReward, n.count)
				end
				tempTab[tostring(n.id)] = #allReward
			end
		end
	end
	local rewardConfing = newServerPetRead.getReturnCatRewardConfig()
	local highWalkReward = rewardConfing.highWalkReward
	newServerPetRead = ipairs(expConfig)
	ipairs(expConfig)[1] = allReward
	ipairs(expConfig)[2] = highWalkReward
	local ipairs(expConfig)[3], config = curReward, ipairs(expConfig)
	return config
end
return caracalUpgradePanel
