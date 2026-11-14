local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AtlantisBriefEditPanel = class("AtlantisBriefEditPanel", baseFguiPanel)
function AtlantisBriefEditPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AtlantisBriefEditPanel:ctor", self.viewName)
end
function AtlantisBriefEditPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
	end
	return self._packageList
end
function AtlantisBriefEditPanel:onInit()
	print("=======AtlantisBriefEditPanel:onInit")
	self.warType = self.param.warType
	if self.warType == gKingdomClassType.nebulaEmperor then
		self.fields.Panel_bg:setString(i18n("nebulaemperor_text_133"))
	else
		self.fields.Panel_bg:setString(i18n("atlantiswar_text_0404"))
	end
	_ENV = i18n("atlantiswar_text_0404")
	i18n("atlantiswar_text_0404").num = 40
	self.fields.Text_limit:setString(i18n("lordequip_text_06", i18n("atlantiswar_text_0404")))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickOk))
	self.fields.Button_ok:setEnabled(false)
	self.fields.input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onInputTextSubmit))
end
function AtlantisBriefEditPanel:onShow()
	print("=======AtlantisBriefEditPanel:onShow")
end
function AtlantisBriefEditPanel:onClickOk(...)
	local brief = self.fields.input:getText()
	local strLen = string.utf8len(brief)
	if 40 < strLen then
		SoraDShowMsgTip(i18n("tips_inputLengthLimit"))
		return
	elseif strLen <= 0 then
		_ENV = i18n("tips_inputLengthLimit")
		i18n("tips_inputLengthLimit").num = 1
		SoraDShowMsgTip(i18n("friend_text_32", i18n("tips_inputLengthLimit")))
		return
	end
	local msgStr = i18n("atlantiswar_text_0405")
	if self.warType == gKingdomClassType.nebulaEmperor then
		msgStr = i18n("nebulaemperor_text_134")
	end
	SoraDShowMsgBox(msgStr, nil, nil, function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			if self.warType == gKingdomClassType.nebulaEmperor then
				local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
				nebulaEmperorCtrl:reqBiographyEdict(self.param.season, brief)
			else
				atlantisActivityCtrl:reqLegionBrief(self.param.season, brief)
			end
			self:closePanel()
		end
	end)
end
function AtlantisBriefEditPanel:onInputTextSubmit(...)
	local brief = self.fields.input:getText()
	local strLen = string.utf8len(brief)
	if strLen <= 0 then
		self.fields.Button_ok:setEnabled(false)
	else
		self.fields.Button_ok:setEnabled(true)
	end
end
return AtlantisBriefEditPanel
