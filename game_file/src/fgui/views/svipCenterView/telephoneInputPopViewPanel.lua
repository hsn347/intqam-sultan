local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local exclusiveVipRead = include("exclusiveVipRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local telephoneInputPopViewPanel = class("telephoneInputPopViewPanel", baseFguiPanel)
function telephoneInputPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("telephoneInputPopViewPanel:ctor", self.viewName)
end
function telephoneInputPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function telephoneInputPopViewPanel:onInit()
	print("=======telephoneInputPopViewPanel:onInit")
	self.fields.Mod_sel:fixChildrenPos()
	fguiHelper.SoraDSetComFields(self)
	self.isShowTel = true
	self.realTelNum = nil
	self.areatype = nil
	self.ccs_bg = self.fields.Panel_bg
	self.ccs_bg:setTitle(i18n("privilege_text_164"))
	self.Text_unDes = SoraDGetChildByName(self, "Text_unDes")
	self.Text_unTip = SoraDGetChildByName(self, "Text_unTip")
	self.Text_unTip:setString(i18n("privilege_text_166"))
	self.Text_unWar = SoraDGetChildByName(self, "Text_unWar")
	self.Text_unWar:setString(i18n("privilege_text_167"))
	self.editBoxUnTel = self.fields.input:getChild("input")
	self.editBoxUnTel:addEventListener(fgui.UIEventType.Changed, handler(self, self.onEditBoxChange))
	self.editBoxUnTel:addEventListener(fgui.UIEventType.Submit, handler(self, self.onEditBoxSubmit))
	self.Button_confirm = SoraDGetChildByName(self, "Button_confirm")
	self.Button_confirm:setTitleText(i18n("common_text_204"))
	self.Button_confirm:addClickEventListener(handler(self, self.btnConfirmClick))
	self:setBtnConfirmStatus(false)
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.ccs_btnChange = self.fields.ccs_btnChange
	self.ccs_btnChange:addClickEventListener(handler(self, self.btnChangeClick))
end
function telephoneInputPopViewPanel:onShow()
	print("=======telephoneInputPopViewPanel:onShow")
	self.areaList = exclusiveVipRead:getTelAreaList()
	self.prefixIndex = 0
	self.prefix = self.areaList[self.prefixIndex + 1].prefix
	self.areatype = self.areaList[self.prefixIndex + 1].type
	local _ENV, items = self.areaList[self.prefixIndex + 1].type, self.areaList[self.prefixIndex + 1].type
	local _ENV, values = self.prefixIndex + 1, self.prefixIndex + 1
	for k, v in ipairs(self.areaList) do
		table.insert(items, i18n(v.area) .. "+" .. v.prefix)
		table.insert(values, v.prefix)
	end
	_ENV = nil
	;(nil).items = items
	;(nil).values = values
	;(nil).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox, nil)
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.prefixIndex)
		self.comboBoxList:scrollToView(self.prefixIndex)
	end)
	self.fields.ComboBox:fixChildrenPos()
end
function telephoneInputPopViewPanel:onComboBoxClick()
	SoraDPlaySound()
	self.prefixIndex = tonumber(self.fields.ComboBox:getSelectedIndex())
	self.prefix = tonumber(self.fields.ComboBox:getValue())
	self.areatype = self.areaList[self.prefixIndex + 1].type
