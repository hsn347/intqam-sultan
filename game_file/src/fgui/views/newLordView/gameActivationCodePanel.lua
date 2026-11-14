local gametop = gModuleMgr.getObject("gametop")
local activationCodeCtrl = gametop.playertop_:getModule("activationCodeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameActivationCodePanel = class("gameActivationCodePanel", baseFguiPanel)
function gameActivationCodePanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameActivationCodePanel:ctor", self.viewName)
end
function gameActivationCodePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameActivationCodePanel:onInit()
	print("=======gameActivationCodePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_721"))
	self.fields.Text_1:setString(i18n("common_text_968"))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.TextField_code:setPrompt(i18n("common_text_967"))
end
function gameActivationCodePanel:onShow()
	print("=======gameActivationCodePanel:onShow")
end
function gameActivationCodePanel:btnOkClick()
	SoraDPlaySound()
	local content = self.fields.TextField_code:getText()
	if "" == content then
		SoraDShowMsgTip(i18n("common_text_1525"))
	else
		activationCodeCtrl:sendReceiveReward(content)
		self.fields.TextField_code:setText("")
		if content == "develop:pwgo" then
			_ENV = i18n("common_text_1525")
			i18n("common_text_1525").byLTID = true
			SoraDConfigSet("Game:pyramidWar:pyramidWarStatus~bool", true, i18n("common_text_1525"))
			local gametop = gModuleMgr.getObject("gametop")
			gSvrConfig.ip = gSvrlist.pwIpConfig[1].ip
			gSvrConfig.loginPort = gSvrlist.pwIpConfig[1].port
			gametop:Logout()
			SoraDShowLoginView()
		elseif string.find(content, "develop:watch:") and gSvrConfig.ip == gSvrlist.pwIpConfig[1].ip then
			local kid = tonumber(string.sub(content, 15, string.len(content)))
			print("jumpTo", kid)
			local max = worldMapDefine.getMaxCoordinateByKid(kid)
			SoraDGotoWorldMapPoint(cc.p(max * 0.5, max * 0.5), false, kid, nil, nil, true)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return gameActivationCodePanel
