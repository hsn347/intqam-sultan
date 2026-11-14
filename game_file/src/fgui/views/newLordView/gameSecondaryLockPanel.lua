local baseFguiPanel = require("fgui.base.baseFguiPanel")
local settingCtrl = SoraDGetCtrl("settingCtrl")
local gameSecondaryLockPanel = class("gameSecondaryLockPanel", baseFguiPanel)
function gameSecondaryLockPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("gameSecondaryLockPanel:ctor", self.viewName)
end
function gameSecondaryLockPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameSecondaryLockPanel:onInit()
	print("=======gameSecondaryLockPanel:onInit")
	self.view:fixChildrenPos()
	self.fields.Com_title:initData(i18n("Safety_lock_text_01"), handler(self, self.onClickClose))
	self.fields.title:setString(i18n("Safety_lock_text_01"))
	self.fields.Text_title:setString(i18n("Safety_lock_text_03"))
	self.fields.Text_content:setString(i18n("Safety_lock_text_02"))
	self.fields.Text_desc:setString(i18n("Safety_lock_text_11"))
	self.fields.title2:setString(i18n("common_text_001"))
	self.fields.Button_go:setTitle(i18n("common_text_477"))
	self.fields.Button_go:addClickEventListener(handler(self, self.onGoClick))
	self.fields.Button_switch:setCallBack(handler(self, self.onSwitchCallBack))
end
function gameSecondaryLockPanel:getIsSDKSwitchOn()
	return userSDKManager.isNeedVerify()
end
function gameSecondaryLockPanel:onShow()
	print("=======gameSecondaryLockPanel:onShow")
	SoraDShowLoading(nil, nil, nil, nil, 5)
	self:updateView()
	userSDKManager.getSafePasswordStatus(function()
		SoraDCloseLoading()
		if tolua.isnull(self) then
			return
		end
		userSDKManager.syncSecondaryLockStatus()
		self:updateView()
	end)
end
function gameSecondaryLockPanel:updateView()
	self.isSwitchOn = settingCtrl:checkValue(gSettingKeyType.passwdVerify) and userSDKManager.isNeedVerify()
	self.fields.Button_switch:setVal(self.isSwitchOn)
end
function gameSecondaryLockPanel:onHide()
end
function gameSecondaryLockPanel:onSwitchCallBack(type)
	SoraDPlaySound()
	local status = not self.isSwitchOn and gStatus.YES or gStatus.NO
	self.fields.Button_switch:setVal(self.isSwitchOn)
	SoraDShowLoading(nil, nil, nil, nil, 5)
	userSDKManager.getSafePasswordStatus(function()
		SoraDCloseLoading()
		if tolua.isnull(self) then
			return
		end
		if not userSDKManager.isNeedVerify() then
			SoraDShowMsgBox(i18n("Safety_lock_text_03"), i18n("common_text_204"), nil, function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					userSDKManager.showSafePasswordSettingView()
				end
			end)
		else
			SoraDCheckSecondaryLock(function()
				if tolua.isnull(self) then
					return
				end
				SoraDShowMsgTip(status == gStatus.YES and i18n("Safety_lock_text_07") or i18n("Safety_lock_text_08"))
				settingCtrl:setKeyValue(gSettingKeyType.passwdVerify, status)
				self.isSwitchOn = not self.isSwitchOn
				self.fields.Button_switch:setVal(self.isSwitchOn)
			end, gSecondaryLockType.Force)
		end
	end)
end
function gameSecondaryLockPanel:onGoClick(type)
	SoraDPlaySound()
	userSDKManager.showSafePasswordSettingView()
	self:close()
end
return gameSecondaryLockPanel
