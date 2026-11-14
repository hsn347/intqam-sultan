_ENV = nil
;(nil).KING_GIFT = 1
;(nil).LEGEND_GIFT = 2
;(nil).PLAYER_GIFT = 3
;(nil).HEGEMON_GIFT = 4
local (nil).KINGSTAR_GIFT, ViewType = 5, nil
local WorldMapKingdomCityKingGiftBag = class("worldMapKingdomCityKingGiftBag", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityKingGiftBag")
	end
	return target
end)
function WorldMapKingdomCityKingGiftBag:ctor()
	self.giftUsrInfo, _ENV = nil, nil
	self.Node_playerGift = SoraDGetChildByName(self, "Node_playerGift")
	self.Node_playerGift:setVisible(false)
	self.btnExplain = SoraDGetChildByName(self, "Button_explain")
	self.btnRecord = SoraDGetChildByName(self, "Button_record")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_giftBag")
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node_btns")
	self.nodeKing = SoraDGetChildByName(self, "Top_Node")
	self.btnAlliance = SoraDGetChildByName(self, "Button_alliance")
	self.btnKing = SoraDGetChildByName(self, "Button_king")
	self.btnAlliance:addTouchEventListener(handler(self, self.btnSwitchClick))
	self.btnKing:addTouchEventListener(handler(self, self.btnSwitchClick))
	self.btnAlliance:setTitleText(i18n("kindofwar_title_01"))
	self.btnKing:setTitleText(i18n("common_text_1189"))
	self.btnExplain:addTouchEventListener(handler(self, self.btnExplainClick))
	self.btnRecord:addTouchEventListener(handler(self, self.btnRecordClick))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.commonFrameTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_giftBag")
	self.commonFrameTitle:setTitle(i18n("kindofwar_title_03"))
	self.btnExplain:setTitleText(i18n("common_text_001"))
	self.btnRecord:setTitleText(i18n("common_text_836"))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMGIFT_GETLIST", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMGIFT_SENDSUCCESS", handler(self, self.reqForList))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_GIFT_LIST_BACK", handler(self, self.sMsgLegendLordGiftListBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_AWARD_GIFT_BACK", handler(self, self.sMsgLegendAwardGiftBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_LORD_GIFT_LIST_BACK", handler(self, self.sMsgHegemonLordGiftListBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_LORD_AWARD_GIFT_BACK", handler(self, self.sMsgHegemonAwardGiftBack))
end
function WorldMapKingdomCityKingGiftBag:init(data, mapid)
	print("mapid====", mapid)
	dump(data, "data===")
	self.viewType = data.viewType or ViewType.KING_GIFT
	self.mapid = mapid
	if self.viewType == ViewType.KING_GIFT then
		self:btnSwitchClick(self.btnKing, ccui.TouchEventType.ended, true)
	elseif self.viewType == ViewType.PLAYER_GIFT then
		self:btnSwitchClick(self.btnAlliance, ccui.TouchEventType.ended, true)
	elseif self.viewType == ViewType.LEGEND_GIFT then
		self.nodeKing:setVisible(false)
		self:reqLegendLordGiftList()
	elseif self.viewType == ViewType.KINGSTAR_GIFT then
		self.nodeKing:setVisible(false)
		self:reqKingStarGiftList()
	elseif self.viewType == ViewType.HEGEMON_GIFT then
		self.bid = data.bid
		self.nodeKing:setVisible(false)
		self:reqHegemonLordGiftList()
	end
end
function WorldMapKingdomCityKingGiftBag:reqForList(target, data)
	SoraDShowLoading(self)
	if data and data.redata.uid then
		SoraDShowMsgTip(i18n("common_text_1433"))
	end
	local kingPacksRead = include("kingPacksRead")
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	KWKingdomCtrl:getPackData(SoraDClickFromKingManager() or SoraDIsLookMyKingdom())
end
function WorldMapKingdomCityKingGiftBag:reqLegendLordGiftList()
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
	legendLordCtrl:reqLordGiftList()
end
function WorldMapKingdomCityKingGiftBag:reqKingStarGiftList()
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
	local activityID = worldMapDefine.getKingStarActivityID(self.mapid)
	kingStarCtrl:reqLordGiftList(activityID)
end
function WorldMapKingdomCityKingGiftBag:reqHegemonLordGiftList()
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
	hegemonCtrl:reqLordGiftList(self.bid)
end
function WorldMapKingdomCityKingGiftBag:initData(target, data)
	SoraDCloseLoading(self)
	self.giftUsrInfo = data.retdate
	self.kingdomLv = data.kingdomLv
	self:initView()
