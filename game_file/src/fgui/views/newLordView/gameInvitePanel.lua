local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameInvitePanel = class("gameInvitePanel", baseFguiPanel)
function gameInvitePanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameInvitePanel:ctor", self.viewName)
end
function gameInvitePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameInvitePanel:onInit()
	print("=======gameInvitePanel:onInit")
	self.curType = 1
	self.fields.Com_title:initData(i18n("common_text_189"), handler(self, self.onClickClose))
	_ENV = i18n("common_text_189")
	_ENV, _ENV, i18n("common_text_189").defaultClick = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_969")
	_ENV, handler(self, self.onClickClose)[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("invite_title_01")
	i18n("common_text_189").tabsetArray, handler(self, self.onClickClose)[2], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	i18n("common_text_189").callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView((i18n("common_text_189")))
end
function gameInvitePanel:onShow()
	print("=======gameInvitePanel:onShow")
end
function gameInvitePanel:onClickTab(tag)
	self.curType = tag
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(self.curType - 1)
end
return gameInvitePanel
