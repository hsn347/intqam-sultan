local baseComponent = require("fgui.base.baseComponent")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local Com_nodeBirthday = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://svipCenterView/Com_nodeBirthday", Com_nodeBirthday)
function Com_nodeBirthday:onInit()
	self.txtNewMails = self.fields.txtNewMails
	self.panelWelfare = self.fields.panelWelfare
	self.btnInputBirthday = self.fields.btnInputBirthday
	self.btnInputTelephone = self.fields.btnInputTelephone
	self.btnWelfareLeft = self.fields.btnWelfareLeft
	self.btnWelfareRight = self.fields.btnWelfareRight
	self.curMailIndex = 1
	self.btnWelfareLeft:addClickEventListener(handler(self, self.btnLeftWelfareClick))
	self.btnWelfareRight:addClickEventListener(handler(self, self.btnRightWelfareClick))
	self.btnInputTelephone:setTitle(i18n("privilege_text_164"))
	self.btnInputBirthday:addClickEventListener(handler(self, self.btnInputBirthdayClick))
	self.btnInputTelephone:addClickEventListener(handler(self, self.btnInputTelephoneClick))
end
function Com_nodeBirthday:onShow()
end
function Com_nodeBirthday:initData()
	local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
	local birthdayInfo = exaltedPrivilegeCtrl:getBirthdayInfo()
	if not next(birthdayInfo) then
		self.btnInputBirthday:setTitle(i18n("privilege_text_27"))
	else
		self.btnInputBirthday:setTitle(i18n("privilege_text_129"))
	end
	local birthdayYearSet = exaltedPrivilegeCtrl:hasBirthdayYearSet()
	self.btnInputBirthday:setReddot(not birthdayYearSet)
	if not birthdayYearSet and not SoraDIsGameGuide() then
		exaltedPrivilegeCtrl = self.btnInputBirthday
		self.btnInputBirthday.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		self.btnInputBirthday.step = 9993000
		SoraDSendMessage(self.btnInputBirthday)
	end
	self.btnInputTelephone:setVisible(exaltedPrivilegeCtrl:isGotSuperVIP())
	dump(welfareInfo, "Com_nodeBirthday:initData")
	if welfareInfo then
		local mailStr = i18n("privilege_text_34")
		local maiNumStr = string.format("(%d)", #welfareInfo)
		exaltedPrivilegeCtrl = exaltedPrivilegeCtrl:isGotSuperVIP()
		exaltedPrivilegeCtrl:isGotSuperVIP().num = mailStr
		exaltedPrivilegeCtrl, exaltedPrivilegeCtrl, exaltedPrivilegeCtrl:isGotSuperVIP().char = exaltedPrivilegeCtrl:isGotSuperVIP()
		exaltedPrivilegeCtrl, exaltedPrivilegeCtrl:isGotSuperVIP().num, exaltedPrivilegeCtrl:isGotSuperVIP().color = exaltedPrivilegeCtrl:isGotSuperVIP()
		exaltedPrivilegeCtrl:isGotSuperVIP().char, exaltedPrivilegeCtrl:isGotSuperVIP().color = exaltedPrivilegeCtrl:isGotSuperVIP()
		self.txtNewMails:setString(i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP()))
		if SoraDFIsRA() then
			exaltedPrivilegeCtrl = i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP())
			i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP()).num = maiNumStr
			exaltedPrivilegeCtrl, exaltedPrivilegeCtrl, i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP()).char = i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP())
			exaltedPrivilegeCtrl, i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP()).num, i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP()).color = i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP())
			i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP()).char, i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP()).color = i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP())
			self.txtNewMails:setString(i18n_html("common_text_1470", i18n_html("common_text_1470", exaltedPrivilegeCtrl:isGotSuperVIP())))
		end
		self.txtNewMails:setVisible(0 < #welfareInfo)
		self.panelWelfare:initData(welfareInfo[self.curMailIndex])
		self.btnWelfareLeft:setVisible(1 < #welfareInfo)
		self.btnWelfareRight:setVisible(1 < #welfareInfo)
	else
		self.panelWelfare:setVisible(false)
	end
end
function Com_nodeBirthday:btnInputBirthdayClick(button, eventType)
	SoraDPlaySound()
	uiManager:show("birthdayInputPopView")
end
function Com_nodeBirthday:btnInputTelephoneClick(button, eventType)
	SoraDPlaySound()
	local inputTel = exaltedPrivilegeCtrl:getTelephoneNum()
	local proxy = uiManager:show("telephoneInputPopView")
	proxy.view:initData(inputTel ~= 0 and inputTel ~= "" and 1 or 0)
end
function Com_nodeBirthday:btnLeftWelfareClick(button, eventType)
	SoraDPlaySound()
	local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
	self.curMailIndex = self.curMailIndex - 1
	if self.curMailIndex < 1 then
		self.curMailIndex = #welfareInfo
	end
	self.panelWelfare.opend = false
	self.panelWelfare.isOpen = false
	self:initData()
end
function Com_nodeBirthday:btnRightWelfareClick(button, eventType)
	SoraDPlaySound()
	local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
	self.curMailIndex = self.curMailIndex + 1
	self.panelWelfare.opend = false
	self.panelWelfare.isOpen = false
	if self.curMailIndex > #welfareInfo then
		self.curMailIndex = 1
	end
	self:initData()
end
return Com_nodeBirthday
