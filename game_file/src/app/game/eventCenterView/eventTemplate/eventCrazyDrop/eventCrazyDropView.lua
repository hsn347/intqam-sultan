local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
local publicRead = include("publicRead")
local buildLogic = include("buildLogic")
local eventCrazyDropView = class("eventCrazyDropView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventCrazyDropView")
	end
	return target
end)
function eventCrazyDropView:ctor()
	_ENV, _ENV = nil, nil
	;(nil).eid = gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_0
	;(nil).name = i18n("common_text_3531")
	;(nil).des = i18n("common_text_3535")
	_ENV, (nil)[1], (nil).bg = nil, nil, "bg_amazingDrop_killMonster.png"
	;(nil).eid = gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_1
	;(nil).name = i18n("common_text_3532")
	;(nil).des = i18n("common_text_3537")
	_ENV, (nil)[2], (nil).bg = nil, nil, "bg_amazingDrop_city_collect.png"
	;(nil).eid = gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_2
	;(nil).name = i18n("common_text_3533")
	;(nil).des = i18n("common_text_3536")
	_ENV, (nil)[3], (nil).bg = nil, nil, "bg_amazingDrop_map_collect.png"
	;(nil).eid = gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_3
	;(nil).name = i18n("common_text_3534")
	;(nil).des = i18n("common_text_3538")
	self.eventList, (nil)[4], (nil).bg = nil, nil, "bg_amazingDrop_pool.png"
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("drop_name_01"))
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.scroll_event = SoraDGetChildByName(self, "Top_Size_ScrollView_event")
	self.scroll_event = include("commonAutoScrollList").new(self.scroll_event)
	self.scroll_event:setSingleCCS("eventCrazyDropSingle")
	self.scroll_rank = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	self.scroll_rank = include("commonAutoScrollList").new(self.scroll_rank)
	self.scroll_rank:setSingleCCS("eventCrazyDropRankSingle")
	self.Image_Size_left = SoraDGetChildByName(self, "Image_Size_left")
	self.Image_Size_left:setContentSize(cc.size(101, display.height - 135))
	self.Image_Size_right = SoraDGetChildByName(self, "Image_Size_right")
	self.Image_Size_right:setContentSize(cc.size(101, display.height - 135))
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.Top_Node_rank = SoraDGetChildByName(self, "Top_Node_rank")
	self.Bottom_Node_rank = SoraDGetChildByName(self, "Bottom_Node_rank")
	self.Text_des = SoraDGetChildByName(self.Top_Node_rank, "Text_des")
	self.Text_des:setString(i18n("drop_text_01"))
	self.Text_rank = SoraDGetChildByName(self.Top_Node_rank, "Text_rank")
	self.Text_rank:setString(i18n("common_text_2193"))
	self.Text_name = SoraDGetChildByName(self.Top_Node_rank, "Text_name")
	self.Text_name:setString(i18n("common_text_264"))
	self.Text_point = SoraDGetChildByName(self.Top_Node_rank, "Text_point")
	self.Text_point:setString(i18n("drop_text_02"))
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self.Bottom_Node_rank, "CCS_commonHead_head")
	self.Text_myRank = SoraDGetChildByName(self.Bottom_Node_rank, "Text_myRank")
	self.Text_myRank:setString(i18n("common_text_827"))
	self.Text_myName = SoraDGetChildByName(self.Bottom_Node_rank, "Text_myName")
	self.Text_myNum = SoraDGetChildByName(self.Bottom_Node_rank, "Text_myNum")
	self.Button_award = SoraDGetChildByName(self.Top_Node_rank, "Button_award")
	self.Button_award:addTouchEventListener(handler(self, self.btnAwardShow))
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
	_ENV = "Top_CCS_commonTabBtn_tab"
	_ENV, _ENV, ("Top_CCS_commonTabBtn_tab").tabNum = handler(self, self.btnAwardShow)
	handler(self, self.btnAwardShow).title = i18n("drop_title_01")
	_ENV, handler(self, self.btnAwardShow)[1], handler(self, self.btnAwardShow).handle = handler(self, self.btnAwardShow)
	handler(self, self.btnAwardShow).title = i18n("common_text_851")
	;("Top_CCS_commonTabBtn_tab").tabsetArray, handler(self, self.btnAwardShow)[2], handler(self, self.btnAwardShow).handle = handler(self, self.btnAwardShow)
	self.ccs_tab:initView("Top_CCS_commonTabBtn_tab")
	self:initTime()
