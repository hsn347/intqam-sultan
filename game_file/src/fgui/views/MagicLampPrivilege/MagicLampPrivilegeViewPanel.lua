local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
local privilegeGiftRead = include("privilegeGiftRead")
local rechargeRead = include("rechargeRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampPrivilegeViewPanel = class("MagicLampPrivilegeViewPanel", baseFguiPanel)
function MagicLampPrivilegeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampPrivilegeViewPanel:ctor", self.viewName)
end
function MagicLampPrivilegeViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RechargeView"
	end
	return self._packageList
end
function MagicLampPrivilegeViewPanel:onInit()
	print("=======MagicLampPrivilegeViewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_4786"), handler(self, self.onClickClose))
	self.fields.Button_left:addTouchEventListener(handler(self, self.btnLeftPageClick))
	self.fields.Button_right:addTouchEventListener(handler(self, self.btnRightPageClick))
	self.fields.List:setVirtualAndLoop()
	self.fields.List:setItemRenderer(handler(self, self.onPageItemRenderer))
	self.fields.Button_buy:addClickListener(handler(self, self.readyBuy))
	self.fields.rechargeGift:fixPos()
	self.fields.rechargeGift:fixNodePos()
end
function MagicLampPrivilegeViewPanel:onTabClick(tag)
	if tag ~= self.tag then
		self.tag = tag
		self:initData()
	end
end
function MagicLampPrivilegeViewPanel:onPageItemRenderer(index, obj)
	obj:initData(self.magicLampList[index + 1])
end
function MagicLampPrivilegeViewPanel:endShow()
	print("=======MagicLampPrivilegeViewPanel:onShow")
	self.privilegeType = self.param and self.param.privilegeType or gRechargePrivilegeType.magiclamp
	self.fromCenter = self.param and self.param.fromCenter or gRechargeActiveFromEnum.ROAD49
	self.isSinglePage = self.param and self.param.isSinglePage or false
	self.magicLampList, _ENV, self.unlockTime = constantRead.getConstValue("ANILA_LAMP_PRIVILEGE_UNLOCK_TIME"), constantRead.getConstValue("ANILA_LAMP_PRIVILEGE_UNLOCK_TIME"), constantRead.getConstValue("ANILA_LAMP_PRIVILEGE_UNLOCK_TIME")
	self.packageIndex = 1
	self.isPageTurn = false
	self.tag = 1
	self.isJinnTwoUnlock = magicLampCtrl:getIsJinnUnlock(gJinnType.JINN_TWO) and serviceFunctions.systemTime() >= self.unlockTime
	if self.privilegeType == gRechargePrivilegeType.star then
		_ENV = gJinnType.JINN_TWO
		_ENV, _ENV, gJinnType.JINN_TWO.defaultClick = nil, self.tag, self.tag
		;(nil).title = i18n("castle_privilege_title_01")
		_ENV, self.tag[1], (nil).tag = nil, nil, 1
		;(nil).title = i18n("castle_privilege_title_02")
		gJinnType.JINN_TWO.tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
		gJinnType.JINN_TWO.callback = handler(self, self.onTabClick)
		self.fields.com_Tab:initView(gJinnType.JINN_TWO)
	elseif self.privilegeType == gRechargePrivilegeType.magiclamp and self.isJinnTwoUnlock and #magicLampCtrl:getMagicLampGift(gJinnType.JINN_TWO) > 0 then
		self.tag = 2
		_ENV = gJinnType.JINN_TWO
		_ENV, _ENV, gJinnType.JINN_TWO.defaultClick = self, self.tag, self.tag
		self.title = i18n("magic_lamp_name_01")
		_ENV, self.tag[1], self.tag = self, self, 1
		self.title = i18n("magic_lamp_name_02")
		gJinnType.JINN_TWO.tabsetArray, self.tag[2], self.tag = self.tag, self, 2
		gJinnType.JINN_TWO.callback = handler(self, self.onTabClick)
		self.fields.com_Tab:initView(gJinnType.JINN_TWO)
	end
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, function()
		local itemIndex = self.fields.List:childIndexToItemIndex(0)
		self.packageIndex = itemIndex % #self.magicLampList + 1
		print("itemIndex=====", itemIndex, self.packageIndex)
		self.isPageTurn = true
		self:setPageView(false)
	end)
	self.fields.List:setScrollEnable(not self.isSinglePage)
	self:initData()
