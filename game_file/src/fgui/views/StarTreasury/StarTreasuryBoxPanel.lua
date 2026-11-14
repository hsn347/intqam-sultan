local baseFguiPanel = require("fgui.base.baseFguiPanel")
local publicRead = include("publicRead")
local starTreasuryRead = include("starTreasuryRead")
local starTreasuryCtrl = SoraDGetCtrl("starTreasuryCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local buildDescribeRead = include("buildDescribeRead")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local StarTreasuryBoxPanel = class("StarTreasuryBoxPanel", baseFguiPanel)
function StarTreasuryBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarTreasuryBoxPanel:ctor", self.viewName)
end
function StarTreasuryBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarTreasuryBoxPanel:onInit()
	print("=======StarTreasuryBoxPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("star_treasury_2"))
	self.fields.btn_isGot:setTitle(i18n("common_text_3833"))
	self.fields.title2:setString(i18n("star_treasury_4"))
	self.fields.btn_left:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and 1 or -1)
	self.fields.btn_right:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and -1 or 1)
	local sType = starTreasuryCtrl:getSType()
	self.boxCfgs = starTreasuryRead.getBoxList(sType)
	self.boxIdx = self.param.boxIdx
	self.fields.list1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.list2:setItemRenderer(handler(self, self.onItemRenderer2))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_buyOAP:addClickListener(handler(self, self.onClickBuy))
end
function StarTreasuryBoxPanel:onShow()
	print("=======StarTreasuryBoxPanel:onShow")
	self:updateView()
