local limitTimeDiscountShopAPI = include("limitTimeDiscountShopAPI")
local allianceDesRead = include("allianceDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local bagViewPanel = class("bagViewPanel", baseFguiPanel)
function bagViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("bagViewPanel:ctor", self.viewName)
end
function bagViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function bagViewPanel:onInit()
	print("=======bagViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.tag = self.param and self.param.type or 0
	self.fields.Com_title:initData(i18n("common_text_307"), handler(self, self.onClickClose))
	_ENV = i18n("common_text_307")
	_ENV, _ENV, i18n("common_text_307").defaultClick = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_309")
	_ENV, self.tag[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_270")
	i18n("common_text_307").tabsetArray, self.tag[2], handler(self, self.onClickClose).tag = self.tag, handler(self, self.onClickClose)
	i18n("common_text_307").callback = handler(self, self.onClickTab)
	self.fields.Tab:initView((i18n("common_text_307")))
	self.fields.Particle_1:fixPos()
	self.fields.icon_new:fixPos()
	self.fields.bag.chatDelegate = self
	self.fields.maskArea:addEventListener(fgui.UIEventType.Click, handler(self, self.hideKeyboardMask))
end
function bagViewPanel:onShow()
	print("=======bagViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.controllers.c1:setSelectedIndex(self.tag)
	self:updateDiscount()
	self:updateNewTag()
	if self.param and self.param.jumpTab then
		self:bagJumpToTab(self.param.jumpTab)
	end
	if self.param and self.param.jumpStore then
		self:storeJumpToTab(self.param.jumpStore)
	end
	if self.param and self.param.mid then
		self:shopViewJump(self.param.mid)
	end
	if self.param and self.param.item then
		self:bagViewJump(self.param.item)
	end
end
function bagViewPanel:endShow()
	self:checkGuide()
	SoraDGetCtrl("propCtrl"):getPumpkinCandy()
end
function bagViewPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag)
	if self.tag == 0 then
		self:checkGuide()
		self.fields.bag:updateData(true)
	else
		self.fields.shop:jumpToNewTab()
	end
end
function bagViewPanel:initShowBtn(showBag)
	self:onClickTab(showBag and 0 or 1)
end
function bagViewPanel:bagViewJump(itemID)
	if self.tag == 0 then
		return self.fields.bag:jumpToItem(itemID)
	else
		return false
	end
end
function bagViewPanel:shopViewJump(itemID)
	if self.tag == 1 then
		return self.fields.shop:jumpToItem(itemID)
	else
		return false
	end
end
function bagViewPanel:jumpToBag()
	self:initShowBtn(true)
end
function bagViewPanel:bagJumpToTab(btnName)
	self.fields.bag:jumpToTab(btnName)
end
function bagViewPanel:storeJumpToTab(btnName)
	self.fields.shop:jumpToTab(btnName)
end
function bagViewPanel:updateDiscount()
	local status, remainTime = limitTimeDiscountShopAPI:getActivityInfo()
	if status and not allianceDesRead.getPlayerConquestWarMigration(false) and not allianceDesRead.getPlayerBattleGroundMigration(false) then
		self.fields.Particle_1:setVisible(true)
	else
		self.fields.Particle_1:setVisible(false)
	end
end
function bagViewPanel:updateNewTag()
	local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
	local isNew = shopltCtrl:getShopNewTag("all")
	self.fields.icon_new:setVisible(isNew)
	self.fields.Tab:setBtnRedDot(2, backpackCtrl:getIsRecoveryShopRedPoint())
end
function bagViewPanel:checkGuide()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	if self.tag == 0 and 0 < backpackCtrl:getItemCount(700101) then
		SoraDGetCtrl("guideCtrl"):updateGuideModule(gGuideModule.USE_ITEM_GUIDE)
	end
end
function bagViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_shop" then
		return self.fields.Tab:getBtn(2)
	elseif self.fields.bag and self.tag == 0 then
		return self.fields.bag:gameGuide_getTarget(itemName, parameters)
	end
	return nil
end
function bagViewPanel:showKeyboardMask()
	self.fields.maskArea:setVisible(true)
end
function bagViewPanel:hideKeyboardMask()
	self.fields.maskArea:runAction(ffa.seq(ffa.delay(0.1), ffa.callFunc(function()
		self.fields.maskArea:setVisible(false)
		self = self.fields.maskArea
		self.fields.maskArea.msg = "MESSAGE_CHAT_CLOSE_IME"
		self.fields.maskArea.viewType = "bagViewPanel"
		SoraDSendMessage(self.fields.maskArea)
	end)))
end
return bagViewPanel