end
function MagicLampPrivilegeViewPanel:initData()
	self.magicLampList, _ENV = nil, nil
	self.packageIndex = 1
	local _ENV, castleGift
	if self.privilegeType == gRechargePrivilegeType.castle then
		self.magicLampList = privilegeGiftCtrl:getCurCanBuyRechargeID()
	elseif self.privilegeType == gRechargePrivilegeType.wall then
		self.magicLampList = privilegeGiftCtrl:getCurWallGiftRechargeID()
	elseif self.privilegeType == gRechargePrivilegeType.star then
		castleGift = privilegeGiftCtrl:getCurCanBuyRechargeID()
		local starGift = privilegeGiftCtrl:getCurStarLvCanBuyRechargeID()
		if 0 < #castleGift then
			self.magicLampList = self.tag == 2 and starGift or castleGift
		else
			self.magicLampList = starGift
		end
	elseif self.privilegeType == gRechargePrivilegeType.magiclamp then
		self.magicLampList = magicLampCtrl:getMagicLampGift(self.tag)
		self.packageIndex = self.isSinglePage and 1 or #self.magicLampList
	end
	local showIndex = 0
	if self.privilegeType == gRechargePrivilegeType.star and 0 < #castleGift or self.privilegeType == gRechargePrivilegeType.magiclamp and self.isJinnTwoUnlock and 0 < #magicLampCtrl:getMagicLampGift(gJinnType.JINN_TWO) then
		showIndex = 1
	end
	self.controllers.c1:setSelectedIndex(showIndex)
	if self.privilegeType == gRechargePrivilegeType.star and #castleGift == 0 then
		self.fields.Com_title:updateTitle(i18n("castle_privilege_title_02"))
	else
		self.fields.Com_title:updateTitle(self.param and self.param.title or i18n("common_text_4786"))
	end
	if #self.magicLampList <= 0 then
		self:close()
		return
	end
	self:initView()