end
function WorldMapKingdomCityKingGiftBag:initView()
	self.scroll:removeAllChildren()
	local kingPacksRead = include("kingPacksRead")
	local keysTbl = kingPacksRead.getTblGift(self.viewType == ViewType.KING_GIFT, self.kingdomLv)
	local sSize = self.scroll:getContentSize()
	self.scroll:setPositionY(display.height - 155)
	self.scroll:setContentSize(cc.size(sSize.width, display.height - 252))
	local realHeight = 0
	local _ENV, singleArray = self.scroll, self.scroll
	for i, v in ipairs(keysTbl) do
		singleArray[i] = SoraDCreatePanel("worldMapKingdomCityKingGiftBagSingle")
		singleArray[i]:initData(v, self.giftUsrInfo, self.viewType, self.kingdomLv, self.mapid)
		realHeight = realHeight + singleArray[i]:returnHeigh()
	end
	local sH = math.max(realHeight, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(singleArray) do
		v:setScroll(self.scroll)
		v:setPosition(self.scroll:getContentSize().width / 2, sH)
		v:addTo(self.scroll, #keysTbl - i)
		sH = sH - v:returnHeigh()
	end
	if not SoraDClickFromKingManager() and not SoraDIsLookMyKingdom() then
		self:hideRecordBtn()
	end
	self.scroll:jumpToTop()
end
function WorldMapKingdomCityKingGiftBag:initLegendLordView()
	if self.viewType == ViewType.KINGSTAR_GIFT then
		local activityID = worldMapDefine.getKingStarActivityID(self.mapid)
		ViewType = self.mapid
		self.mapid[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("kingstarbattle_text_31")
		ViewType = nil
		;(nil).ranklist = i18n("remains_name_01")
		self.mapid[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text9", nil)
		ViewType = nil
		;(nil).ranklist = i18n("king_star_rank_text3")
		local self.mapid[gActivityTimeActivityID.LEGEND_LORD_9001647], titleCfg = i18n("king_star_rank_text9", nil), self.mapid
		self.commonFrameTitle:setTitle(activityID and titleCfg[activityID] or i18n("kingstarbattle_text_31"))
	else
		self.commonFrameTitle:setTitle(i18n("common_text_4218"))
	end
	local sSize = self.scroll:getContentSize()
	self.scroll:removeAllChildren()
	self.scroll:setPositionY(display.height - 80)
	self.scroll:setContentSize(cc.size(sSize.width, display.height - 177))
	local legendLordGiftList = self.legendLordGiftList
	self.legendGiftUserList, ViewType = self.scroll, self.scroll
	for i, v in ipairs(legendLordGiftList) do
		if v.uidList and #v.uidList > 0 then
			for t = 1, #v.uidList do
				table.insert(self.legendGiftUserList, v.uidList[t])
			end
		end
	end
	local realHeight = 0
	local ViewType, singleArray = ipairs(legendLordGiftList)
	for i, v in ipairs(legendLordGiftList) do
		singleArray[i] = SoraDCreatePanel("worldMapKingdomCityKingGiftBagSingle")
		singleArray[i]:initLegendLordGiftData(self.viewType, v, self.legendGiftUserList, self.mapid)
		realHeight = realHeight + singleArray[i]:returnLegendHeight()
	end
	local sH = math.max(realHeight, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(singleArray) do
		v:setScroll(self.scroll)
		v:setPosition(self.scroll:getContentSize().width / 2, sH)
		v:addTo(self.scroll, #legendLordGiftList - i)
		sH = sH - v:returnLegendHeight()
	end
	local isKing = true
	if not isKing then
		self:hideRecordBtn()
	end
end
function WorldMapKingdomCityKingGiftBag:initHegemonLordView()
	self.commonFrameTitle:setTitle(i18n("hegemon_title_09"))
	local sSize = self.scroll:getContentSize()
	self.scroll:removeAllChildren()
	self.scroll:setPositionY(display.height - 80)
	self.scroll:setContentSize(cc.size(sSize.width, display.height - 177))
	local hegemonLordGiftList = self.hegemonLordGiftList
	self.hegemonGiftUserList, _ENV = self.scroll, self.scroll
	for i, v in ipairs(hegemonLordGiftList) do
		if v.uidList and #v.uidList > 0 then
			for t = 1, #v.uidList do
				table.insert(self.hegemonGiftUserList, v.uidList[t])
			end
		end
	end
	local realHeight = 0
	local _ENV, singleArray = ipairs(hegemonLordGiftList)
	for i, v in ipairs(hegemonLordGiftList) do
		singleArray[i] = SoraDCreatePanel("worldMapKingdomCityKingGiftBagSingle")
		singleArray[i]:initHegemonLordGiftData(v, self.hegemonGiftUserList, self.bid, self.mapid)
		realHeight = realHeight + singleArray[i]:returnLegendHeight()
	end
	local sH = math.max(realHeight, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(singleArray) do
		v:setScroll(self.scroll)
		v:setPosition(self.scroll:getContentSize().width / 2, sH)
		v:addTo(self.scroll, #hegemonLordGiftList - i)
		sH = sH - v:returnLegendHeight()
	end
	local isKing = true
	if not isKing then
		self:hideRecordBtn()
	end
end
function WorldMapKingdomCityKingGiftBag:btnExplainClick(button, type)
	if type == ccui.TouchEventType.ended then
		userSDKManager.showFAQs()
	end
end
function WorldMapKingdomCityKingGiftBag:btnRecordClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBagRecord")
		panel:show()
		_ENV = nil
		;(nil).viewType = self.viewType
		;(nil).bid = self.bid
		panel:initData(nil, self.mapid)
	end
end
function WorldMapKingdomCityKingGiftBag:hideRecordBtn(...)
	self.btnExplain:setPositionX(320)
	self.btnRecord:setVisible(false)
end
function WorldMapKingdomCityKingGiftBag:sMsgLegendLordGiftListBack(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
	local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
	SoraDCloseLoading(self)
	_UPVALUE2_ = self
	self[1] = self.viewType
	self[2] = ViewType.KINGSTAR_GIFT
	dump(self, "self.viewType == ViewType.KINGSTAR_GIFT")
	self.legendLordGiftList = self.viewType == ViewType.KINGSTAR_GIFT and kingStarCtrl:getLordGiftList() or legendLordCtrl:getLordGiftList()
	dump(self.legendLordGiftList, "self.legendLordGiftList")
	self:initLegendLordView()
end
function WorldMapKingdomCityKingGiftBag:sMsgLegendAwardGiftBack(target, data)
	local awardItem = data.awardItem
	SoraDShowMsgTip(i18n("common_text_1433"))
	local gametop = gModuleMgr.getObject("gametop")
	local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
	local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
	self.legendLordGiftList = self.viewType == ViewType.KINGSTAR_GIFT and kingStarCtrl:getLordGiftList() or legendLordCtrl:getLordGiftList()
	self:initLegendLordView()
end
function WorldMapKingdomCityKingGiftBag:sMsgHegemonLordGiftListBack(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
	SoraDCloseLoading(self)
	self.hegemonLordGiftList = hegemonCtrl:getLordGiftList(self.bid)
	self:initHegemonLordView()
end
function WorldMapKingdomCityKingGiftBag:sMsgHegemonAwardGiftBack(target, data)
	local awardItem = data.awardItem
	SoraDShowMsgTip(i18n("common_text_1433"))
	local gametop = gModuleMgr.getObject("gametop")
	local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
	local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
	self.legendLordGiftList = self.viewType == ViewType.KINGSTAR_GIFT and kingStarCtrl:getLordGiftList() or legendLordCtrl:getLordGiftList()
	self:initHegemonLordView()
end
function WorldMapKingdomCityKingGiftBag:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local activityID = data.activityID
	if type(activityID) ~= "table" then
		ViewType = type(activityID)
		activityID, type(activityID)[1] = type(activityID), data.activityID
	end
	if activityID then
		for i, v in ipairs(activityID) do
			if tonumber(v) == gActivityTimeActivityID.LEGEND_LORD or tonumber(v) == gActivityTimeActivityID.KING_STAR_BATTLE then
				local activityState = activityShowCtrl:getStateByID(tonumber(v))
				if activityState == gActivityState.CLOSE then
					if self.viewType == ViewType.LEGEND_GIFT then
						self:closePanel()
					end
					break
				end
				if activityState == gActivityState.OPEN then
					local param = activityShowCtrl:getParamByID(tonumber(v))
					local legendState = param.curState
					if legendState == ACTIVITY_STATE.PREPARE then
						self:closePanel()
						break
					end
					if legendState == ACTIVITY_STATE.ACTIVE then
						self:closePanel()
						break
					end
					if legendState == ACTIVITY_STATE.SETTLE then
						self:closePanel()
					end
				end
				break
			end
		end
	end
end
function WorldMapKingdomCityKingGiftBag:btnSwitchClick(button, type, notSound)
	if type == ccui.TouchEventType.ended then
		if not notSound then
			SoraDPlaySound()
		end
		local switch = function(bool)
			self.btnAlliance:setTouchEnabled(bool)
			self.btnAlliance:setBright(not bool)
			self.btnAlliance:setTitleColor(not bool and cc.c3b(255, 245, 176) or cc.c3b(144, 132, 97))
			self.btnKing:setTouchEnabled(not bool)
			self.btnKing:setBright(bool)
			self.btnKing:setTitleColor(bool and cc.c3b(255, 245, 176) or cc.c3b(144, 132, 97))
			self:reqForList()
			self.nodeKing:setVisible(true)
		end
		if button == self.btnAlliance then
			self.viewType = ViewType.PLAYER_GIFT
			switch(false)
		elseif button == self.btnKing then
			self.viewType = ViewType.KING_GIFT
			switch(true)
		end
	end
end
return WorldMapKingdomCityKingGiftBag
