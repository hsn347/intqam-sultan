local conquestWarReinforcementsCtrl = SoraDGetCtrl("conquestWarReinforcementsCtrl")
local nationalFlagRead = include("nationalFlagRead")
local constantRead = include("constantRead")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local GetInvitation_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/GetInvitation_single", GetInvitation_single)
function GetInvitation_single:onInit()
	self:fixChildrenPos()
	self.fields.n26:fix()
	self.fields.n18:fix()
	self.maxNum = constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10)
	self.fields.Button_Agree:addClickListener(handler(self, self.onClickAgree))
	self.fields.Button_Agree:setString(i18n("common_text_140"))
	self.fields.Button_Cancle:addClickListener(handler(self, self.onClickReject))
end
function GetInvitation_single:onShow()
end
function GetInvitation_single:initData(data)
	self.kid = data.kid
	self.state = data.state
	self.agreeNum = data.agreeNum
	self.maxStrength = data.maxStrength
	self.agreeStrength = data.agreeStrength
	self.strengthDiff = data.strengthDiff
	self.fields.Button_Cancle:setString(i18n("common_text_091"))
	self.fields.Text_Status:setPositionY(30)
	if self.state == gConquestWarReinforcementsState.AGREE then
		self.fields.Button_Cancle:setString(i18n("conquestwar_text_48"))
		self.fields.Text_Status:setString(i18n("conquestwar_text_23"))
	elseif self.state == gConquestWarReinforcementsState.REJECT then
		self.fields.Text_Status:setString(i18n("conquestwar_text_22"))
		self.fields.Text_Status:setPositionY(53)
	end
	self.controllers.c1:setSelectedIndex(self.state - 1)
	local imageBg = nationalFlagRead.getAcrossBgImageByID(data.kingdomFlag)
	local imageName = nationalFlagRead.getAcrossPopupImageByID(data.kingdomFlag)
	self.fields.Image_Flag:setURL(imageName)
	self.fields.Image_Flagbg:setURL(imageBg)
	self.fields.Text_Kingdom:setString(string.format("#%d", data.kid))
	_ENV = string.format("#%d", data.kid)
	_ENV, _ENV, string.format("#%d", data.kid).num = conquestWarCtrl, conquestWarCtrl:getNumString(data.kingdomStrength), conquestWarCtrl:getNumString(data.kingdomStrength)
	_ENV, conquestWarCtrl:getNumString(data.kingdomStrength).num, conquestWarCtrl.color = conquestWarCtrl, conquestWarCtrl, "#FFF5E1"
	conquestWarCtrl:getNumString(data.kingdomStrength).__default, conquestWarCtrl.color = conquestWarCtrl, "#D7C39B"
	self.fields.Text_KingdomPower:setString(i18n_html("conquestwar_text_13", string.format("#%d", data.kid)))
	_ENV = i18n_html("conquestwar_text_13", string.format("#%d", data.kid))
	_ENV, _ENV, i18n_html("conquestwar_text_13", string.format("#%d", data.kid)).num = conquestWarCtrl, conquestWarCtrl:getNumString(data.maxStrength), conquestWarCtrl:getNumString(data.maxStrength)
	_ENV, conquestWarCtrl:getNumString(data.maxStrength).num, conquestWarCtrl.color = conquestWarCtrl, conquestWarCtrl, "#FFF5E1"
	conquestWarCtrl:getNumString(data.maxStrength).__default, conquestWarCtrl.color = conquestWarCtrl, "#D7C39B"
	self.fields.Text_OneMaxPower:setString(i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid))))
	_ENV = i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid)))
	i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid))).num1 = conquestWarCtrl:getNumString(data.agreeStrength)
	_ENV, _ENV, i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid))).num2 = conquestWarCtrl, conquestWarCtrl:getNumString(data.strengthDiff), conquestWarCtrl:getNumString(data.strengthDiff)
	_ENV, conquestWarCtrl:getNumString(data.strengthDiff).num1, conquestWarCtrl.color = conquestWarCtrl, conquestWarCtrl, "#FFF5E1"
	conquestWarCtrl:getNumString(data.strengthDiff).__default, conquestWarCtrl.color = conquestWarCtrl, "#D7C39B"
	self.fields.Text_NeedPower:setString(i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid)))))
	_ENV = i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid))))
	i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid)))).num1 = data.agreeNum
	_ENV, _ENV, i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid)))).num2 = i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid))))
	_ENV, self.maxNum.num1, i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid)))).color = i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid))))
	self.maxNum.__default, i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid)))).color = i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid))))
	self.fields.Text_NeedNum:setString(i18n_html("conquestwar_text_15", i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_13", string.format("#%d", data.kid))))))
end
function GetInvitation_single:onClickAgree()
	SoraDPlaySound()
	local myStrength = conquestWarReinforcementsCtrl:getStrength()
	_ENV = nil
	;(nil).content = i18n("conquestwar_text_31")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		if self.maxNum <= self.agreeNum then
			SoraDShowMsgTip(i18n("conquestwar_text_32"))
			return
		end
		if myStrength > self.maxStrength then
			SoraDShowMsgTip(i18n("conquestwar_text_33"))
			return
		end
		if SoraDIsSelfKing() then
			SoraDShowMsgTip(i18n("conquestwar_text_44"))
			return
		end
		if myStrength + self.agreeStrength > self.strengthDiff then
			SoraDShowMsgTip(i18n("conquestwar_text_33"))
			return
		end
		self = i18n("conquestwar_text_33")
		i18n("conquestwar_text_33").kid = self.kid
		conquestWarReinforcementsCtrl:reqConquestWarAgreeInvite(i18n("conquestwar_text_33"))
	end
	uiManager:show("MessageBox", nil)
end
function GetInvitation_single:onClickReject()
	SoraDPlaySound()
	if self.state == gConquestWarReinforcementsState.INVETED then
		_ENV = nil
		;(nil).content = i18n("conquestwar_text_30")
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			conquestWarReinforcementsCtrl = nil
			;(nil).kid = self.kid
			conquestWarReinforcementsCtrl:reqConquestWarRejectInvite(nil)
		end
		uiManager:show("MessageBox", nil)
	elseif self.state == gConquestWarReinforcementsState.AGREE then
		_ENV = nil
		;(nil).content = i18n("conquestwar_text_34")
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			conquestWarReinforcementsCtrl = nil
			;(nil).kid = self.kid
			conquestWarReinforcementsCtrl:reqConquestWarAgreeCancel(nil)
		end
		uiManager:show("MessageBox", nil)
	end
end
return GetInvitation_single
