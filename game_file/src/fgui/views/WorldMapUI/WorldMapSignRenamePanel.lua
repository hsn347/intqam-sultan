local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapSignRenamePanel = class("WorldMapSignRenamePanel", baseFguiPanel)
function WorldMapSignRenamePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("WorldMapSignRenamePanel:ctor", self.viewName)
end
function WorldMapSignRenamePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldMapSignRenamePanel:onInit()
	print("=======WorldMapSignRenamePanel:onInit")
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
	self.nodeSwitch = self.fields.CCS_gameSettingCommonSwitch_switch
	self.textSwitch = self.fields.text_switch
	self.labelWarn = self.fields.Text_warn
	self.btnRename = self.fields.Button_rename
	self.tfdRename = self.fields.TextField_rename
	self.nodeSwitch:addClickEventListener(handler(self, self.btnSwitchClickCallBack))
	self.textSwitch:setString(i18n("privilege_text_142"))
	self.nodeSwitch:setSelected(not lordInfoCtrl:getSignatureFlag())
	self.maxLen = MAP_COLLECTNAME_MAX
	self.fields.Panel_bg:setTitle(i18n("privilege_text_92"))
	self.btnRename:setTitleText(i18n("common_text_243"))
	self.btnRename:addTouchEventListener(handler(self, self.btnRenameClickCallBack))
	local image = self.fields.Image_5
	self.tfdRename:setMaxLength(self.maxLen)
	self.tfdRename:addEventListener(fgui.UIEventType.Changed, handler(self, self.updateView))
	_ENV = handler(self, self.updateView)
	handler(self, self.updateView).count = self.maxLen
	self.labelWarn:setString(i18n("common_text_364", handler(self, self.updateView)))
	if lordInfoCtrl:getSignatureCDTime() > 0 and lordInfoCtrl:getSignatureByGm() then
		timeWarn = self.fields.texttimeWarn2
		timeWarn:setVisible(true)
		timeWarn:setColor(display.COLOR_RED)
		timeWarn:setString(i18n("privilege_text_140"))
		self.timeWarn = timeWarn
	end
	local leftTime = atlantisActivityCtrl:getPalaceRemainTime()
	if 0 < leftTime then
		self.ccs_switch = self.fields.CCS_gameSettingCommonSwitch_switch2
		self.ccs_switch:addClickEventListener(handler(self, self.btnSwitchDressClick))
		local signatureBox = lordInfoCtrl:getSignatureBox()
		self.ccs_switch:setSelected(signatureBox and 0 < signatureBox)
		local text_switch = self.fields.text_switch2
		text_switch = SoraDCreateTimerLabel(nil, text_switch)
		text_switch:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return string.format([[
%s
%s]], i18n("atlantiswar_text_0390"), i18n("atlantiswar_text_0391", nil))
		end)
		text_switch:beginTime(leftTime)
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function WorldMapSignRenamePanel:onShow()
	print("=======WorldMapSignRenamePanel:onShow")
end
function WorldMapSignRenamePanel:btnSwitchClickCallBack(isListen)
	local showString = ""
	showString = lordInfoCtrl:getSignatureFlag() and i18n("privilege_text_143") or i18n("privilege_text_144")
	SoraDShowMsgTip(showString)
	lordInfoCtrl:reqSwitchSignature()
end
function WorldMapSignRenamePanel:initData(...)
end
function WorldMapSignRenamePanel:setSignInfo(info)
	self.signature = info.signature or ""
	self.tfdRename:setText(self.signature)
	self:updateView()
	self.timeNumber = lordInfoCtrl:getSignatureCDTime()
	if self.timeNumber and self.timeNumber > 0 then
		self:setBtnState(false)
		self.btnRename:setTitleColor(display.COLOR_RED)
		self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime))
		self:updateTime()
	end
end
function WorldMapSignRenamePanel:updateTime(time)
	if not self.timeNumber or self.timeNumber < 0 then
		if self.timeHandle then
			SoraDManagerRemoveTimer(self, self.timeHandle)
			self.timeHandle = nil
		end
		self.btnRename:setTitleColor(display.COLOR_WHITE)
		self.btnRename:setTitleText(i18n("common_text_243"))
		self:setBtnState(true)
		if self.timeWarn then
			self.timeWarn:setVisible(false)
		end
		return
	end
	self.timeNumber = lordInfoCtrl:getSignatureCDTime()
	self.btnRename:setTitleText(SoraDConvertSecondToString(self.timeNumber))
end
function WorldMapSignRenamePanel:btnRenameClickCallBack(button, type)
	SoraDPlaySound()
	local text = self.tfdRename:getText()
	if text == "" then
		text = nil
	end
	SoraDShowMsgBox(i18n("privilege_text_139"), i18n("common_text_204"), nil, function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			lordInfoCtrl:reqChangeSignature(text)
			self:close(button, type)
		end
	end)
end
function WorldMapSignRenamePanel:updateView()
	local returnName = self.tfdRename:getText()
	local nameLen = string.utf8len(returnName)
	local err = gErrDef.Err_None
	local __err
	if returnName ~= "" then
		local name = string.match(returnName, "%s*(.-)%s*$")
		if string.sub(name, 1, 1) == "(" then
			err = gErrDef.Err_NICKNAME_BRACKET
		elseif string.match(name, "$SoarDragon&") then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif not gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameLegality(name) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif not SoraDIsUtf8String(name) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameShieldWord(returnName) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(returnName) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		end
	end
	if err == gErrDef.Err_None then
		_ENV = 1
		;(1).count = self.maxLen - nameLen
		self.labelWarn:setString(i18n("common_text_364", 1))
		self.labelWarn:setColor(cc.c3b(215, 195, 155))
		self:setBtnState(true)
		self.btnRename:setEnabled(1 <= nameLen)
		self.btnRename:setBright(1 <= nameLen)
	else
		self.labelWarn:setColor(display.COLOR_RED)
		self:setBtnState(false)
		if err == gErrDef.Err_NICKNAME_BRACKET then
			self.labelWarn:setString(__err or i18n("common_text_367"))
		else
			self.labelWarn:setString(__err or i18n("notice_0071"))
		end
	end
end
function WorldMapSignRenamePanel:setBtnState(canUse)
	SoraDPlaySound()
	if self.timeNumber and self.timeNumber > 0 then
		canUse = false
	end
	self.btnRename:setTouchEnabled(canUse)
	self.btnRename:setBright(canUse)
end
function WorldMapSignRenamePanel:btnSwitchDressClick(...)
	SoraDPlaySound()
	if atlantisActivityCtrl:getPalaceRemainTime() <= 0 then
		SoraDShowMsgTip(i18n("atlantiswar_text_0365"))
		self:closePanel()
		return
	end
	local signatureBox = lordInfoCtrl:getSignatureBox()
	if signatureBox and 0 < signatureBox then
		lordInfoCtrl:reqSetSignatureBox()
	else
		lordInfoCtrl:reqSetSignatureBox(1)
	end
end
return WorldMapSignRenamePanel
