local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local allianceDesRead = include("allianceDesRead")
local allianceMobView = class("allianceMobView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMobView")
	end
	return target
end)
function allianceMobView:ctor()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setTitle(i18n("mail_text_417"))
	self.Top_Node_general = SoraDGetChildByName(self, "Top_Node_general")
	self.Bottom_Node_general = SoraDGetChildByName(self, "Bottom_Node_general")
	self.Top_Node_donate = SoraDGetChildByName(self, "Top_Node_donate")
	self.Bottom_Node_donate = SoraDGetChildByName(self, "Bottom_Node_donate")
	self.Top_Node_alliance = SoraDGetChildByName(self, "Top_Node_alliance")
	self.Bottom_Node_alliance = SoraDGetChildByName(self, "Bottom_Node_alliance")
	self.btnHelpOwn = SoraDGetChildByName(self, "btn_help")
	self.scrollList = SoraDGetChildByName(self.Top_Node_general, "Size_ScrollView_list")
	self.scrollList = include("commonAutoScrollList").new(self.scrollList)
	self.scrollList:setSingleCCS("allianceMobSingle")
	self.scrollList:setVisbileShowScale(1.5, 1.5)
	self.scrollDList = SoraDGetChildByName(self.Top_Node_donate, "Size_ScrollView_donateList")
	self.scrollDList = include("commonAutoScrollList").new(self.scrollDList)
	self.scrollDList:setSingleCCS("allianceMobMSingle")
	self.scrollAList = SoraDGetChildByName(self.Top_Node_alliance, "Size_ScrollView_allianceList")
	self.scrollAList = include("commonAutoScrollList").new(self.scrollAList)
	self.scrollAList:setSingleCCS("allianceMobASingle")
	self.Node_iconLevel = SoraDGetChildByName(self.Top_Node_general, "Node_iconLevel")
	self.Button_iconLevel = SoraDGetChildByName(self.Top_Node_general, "Button_iconLevel")
	self.Button_iconLevel:addTouchEventListener(handler(self, self.onIconLevelClick))
	self.btnHelpOwn:addTouchEventListener(handler(self, self.onFAQClick))
	self.Text_allianceName = SoraDGetChildByName(self.Top_Node_general, "Text_allianceName")
	self.Node_level = SoraDGetChildByName(self.Top_Node_general, "Node_level")
	self.BFLabel_level = SoraDGetChildByName(self.Node_level, "BitmapFontLabel_level")
	self.Text_level = SoraDGetChildByName(self.Node_level, "Text_level")
	self.Text_level:setString(i18n("common_text_279"))
	self.Panel_bar = SoraDGetChildByName(self.Top_Node_general, "Panel_bar")
	self.Text_progress = SoraDGetChildByName(self.Top_Node_general, "Text_progress")
	self.Button_price = SoraDGetChildByName(self.Top_Node_general, "Button_price")
	self.Button_price:addTouchEventListener(handler(self, self.onBtnPriceClick))
	self.Text_award = SoraDGetChildByName(self.Top_Node_general, "Text_award")
	self.Text_award:setString(i18n("common_text_2078"))
	self.Node_time = SoraDGetChildByName(self.Top_Node_general, "Node_time")
	self.Text_time = SoraDGetChildByName(self.Node_time, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Node_point = SoraDGetChildByName(self.Top_Node_general, "Node_point")
	self.Text_myPoint = SoraDGetChildByName(self.Node_point, "Text_myPoint")
	_ENV = i18n("common_text_2078")
	i18n("common_text_2078").num = ""
	self.Text_myPoint:setString(i18n("common_text_1256", i18n("common_text_2078")))
	self.Text_point = SoraDGetChildByName(self.Node_point, "Text_point")
	self.Text_tip = SoraDGetChildByName(self.Bottom_Node_general, "Text_tip")
	self.Text_tip:setString(i18n("alliance_mobilize_text_06"))
	self.Button_refresh = SoraDGetChildByName(self.Bottom_Node_general, "Button_refresh")
	self.Button_refresh:addTouchEventListener(handler(self, self.onBtnRefreshClick))
	self.Node_gold = SoraDGetChildByName(self.Button_refresh, "Node_gold")
	self.Text_refresh = SoraDGetChildByName(self.Node_gold, "Text_refresh")
	self.Text_refresh:setString(i18n("common_text_911"))
	self.Text_gold = SoraDGetChildByName(self.Node_gold, "Text_gold")
	self.Text_name = SoraDGetChildByName(self.Top_Node_donate, "Text_name")
	self.Text_name:setString(i18n("common_text_264"))
	self.Text_des = SoraDGetChildByName(self.Top_Node_donate, "Text_des")
	self.Text_des:setString(i18n("common_text_1764"))
	self.Text_rank = SoraDGetChildByName(self.Top_Node_donate, "Text_rank")
	self.Text_rank:setString(i18n("common_text_3154"))
	self.Text_aname = SoraDGetChildByName(self.Top_Node_alliance, "Text_name")
	self.Text_aname:setString(i18n("common_text_264"))
	self.Text_score = SoraDGetChildByName(self.Top_Node_alliance, "Text_score")
	self.Text_score:setString(i18n("common_text_1764"))
	self.txtRank = SoraDGetChildByName(self.Top_Node_alliance, "Text_rank")
	self.txtRank:setString(i18n("common_text_3154"))
	self.Btn_reward = SoraDGetChildByName(self.Bottom_Node_alliance, "Btn_reward")
	self.Btn_reward:addTouchEventListener(handler(self, self.onBtnPriceClick))
	self.Panel_touch = SoraDGetChildByName(self.Bottom_Node_alliance, "Panel_touch")
	self.Panel_touch:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.Panel_touch_me = SoraDGetChildByName(self.Bottom_Node_donate, "Panel_touch_me")
	self.Panel_touch_me:addTouchEventListener(handler(self, self.btnJumpMeCallBack))
	self.Panel_touch_flag = SoraDGetChildByName(self.Bottom_Node_alliance, "Panel_touch_flag")
	self.Panel_touch_flag:addTouchEventListener(handler(self, self.btnJumpAllianceCallBack))
	self.spRank = SoraDGetChildByName(self.Bottom_Node_donate, "Sprite_rank")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	_ENV = "CCS_commonTabBtn_tab"
	;("CCS_commonTabBtn_tab").tabNum = 3
	_ENV, _ENV, ("CCS_commonTabBtn_tab").defaultClick = handler(self, self.btnJumpAllianceCallBack)
	handler(self, self.btnJumpAllianceCallBack).title = i18n("alliance_mobilize_text_04")
	_ENV, handler(self, self.btnJumpAllianceCallBack)[1], handler(self, self.btnJumpAllianceCallBack).handle = handler(self, self.btnJumpAllianceCallBack)
	handler(self, self.btnJumpAllianceCallBack).title = i18n("alliance_mobilize_text_05")
	_ENV, handler(self, self.btnJumpAllianceCallBack)[2], handler(self, self.btnJumpAllianceCallBack).handle = handler(self, self.btnJumpAllianceCallBack)
	handler(self, self.btnJumpAllianceCallBack).title = i18n("common_text_1153")
	;("CCS_commonTabBtn_tab").tabsetArray, handler(self, self.btnJumpAllianceCallBack)[3], handler(self, self.btnJumpAllianceCallBack).handle = handler(self, self.btnJumpAllianceCallBack)
	self.ccs_tab:initView("CCS_commonTabBtn_tab")
	self:suitView()
end
function allianceMobView:suitView()
	self.scrollList:setContentSize(cc.size(640, display.height - 648))
	self.scrollDList:setContentSize(cc.size(640, display.height - 316))
	self.scrollAList:setContentSize(cc.size(640, display.height - 316))
	self.ccs_box = SoraDGetChildByName(self, "CCS_animationMobilizationBox_box")
	self.animationBox = self.ccs_box:getActionByTag(self.ccs_box:getTag())
	self.animationBox:gotoFrameAndPlay(0, true)
end
function allianceMobView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_COMMIT_BACK", handler(self, self.initGeneralView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_REFRESH", handler(self, self.initGeneralView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_USER_INFO_BACK", handler(self, self.initAMRankView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_RANK_INFO_BACK", handler(self, self.initAGRankView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function allianceMobView:onEnterOther()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:alliance:mobilization~bool", true, nil)
	_ENV = "Game:alliance:mobilization~bool"
	;("Game:alliance:mobilization~bool").msg = "MESSAGE_GREEN_POINT_UPDATE"
	;("Game:alliance:mobilization~bool").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE
	SoraDSendMessage("Game:alliance:mobilization~bool")
	_ENV = "Game:alliance:mobilization~bool"
	;("Game:alliance:mobilization~bool").msg = "MESSAGE_GREEN_POINT_UPDATE"
	;("Game:alliance:mobilization~bool").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_TASK
	SoraDSendMessage("Game:alliance:mobilization~bool")
	_ENV = "Game:alliance:mobilization~bool"
	;("Game:alliance:mobilization~bool").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;("Game:alliance:mobilization~bool").eventID = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY
	SoraDSendMessage("Game:alliance:mobilization~bool")
end
function allianceMobView:initGeneralView(target, data)
	SoraDCloseLoading(self)
	local ret, status, time = playerMobilizationCtrl:getShowTime()
	self.Node_time:setVisible(ret)
	if ret then
		self.Text_time:setTimeLast(function(ticket)
			if status == gMobilizationActivityStatus.ACTIVITY_PREPAREING then
				status = nil
				;(nil).time = ticket
				if i18n("common_text_606", nil) then
					goto lbl_18
				end
			end
			status = nil
			;(nil).time = ticket
			::lbl_18::
			return (i18n("common_text_607", nil))
		end)
		self.Text_time:beginTime(time)
		SoraDToCenter(self.Node_time)
	end
	local allianceScore = playerMobilizationCtrl:getAllianceScore()
	local allianceMatchlv = playerMobilizationCtrl:getAllianceMatchlev()
	self.Node_iconLevel:removeAllChildren()
	local animationLevel = SoraDCreatAnimation(string.format("animationMobilizationLv%.2d", allianceMatchlv))
	animationLevel:addTo(self.Node_iconLevel)
	local allianceInfo = playerMobilizationCtrl:getAllianceInfo()
	local stageName = mobilizationltCtrl:getMobilizationNameByLv(allianceMatchlv)
	self.Text_allianceName:setString(i18n(stageName))
	local stage, stageScore, isReachMax = mobilizationltCtrl:getCurrentStageMax(allianceScore, allianceMatchlv)
	self.BFLabel_level:setString(isReachMax and stage or stage - 1)
	SoraDToCenter(self.Node_level)
	local percent, delta, stageDelta = mobilizationltCtrl:getCurrentStagePercent(allianceScore, allianceMatchlv)
	self.Panel_bar:setContentSize(cc.size(delta * 568 / stageDelta, 92))
	_ENV = cc.size(delta * 568 / stageDelta, 92)
	cc.size(delta * 568 / stageDelta, 92).member = string.formatnumberthousands(delta)
	cc.size(delta * 568 / stageDelta, 92).total = string.formatnumberthousands(stageDelta)
	self.Text_progress:setString(i18n("common_text_155", cc.size(delta * 568 / stageDelta, 92)))
	local personScore = playerMobilizationCtrl:getPersonScore()
	self.Text_point:setString(string.formatnumberthousands(personScore))
	SoraDToCenter(self.Node_point)
	local resetTimes = playerMobilizationCtrl:getPersonResetTimes()
	self.resetGold = mobilizationltCtrl:getResetGold(allianceMatchlv, resetTimes + 1)
	self.Text_gold:setString(self.resetGold)
	SoraDToCenter(self.Node_gold, 1)
	local missionData = playerMobilizationCtrl:getMissionset()
	local _ENV, scrollData = playerMobilizationCtrl, playerMobilizationCtrl
	for k, v in pairs(missionData) do
		if not mobilizationltCtrl:getTaskDes(v.tasktypeid) then
			playerMobilizationCtrl = mobilizationltCtrl:getTaskDes(v.tasktypeid)
			mobilizationltCtrl:getTaskDes(v.tasktypeid).num = v.tasktypeid
			mobilizationltCtrl:getTaskDes(v.tasktypeid)[1] = "NA"
		end
		v.des = mobilizationltCtrl:getTaskDes(v.tasktypeid)
		v.target = mobilizationltCtrl:getTaskTarget(v.tasktypeid)
		v.lv = mobilizationltCtrl:getTaskTargetLV(v.tasktypeid)
		v.award = mobilizationltCtrl:getTaskInfo(v.tasktypeid).reward
		v.award[#v.award + 1] = 1047
		v.award[#v.award + 1] = mobilizationltCtrl:getTaskInfo(v.tasktypeid).point
		v.isTurn = mobilizationltCtrl:getTaskTurn(v.tasktypeid)
		table.insert(scrollData, v)
	end
	table.sort(scrollData, function(a, b)
		if a.taskstatus == b.taskstatus then
			return a.tasktypeid < b.tasktypeid
		else
			return a.taskstatus > b.taskstatus
		end
	end)
	if data and data.isReset then
		self.scrollList:jumpToTop()
		_ENV = table.insert
		table.insert.scroll = self.scrollList
		table.insert.view = self
		table.insert.actType = SoraDFIsRA() and 2 or 1
		self.scrollList:updateScrollView(cc.size(640, 140), scrollData, 1, table.insert, true)
		_ENV = table.insert
		table.insert.scroll = self.scrollList
		table.insert.view = self
		self.scrollList:updateScrollView(cc.size(640, 140), scrollData, 1, table.insert)
	else
		_ENV = table.insert
		table.insert.scroll = self.scrollList
		table.insert.view = self
		self.scrollList:updateScrollView(cc.size(640, 140), scrollData, 1, table.insert)
	end
end
function allianceMobView:initAMRankView(target, data)
	local Text_myRank = SoraDGetChildByName(self.Bottom_Node_donate, "Text_myRank")
	local Sprite_index = SoraDGetChildByName(self.Bottom_Node_donate, "Sprite_index")
	local Text_myName = SoraDGetChildByName(self.Bottom_Node_donate, "Text_myName")
	local Text_myNum = SoraDGetChildByName(self.Bottom_Node_donate, "Text_myNum")
	local ccs_head = SoraDGetExtendChildFromCCSByName(self.Bottom_Node_donate, "CCS_commonHead_head")
	local rankList = playerMobilizationCtrl:getAllianceRankInfo()
	local myScore = playerMobilizationCtrl:getPersonScore()
	local myAllianceRank = 0
	dump(rankList, "weoruoiweuroweiru")
	rankList.currank = rankList.currank or 0
	if rankList.currank == 0 then
		Sprite_index:setVisible(false)
		Text_myRank:setVisible(true)
		Text_myRank:setString(i18n("common_text_3575"))
	elseif rankList.currank <= RANK_TOP_SPECIAL then
		Sprite_index:setVisible(true)
		Text_myRank:setVisible(false)
		Sprite_index:setSpriteFrame("icon_ranking_" .. rankList.currank .. ".png")
	else
		Sprite_index:setVisible(false)
		Text_myRank:setString(rankList.currank)
	end
	if not rankList.rankdata then
		_ENV = rankList.rankdata
	end
	for i, v in ipairs(rankList.rankdata) do
		if gametop.playertop_:getPlayerID() == v.uid then
			myAllianceRank = v.alliancerank
		end
	end
	self.spRank:setSpriteFrame(allianceDesRead.getIcon(myAllianceRank))
	Text_myName:setString(lordInfoCtrl:getBaseInfo().nickName)
	Text_myNum:setString(string.formatnumberthousands(myScore))
	ccs_head:setHeadSprite()
	ccs_head:setPlayerID()
	if not rankList.rankdata then
		_ENV = rankList.rankdata
	end
	_ENV = string.formatnumberthousands(myScore)
	string.formatnumberthousands(myScore).scroll = self.scrollDList
	string.formatnumberthousands(myScore).view = self
	self.scrollDList:updateScrollView(cc.size(640, 120), rankList.rankdata, 1, string.formatnumberthousands(myScore))
end
function allianceMobView:initAGRankView(target, data)
	local Text_aRank = SoraDGetChildByName(self.Bottom_Node_alliance, "Text_aRank")
	local Sprite_index = SoraDGetChildByName(self.Bottom_Node_alliance, "Sprite_index")
	local Node_allianceFlag = SoraDGetChildByName(self.Bottom_Node_alliance, "Node_allianceFlag")
	local Text_aName = SoraDGetChildByName(self.Bottom_Node_alliance, "Text_aName")
	local Text_aLordName = SoraDGetChildByName(self.Bottom_Node_alliance, "Text_aLordName")
	local Text_aNum = SoraDGetChildByName(self.Bottom_Node_alliance, "Text_aNum")
	local groupInfo = playerMobilizationCtrl:getGroupRankInfo()
	local myScore = playerMobilizationCtrl:getAllianceScore()
	groupInfo.currank = groupInfo.currank or 0
	if groupInfo.currank == 0 then
		Sprite_index:setVisible(false)
		Text_aRank:setVisible(true)
		Text_aRank:setString(i18n("common_text_3575"))
	elseif groupInfo.currank <= RANK_TOP_SPECIAL then
		if 0 < myScore then
			Sprite_index:setVisible(true)
			Text_aRank:setVisible(false)
			Sprite_index:setSpriteFrame("icon_ranking_" .. groupInfo.currank .. ".png")
		else
			Sprite_index:setVisible(false)
			Text_aRank:setVisible(true)
			Text_aRank:setString(i18n("common_text_3575"))
		end
	else
		Sprite_index:setVisible(false)
		if myScore <= 0 then
			Text_aRank:setString(i18n("common_text_3575"))
		else
			Text_aRank:setString(groupInfo.currank)
		end
	end
	local flagID = allianceMgr:getAllianceProperty("flag")
	Node_allianceFlag:removeAllChildren()
	local flag = SoraDGetAllianceFlagByFid(flagID)
	flag:addTo(Node_allianceFlag)
	local abbr = allianceMgr:getAllianceProperty("abbr")
	local aname = allianceMgr:getAllianceProperty("name")
	_ENV = i18n("common_text_3575")
	i18n("common_text_3575").abbr = abbr
	i18n("common_text_3575").name = aname
	local nameStr = string.format("%s#%d", i18n("common_text_186", i18n("common_text_3575")), gametop.playertop_:getKingdomID())
	Text_aName:setString(nameStr)
	local leaderName = allianceMgr:getAllianceProperty("leaderName")
	_ENV = gametop.playertop_:getKingdomID()
	gametop.playertop_:getKingdomID().name = leaderName
	Text_aLordName:setString(i18n("common_text_926", gametop.playertop_:getKingdomID()))
	Text_aNum:setString(string.formatnumberthousands(myScore))
	if not groupInfo.rankdata then
		_ENV = groupInfo.rankdata
	end
	_ENV = string.formatnumberthousands(myScore)
	string.formatnumberthousands(myScore).scroll = self.scrollAList
	string.formatnumberthousands(myScore).view = self
	self.scrollAList:updateScrollView(cc.size(640, 120), groupInfo.rankdata, 1, string.formatnumberthousands(myScore))
end
function allianceMobView:onGeneralClick(tag, name)
	self.Top_Node_general:setVisible(true)
	self.Bottom_Node_general:setVisible(true)
	self.Top_Node_donate:setVisible(false)
	self.Bottom_Node_donate:setVisible(false)
	self.Top_Node_alliance:setVisible(false)
	self.Bottom_Node_alliance:setVisible(false)
	self:initGeneralView()
end
function allianceMobView:onMemberClick(tag, name)
	self.Top_Node_general:setVisible(false)
	self.Bottom_Node_general:setVisible(false)
	self.Top_Node_donate:setVisible(true)
	self.Bottom_Node_donate:setVisible(true)
	self.Top_Node_alliance:setVisible(false)
	self.Bottom_Node_alliance:setVisible(false)
	print("--请求联盟贡献排行榜")
	playerMobilizationCtrl:reqRankInfo()
end
function allianceMobView:onAllianceClick(tag, name)
	self.Top_Node_general:setVisible(false)
	self.Bottom_Node_general:setVisible(false)
	self.Top_Node_donate:setVisible(false)
	self.Bottom_Node_donate:setVisible(false)
	self.Top_Node_alliance:setVisible(true)
	self.Bottom_Node_alliance:setVisible(true)
	playerMobilizationCtrl:reqGroupRankInfo()
end
function allianceMobView:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(self)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "mobilization" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function allianceMobView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY) then
		self:removeFromParent()
	end
end
function allianceMobView:onIconLevelClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("commonInstruction"):show()
	end
end
function allianceMobView:onBtnPriceClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceMobAwardView"):show()
	end
end
function allianceMobView:btnJumpClickCallBack(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local groupInfo = playerMobilizationCtrl:getGroupRankInfo()
		if groupInfo.currank and groupInfo.currank > 0 then
			self.scrollAList:jumpIndexToTop(groupInfo.currank)
		end
	end
end
function allianceMobView:btnJumpMeCallBack(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local rankList = playerMobilizationCtrl:getAllianceRankInfo()
		if rankList.currank and rankList.currank > 0 then
			self.scrollDList:jumpIndexToTop(rankList.currank)
		end
	end
end
function allianceMobView:btnJumpAllianceCallBack(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading(self)
		_ENV = nil
		;(nil).aid = allianceMgr:getOwnAid()
		_ENV, (nil).kid = gametop.playertop_:getKingdomID(), gametop.playertop_:getKingdomID()
		gametop.playertop_:getKingdomID().from = "mobilization"
		allianceQuery:reqAllianceByID(nil, (gametop.playertop_:getKingdomID()))
	end
end
function allianceMobView:onFAQClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_MOBILIZATION)
	end
end
function allianceMobView:onBtnRefreshClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceMobResetView")
		panel:initData(self.resetGold, self)
		panel:show()
	end
end
return allianceMobView