end
function StarTreasuryBoxPanel:updateView()
	self.curBoxCfg = self.boxCfgs[self.boxIdx]
	self.preBoxCfg = self.boxCfgs[self.boxIdx - 1]
	self.itemId = self.curBoxCfg.itemId
	self.boxReward = backpackltCtrl:getRandomGiftShowItems(self.itemId)
	self.boxName = publicRead.getName(self.itemId)
	backpackltCtrl = nil
	;(nil).name = self.boxName
	self.fields.title1:setString(i18n("star_treasury_3", nil))
	self.fields.box_name:setString(self.boxName)
	backpackltCtrl = i18n("star_treasury_3", nil)
	i18n("star_treasury_3", nil).num = self.curBoxCfg.totalNum
	i18n("star_treasury_3", nil).price = self.curBoxCfg.value
	self.fields.title3:setString(i18n("star_treasury_5", i18n("star_treasury_3", nil)))
	self.fields.list1:setNumItems(#self.boxReward)
	self.fields.list2:setNumItems(#self.curBoxCfg.totalReward)
	local icon = self.curBoxCfg.icon == "" and "icon_ghbk_xz_01.png" or self.curBoxCfg.icon
	self.fields.boxIcon:setURL(icon)
	self.fields.Usm_2:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_2:clearEffect()
	self.fields.Usm_2:stopAllActions()
	self.fields.Usm_2:setAlpha(0)
	self.fields.Usm_2:runAction(ffa.fadeIn(0.3))
	self.fields.Usm_2:setEffectPath("G_ghbk_baoxiang" .. self.boxIdx .. ".usm")
	local isRecord = starTreasuryCtrl:getIsBoxRecord(self.curBoxCfg.recharge)
	local isPreRecord = self.preBoxCfg == nil and true or starTreasuryCtrl:getIsBoxRecord(self.preBoxCfg.recharge)
	if isRecord then
		self.controllers.c1:setSelectedIndex(3)
	elseif not isPreRecord then
		self.controllers.c1:setSelectedIndex(2)
		backpackltCtrl = ffa.fadeIn(0.3)
		ffa.fadeIn(0.3).name = publicRead.getName(self.preBoxCfg.itemId)
		self.fields.tips:setString(i18n("star_treasury_6", ffa.fadeIn(0.3)))
	elseif not isRecord and isPreRecord then
		self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
		self:updateBuyButton()
	end
	self.fields.price_title:setString(self.curBoxCfg.Discount .. "%")
	local isAddEnable = self.boxCfgs[self.boxIdx + 1] ~= nil
	local isMinEnable = self.boxCfgs[self.boxIdx - 1] ~= nil
	if SoraDFIsRA() then
		self.fields.btn_left:setVisible(isAddEnable)
		self.fields.btn_right:setVisible(isMinEnable)
	else
		self.fields.btn_left:setVisible(isMinEnable)
		self.fields.btn_right:setVisible(isAddEnable)
	end
end
function StarTreasuryBoxPanel:onItemRenderer1(index, object)
	local data = self.boxReward[index + 1]
	object:initData(data.id, data.count)
end
function StarTreasuryBoxPanel:onItemRenderer2(index, object)
	local data = self.curBoxCfg.totalReward[index + 1]
	object:initData(data.id, data.count)
end
function StarTreasuryBoxPanel:updateBuyButton()
	self.fields.Button_buyOAP:initData(nil, nil, self.curBoxCfg.recharge)
	local nowPrice = paymentManager.judgePrice(self.curBoxCfg.recharge, self.curBoxCfg.price)
	local discount = self.curBoxCfg.OriginalPrice / self.curBoxCfg.price
	local oriPrice = paymentManager.calculateDiscount(self.curBoxCfg.recharge, nowPrice, discount, self.curBoxCfg.OriginalPrice)
	self.fields.Button_buy:initData(nowPrice, oriPrice, self.curBoxCfg.recharge)
end
function StarTreasuryBoxPanel:onPageClick(sender, params)
	SoraDPlaySound()
	local curIndex = self.boxIdx + params
	if self.boxCfgs[curIndex] == nil then
		if 0 < params then
			curIndex = #self.boxCfgs
		else
			curIndex = 1
		end
	end
	self.boxIdx = curIndex
	self:updateView()
end
function StarTreasuryBoxPanel:onClickBuy(eventContext)
	SoraDPlaySound()
	local name = eventContext:getSender():getName()
	local func = function()
		if name == "Button_buy" then
			starTreasuryCtrl:sendBuy(self.curBoxCfg.recharge)
			paymentManager.OnemtReadyBuy(self.curBoxCfg.recharge, gRechargeActiveFromEnum.ROAD43)
		elseif name == "Button_buyOAP" then
			name, name = nil, gRechargeActiveFromEnum.ROAD43
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD43
			SoraDShowH5PurchaseView(self.curBoxCfg.recharge, gRechargeActiveFromEnum.ROAD43, nil)
		end
		self:close()
	end
	local qType = self.curBoxCfg.tipsLv[1]
	local qValue1 = self.curBoxCfg.tipsLv[2]
	local qValue2 = self.curBoxCfg.tipsLv[3]
	dump(self.curBoxCfg, "self.curBoxCfg")
	dump(qValue2, "qValue2")
	if qType == 1 and qValue2 > SoraDGetBuildStarLv(qValue1) or qType == 2 and qValue2 > magicLampCtrl:getJinnLv(qValue1) then
		local callBackHandle = function(exitType)
			if MSGBOX_CALLBACK_YES == exitType then
				SoraDPlaySound()
				func()
			end
		end
		local str
		if qType == 1 then
			_ENV = nil
			;(nil).build = buildDescribeRead.getName(qValue1, qValue2)
			;(nil).name = self.boxName
			str = i18n("star_treasury_8", nil)
		elseif qType == 2 then
			_ENV = nil
			;(nil).lamp = magicLampRead.getJinnName(qValue1, 0)
			;(nil).name = self.boxName
			str = i18n("star_treasury_11", nil)
		end
		SoraDShowMsgBox(str, i18n("common_text_054"), i18n("common_text_185"), callBackHandle)
	else
		func()
	end
end
return StarTreasuryBoxPanel
