local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lordLocalData = include("lordLocalData")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonAccountBonusBoxPanel = class("commonAccountBonusBoxPanel", baseFguiPanel)
function commonAccountBonusBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("commonAccountBonusBoxPanel:ctor", self.viewName)
end
function commonAccountBonusBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function commonAccountBonusBoxPanel:onInit()
	print("=======commonAccountBonusBoxPanel:onInit")
	_ENV, self.rewardArray, _ENV = print, print, print
	print.NOBIND = 1
	print.BIND_NOREWARD = 2
	self.status, print.PHONE_NOREWARD = print, 3
	self.curStatus = self.status.NOBIND
	self.isPhoneModel = false
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setAlignCenter(true)
	self.fields.Text_des:setString(i18n("bind_phone_text_03"))
	self.fields.phone:fixPos()
	self.fields.Text_phoneTip:fixPos()
end
function commonAccountBonusBoxPanel:onItemRenderer(index, obj)
	obj:initData(self.rewardArray[index + 1].id, self.rewardArray[index + 1].count)
end
function commonAccountBonusBoxPanel:onShow()
	print("=======commonAccountBonusBoxPanel:onShow")
	self:initView()
end
function commonAccountBonusBoxPanel:initView()
	local isBind = userSDKManager.returnAccountBindType(gSDKDef.platformType.email)
	local isPhoneBind = userSDKManager.returnAccountBindType(gSDKDef.platformType.mobile)
	local lordBase = lordInfoCtrl:getBaseInfo()
	local isReward = lordBase.hasBindAccountReward or false
	local isBindPhone = lordBase.receiveBindPhone or false
	if isBind and isReward then
		self.isPhoneModel = true
	end
	if not IsArClient then
		self.isPhoneModel = false
		isPhoneBind = true
		isBindPhone = true
	end
	if not isBind then
		self.controllers.c1:setSelectedIndex(0)
		self.curStatus = self.status.NOBIND
		self.fields.Button_go:setString(i18n("common_text_477"))
		self.fields.Text_tip:setString(i18n("common_text_3673"))
	elseif isBind and isReward and not isPhoneBind then
		self.controllers.c1:setSelectedIndex(1)
		self.curStatus = self.status.NOBIND
		self.fields.Button_go:setString(i18n("common_text_477"))
		self.fields.Text_phoneTip:setString(i18n("bind_phone_text_01"))
	elseif isBind and not isReward then
		self.controllers.c1:setSelectedIndex(2)
		self.curStatus = self.status.BIND_NOREWARD
		self.fields.Button_go:setString(i18n("common_text_1146"))
		self.fields.Text_tip:setString(i18n("bind_phone_text_06"))
	elseif isPhoneBind and not isBindPhone then
		self.controllers.c1:setSelectedIndex(3)
		self.curStatus = self.status.PHONE_NOREWARD
		self.fields.Button_go:setString(i18n("common_text_1146"))
		self.fields.Text_phoneTip:setString(i18n("bind_phone_text_02"))
	end
	self:initAwards()
end
function commonAccountBonusBoxPanel:initAwards()
	local awards = lordLocalData.getBindAward()
	self.award = awards[1].reward
	if self.isPhoneModel then
		self.award = awards[4].reward
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewardArray = serviceFunctions.tableFormat(self.award, nil)
	self.fields.List:setNumItems(#self.rewardArray)
end
function commonAccountBonusBoxPanel:btnGoClick()
	SoraDPlaySound()
	if self.curStatus == self.status.NOBIND then
		userSDKManager.showBindView()
		self:close()
	elseif self.curStatus == self.status.BIND_NOREWARD then
		lordInfoCtrl:sendGetBindAccountReward()
		self:close()
	elseif self.curStatus == self.status.PHONE_NOREWARD then
		lordInfoCtrl:sendGetBindPhoneAccountReward()
		self:close()
	end
end
return commonAccountBonusBoxPanel
