local nebulaCelebrationCtrl = SoraDGetCtrl("nebulaCelebrationCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaCelebrationMainPanel = class("NebulaCelebrationMainPanel", baseFguiPanel)
function NebulaCelebrationMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaCelebrationMainPanel:ctor", self.viewName)
end
function NebulaCelebrationMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "fonts"
	end
	return self._packageList
end
function NebulaCelebrationMainPanel:onInit()
	print("=======NebulaCelebrationMainPanel:onInit")
	self.fields.Com_title:initData(i18n("Nebula_Celebration_title01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = i18n("Nebula_Celebration_title01")
	_ENV, _ENV, i18n("Nebula_Celebration_title01").defaultClick = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("Nebula_Celebration_title03")
	_ENV, handler(self, self.onClickClose)[1], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("Nebula_Celebration_title02")
	i18n("Nebula_Celebration_title01").tabsetArray, handler(self, self.onClickClose)[2], handler(self, self.onClickHelp).tag = handler(self, self.onClickClose), handler(self, self.onClickHelp)
	i18n("Nebula_Celebration_title01").callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView((i18n("Nebula_Celebration_title01")))
end
function NebulaCelebrationMainPanel:onClickTab(index)
	self.tabIndex = index
	self:updateUI()
	if self.tabIndex == 1 then
		self:tryShowUnlockEffect()
	end
end
function NebulaCelebrationMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Nebula_Celebration_text01")
	uiManager:show("RuleView", nil)
end
function NebulaCelebrationMainPanel:onIntoPanel()
	print("NebulaCelebrationMainPanel:onIntoPanel", SoraDCurrentTopPanelNameFromManager())
	if SoraDCurrentTopPanelNameFromManager() == self.__cname then
		self:tryShowUnlockEffect()
	end
end
function NebulaCelebrationMainPanel:onShow()
	print("=======NebulaCelebrationMainPanel:onShow")
	self.tabIndex = 1
	self:updateUI()
	self:tryShowUnlockEffect()
	self.fields.Panel_reward:resizeBannerEffect()
end
function NebulaCelebrationMainPanel:updateUI()
	self:updateReddot()
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	if self.tabIndex == 1 then
		self.fields.Panel_reward:updateUI()
	else
		self.fields.Panel_task:updateUI()
	end
end
function NebulaCelebrationMainPanel:updateReddot()
	self.fields.Com_tab:setBtnRedDot(1, nebulaCelebrationCtrl:hasAward())
	self.fields.Com_tab:setBtnRedDot(2, nebulaCelebrationCtrl:taskReddot())
end
function NebulaCelebrationMainPanel:tryShowUnlockEffect()
	if self.tabIndex == 1 then
		self.fields.Panel_reward:showUnlockEffect()
	end
end
return NebulaCelebrationMainPanel
