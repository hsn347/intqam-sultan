local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local arenaltCtrl = include("arenaltCtrl")
local lordSpineDef = include("lordSpineDef")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaReadyViewPanel = class("ArenaReadyViewPanel", baseFguiPanel)
function ArenaReadyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaReadyViewPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.EXCHANGE_MALL_ARENA
end
function ArenaReadyViewPanel:onInit()
	print("=======ArenaReadyViewPanel:onInit")
	self.fields.Com_title:initData(i18n("arena_btn_01"), handler(self, self.onClickClose), handler(self, self.showHelp))
	local _fields = fguiHelper.get_fields(self.fields.Node_left)
	self.fieldsLeft = _fields
	_fields.Text_name:setString(i18n("arena_text_01") .. "\n" .. arenaltCtrl.showGroupServer())
	_fields.Text_resetTime = SoraDCreateTimerLabel(self, _fields.Text_resetTime)
	_fields.Text_resetTime:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("ramadan_world_explorer_text_0002", nil)
	end)
	local beginResetTime = function()
		local time = serviceFunctions.getNextMonthFirstDayTime()
		if 0 < time then
			_fields.Text_resetTime:beginTime(time)
		end
	end
	_fields.Text_resetTime:setTimeEndListener(beginResetTime)
	beginResetTime()
	_fields.Button_help:addClickListener(handler(self, self.onClickLocalHelp))
	_fields.Image_cloth:addClickListener(handler(self, self.imgLeftClothClick))
	local _fields = fguiHelper.get_fields(self.fields.Node_right)
	self.fieldsRight = _fields
	_fields.Text_name:setString(i18n("arena_text_33"))
	_fields.Text_acTime = SoraDCreateTimerLabel(self, _fields.Text_acTime)
	_fields.Image_cloth:addClickListener(handler(self, self.imgRightClothClick))
	self.fields.Label_reset:setString(i18n("shop_text_04"))
	self.fields.List_exchange:setItemRenderer(handler(self, self.onExchangeItemRenderer))
	self.fields.List_exchange:setVirtual()
	_ENV = handler(self, self.onExchangeItemRenderer)
	_ENV, _ENV, handler(self, self.onExchangeItemRenderer).defaultClick = handler(self, self.onExchangeItemRenderer)
	_ENV, handler(self, self.onExchangeItemRenderer)[1], handler(self, self.onExchangeItemRenderer).title = handler(self, self.onExchangeItemRenderer)
	handler(self, self.onExchangeItemRenderer).tabsetArray, handler(self, self.onExchangeItemRenderer)[2], handler(self, self.onExchangeItemRenderer).title = handler(self, self.onExchangeItemRenderer)
	handler(self, self.onExchangeItemRenderer).callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(handler(self, self.onExchangeItemRenderer))
end
function ArenaReadyViewPanel:onShow()
	print("=======ArenaReadyViewPanel:onShow")
	self:initData()
	self:addSpine()
	self:refreshTabBtn()
	guideCtrl:updateGuideModule(gGuideModule.ARENA_INNER)
end
function ArenaReadyViewPanel:showHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = arenaltCtrl.getArenaResetDate()
	SoraDShowHelpMsgTip(i18n("arena_text_05", nil))
end
function ArenaReadyViewPanel:onClickLocalHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = arenaltCtrl.getArenaResetDate()
	SoraDShowHelpMsgTip(i18n("arena_text_43", nil))
end
function ArenaReadyViewPanel:addSpine()
	local infoLeft = lordSpineDef.getLordSpineInfo(1505)
	if infoLeft then
		local Spine = self.fieldsLeft.Com_hero:getChild("Spine")
		Spine:setEffectPath(infoLeft.json)
		Spine:getSpine():setAutoCull(false)
		Spine:setPositionY(Spine:getPositionY() - 90)
	end
	local infoRight = lordSpineDef.getLordSpineInfo(1409)
	if infoRight then
		local Spine = self.fieldsRight.Com_hero:getChild("Spine")
		Spine:setEffectPath(infoRight.json)
		Spine:getSpine():setAutoCull(false)
		Spine:setPositionY(Spine:getPositionY() - 50)
	end
end
function ArenaReadyViewPanel:refreshTabBtn()
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local ret, num = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID)
	self.fields.com_Tab:setBtnRedDot(2, ret, num)
