local cityCtrl = SoraDGetCtrl("cityCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeVipFramePanel = class("rechargeVipFramePanel", baseFguiPanel)
function rechargeVipFramePanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargeVipFramePanel:ctor", self.viewName)
end
function rechargeVipFramePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargeVipFramePanel:onInit()
	print("=======rechargeVipFramePanel:onInit")
	self.itemList, _ENV, self.isHideCurrentSceneView = print, print, true
	self.fields.Com_title:initData(i18n("common_text_1967"), handler(self, self.onClickClose))
	self.fields.Text_rechargeTip:setString(i18n("enjoyable_store_06"))
	self.fields.Text_err:setString(i18n("enjoyable_store_02"))
	self.fields.Button_feedBack:setString(i18n("common_text_2102"))
	self.fields.Button_feedBack:addClickListener(handler(self, self.btnFeedBackClick))
	self.fields.Button_pwd:addClickListener(handler(self, self.btnPwdClick))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.nbg:fix()
	self.fields.Button_feedBack:fixPos()
	self.fields.Text_totalRecharge:fixPos()
	self.fields.Button_pwd:fixPos()
	self.fields.Text_rechargeTip:fixPos()
	self.fields.Button_enter:fixPos()
end
function rechargeVipFramePanel:onListRenderer(index, obj)
	obj:initData(self.itemList[index + 1], self)
end
function rechargeVipFramePanel:onShow()
	print("=======rechargeVipFramePanel:onShow")
	self:req4init()
end
function rechargeVipFramePanel:updateSpecialBox()
	local isAllBuy = true
	if not premiumStoreCtrl:getData().superInfo then
		_ENV = premiumStoreCtrl:getData().superInfo
	end
	for i, v in ipairs(premiumStoreCtrl:getData().superInfo) do
		if v.unlock and v.buyCount < v.limit then
			isAllBuy = false
			break
		end
	end
	self.fields.Button_enter:initData(not isAllBuy)
end
function rechargeVipFramePanel:msgBackData(target, data)
	SoraDCloseLoading(self)
	local redata = data.redata
	if redata then
		self.sourceList = redata
		self.totalRecharge = premiumStoreCtrl:getDollor()
		self:initView()
	end
end
function rechargeVipFramePanel:pwdBack(target, data)
	self:updatePWD()
end
function rechargeVipFramePanel:updateView(target, data)
	premiumStoreCtrl:updateUnlockData()
	self.sourceList = premiumStoreCtrl:getData()
	self.totalRecharge = premiumStoreCtrl:getDollor()
	self:initView()
end
function rechargeVipFramePanel:initView()
	self:updatePWD()
	self:updateScroll()
	self:updateSpecialBox()
end
function rechargeVipFramePanel:updateScroll()
	if not self.sourceList.normalRecord then
		_UPVALUE0_ = self.sourceList.normalRecord
	end
	self.itemList = self.sourceList.normalRecord
	self.fields.List:setNumItems(#self.itemList)
end
function rechargeVipFramePanel:updatePWD()
	self.isShowPwd = premiumStoreCtrl:getIsShow()
	if self.isShowPwd then
		premiumStoreCtrl = nil
		premiumStoreCtrl = nil
		;(nil).n = paymentManager.returnCurrencyByChannel()
		;(nil).c = paymentManager.exchangeByChannel(self.totalRecharge)
		;(nil).num = i18n("common_text_2358", nil)
		self.fields.Text_totalRecharge:setString(i18n("common_text_1968", nil))
	else
		premiumStoreCtrl = i18n("common_text_1968", nil)
		premiumStoreCtrl = i18n("common_text_1968", nil)
		i18n("common_text_1968", nil).n = paymentManager.returnCurrencyByChannel()
		i18n("common_text_1968", nil).c = "***"
		i18n("common_text_1968", nil).num = i18n("common_text_2358", i18n("common_text_1968", nil))
		self.fields.Text_totalRecharge:setString(i18n("common_text_1968", i18n("common_text_1968", nil)))
	end
end
function rechargeVipFramePanel:req4init()
	SoraDShowLoading(self)
	premiumStoreCtrl:sendOpenPage()
end
function rechargeVipFramePanel:btnFeedBackClick()
	SoraDPlaySound()
	userSDKManager.openFeedback("Purchase", true)
end
function rechargeVipFramePanel:btnPwdClick()
	SoraDPlaySound()
	if premiumStoreCtrl:getPassword() then
		_ENV = nil
		;(nil).isSet = true
		;(nil).btnCallback = function(pwd)
			premiumStoreCtrl:sendSetPwd(pwd)
		end
		uiManager:show("commonPasswordView", nil)
	elseif self.isShowPwd then
		function _ENV(pwd)
			premiumStoreCtrl:sendSetPwd(pwd)
		end
		_ENV = nil
		;(nil).n = paymentManager.returnCurrencyByChannel()
		;(nil).c = "***"
		;(function(pwd)
			premiumStoreCtrl:sendSetPwd(pwd)
		end).num = i18n("common_text_2358", nil)
		self.fields.Text_totalRecharge:setString(i18n("common_text_1968", function(pwd)
			premiumStoreCtrl:sendSetPwd(pwd)
		end))
		self.isShowPwd = false
		premiumStoreCtrl:sendSwitch(0)
	else
		local isSecondaryLockShow = userSDKManager.getIsSecondaryLockShow()
		_ENV = premiumStoreCtrl
		premiumStoreCtrl.isSet = false
		premiumStoreCtrl.pwdType = 2
		local premiumStoreCtrl.btnCallback, param = function(pwd)
			premiumStoreCtrl:sendSwitch(1, tostring(pwd))
		end, premiumStoreCtrl
		if isSecondaryLockShow then
			param.des = i18n("Safety_lock_text_31")
			function param.helpCallback()
				print("param.helpCallback")
				uiManager:close("commonPasswordView")
				SoraDIsNeedOpenVerifySecondaryLock(function()
					print("SoraDIsNeedOpenVerifySecondaryLock")
					_ENV = nil
					;(nil).verHolder = i18n("Safety_lock_text_29")
					;(nil).title = i18n("Safety_lock_text_28")
					SoraDCheckSecondaryLock(function()
						premiumStoreCtrl:sendResetPwd()
					end, gSecondaryLockType.PremiumStoreRestPsw, "exclusiveVipView", nil)
				end, i18n("Safety_lock_text_27"))
			end
		end
		uiManager:show("commonPasswordView", param)
	end
end
return rechargeVipFramePanel
