local guideCtrl = SoraDGetCtrl("guideCtrl")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
_ENV = "warGemCtrl"
;("warGemCtrl").INFO_VIEW = 1
;("warGemCtrl").BAG_VIEW = 2
local _UPVALUE5_, ("warGemCtrl").EXCHANGE_VIEW, TAB_INDEX = nil, 3, "warGemCtrl"
;(nil)[1] = 1
;(nil)[2] = 15
;(nil)[3] = 35
;(nil)[4] = 55
local (nil)[5], starLvTable = 70, nil
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemMainPanel = class("WarGemMainPanel", baseFguiPanel)
function WarGemMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("WarGemMainPanel:ctor", self.viewName)
end
function WarGemMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "bagView"
	end
	return self._packageList
end
function WarGemMainPanel:onInit()
	self.fields.InfoView:setPanel(self)
	self:addClickListener(function()
		self.fields.InfoView:hideCombo(self:getTouchTarget())
	end)
	self.fields.Com_title:initData(i18n("common_text_3878"), handler(self, self.onClickClose))
	self.fields.Com_title:setSmallHelpCallBack(handler(self, self.onClickHelp))
	self.fields.Button_getMore:setString(i18n("common_text_3882"))
	if warGemCtrl:isExchangeStoreOpen() then
		self.fields.Panel_tab:setTabNum(3)
		self.fields.Panel_tab:setBtnTitle3(i18n("common_text_1809"))
	else
		self.fields.Panel_tab:setTabNum(2)
	end
	self.fields.Panel_tab:setBtnTitle1(i18n("common_text_3879"))
	self.fields.Panel_tab:setBtnTitle2(i18n("common_text_3880"))
	self.fields.Panel_tab:setBtnCallback(handler(self, self.onTabCallback))
	self.fields.Button_getMore:addClickListener(handler(self, self.onClickGetMore))
end
function WarGemMainPanel:onClickGetMore()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemType = gItemType.WAR_GEM
	;(nil).itemType2 = gItemType.POWERFUL_ESSENCE
	uiManager:show("vipBuyView", nil)
end
function WarGemMainPanel:onTabCallback(index)
	print("onTabCallback!!!", index)
	self.tabIndex = index
	self:updateTab()
end
function WarGemMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("common_text_3878")
	;(nil).content = i18n("common_text_4038")
	uiManager:show("RuleView", nil)
end
function WarGemMainPanel:onShow()
	print("=======WarGemMainPanel:onShow")
	self.tabIndex = TAB_INDEX.INFO_VIEW
	self:updateTab()
	self:showWarStarGemGuide()
end
function WarGemMainPanel:showWarStarGemGuide()
	local step = guideCtrl:updateGuideModule(gGuideModule.WAR_GEM)
	if not step then
		local starLvLimit = require("app." .. LocalTblPath .. ".config_server.buildstar301")
		guideCtrl = ".config_server.buildstar301"
		;(".config_server.buildstar301").byUID = true
		local curStarLv = SoraDConfigGet("Game:warGemView:starLv~integer", ".config_server.buildstar301")
		local isShow = false
		local bidLv = SoraDGetBuildStarLv(BUILDID.MIRACLE)
		local targetLv = 0
		for i, v in ipairs(starLvTable) do
			if v > curStarLv and v <= bidLv then
				isShow = true
				targetLv = starLvLimit[v].unlockedenchantment
			end
		end
		print("wargemguide", step, isShow, bidLv, curStarLv, targetLv)
		if isShow then
			print("isShow", isShow)
			self.gameGuideView = include("gameGuideView").new()
			guideCtrl, guideCtrl = bidLv, isShow
			isShow.noticeKey, bidLv.lv = bidLv, tostring(targetLv)
			self.gameGuideView:startGuideWithStep(65001, isShow)
			self.gameGuideView:show()
			guideCtrl = isShow
			isShow.byUID = true
			SoraDConfigSet("Game:warGemView:starLv~integer", bidLv, isShow)
			return true
		end
	end
	if not SoraDIsGameGuide() and guideCtrl:isGuideNotCompleted(gGuideModule.WAR_GEM_HOLE) then
		local lv = SoraDGetBuildLv(BUILDID.MIRACLE)
		local constantRead = include("constantRead")
		local needLv = constantRead.getConstValue("WAR_STONE_CHANGE_LEVLE")
		local isShow = lv >= needLv
		print(lv, needLv, isShow)
		if isShow then
			self.gameGuideView = include("gameGuideView").new()
			self.gameGuideView:startGuideWithStep(90401)
			self.gameGuideView:show()
			return true
		end
	end
end
function WarGemMainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "gemSingle" then
		local hole = self.fields.InfoView:gameGuide_getTarget(itemName, parameters)
		print("hole====", hole)
		if hole and hole:hasGem() then
			print("已经镶嵌，引导直接完成！", gGuideStep.WAR_GEM_STEP_COMPLETE)
			guideCtrl:testCompleteGuide(gGuideStep.WAR_GEM_STEP_COMPLETE)
			_ENV = guideCtrl
			guideCtrl.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
			guideCtrl.step = parameters.endStep
			SoraDSendMessage(guideCtrl)
			_ENV = guideCtrl
			guideCtrl.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(guideCtrl)
			return nil
		end
		return hole
	elseif itemName == "gemSingleChange" then
		return self.fields.InfoView:gameGuide_getTarget(itemName, parameters)
	end
	return SoraDGetChildByName(self, itemName)
end
function WarGemMainPanel:updateTab()
	self.controllers.Ctrl_tab:setSelectedIndex(self.tabIndex - 1)
	self.fields.Panel_tab:setLineVisible(false)
	if self.tabIndex == TAB_INDEX.INFO_VIEW then
		self.fields.InfoView:updateView()
	elseif self.tabIndex == TAB_INDEX.BAG_VIEW then
		if not self.bagView then
			self.bagView = fgui.UIPackage:createObject("WarGem", "WarGemItem")
			self.bagView:setSize(self.fields.BagViewBG:getSize())
			self.fields.BagViewBG:addChild(self.bagView)
		end
	elseif self.tabIndex == TAB_INDEX.EXCHANGE_VIEW then
		if not self.exchangeView then
			self.exchangeView = fgui.UIPackage:createObject("WarGem", "WarGemMainExchange")
			self.exchangeView:setSize(self.fields.ExchangeViewBG:getSize())
			self.fields.ExchangeViewBG:addChild(self.exchangeView)
		end
		self.exchangeView:updateView()
	else
		error("undefined tab " .. self.tabIndex)
	end
end
function WarGemMainPanel:onHide()
	print("=======WarGemMainPanel:onHide")
end
function WarGemMainPanel:onDispose()
	print("=======WarGemMainPanel:onDispose")
	local warGemCtrl = SoraDGetCtrl("warGemCtrl")
	warGemCtrl:resetGemNewInfo()
	warGemCtrl:setEditPanelId(nil)
end
return WarGemMainPanel
