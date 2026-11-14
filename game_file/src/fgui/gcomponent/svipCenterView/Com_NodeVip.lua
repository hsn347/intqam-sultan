local baseComponent = require("fgui.base.baseComponent")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local exclusiveVipRead = include("exclusiveVipRead")
local Com_NodeVip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://svipCenterView/Com_NodeVip", Com_NodeVip)
function Com_NodeVip:onInit()
	self.privileged_progressBar = self.fields.privileged_progressBar
	self.btnLook = self.fields.btnLook
	self.txtPriIns = self.fields.txtPriIns
	self.txtPriTitle = self.fields.txtPriTitle
	self.txtAdd = self.fields.txtAdd
	self.txtMax = self.fields.txtMax
	self.imgCenter = self.fields.imgCenter
	self.btn_pwd = self.fields.btn_pwd
	self.btn_add = self.fields.btn_add
	self.privileged_progressBar:setPercent(0)
	self.btnLook:setTitle(i18n("privilege_text_16"))
	self.btnLook:addClickEventListener(handler(self, self.btnLookClick))
	self.btn_add:addClickEventListener(handler(self, self.btnScoreClick))
	self.btn_pwd:addClickEventListener(handler(self, self.btnPwdClick))
	self.txtMax:setString(i18n("lordskill_text_07"))
	self.btn_pwd:fixPos()
	self.btn_add:fixPos()
	self.txtAdd:fixPos()
end
function Com_NodeVip:onShow()
end
function Com_NodeVip:setPercent(percent)
	local percent = math.min(math.max(percent, 0), 100)
	self.privileged_progressBar:setPercent(percent / 100)
end
function Com_NodeVip:initData()
	local curScore = exaltedPrivilegeCtrl:getTotalScores()
	local totalRecharge = premiumStoreCtrl:getDollor()
	local nextlevelInfo, isMax = exclusiveVipRead:getNextLevelPrivilegeInfo(curScore)
	self.isShowPwd = premiumStoreCtrl:getIsShow()
	self.txtMax:setVisible(isMax)
	self.txtPriTitle:setVisible(not isMax)
	self.txtPriIns:setVisible(not isMax)
	if self.isShowPwd then
		if not isMax then
			exaltedPrivilegeCtrl = nil
			;(nil).member = string.formatnumberthousands(curScore)
			;(nil).total = string.formatnumberthousands(nextlevelInfo.grade)
			self.txtAdd:setString(i18n("common_text_155", nil))
		else
			exaltedPrivilegeCtrl = i18n("common_text_155", nil)
			i18n("common_text_155", nil).member = string.formatnumberthousands(curScore)
			i18n("common_text_155", nil).total = "MAX"
			self.txtAdd:setString(i18n("common_text_155", i18n("common_text_155", nil)))
		end
	else
		exaltedPrivilegeCtrl = i18n("common_text_155", i18n("common_text_155", nil))
		i18n("common_text_155", i18n("common_text_155", nil)).member = "***"
		i18n("common_text_155", i18n("common_text_155", nil)).total = "***"
		self.txtAdd:setString(i18n("common_text_155", i18n("common_text_155", i18n("common_text_155", nil))))
	end
	self:setPercent(nextlevelInfo and curScore / nextlevelInfo.grade * 100 or 100)
	self.btn_add:setVisible(self.isShowPwd)
	if nextlevelInfo then
		exaltedPrivilegeCtrl = i18n("common_text_155", i18n("common_text_155", i18n("common_text_155", nil)))
		exaltedPrivilegeCtrl, exaltedPrivilegeCtrl, i18n("common_text_155", i18n("common_text_155", i18n("common_text_155", nil))).name = nextlevelInfo.name, i18n(nextlevelInfo.name), i18n(nextlevelInfo.name)
		exaltedPrivilegeCtrl, i18n(nextlevelInfo.name).name, nextlevelInfo.name.color = nextlevelInfo.name, nextlevelInfo.name, "#F2E5CA"
		i18n(nextlevelInfo.name).__default, nextlevelInfo.name.color = nextlevelInfo.name, "#FFC864"
		self.txtPriTitle:setString(i18n_html("privilege_text_15", i18n("common_text_155", i18n("common_text_155", i18n("common_text_155", nil)))))
		self.txtPriIns:setString(i18n(nextlevelInfo.describe))
		if nextlevelInfo.type == gExaltedPrivilegeType.LORD_HEAD_PRIVILEGE then
			local head = include("head")
			local strName = i18n(head[nextlevelInfo.value[1]].name)
			exaltedPrivilegeCtrl = i18n(nextlevelInfo.describe)
			i18n(nextlevelInfo.describe).name = strName
			newName = i18n(nextlevelInfo.name, i18n(nextlevelInfo.describe))
			exaltedPrivilegeCtrl = i18n(nextlevelInfo.describe)
			i18n(nextlevelInfo.describe).name = strName
			newDescribe = i18n(nextlevelInfo.describe[1], i18n(nextlevelInfo.describe))
			exaltedPrivilegeCtrl = i18n(nextlevelInfo.describe)
			exaltedPrivilegeCtrl, exaltedPrivilegeCtrl, i18n(nextlevelInfo.describe).name = i18n(nextlevelInfo.describe)
			exaltedPrivilegeCtrl, newName.name, i18n(nextlevelInfo.describe).color = i18n(nextlevelInfo.describe)
			newName.__default, i18n(nextlevelInfo.describe).color = i18n(nextlevelInfo.describe)
			self.txtPriTitle:setString(i18n_html("privilege_text_15", i18n(nextlevelInfo.describe)))
			self.txtPriIns:setString(i18n(newDescribe))
		end
	end
	if isMax then
		self.imgCenter:setURL("bg_zxvip_ydbj1.png")
	end
end
function Com_NodeVip:btnPwdClick(button, eventType)
	SoraDPlaySound()
	if premiumStoreCtrl:getPassword() then
		_ENV = nil
		;(nil).isSet = true
		;(nil).pwdType = 2
		;(nil).btnCallback = function(pwd)
			premiumStoreCtrl:sendSetPwd(pwd)
		end
		uiManager:show("commonPasswordView", nil)
	elseif self.isShowPwd then
		function _ENV(pwd)
			premiumStoreCtrl:sendSetPwd(pwd)
		end
		;(function(pwd)
			premiumStoreCtrl:sendSetPwd(pwd)
		end).member = "***"
		;(function(pwd)
			premiumStoreCtrl:sendSetPwd(pwd)
		end).total = "***"
		self.txtAdd:setString(i18n("common_text_155", function(pwd)
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
			premiumStoreCtrl:sendSwitch(1, pwd)
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
	self.btn_add:setVisible(self.isShowPwd)
end
function Com_NodeVip:btnScoreClick(button, type)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("exclusiveScorePopView")
	panel:show()
end
function Com_NodeVip:btnLookClick(button, type)
	SoraDPlaySound()
	uiManager:show("gotPrivilegePopView")
end
return Com_NodeVip
