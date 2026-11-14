local loginRewardCtrl = SoraDGetCtrl("loginRewardCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LuckyCardPanel = class("LuckyCardPanel", baseFguiPanel)
function LuckyCardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("LuckyCardPanel:ctor", self.viewName)
end
function LuckyCardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LuckyCardPanel:onInit()
	print("=======LuckyCardPanel:onInit")
	self.fields.Com_title:initData(i18n("login_title_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
end
function LuckyCardPanel:onShow()
	print("=======LuckyCardPanel:onShow")
end
function LuckyCardPanel:updateView()
	self.fields.Com_Content:updateView()
end
function LuckyCardPanel:playAnimation(data)
	self.fields.Com_Content:playAnimation(data)
end
function LuckyCardPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("login_text_02")
	uiManager:show("RuleView", nil)
end
function LuckyCardPanel:gameGuide_getTarget(itemName)
	if itemName == "luckyCard" then
		return self.fields.Com_Content:getChild("Button_Choose")
	else
		return self.fields[itemName]
	end
end
function LuckyCardPanel:endShow()
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		self:removeFromParent()
	end
	local ret = loginRewardCtrl:isFinishGuide()
	print("ret===", ret)
	if not ret and loginRewardCtrl:getCanReceive() then
		self.fields.Com_Content:setIsInGuide(true)
		_ENV = self.fields.Com_Content
		self.fields.Com_Content.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		self.fields.Com_Content.step = 11001
		SoraDSendMessage(self.fields.Com_Content)
	end
end
return LuckyCardPanel
