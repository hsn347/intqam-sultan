local activity_9001670_Ctrl = SoraDGetCtrl("activity_9001670_Ctrl")
local activity_9001670_Read = include("activity_9001670_Read")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001670_MainPanel = class("Activity_9001670_MainPanel", baseFguiPanel)
function Activity_9001670_MainPanel:ctor(...)
	Activity_9001670_MainPanel.super.ctor(self, ...)
	print("Activity_9001670_MainPanel:ctor", self.viewName)
	self.debug = true
	self.activityID = gActivityTimeActivityID.REBUILD_BUBBLE_LAND
	Activity_9001670_MainPanel = self.viewName
	self.viewName.byUID = true
	self.showFinger = SoraDConfigGet("Game:activity_9001670:showFinger~bool", self.viewName)
end
function Activity_9001670_MainPanel:onInit()
	print("=======Activity_9001670_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self:updateLabelTime()
	self.fields.Label_time:setTimeEndListener(handler(self, self.timeEndListener))
	local _fields = fguiHelper.get_fields(self.fields.Com_gift)
	_fields.Button_buyGift:setString(i18n("Bubble_island_rebuild_text_36"))
	_fields.Button_buyGift:addClickListener(handler(self, self.onClickBuyGift))
	_ENV = handler(self, self.onClickBuyGift)
	handler(self, self.onClickBuyGift).byUID = true
	self.buyGiftRed = SoraDConfigGet("Game:activity_9001670:buyGiftRed~bool", handler(self, self.onClickBuyGift))
	if not self.buyGiftRed then
		_fields.Button_buyGift:setReddot(true)
	end
	local mv_gift = _fields.Button_buyGift:getChild("mv_gift")
	mv_gift:setAllFrameName("9001670_gift_%02d.png", 1)
	_fields.Text_title:setString(i18n("Bubble_island_rebuild_text_18"))
	_fields.List:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.giftList = _fields.List
	local _fields = fguiHelper.get_fields(self.fields.Com_box)
	_fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
	_fields.Text_tip:setString(i18n("Bubble_island_rebuild_text_55"))
	_fields.Text_tip:addClickListener(handler(self, self.onClickBtnRecord))
	_fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	_fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.Button_go = _fields.Button_go
	_fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self:updateComBox()
end
function Activity_9001670_MainPanel:onShow()
	print("=======Activity_9001670_MainPanel:onShow")
	local doStage = activity_9001670_Ctrl:getDoStage()
	_ENV = activity_9001670_Ctrl
	_ENV, _ENV, activity_9001670_Ctrl.defaultClick = nil, doStage + 1, doStage + 1
	_ENV, (doStage + 1)[1], (nil).title = nil, nil, i18n("Bubble_island_rebuild_text_02")
	activity_9001670_Ctrl.tabsetArray, (doStage + 1)[2], (nil).title = doStage + 1, nil, i18n("Bubble_island_rebuild_text_03")
	local activity_9001670_Ctrl.callback, param = handler(self, self.onClickTab), activity_9001670_Ctrl
	self.fields.com_Tab:initView(param)
end
function Activity_9001670_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Bubble_island_rebuild_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001670_MainPanel:onClickTab(tag)
	self.curTag = tag
	self.controllers.c2:setSelectedIndex(tag - 1)
	if self.curTag == 2 then
		if activity_9001670_Ctrl:checkDoStage2() then
			activity_9001670_Ctrl:reqGiftRecord()
		end
		activity_9001670_Ctrl:sendReqInitDataMsg()
		if not self.showFinger and not self.spriteFinger then
			local spriteFinger = SoraDFingerAction()
			spriteFinger:addTo(self.fields.Com_box:displayObject())
			spriteFinger:setPosition(47, 114)
			self.spriteFinger = spriteFinger
		end
	end
end
function Activity_9001670_MainPanel:onGiftItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
		_fields.Text_time = SoraDCreateTimerLabel(nil, _fields.Text_time)
	end
	local giftType = index + 1
	_fields.Image_gift:setURL(activity_9001670_Read.getGiftIcon(giftType))
	_fields.Text_name:setString(activity_9001670_Read.getGiftName(giftType))
	self:updateGiftTime(_fields, giftType)
end
function Activity_9001670_MainPanel:updateGiftTime(_fields, giftType)
	local totalScore = activity_9001670_Ctrl:getTotalScore()
	local lv = activity_9001670_Read.getAllianceLv(totalScore)
	local giftMap = activity_9001670_Read.getAllianceLvReward(lv)
	local giftCount = giftMap[giftType] or 0
	if giftCount <= 0 then
		_fields.Text_time:setString(i18n("jinn_skill_62"))
		return
	end
	local grantTime = activity_9001670_Read.getGiftGrantTime(giftType)
	local grantNum = activity_9001670_Read.getGiftGrantNum(giftType)
	local partyInfo = activity_9001670_Ctrl:getPartyInfo()
	local partyTime = partyInfo and partyInfo.time or serviceFunctions.systemTime()
	local totalTime = serviceFunctions.systemTime() - partyTime
	local totalNum = math.floor(totalTime / grantTime) * grantNum
	if giftCount <= totalNum then
		_fields.Text_time:setString(i18n("Bubble_island_rebuild_text_19"))
	else
		local remainTime = (totalNum / grantNum + 1) * grantTime - totalTime
		_fields.Text_time:beginTime(remainTime)
		_fields.Text_time:setTimeEndListener(function(...)
			self:updateGiftTime(_fields, giftType)
		end)
	end
end
function Activity_9001670_MainPanel:onClickBtnRecord(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001670_Record")
end
function Activity_9001670_MainPanel:onClickBtnGo(...)
	SoraDPlaySound()
	local partyInfo = activity_9001670_Ctrl:getPartyInfo()
	if partyInfo then
		if not activity_9001670_Ctrl:checkPartyTime() then
			SoraDShowMsgTip(i18n("hero_appoint_22"))
			self:updateBtnGoState()
			return
		end
		if worldMapDefine.inInCrossWar() then
			SoraDShowMsgTip(i18n("tips_feast_across_limit"))
			return
		end
		local mapSyncUtilClient = include("mapSyncUtilClient")
		local clientPos = mapSyncUtilClient.serverTOClientPos(cc.p(partyInfo.x, partyInfo.y))
		SoraDGotoWorldMapPoint(clientPos, true)
		SoraDRemoveAllPanelFromManager()
		return
	end
	if not activity_9001670_Ctrl:checkCanPlaceFeast() then
		return
	end
	SoraDShowMsgBox(i18n("Bubble_island_rebuild_text_22"), i18n("common_text_2132"), i18n("common_text_185"), function(eventType)
		if MSGBOX_CALLBACK_YES == eventType then
			if not activity_9001670_Ctrl:checkCanPlaceFeast() then
				return
			end
			_ENV = activity_9001670_Ctrl:checkCanPlaceFeast()
			local activity_9001670_Ctrl:checkCanPlaceFeast().activityID, layInstanceData = self.activityID, activity_9001670_Ctrl:checkCanPlaceFeast()
			SoraDGotoWorldMapPoint(nil, nil, nil, worldMapLayInstanceTypeDef.layInstanceFeast, layInstanceData)
			SoraDRemoveAllPanelFromManager()
		end
	end)
end
function Activity_9001670_MainPanel:onClickBtnReward(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001670_Reward")
	if self.spriteFinger then
		self.spriteFinger:removeFromParent()
		self.spriteFinger = nil
	end
	if not self.showFinger then
		self.showFinger = true
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:activity_9001670:showFinger~bool", self.showFinger, nil)
	end
end
function Activity_9001670_MainPanel:updateComBox(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_box)
	local totalScore = activity_9001670_Ctrl:getTotalScore()
	local lv = activity_9001670_Read.getAllianceLv(totalScore)
	_fields.Label_lv:setString(lv)
	_fields.bar:setValue(totalScore)
	local expMax = activity_9001670_Read.getAllianceLvExpMax(lv + 1)
	_fields.bar:setMax(expMax)
	local usmPath = activity_9001670_Read.getAllianceCastleUsm(lv)
	if not self.usmPath then
		self.usmPath = usmPath
		self.fields.Usm_2:setEffectPath(usmPath)
	elseif self.usmPath ~= usmPath and self.curTag == 2 then
		self.usmPath = usmPath
		self:showUpgradeEffect()
	end
	if activity_9001670_Ctrl:checkPartyTime() then
		self.fields.Com_gift:setVisible(true)
		if not self.isGiftListInit then
			self.giftList:setNumItems(activity_9001670_Read.getGiftTypeMax())
			self.isGiftListInit = true
		end
	else
		self.fields.Com_gift:setVisible(false)
	end
	self:updateBtnGoState()
end
function Activity_9001670_MainPanel:updateBtnGoState(...)
	self.Button_go:setEnabled(true)
	local partyInfo = activity_9001670_Ctrl:getPartyInfo()
	if partyInfo then
		if activity_9001670_Ctrl:checkPartyTime() then
			self.Button_go:setString(i18n("Bubble_island_rebuild_text_23"))
		else
			self.Button_go:setString(i18n("hero_appoint_22"))
			self.Button_go:setEnabled(false)
			self.fields.Com_gift:setVisible(false)
		end
	else
		if not allianceMgr:hasJoinAlliance() then
			self.Button_go:setString(i18n("pyramid_text_02"))
			self.Button_go:setEnabled(false)
			return
		end
		self.Button_go:setString(i18n("Bubble_island_rebuild_text_20"))
	end
end
function Activity_9001670_MainPanel:updateLabelTime(...)
	local doStage = activity_9001670_Ctrl:getDoStage()
	local strTime = clientEventMgr.getStageTimeStr(doStage, self.activityID)
	self.fields.Label_time:initActivityTimeStyle(self.activityID, strTime)
end
function Activity_9001670_MainPanel:timeEndListener(...)
	self:updateLabelTime()
	if activity_9001670_Ctrl:checkDoStage2() and self.curTag ~= 2 then
		self.fields.com_Tab:setTabIndex(2, true)
	end
	self.fields.Com_rebuild:updateTextTip()
end
function Activity_9001670_MainPanel:updateTabBtnRed(...)
	local ret, num = activity_9001670_Ctrl:getRewardLvRedNum()
	self.fields.com_Tab:setBtnRedDot(1, ret, num)
end
function Activity_9001670_MainPanel:onMsgUpdateData(target, event)
	SoraDCloseLoading()
	local subMsg = event.subMsg
	if subMsg == "giftRecord" then
		local _fields = fguiHelper.get_fields(self.fields.Com_box)
		if not event.rspdata then
			local _ENV, recordList = event.rspdata, event.rspdata
		end
		local record = recordList[1]
		if record then
			_ENV = nil
			local (nil).item, params = activity_9001670_Read.getGiftName(record.giftType), nil
			if record.nickName then
				params.name = record.nickName
			else
				params.name = i18n("common_text_069")
			end
			local recordStr = i18n("Bubble_island_rebuild_text_24", params)
			_fields.Text_tip:setString(recordStr)
		else
			_fields.Text_tip:setString(i18n("Bubble_island_rebuild_text_53"))
		end
	elseif subMsg == "initData" then
		self:updateComBox()
		self:updateTabBtnRed()
	elseif subMsg == "stageReward" then
		self:updateTabBtnRed()
	end
end
function Activity_9001670_MainPanel:onClickBuyGift(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).byUID = true
	self.buyGiftRed = SoraDConfigGet("Game:activity_9001670:buyGiftRed~bool", nil)
	if not self.buyGiftRed then
		self.buyGiftRed = true
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:activity_9001670:buyGiftRed~bool", true, nil)
		local _fields = fguiHelper.get_fields(self.fields.Com_gift)
		_fields.Button_buyGift:setReddot(false)
	end
	if not activity_9001670_Ctrl:checkRechargeDeadLine() then
		return
	end
	uiManager:show("Activity_9001670_BuyGift")
end
function Activity_9001670_MainPanel:showUpgradeEffect(...)
	self.fields.Usm_2:setEffectPath(self.usmPath)
	self.fields.Usm_sj:play()
end
return Activity_9001670_MainPanel