end
function ArenaReadyViewPanel:onClickTab(tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
	self.fields.Node_left:setVisible(tag == 1)
	self.fields.Node_right:setVisible(tag == 1)
	if tag == 2 then
		self:initExchangeData()
		self:refreshTabBtn()
	end
end
function ArenaReadyViewPanel:initExchangeData(...)
	local activityExchangeMallRead = include("activityExchangeMallRead")
	self.tableData = activityExchangeMallRead:getShopItemListByRegionId(self.activityID)
	dump(self.tableData, "==self.tableData==")
	self.fields.List_exchange:setNumItems(#self.tableData)
end
function ArenaReadyViewPanel:onExchangeItemRenderer(index, obj)
	local data = self.tableData[index + 1]
	_UPVALUE0_ = nil
	;(nil).scroll = self.fields.List_exchange
	;(nil).view = self
	;(nil).activityID = self.activityID
	obj:initData(data, nil)
end
function ArenaReadyViewPanel:initData(target, redata)
	self.battleInfo = arenaCtrl:getBattleInfo()
	self.timerQueue = arenaCtrl:getGlobalQueueTimer()
	self:initView()
end
function ArenaReadyViewPanel:initView()
	self:initTipIcon()
	if self.timerQueue then
		local _fields = self.fieldsRight
		if self.battleInfo.globalArena.arenaStatus == gActivityState.OPEN then
			_fields.Text_acTime:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n("common_text_607", nil)
			end)
			if self.timerQueue then
				local ticket = self.timerQueue.timerNode.timer:getRemainTime()
				_fields.Text_acTime:beginTime(ticket)
			end
		elseif self.battleInfo.globalArena.arenaStatus == gActivityState.CLOSE then
			_fields.Text_acTime:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n("common_text_606", nil)
			end)
			if self.timerQueue then
				local ticket = self.timerQueue.timerNode.timer:getRemainTime()
				_fields.Text_acTime:beginTime(ticket)
			end
		end
	end
end
function ArenaReadyViewPanel:initTipIcon(...)
	local setIcon = function(_fields, battleType)
		local tipEnum, showIcon = arenaCtrl:getTipState(battleType)
		_fields.Image_tip:setVisible(tipEnum ~= nil)
		_fields.Image_state:setVisible(tipEnum ~= nil)
		_fields.Label_reddot:setVisible(false)
		if not showIcon then
			return
		end
		_fields.Image_state:setURL(showIcon)
		if gArenaTipEnum.haveReward == tipEnum then
			_fields.Image_state:setScaleX(0.9)
			_fields.Image_state:setScaleY(0.9)
		elseif gArenaTipEnum.rankFall == tipEnum then
			_fields.Image_state:setScaleX(0.7)
			_fields.Image_state:setScaleY(-0.7)
		elseif gArenaTipEnum.haveAttackChange == tipEnum or gArenaTipEnum.underAttackAndWin == tipEnum then
			_fields.Image_tip:setVisible(false)
			_fields.Image_state:setVisible(false)
			_fields.Label_reddot:setVisible(true)
		end
	end
	setIcon(self.fieldsLeft, gArenaBattleType.ARENA_LOCAL)
	setIcon(self.fieldsRight, gArenaBattleType.AREAN_GLOBAL)
end
function ArenaReadyViewPanel:imgLeftClothClick()
	SoraDPlaySound()
	arenaCtrl:clickTip(gArenaBattleType.ARENA_LOCAL)
	if self.battleInfo.localArena.myRank > 0 then
		local index = arenaltCtrl.getSubSectionIndex(gArenaBattleType.ARENA_LOCAL, self.battleInfo.localArena.arenaGroup)
		_ENV = nil
		;(nil).battleType = gArenaBattleType.ARENA_LOCAL
		;(nil).index = index
		uiManager:show("ArenaMainView", nil)
	else
		_ENV = "ArenaMainView"
		;("ArenaMainView").battleType = gArenaBattleType.ARENA_LOCAL
		uiManager:show("ArenaSelectView", "ArenaMainView")
	end
end
function ArenaReadyViewPanel:imgRightClothClick()
	SoraDPlaySound()
	if self.battleInfo.globalArena.serverUnlock then
		arenaCtrl:clickTip(gArenaBattleType.AREAN_GLOBAL)
		if self.battleInfo.globalArena.myRank > 0 then
			local index = arenaltCtrl.getSubSectionIndex(gArenaBattleType.AREAN_GLOBAL, self.battleInfo.globalArena.arenaGroup)
			_ENV = nil
			;(nil).battleType = gArenaBattleType.AREAN_GLOBAL
			;(nil).index = index
			uiManager:show("ArenaMainView", nil)
		else
			_ENV = "ArenaMainView"
			;("ArenaMainView").battleType = gArenaBattleType.AREAN_GLOBAL
			uiManager:show("ArenaSelectView", "ArenaMainView")
		end
	else
		SoraDShowMsgTip(i18n("common_text_699"))
	end
end
function ArenaReadyViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "left_cloth" then
		return self.fieldsLeft.Image_cloth
	end
	return self.fields[itemName]
end
return ArenaReadyViewPanel