end
function eventCrazyDropView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_RANKINGS_SUCCESS", handler(self, self.refreshRankView))
end
function eventCrazyDropView:onDropView()
	self.scroll_event:setVisible(true)
	self.scroll_rank:setVisible(false)
	self.Top_Node:setVisible(true)
	self.Bottom_Node:setVisible(true)
	self.Top_Node_rank:setVisible(false)
	self.Bottom_Node_rank:setVisible(false)
	local _ENV, openEvent = self.Bottom_Node_rank.setVisible, self.Bottom_Node_rank.setVisible
	for k, v in ipairs(self.eventList) do
		local eventState = activityShowCtrl:getStateByID(v.eid)
		if eventState == gActivityState.OPEN or eventState == gActivityState.PREPARE then
			local award = activityShowCtrl:getCrazyDropShowItems(v.eid)
			_ENV = activityShowCtrl
			activityShowCtrl.info = v
			activityShowCtrl.eventState = eventState
			local activityShowCtrl.award, data = award, activityShowCtrl
			table.insert(openEvent, data)
		end
	end
	_ENV = activityShowCtrl:getStateByID(v.eid)
	activityShowCtrl:getStateByID(v.eid).scroll = self.scroll
	activityShowCtrl:getStateByID(v.eid).view = self
	self.scroll_event:updateScrollView(cc.size(622, 200), openEvent, 1, (activityShowCtrl:getStateByID(v.eid)))
end
function eventCrazyDropView:onRankView()
	self.scroll_event:setVisible(false)
	self.scroll_rank:setVisible(true)
	self.Top_Node:setVisible(false)
	self.Bottom_Node:setVisible(false)
	self.Top_Node_rank:setVisible(true)
	self.Bottom_Node_rank:setVisible(true)
	activityShowCtrl:sendReqRankList()
end
function eventCrazyDropView:refreshRankView()
	local rankData = activityShowCtrl:getCrazyDropRankInfo()
	if rankData.selfInfo then
		self.Text_myRank:setString(rankData.selfInfo.rank == 0 and i18n("common_text_827") or rankData.selfInfo.rank)
		if rankData.selfInfo.allianceAbbr then
			activityShowCtrl = nil
			;(nil).abbr = rankData.selfInfo.allianceAbbr
			;(nil).name = rankData.selfInfo.nickName
			if i18n("common_text_186", nil) then
				goto lbl_41
			end
		end
		::lbl_41::
		self.Text_myName:setString(rankData.selfInfo.nickName)
		self.Text_myNum:setString(string.formatnumberthousands(rankData.selfInfo.score))
		self.ccs_head:setHeadSprite(rankData.selfInfo.iconID, rankData.selfInfo.avatar)
		self.ccs_head:setPlayerID(rankData.selfInfo.uid)
	end
	if rankData.rankInfo then
		local activityShowCtrl, data = rankData.rankInfo, rankData.rankInfo
		self.scroll_rank:updateScrollView(cc.size(640, 112), rankData.rankInfo)
	end
end
function eventCrazyDropView:initTime()
	local ret, status = activityShowCtrl:isCrazyDropOpenOrPrepare()
	local time = activityShowCtrl:getCrazyDropTime()
	self.Text_time:setVisible(ret)
	local lang = status == gActivityState.OPEN and i18n("common_text_3173") or i18n("common_text_608")
	if ret then
		self.Text_time:setTimeLast(function(ticket)
			return lang .. ticket
		end)
		self.Text_time:beginTime(time)
	end
end
function eventCrazyDropView:btnAwardShow(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local activityltCtrl = include("activityltCtrl")
		local rankData = rankingsCtrl:getRankRewardData(1)
		local _ENV, data = rankingsCtrl, rankingsCtrl
		for k, v in ipairs(rankData) do
			_UPVALUE2_, _ENV = nil, nil
			;(nil).rank, (nil)[1] = nil, v.rankMin
			;(nil).rank, (nil)[2] = nil, v.rankMax
			data[k], (nil).reward = nil, v.reward
		end
		local panel = SoraDCreatePanel("commonRankAwardView")
		panel:initData(data)
		panel:show()
	end
end
function eventCrazyDropView:judgeClose()
	if not activityShowCtrl:isCrazyDropOpenOrPrepare() then
		self:removeFromParent()
	end
end
return eventCrazyDropView