end
function telephoneInputPopViewPanel:OnEditBoxTouch(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		target:touchDownAction(target, eventType)
	end
end
function telephoneInputPopViewPanel:setBtnConfirmStatus(isBright)
	self.Button_confirm:setBright(isBright)
	self.Button_confirm:setEnabled(isBright)
	self.Button_confirm:setTitleColor(isBright and cc.c3b(255, 255, 255) or cc.c3b(125, 125, 125))
end
function telephoneInputPopViewPanel:onEditBoxChange()
	local newInput = self.editBoxUnTel:getText()
	newInput = string.match(newInput, "([%d]+)") or ""
	local isCD, leftTime = self:isInCD()
	if string.utf8len(newInput) < 6 then
		self:setBtnConfirmStatus(false)
		if not isCD then
			self:changeBtnModel(false)
			self.Text_unWar:setVisible(true)
		else
			self.Text_unWar:setVisible(false)
		end
	elseif string.utf8len(newInput) >= 6 and string.utf8len(newInput) < 14 then
		self.Text_unWar:setVisible(false)
		self:setBtnConfirmStatus(true)
		if not isCD then
			self:changeBtnModel(true)
		end
	elseif string.utf8len(newInput) >= 14 then
		self.Text_unWar:setVisible(true)
		self:setBtnConfirmStatus(false)
	end
	self.realTelNum = newInput
end
function telephoneInputPopViewPanel:onEditBoxSubmit()
	SoraDDelayCallOnce("telephoneInputPopView", function()
		if self.editBoxUnTel and not tolua.isnull(self.editBoxUnTel) then
			self.editBoxUnTel:setText(self.realTelNum)
			self.editBoxUnTel:setPromptHolder("")
		end
	end)
end
function telephoneInputPopViewPanel:initData(model)
	self.model = model
	self.controllers.c1:setSelectedIndex(self.model)
	if self.model == 0 then
		self:setUnbindInfo()
	else
		self:setBindedInfo()
		local isCD, leftTime = self:isInCD()
		self.Text_unWar:setVisible(not isCD)
	end
end
function telephoneInputPopViewPanel:setUnbindInfo()
	self.Text_unDes:setString(i18n("privilege_text_165"))
	_UPVALUE2_ = exclusiveVipRead
	exclusiveVipRead[1] = "id"
	exclusiveVipRead[2] = "count"
	local rewards = serviceFunctions.tableFormat(exclusiveVipRead:getPrivilegeReward(gExaltedPrivilegeWelfareReward.EXALTED_CALL), exclusiveVipRead)
	self.fields.scroll:setItemRenderer(function(index, obj)
		local data = rewards[index + 1]
		obj:initData(data.id, data.count)
	end)
	self.fields.scroll:setNumItems(#rewards)
	_ENV = i18n("privilege_text_165")
	i18n("privilege_text_165").num = i18n("privileged_phone_text_02")
	self.fields.Text_telNum:setString(i18n("privileged_phone_text_01", i18n("privilege_text_165")))
end
function telephoneInputPopViewPanel:setBindedInfo()
	self.Text_unDes:setString(i18n("privilege_text_170"))
	local isCD, leftTime = self:isInCD()
	if isCD then
		self.Text_time:setVisible(true)
		self.Text_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("privilege_text_31", nil)
		end)
		self.Text_time:beginTime(leftTime)
		self:changeBtnModel(false)
	else
		self.Text_time:setVisible(false)
		self:changeBtnModel(true)
	end
	self.ccs_btnChange:setTitle(i18n("common_text_243"))
	self.ccs_btnChange:setCostNum(PRIVILEGE_PHONE_CHANGEGOLD)
	local isGoldEnough = SoraDEnoughGold(PRIVILEGE_PHONE_CHANGEGOLD, true)
	local telephoneStr = self:getShowPhoneNum()
	self.fields.Text_telNum:setString(telephoneStr)
end
function telephoneInputPopViewPanel:getShowPhoneNum()
	local telephoneNum, areatype, prefix = exaltedPrivilegeCtrl:getTelephoneNum()
	exaltedPrivilegeCtrl = nil
	;(nil).num = i18n("privileged_phone_text_02")
	local strNum = i18n("privileged_phone_text_01", nil)
	if telephoneNum ~= 0 then
		areatype = tonumber(areatype)
		if areatype and 0 < areatype then
			self.prefixIndex = areatype - 1
			prefix = self.areaList[areatype].prefix
			self.areatype = self.areaList[areatype].type
			self.fields.ComboBox:setTitle(i18n(self.areaList[areatype].area) .. "+" .. prefix)
		end
		local repHead = string.sub(telephoneNum, 1, 3)
		local repTail = string.sub(telephoneNum, -2, -1)
		local prefixStr = prefix and tostring(prefix) .. "-" or ""
		local showStr = prefixStr .. repHead .. "****" .. repTail
		exaltedPrivilegeCtrl = repTail
		repTail.num = showStr
		strNum = i18n("privileged_phone_text_01", repTail)
	end
	return strNum
end
function telephoneInputPopViewPanel:isInCD()
	local leftTime = PRIVILEGE_PHONE_CD + (exaltedPrivilegeCtrl:getPhoneTime() or 0) - serviceFunctions.systemTime()
	return 0 < leftTime, leftTime
end
function telephoneInputPopViewPanel:changeBtnModel(isBright)
	self.ccs_btnChange:setBright(isBright)
	self.ccs_btnChange:setTouchEnabled(isBright)
end
function telephoneInputPopViewPanel:changeShowModel()
	if self.isShowTel then
		self.editBoxUnTel:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
	else
		self.editBoxUnTel:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	end
	if self.realTelNum then
		self.editBoxUnTel:setText(self.realTelNum)
	end
end
function telephoneInputPopViewPanel:btnConfirmClick(button, event)
	SoraDPlaySound()
	if not tonumber(self.realTelNum) then
		SoraDShowMsgTip(i18n("privilege_text_172"))
		return
	end
	if string.utf8len(self.realTelNum) < 6 or string.utf8len(self.realTelNum) >= 14 then
		SoraDShowMsgTip(i18n("privilege_text_167"))
		return
	end
	SoraDShowMsgBox(i18n("privilege_text_168"), i18n("common_text_204"), nil, function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			SoraDShowLoading(self)
			exaltedPrivilegeCtrl:reqSetPhoneNum(tostring(self.realTelNum), self.areaList[self.prefixIndex + 1].type)
		end
	end)
end
function telephoneInputPopViewPanel:btnChangeClick(button, event)
	SoraDPlaySound()
	if not tonumber(self.realTelNum) then
		SoraDShowMsgTip(i18n("privilege_text_172"))
		return
	end
	if string.utf8len(self.realTelNum) < 6 or string.utf8len(self.realTelNum) >= 14 then
		SoraDShowMsgTip(i18n("privilege_text_167"))
		return
	end
	if SoraDEnoughGold(PRIVILEGE_PHONE_CHANGEGOLD) then
		if premiumStoreCtrl:getPassword() then
			_ENV = i18n("privilege_text_167")
			i18n("privilege_text_167").isSet = true
			i18n("privilege_text_167").btnCallback = function(pwd)
				premiumStoreCtrl:sendSetPwd(pwd)
			end
			uiManager:show("commonPasswordView", i18n("privilege_text_167"))
		else
			local isSecondaryLockShow = userSDKManager.getIsSecondaryLockShow()
			_ENV = uiManager
			uiManager.isSet = false
			uiManager.pwdType = 2
			local uiManager.btnCallback, param = function(pwd)
				premiumStoreCtrl:sendSwitch(1, tostring(pwd))
			end, uiManager
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
end
return telephoneInputPopViewPanel
