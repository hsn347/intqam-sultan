local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeginPGameStartPanel = class("ForeginPGameStartPanel", baseFguiPanel)
local foreignPavilionRead = include("foreignPavilionRead")
local gameTypes = foreignPavilionRead.gameTypes
function ForeginPGameStartPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ForeginPGameStartPanel:ctor", self.viewName)
end
function ForeginPGameStartPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
	end
	return self._packageList
end
function ForeginPGameStartPanel:onInit()
	print("=======ForeginPGameStartPanel:onInit")
	_UPVALUE4_ = print
	_UPVALUE4_, self.gameTitles, print[1] = print, print, "exitic_pavillion_text_0123"
	_UPVALUE4_, self.gameTitles, print[2] = print, print, "exitic_pavillion_text_0124"
	_UPVALUE4_, self.gameTitles, print[3] = print, print, "exitic_pavillion_text_0125"
	_UPVALUE4_, self.gameTitles, print[4] = print, print, "EP_TD_title_0001"
	_UPVALUE4_, self.gameDescs, print[1] = print, print, "exitic_pavillion_text_0115"
	_UPVALUE4_, self.gameDescs, print[2] = print, print, "exitic_pavillion_text_0111"
	_UPVALUE4_, self.gameDescs, print[3] = print, print, "exitic_pavillion_text_0103"
	_UPVALUE4_, self.gameDescs, print[4] = print, print, "EP_TD_rule_0001"
	self.panelNames, print[1] = print, "RoadRoughView"
	self.panelNames, print[2] = print, "LinkLinkView"
	self.panelNames, print[3] = print, "ForeignPShootGame"
	self.panelNames, print[4] = print, "TowerDefend"
	self.fields.button_start:setString(i18n("exitic_pavillion_text_0117"))
	self.fields.button_start:addClickEventListener(handler(self, self.onGameStart))
end
function ForeginPGameStartPanel:onShow()
	print("=======ForeginPGameStartPanel:onShow")
	local gameType = self.proxy.param.gameType
	self.gameType = gameType
	self.isInStory = self.proxy.param.isInStory
	self.gameSource = self.proxy.param.gameSource or "exoticPavilion"
	local title = self.gameTitles[gameType]
	local desc = self.gameDescs[gameType]
	self.fields.text_title:setString(i18n(title))
	if self.gameType == gameTypes.TOWERDEFEND then
		local towerDefendRead = include("towerDefendRead")
		_ENV = i18n(title)
		i18n(title).time = towerDefendRead.getGameConfig().gameTime
		self.fields.text_desc:setString(i18n(desc, i18n(title)))
	else
		self.fields.text_desc:setString(i18n(desc))
	end
end
function ForeginPGameStartPanel:onHide()
	print("=======ForeginPGameStartPanel:onHide")
end
function ForeginPGameStartPanel:onDispose()
	print("=======ForeginPGameStartPanel:onDispose")
end
function ForeginPGameStartPanel:onGameStart()
	SoraDPlaySound()
	_ENV = self.gameType
	self.gameType.isInStory = self.isInStory
	self.gameType.showGuide = self:getShowGuide()
	uiManager:show(self.panelNames[self.gameType], self.gameType)
	self:close()
end
function ForeginPGameStartPanel:getShowGuide(...)
	if self.gameType == gameTypes.TOWERDEFEND then
		local showGuide = false
		if self.gameSource == "exoticPavilion" then
			local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
			gameTypes = nil
			;(nil).byUID = true
			local openCount = SoraDConfigGet("Game:towerdefendGuide:count~integer", nil)
			if openCount == nil or openCount ~= exoticPavilionCtrl:getOpenCount() then
				showGuide = true
				gameTypes = exoticPavilionCtrl
				exoticPavilionCtrl.byUID = true
				SoraDConfigSet("Game:towerdefendGuide:count~integer", exoticPavilionCtrl:getOpenCount(), exoticPavilionCtrl)
			end
		elseif self.gameSource == "heroNewTrial" then
			gameTypes = SoraDConfigSet
			SoraDConfigSet.byUID = true
			local hasShowGuide = SoraDConfigGet("Game:heroNewTrial:hasShowGuide~bool", SoraDConfigSet) or false
			if not hasShowGuide then
				showGuide = true
				gameTypes = exoticPavilionCtrl:getOpenCount()
				exoticPavilionCtrl:getOpenCount().byUID = true
				SoraDConfigSet("Game:heroNewTrial:hasShowGuide~bool", true, (exoticPavilionCtrl:getOpenCount()))
			end
		end
		return showGuide
	else
		return false
	end
end
return ForeginPGameStartPanel
