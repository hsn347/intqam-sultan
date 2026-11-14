local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignPGameChoosePanel = class("ForeignPGameChoosePanel", baseFguiPanel)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local foreignPavilionRead = include("foreignPavilionRead")
local gameTypes = foreignPavilionRead.gameTypes
function ForeignPGameChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	print("ForeignPGameChoosePanel:ctor", self.viewName)
end
function ForeignPGameChoosePanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	self.debug = true
	return self._packageList
end
function ForeignPGameChoosePanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======ForeignPGameChoosePanel:onInit")
	self.fields.com_title:initData(i18n("exitic_pavillion_text_0063"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.btn_linkgame:addClickEventListener(handler(self, self.towerDefendClick))
	self.fields.btn_shoot:addClickEventListener(handler(self, self.shootClick))
	self.fields.btn_roadrough:addClickEventListener(handler(self, self.roadroughClick))
	_UPVALUE3_ = self.fields.btn_roadrough.addClickEventListener
	self.btns, self.fields.btn_roadrough.addClickEventListener[1] = self.fields.btn_roadrough.addClickEventListener, self.fields.btn_roadrough
	self.btns, self.fields.btn_roadrough.addClickEventListener[2] = self.fields.btn_roadrough.addClickEventListener, self.fields.btn_linkgame
	self.btns, self.fields.btn_roadrough.addClickEventListener[3] = self.fields.btn_roadrough.addClickEventListener, self.fields.btn_shoot
	self.fields.text_npc_name:setString(i18n("exitic_pavillion_text_0046"))
	local lang = SoraDGetDefaultLanguage()
	self.fields.btn_linkgame:setIcon(string.format("icon_ygg_gamefont_4_%s.png", lang == "ar" and "ar" or "en"))
	self.fields.btn_shoot:setIcon(string.format("icon_ygg_gamefont_3_%s.png", lang == "ar" and "ar" or "en"))
	self.fields.btn_roadrough:setIcon(string.format("icon_ygg_gamefont_1_%s.png", lang == "ar" and "ar" or "en"))
end
function ForeignPGameChoosePanel:onShow()
	self.firstIn = true
	print("=======ForeignPGameChoosePanel:onShow")
	self.fields.role:setChat(1, 1, -1)
	self:updateView()
	self.fields.txt_time:setVisible(false)
	self.fields.n57:setVisible(false)
	self.fields.titlebg:setAllFrameName("G_ygg_daji2_%02d.png", 1)
	self.fields.titlebg:setPlaySettings(0, -1, -1)
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
end
function ForeignPGameChoosePanel:updateView()
	local isHaveLast = exoticPavilionCtrl:getLastGameCount() > 0
	self.isHaveLast = isHaveLast
	exoticPavilionCtrl = nil
	exoticPavilionCtrl, exoticPavilionCtrl, (nil).num = exoticPavilionCtrl, exoticPavilionCtrl:getLastGameCount(), exoticPavilionCtrl:getLastGameCount()
	exoticPavilionCtrl:getLastGameCount().num, exoticPavilionCtrl.color = exoticPavilionCtrl, isHaveLast and "#ffffff" or "#ff0000"
	self.fields.text_last:setString(i18n_html("exitic_pavillion_text_0069", nil, (exoticPavilionCtrl:getLastGameCount())))
	self.fields.intimacy:initData()
	self.fields.role:updateRole(exoticPavilionCtrl:getCurDressLv(), self.firstIn)
	self.firstIn = false
end
function ForeignPGameChoosePanel:onHide()
	print("=======ForeignPGameChoosePanel:onHide")
end
function ForeignPGameChoosePanel:onDispose()
	print("=======ForeignPGameChoosePanel:onDispose")
end
function ForeignPGameChoosePanel:linkgameClick(sender, params)
	SoraDPlaySound()
	if not self.isHaveLast then
		SoraDShowMsgTip(i18n("exitic_pavillion_text_0127"))
		return
	end
	_ENV = i18n("exitic_pavillion_text_0127")
	i18n("exitic_pavillion_text_0127").gameType = gameTypes.LINKGAME
	uiManager:show("ForeginPGameStart", i18n("exitic_pavillion_text_0127"))
	self.gameIdx = 2
end
function ForeignPGameChoosePanel:shootClick(sender, params)
	SoraDPlaySound()
	if not self.isHaveLast then
		SoraDShowMsgTip(i18n("exitic_pavillion_text_0127"))
		return
	end
	_ENV = i18n("exitic_pavillion_text_0127")
	i18n("exitic_pavillion_text_0127").gameType = gameTypes.SHOOTGAME
	i18n("exitic_pavillion_text_0127").isInStory = false
	uiManager:show("ForeginPGameStart", i18n("exitic_pavillion_text_0127"))
	self.gameIdx = 3
end
function ForeignPGameChoosePanel:roadroughClick(sender, params)
	SoraDPlaySound()
	if not self.isHaveLast then
		SoraDShowMsgTip(i18n("exitic_pavillion_text_0127"))
		return
	end
	_ENV = i18n("exitic_pavillion_text_0127")
	i18n("exitic_pavillion_text_0127").gameType = gameTypes.ROADROUGH
	uiManager:show("ForeginPGameStart", i18n("exitic_pavillion_text_0127"))
	self.gameIdx = 1
end
function ForeignPGameChoosePanel:towerDefendClick(sender, params)
	SoraDPlaySound()
	if not self.isHaveLast then
		SoraDShowMsgTip(i18n("exitic_pavillion_text_0127"))
		return
	end
	_ENV = SoraDShowMsgTip
	local SoraDShowMsgTip.gameType, param = gameTypes.TOWERDEFEND, SoraDShowMsgTip
	uiManager:show("ForeginPGameStart", param):setOwnerKey(self)
	self.gameIdx = 2
end
function ForeignPGameChoosePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("exitic_pavillion_text_0068")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ForeignPGameChoosePanel:showWin()
	self.gameIdx = self.gameIdx or 1
	self.fields.role:setChat(1, 2, -1)
	self.fields.intimacy:addHeartShow(function()
		self:updateView()
	end, self.btns[self.gameIdx])
end
function ForeignPGameChoosePanel:showLose()
	self.gameIdx = self.gameIdx or 1
	self.fields.role:setChat(1, 3, -1)
	self.fields.intimacy:addHeartShow(function()
		self:updateView()
	end, self.btns[self.gameIdx])
end
return ForeignPGameChoosePanel
