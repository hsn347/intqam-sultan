local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignPavilionActivityPanel = class("ForeignPavilionActivityPanel", baseFguiPanel)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function ForeignPavilionActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	print("ForeignPavilionActivityPanel:ctor", self.viewName)
	self.debug = true
end
function ForeignPavilionActivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function ForeignPavilionActivityPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	self.fields.com_title:initData(i18n("activity_name_9001374"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	print("=======ForeignPavilionActivityPanel:onInit")
end
function ForeignPavilionActivityPanel:onShow()
	print("=======ForeignPavilionActivityPanel:onShow")
	self:setStageAndStep()
	exoticPavilionCtrl:reqEPData()
	self.fields.txt_time:setVisible(false)
	self.fields.n26:setVisible(false)
end
function ForeignPavilionActivityPanel:setStageAndStep()
	local curStage = exoticPavilionCtrl:getCurStage()
	local curStep = exoticPavilionCtrl:getCurStep()
	self.fields.story:initData(curStage, curStep)
	self.fields.mainView:updateView()
	self.controllers.c1:setSelectedIndex(curStage == 2 and 1 or 0)
	if self.oldCurStage ~= 2 then
		self.fields.text_npc_name:setString(i18n("exitic_pavillion_text_0046"))
		self.fields.titlebg:setAllFrameName("G_ygg_daji2_%02d.png", 1)
		self.fields.titlebg:setPlaySettings(0, -1, -1)
	end
	self.oldCurStage = curStage
	self.oldCurStep = curStep
end
function ForeignPavilionActivityPanel:updateView()
	self.openTime = serviceFunctions.systemTime()
	self.fields.mainView:updateView()
end
function ForeignPavilionActivityPanel:onHide()
	print("=======ForeignPavilionActivityPanel:onHide")
end
function ForeignPavilionActivityPanel:onDispose()
	print("=======ForeignPavilionActivityPanel:onDispose")
end
function ForeignPavilionActivityPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("exitic_pavillion_text_0038")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return ForeignPavilionActivityPanel
