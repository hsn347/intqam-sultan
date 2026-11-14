local ladderGiftCtrl = SoraDGetCtrl("ladderGiftCtrl")
local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local privilegeGiftRead = include("privilegeGiftRead")
local rechargeRead = include("rechargeRead")
local publicRead = include("publicRead")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local vipPrivilegeGiftPopViewPanel = class("vipPrivilegeGiftPopViewPanel", baseFguiPanel)
function vipPrivilegeGiftPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("vipPrivilegeGiftPopViewPanel:ctor", self.viewName)
end
function vipPrivilegeGiftPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function vipPrivilegeGiftPopViewPanel:onInit()
	print("=======vipPrivilegeGiftPopViewPanel:onInit")
	self.itemList, _ENV = print, print
	self.fields.text_instance:setString(i18n("common_text_4061") .. ":" .. fguiHelper.getColorString("#FFD43E", i18n("common_text_3990")))
	self.fields.Button_left:addClickListener(handler(self, self.btnLeftClick))
	self.fields.Button_right:addClickListener(handler(self, self.btnRightClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.Lab_discount:fixPos()
	self.fields.Text_gold:fixPos()
	self.fields.text_instance:fixPos()
end
function vipPrivilegeGiftPopViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1])
end
function vipPrivilegeGiftPopViewPanel:onShow()
	print("=======vipPrivilegeGiftPopViewPanel:onShow")
	self.curLv = self.param.curLv
	self.isKLVOpen = kingdomLevelDataModuleAPI:isOpen()
	self.vipInfo = lordInfoCtrl:getVipDetails()
	self.maxVipLv = self.isKLVOpen and VIP_MAX_LV - 1 or VIP_SVIP_LV
	self:initData(self.curLv)
end
function vipPrivilegeGiftPopViewPanel:initData(curLv)
	self.curLv = curLv
	local packageInfo = privilegeGiftRead.getVipPrivilegePackageDataByLv(self.curLv)
	self.rechargeID = packageInfo.rechargeID
	local packageName = i18n(rechargeRead.getPageViewData(packageInfo.rechargeID).activeName)
	local retValue = privilegeGiftCtrl:getErrByRechargeID(packageInfo.rechargeID)
	self.nowPrice = paymentManager.judgePrice(packageInfo.rechargeID, packageInfo.price)
	local discount = packageInfo.originalPrice / packageInfo.price
	self.oriPrice = paymentManager.calculateDiscount(packageInfo.rechargeID, self.nowPrice, discount, packageInfo.originalPrice)
	self.fields.Text_name:setString(packageName)
	self.fields.Lab_discount:setString(packageInfo.discount[2] .. "%")
	self.fields.Text_gold:setString(string.formatnumberthousands(packageInfo.gold))
	rechargeRead = string.formatnumberthousands(packageInfo.gold)
	string.formatnumberthousands(packageInfo.gold)[1] = "id"
	string.formatnumberthousands(packageInfo.gold)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(packageInfo.rewards, string.formatnumberthousands(packageInfo.gold))
	self.fields.List:setNumItems(#self.itemList)
	self:updateOutAppPurchase(retValue == gErrDef.Err_None or retValue == gErrDef.Err_PRIVILEGE_GIFT_VIP_LV_NOT_ENOUGH)
	self.fields.Button_buy:initData(retValue, self.nowPrice, self.oriPrice)
end
function vipPrivilegeGiftPopViewPanel:updateOutAppPurchase(isShow)
	if isShow and SoraDCheckOAPIsOpen(self.rechargeID) then
		self.fields.Com_OAP:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.rechargeID
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleItemBuyClick = handler(self, self.handleItemBuyClick)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.fields.Com_OAP:initData(false)
	else
		self.fields.Com_OAP:setVisible(false)
		self.fields.Button_buy:setVisible(true)
	end
	_ENV, _UPVALUE1_ = self.fields.Button_buy, self.fields.Button_buy.setVisible
	self.fields.Button_buy.rechargeID = self.rechargeID
	local self.fields.Button_buy.setVisible[1], rechargeIDList = self.fields.Button_buy, self.fields.Button_buy.setVisible
	if SoraDisShowRechargeGiftNode(rechargeIDList) then
		self.fields.Com_gift:initData(rechargeIDList)
		self.fields.Com_gift:setVisible(true)
	else
		self.fields.Com_gift:setVisible(false)
	end
end
function vipPrivilegeGiftPopViewPanel:handleItemBuyClick()
	local retValue = privilegeGiftCtrl:getErrByRechargeID(self.rechargeID)
	if retValue == gErrDef.Err_PRIVILEGE_GIFT_VIP_LV_NOT_ENOUGH then
		local comStr = ""
		if self.curLv <= VIP_SVIP_LV then
			if self.vipInfo.level < self.curLv then
				comStr = i18n("common_text_1147")
			end
		elseif self.vipInfo.level < self.curLv then
			comStr = i18n("common_text_4456")
		end
		SoraDShowMsgTip(comStr)
		return false
	end
	if retValue == gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY then
		SoraDShowMsgTip(i18n("common_text_3833"))
		return false
	end
	return true
end
function vipPrivilegeGiftPopViewPanel:purchaseBack()
	self:close()
end
function vipPrivilegeGiftPopViewPanel:btnLeftClick()
	SoraDPlaySound()
	if SoraDFIsRA() then
		self.curLv = self.curLv + 1
		if self.curLv > self.maxVipLv then
			self.curLv = 1
		end
	else
		self.curLv = self.curLv - 1
		if self.curLv < 1 then
			self.curLv = self.maxVipLv
		end
	end
	self:initData(self.curLv)
end
function vipPrivilegeGiftPopViewPanel:btnRightClick()
	SoraDPlaySound()
	if SoraDFIsRA() then
		self.curLv = self.curLv - 1
		if self.curLv < 1 then
			self.curLv = self.maxVipLv
		end
	else
		self.curLv = self.curLv + 1
		if self.curLv > self.maxVipLv then
			self.curLv = 1
		end
	end
	self:initData(self.curLv)
end
function vipPrivilegeGiftPopViewPanel:btnBuyClick()
	SoraDPlaySound()
	local retValue = privilegeGiftCtrl:getErrByRechargeID(self.rechargeID)
	if retValue == gErrDef.Err_PRIVILEGE_GIFT_VIP_LV_NOT_ENOUGH then
		local comStr = ""
		if self.curLv <= VIP_SVIP_LV then
			if self.vipInfo.level < self.curLv then
				comStr = i18n("common_text_1147")
			end
		elseif self.vipInfo.level < self.curLv then
			comStr = i18n("common_text_4456")
		end
		SoraDShowMsgTip(comStr)
		return
	end
	if retValue == gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY then
		SoraDShowMsgTip(i18n("common_text_3833"))
		return
	end
	paymentManager.normalGiftBuyClassify(self.rechargeID)
end
return vipPrivilegeGiftPopViewPanel
