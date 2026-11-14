local activity_9001717_Read = include("activity_9001717_Read")
local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001717_MainPanel = class("Activity_9001717_MainPanel", baseFguiPanel)
function Activity_9001717_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001717_MainPanel.super.ctor(self, ...)
	print("Activity_9001717_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FANTASY_LAND
	Activity_9001717_MainPanel = self.viewName
	self.viewName.byUID = true
	self.showFinger = SoraDConfigGet("Game:activity_9001717:showFinger~bool", self.viewName)
end
function Activity_9001717_MainPanel:onInit()
	print("=======Activity_9001717_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:getLabelTime():setTimeEndListener(handler(self, self.timeEndListener))
	local _fields = fguiHelper.get_fields(self.fields.Com_gift)
	self.Button_buyGift = _fields.Button_buyGift
	self.Button_buyGift:setString(i18n("Bubble_island_rebuild_text_36"))
	self.Button_buyGift:addClickListener(handler(self, self.onClickBuyGift))
	_ENV = handler(self, self.onClickBuyGift)
	handler(self, self.onClickBuyGift).byUID = true
	self.buyGiftRed = SoraDConfigGet("Game:activity_9001717:buyGiftRed~bool", handler(self, self.onClickBuyGift))
	if not self.buyGiftRed then
		self.Button_buyGift:setReddot(true)
	end
	_fields.Text_title:setString(i18n("Bubble_island_rebuild_text_18"))
	_fields.List:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.giftList = _fields.List
	local _fields = fguiHelper.get_fields(self.fields.Com_box)
	_fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
	self.Text_tip = _fields.Text_tip
	self.Text_tip:addClickListener(handler(self, self.onClickBtnRecord))
	_fields.Text_noAlliance:setString(i18n("Bubble_island_rebuild_text_06"))
	_fields.Text_noAlliance:setVisible(false)
	_fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	_fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.Button_go = _fields.Button_go
	_fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.Usm_up:setVisible(false)
	self.fields.Usm_bg:setVisible(false)
	self.fields.Usm_up:setCompleteCallback(function()
		self.fields.Usm_up:setVisible(false)
	end)
end
function Activity_9001717_MainPanel:endShow()
	print("=======Activity_9001717_MainPanel:endShow")
	self.Text_tip:setString(i18n("Bubble_island_rebuild_text_55"))
	local doStage = activity_9001717_Ctrl:getDoStage()
	_ENV = i18n("Bubble_island_rebuild_text_55")
	_ENV, _ENV, i18n("Bubble_island_rebuild_text_55").defaultClick = i18n("Bubble_island_rebuild_text_55")
	_ENV, (doStage + 1)[1], i18n("Bubble_island_rebuild_text_55").title = i18n("Bubble_island_rebuild_text_55")
	i18n("Bubble_island_rebuild_text_55").tabsetArray, (doStage + 1)[2], i18n("Bubble_island_rebuild_text_55").title = doStage + 1, i18n("Bubble_island_rebuild_text_55")
	i18n("Bubble_island_rebuild_text_55").callback = handler(self, self.onClickTab)
	self.fields.Com_title:initTab(i18n("Bubble_island_rebuild_text_55"))
	self:updateTabBtnRed()
	local memberMgr = SoraDGetCtrl("memberMgr")
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	local partyInfo = activity_9001717_Ctrl:getPartyInfo()
	if partyInfo and jointime < partyInfo.time then
		self.Button_buyGift:setVisible(true)
	else
		self.Button_buyGift:setVisible(false)
	end
end
function Activity_9001717_MainPanel:updateComBox(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_box)
	local totalScore = activity_9001717_Ctrl:getTotalScore()
	local lv = activity_9001717_Read.getAllianceLv(totalScore)
	local expMax = activity_9001717_Read.getAllianceLvExpMax(lv + 1)
	if allianceMgr:hasJoinAlliance() then
		_fields.Text_noAlliance:setVisible(false)
		_fields.Label_lv:setVisible(true)
		_fields.bar:setVisible(true)
		_fields.Label_lv:setString(lv)
		_fields.bar:setValue(totalScore)
		_fields.bar:setMax(expMax)
	else
		_fields.Text_noAlliance:setVisible(true)
		_fields.Label_lv:setVisible(false)
		_fields.bar:setVisible(false)
	end
	local castleType = activity_9001717_Read.getAllianceCastleType(lv)
	self.controllers.c1:setSelectedIndex(castleType - 1)
	self:updateUsmBg(castleType)
	if self.castleType and self.castleType ~= castleType then
		self:showUpgradeEffect()
	else
		self.fields.Usm_up:setVisible(false)
	end
	self.castleType = castleType
	if activity_9001717_Ctrl:checkPartyTime() then
		self.fields.Com_gift:setVisible(true)
		self.giftList:setNumItems(activity_9001717_Read.getGiftTypeMax())
	else
		self.fields.Com_gift:setVisible(false)
	end
	self:updateBtnGoState()
end
function Activity_9001717_MainPanel:updateBtnGoState(...)
	self.Button_go:setEnabled(true)
	local partyInfo = activity_9001717_Ctrl:getPartyInfo()
	if partyInfo then
		if activity_9001717_Ctrl:checkPartyTime() then
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
function Activity_9001717_MainPanel:onGiftItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local giftType = index + 1
	_fields.Image_gift:setURL(activity_9001717_Read.getGiftIcon(giftType))
	_fields.Text_name:setString(activity_9001717_Read.getGiftName(giftType))
	self:updateGiftTime(_fields, giftType)
end
function Activity_9001717_MainPanel:updateGiftTime(_fields, giftType)
	local totalScore = activity_9001717_Ctrl:getTotalScore()
	local lv = activity_9001717_Read.getAllianceLv(totalScore)
	local giftMap = activity_9001717_Read.getAllianceLvReward(lv)
	local giftCount = giftMap[giftType] or 0
	if giftCount <= 0 then
		_fields.Text_time:setString(i18n("jinn_skill_62"))
		return
	end
	local grantTime = activity_9001717_Read.getGiftGrantTime(giftType)
	local grantNum = activity_9001717_Read.getGiftGrantNum(giftType)
	local partyInfo = activity_9001717_Ctrl:getPartyInfo()
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
function Activity_9001717_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("fantasy_land_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001717_MainPanel:onClickTab(tag)
	self.curTag = tag
	self.controllers.c2:setSelectedIndex(tag - 1)
	if self.curTag == 2 then
		if activity_9001717_Ctrl:checkDoStage2() then
			activity_9001717_Ctrl:reqGiftRecord()
		end
		activity_9001717_Ctrl:sendReqInitDataMsg()
		if not self.showFinger and not self.spriteFinger then
			local spriteFinger = SoraDFingerAction()
			spriteFinger:addTo(self.fields.Com_box:displayObject())
			spriteFinger:setPosition(89, 124)
			self.spriteFinger = spriteFinger
		end
	end
end
function Activity_9001717_MainPanel:updateLabelTime(...)
	local doStage = activity_9001717_Ctrl:getDoStage()
	local strTime = clientEventMgr.getStageTimeStr(doStage, self.activityID)
	self.fields.Com_title:getLabelTime():initActivityTimeStyle(self.activityID, strTime)
end
function Activity_9001717_MainPanel:timeEndListener(...)
	self:updateLabelTime()
	if activity_9001717_Ctrl:checkDoStage2() and self.curTag ~= 2 then
		self.fields.Com_title:setTabIndex(2, true)
	end
	self.fields.Com_rebuild:updateTextTip()
end
function Activity_9001717_MainPanel:updateTabBtnRed(...)
	local ret, num = activity_9001717_Ctrl:getReceiveStatusAndNum()
	self.fields.Com_title:setBtnRedDot(1, ret, num)
end
function Activity_9001717_MainPanel:onMsgUpdateData(target, event)
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
			local (nil).item, params = activity_9001717_Read.getGiftName(record.giftType), nil
			if record.nickName then
				params.name = record.nickName
			else
				params.name = i18n("common_text_069")
			end
			local recordStr = i18n("Bubble_island_rebuild_text_24", params)
			self.Text_tip:setString(recordStr)
		else
			self.Text_tip:setString(i18n("Bubble_island_rebuild_text_53"))
		end
	elseif subMsg == "initData" then
		self:updateComBox()
		self:updateTabBtnRed()
	elseif subMsg == "stageReward" then
		self:updateTabBtnRed()
	end
end
function Activity_9001717_MainPanel:onClickBuyGift(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).byUID = true
	self.buyGiftRed = SoraDConfigGet("Game:activity_9001717:buyGiftRed~bool", nil)
	if not self.buyGiftRed then
		self.buyGiftRed = true
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:activity_9001717:buyGiftRed~bool", true, nil)
		self.Button_buyGift:setReddot(false)
	end
	if not activity_9001717_Ctrl:checkRechargeDeadLine() then
		return
	end
	uiManager:show("Activity_9001717_BuyGift")
end
function Activity_9001717_MainPanel:onClickBtnRecord(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001717_Record")
end
function Activity_9001717_MainPanel:onClickBtnGo(...)
	SoraDPlaySound()
	local partyInfo = activity_9001717_Ctrl:getPartyInfo()
	if partyInfo then
		if not activity_9001717_Ctrl:checkPartyTime() then
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
	if not activity_9001717_Ctrl:checkCanPlaceFeast() then
		return
	end
	SoraDShowMsgBox(i18n("Bubble_island_rebuild_text_22"), i18n("common_text_2132"), i18n("common_text_185"), function(eventType)
		if MSGBOX_CALLBACK_YES == eventType then
			if not activity_9001717_Ctrl:checkCanPlaceFeast() then
				return
			end
			_ENV = activity_9001717_Ctrl:checkCanPlaceFeast()
			local activity_9001717_Ctrl:checkCanPlaceFeast().activityID, layInstanceData = self.activityID, activity_9001717_Ctrl:checkCanPlaceFeast()
			SoraDGotoWorldMapPoint(nil, nil, nil, worldMapLayInstanceTypeDef.layInstanceFeast, layInstanceData)
			SoraDRemoveAllPanelFromManager()
		end
	end)
end
function Activity_9001717_MainPanel:onClickBtnReward(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001717_Reward")
	if self.spriteFinger then
		self.spriteFinger:removeFromParent()
		self.spriteFinger = nil
	end
	if not self.showFinger then
		self.showFinger = true
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:activity_9001717:showFinger~bool", self.showFinger, nil)
	end
end
function Activity_9001717_MainPanel:onHide()
	if self.spriteFinger then
		self.spriteFinger:removeFromParent()
		self.spriteFinger = nil
	end
end
function Activity_9001717_MainPanel:updateUsmBg(castleType)
	if castleType ~= 3 then
		self.fields.Usm_bg:setVisible(false)
		return
	end
	self.fields.Usm_bg:clearEffect()
	if self.castleType == 2 and castleType == 3 then
		self.fields.Usm_bg:setEffectPath("activity_bg_9001717_upglow.usm,activity_bg_9001717.usm", true)
	else
		self.fields.Usm_bg:setEffectPath("activity_bg_9001717.usm", true)
	end
	self.fields.Usm_bg:setVisible(true)
end
function Activity_9001717_MainPanel:showUpgradeEffect(...)
	self.fields.Usm_up:setVisible(true)
	self.fields.Usm_up:play()
end
return Activity_9001717_MainPanel
