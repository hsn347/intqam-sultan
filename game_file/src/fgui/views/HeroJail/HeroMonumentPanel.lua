local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local heroCenotaphCtrl = gametop.playertop_:getModule("heroCenotaphCtrl")
local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
local buffDesRead = include("buffDesRead")
local cityBuildConstDef = include("cityBuildConstDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroMonumentPanel = class("HeroMonumentPanel", baseFguiPanel)
function HeroMonumentPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroMonumentPanel:ctor", self.viewName)
end
function HeroMonumentPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildViewCommon"
	end
	return self._packageList
end
function HeroMonumentPanel:onInit()
	print("=======HeroMonumentPanel:onInit")
	_ENV = "=======HeroMonumentPanel:onInit"
	;("=======HeroMonumentPanel:onInit").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======HeroMonumentPanel:onInit")
	self.fields.Com_title:initData(i18n("buildDes_name_124"), handler(self, self.onClickClose), handler(self, self.btnHelpClickCallBack))
	self.fields.Text_bless:setString(i18n("cenotaph_text_01"))
	self.fields.Text_tip:setString(i18n("cenotaph_text_02"))
	self.fields.Text_blessResult:setString(i18n("cenotaph_title_01"))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self.fields.Text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("cenotaph_text_03", nil)
	end)
	self.fields.Button_execute:setVisible(false)
	self.fields.Button_execute:setString(i18n("prison_text_08"))
	self.fields.Button_execute:addClickListener(handler(self, self.btnExecuteClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.progressBar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function HeroMonumentPanel:onShow()
	print("=======HeroMonumentPanel:onShow")
	_ENV = "=======HeroMonumentPanel:onShow"
	;("=======HeroMonumentPanel:onShow").msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	;("=======HeroMonumentPanel:onShow").offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
	SoraDSendMessage("=======HeroMonumentPanel:onShow")
	self:initData()
end
function HeroMonumentPanel:timeUpdate(time)
	self.fields.progressBar:setValue(self.queue.totaltime - time)
	if time <= 0 then
		self:initData()
	end
end
function HeroMonumentPanel:initData()
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.hero_cenotaph)
	if self.queue then
		self.fields.Text_time:beginTime(self.queue.timerNode.timer:getRemainTime())
		self.fields.progressBar:setMax(self.queue.totaltime)
	else
		self.fields.Text_time:endTime()
	end
	local isOwnExeHero = heroJailCtrl:isCanExecutePrisonInMyJail() or false
	self.fields.Button_execute:setVisible(isOwnExeHero)
	local isOpen = heroCenotaphCtrl:isOpenBlessing()
	self.attributeList = heroCenotaphCtrl:getAttributeList()
	self.fields.List:setNumItems(#self.attributeList)
	self.fields.Text_effect:setString(isOpen and i18n("hero_text_06") or i18n("hero_text_07"))
	self.fields.Text_effect:setColor(isOpen and cc.c3b(0, 190, 30) or cc.c3b(190, 40, 40))
	self.fields.progressBar:setVisible(isOpen ~= nil)
	self.fields.Text_time:setVisible(isOpen ~= nil)
end
function HeroMonumentPanel:onItemRederer(index, target)
	local v = self.attributeList[index + 1]
	target:fixChildrenPos()
	target:setString(buffDesRead.getTitleBase(v.key))
	target:getChildByName("Text_Value"):setString(buffDesRead.getTitleValueWithValue(v.key, v.value))
end
function HeroMonumentPanel:btnExecuteClick()
	SoraDPlaySound("equipment", 3)
	uiManager:show("HeroJailList")
end
function HeroMonumentPanel:btnHelpClickCallBack()
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HERO_CENOTAPH)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.HERO_CENOTAPH)
	end
end
function HeroMonumentPanel:onHide()
	_ENV = nil
	;(nil).isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_RECOVER
	SoraDSendMessage(nil)
end
return HeroMonumentPanel