end
function MagicLampPrivilegeViewPanel:initView()
	self.fields.Button_left:setVisible(not self.isSinglePage and #self.magicLampList > 1)
	self.fields.Button_right:setVisible(not self.isSinglePage and #self.magicLampList > 1)
	self.fields.Com_indicator:setVisible(not self.isSinglePage and #self.magicLampList > 1)
	self.fields.Com_indicator:reserLastIndex()
	_UPVALUE0_ = not self.isSinglePage and #self.magicLampList > 1
	;(not self.isSinglePage and #self.magicLampList > 1).count = #self.magicLampList
	;(not self.isSinglePage and #self.magicLampList > 1).intervalWidth = 8
	;(not self.isSinglePage and #self.magicLampList > 1).begin = self.packageIndex
	self.fields.Com_indicator:initData(not self.isSinglePage and #self.magicLampList > 1)
	self.fields.List:setNumItems(self.isSinglePage and 1 or #self.magicLampList)
	self.fields.List:scrollToView(self.packageIndex - 1)
	self:setPageView(false)
end
function MagicLampPrivilegeViewPanel:setCurLight()
	self.fields.Com_indicator:setCurLight(self.packageIndex)
end
function MagicLampPrivilegeViewPanel:setPageView(isAni)
	self.fields.List:scrollToView(self.packageIndex - 1, isAni)
	self:setCurLight()
	local giftCfg = self.magicLampList[self.packageIndex]
	if type(giftCfg) == "number" then
		self.showGift = privilegeGiftRead.getRechargeGiftByID(giftCfg) or privilegeGiftRead.getStarRechargeGiftByID(giftCfg)
	else
		self.showGift = giftCfg
	end
	self.fields.Com_giftCar:setVisible(shoppingCartCtrl:isValidUse())
	self.fields.Com_giftCar:setGiftID(self.showGift.rechargeID)
	if self.showGift.targetID and self.privilegeType == gRechargePrivilegeType.magiclamp then
		self.fields.Banner:setIcon(privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true))
		local colorStr = fguiHelper.getColorString("#FFFFFF", self.showGift.lv)
		_ENV = privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true)
		privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true).name = privilegeGiftRead.getMagicLampJinnName(self.showGift.targetID)
		privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true).lv = colorStr
		self.fields.Text_giftName:setString(i18n("rechare_activename_2100", privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true)))
	else
		self.fields.Banner:setIcon("bg_cbsj_head_01.png")
		local giftStyle = rechargeRead.getPageViewData(self.showGift.rechargeID)
		local colorStr = fguiHelper.getColorString("#FFFFFF", giftStyle.activeName.lv or giftStyle.activeName.num)
		_ENV = i18n("rechare_activename_2100", privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true))
		i18n("rechare_activename_2100", privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true)).lv = colorStr
		i18n("rechare_activename_2100", privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true)).num = colorStr
		self.fields.Text_giftName:setString(i18n(giftStyle.activeName[1], i18n("rechare_activename_2100", privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true))))
	end
	self.fields.Com_disTop:initData(self.showGift)
	local str_resource = SoraDConvertNumberWithUnit(self.showGift.totalResource)
	local str_hour = math.floor(self.showGift.totalSpeed / 3600)
	_ENV = i18n(giftStyle.activeName[1], i18n("rechare_activename_2100", privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true)))
	i18n(giftStyle.activeName[1], i18n("rechare_activename_2100", privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true))).resource = str_resource
	i18n(giftStyle.activeName[1], i18n("rechare_activename_2100", privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true))).hour = str_hour
	self.fields.Text_tips:setString(i18n("common_text_3989", i18n(giftStyle.activeName[1], i18n("rechare_activename_2100", privilegeGiftRead.getMagicLampJinnPng(self.showGift.targetID, true)))))
	local showPrice, isGetPrice = paymentManager.judgePrice(self.showGift.rechargeID, self.showGift.price)
	local discount = self.showGift.originalPrice / self.showGift.price
	local oriShowPrice = paymentManager.calculateDiscount(self.showGift.rechargeID, showPrice, discount, self.showGift.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self.fields.Button_buy:initData(self.nowPrice, self.oriPrice)
	self:updateOutAppPurchase()
end
function MagicLampPrivilegeViewPanel:updateOutAppPurchase()
	local rid = self.showGift.rechargeID
	if SoraDCheckOAPIsOpen(rid) then
		self.fields.outAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = rid
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		self.oriPrice.fromCenter = self.fromCenter
		;(false).logInfo, self.oriPrice.isPageTurn = self.oriPrice, self.isPageTurn
		;(false).handlePurchaseBack = handler(self, self.initData)
		;(false).handleBuyClick = handler(self, self.readyBuy)
		self.fields.outAppPurchaseButtons:initData(false)
	else
		self.fields.outAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:setVisible(true)
	end
	_ENV, _UPVALUE1_ = self.fields.Button_buy, self.fields.Button_buy.setVisible
	self.fields.Button_buy.rechargeID = self.showGift.rechargeID
	local self.fields.Button_buy.setVisible[1], rechargeIDList = self.fields.Button_buy, self.fields.Button_buy.setVisible
	self.fields.rechargeGift:initData(rechargeIDList)
end
function MagicLampPrivilegeViewPanel:turnPage(actionFoward)
	self.packageIndex = actionFoward and self.packageIndex - 1 or self.packageIndex + 1
	local isAni = true
	if self.packageIndex < 1 then
		self.packageIndex = #self.magicLampList
		isAni = false
	elseif self.packageIndex > #self.magicLampList then
		self.packageIndex = 1
		isAni = false
	end
	self:setPageView(isAni)
end
function MagicLampPrivilegeViewPanel:btnLeftPageClick()
	SoraDPlaySound()
	self.isPageTurn = true
	self:turnPage(true)
end
function MagicLampPrivilegeViewPanel:btnRightPageClick()
	SoraDPlaySound()
	self.isPageTurn = true
	self:turnPage(false)
end
function MagicLampPrivilegeViewPanel:readyBuy()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.showGift.rechargeID)
	paymentManager.OnemtReadyBuy(self.showGift.rechargeID, self.fromCenter, self.isPageTurn)
end
return MagicLampPrivilegeViewPanel
