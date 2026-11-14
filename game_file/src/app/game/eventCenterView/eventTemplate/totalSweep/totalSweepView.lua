local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local annihilationCtrl = gametop.playertop_:getModule("annihilationCtrl")
local annihilationRead = include("annihilationRead")
local totalSweepView = class("totalSweepView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("totalSweepView")
	end
	return target
end)
function totalSweepView:ctor()
	self.awardBoxArray, _ENV, self.isHideCurrentSceneView = nil, nil, true
	self.isRank = false
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_bg")
	self.ccs_title:setTitle(i18n("activityname_9001131"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.Image_event:loadTexture("bg_activity_9001131.png", ccui.TextureResType.plistType)
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Top_Node_load = SoraDGetChildByName(self, "Top_Node_load")
	self.ScrollView_load = SoraDGetChildByName(self.Top_Node_load, "ScrollView_load")
	self.Node_progressContent = SoraDGetChildByName(self.ScrollView_load, "Node_progressContent")
	self.Node_title = SoraDGetChildByName(self.ScrollView_load, "Node_title")
	self.Text_eventTitle = SoraDGetChildByName(self.Node_title, "Text_eventTitle")
	self.Text_eventTitle:setString(i18n("annihilation_text_05"))
	SoraDToCenter(self.Node_title, 20)
	self.Text_contextTitle = SoraDGetChildByName(self.ScrollView_load, "Text_contextTitle")
	self.Text_contextTitle:setString(i18n("annihilation_text_06"))
	self.Text_context = SoraDChangeTextToHtml(SoraDGetChildByName(self.ScrollView_load, "Text_context"))
	_ENV = SoraDGetChildByName(self.ScrollView_load, "Text_context")
	SoraDGetChildByName(self.ScrollView_load, "Text_context").extra = i18n("annihilation_text_08")
	SoraDGetChildByName(self.ScrollView_load, "Text_context").box = i18n("annihilation_text_09")
	_ENV, _ENV, SoraDGetChildByName(self.ScrollView_load, "Text_context").reward = "common_text_2194", i18n("common_text_2194"), i18n("common_text_2194")
	_ENV, i18n("common_text_2194").extra, ("common_text_2194").color = "common_text_2194", "common_text_2194", "#ffff00"
	_ENV, i18n("common_text_2194").box, ("common_text_2194").color = "common_text_2194", "common_text_2194", "#ffff00"
	_ENV, i18n("common_text_2194").reward, ("common_text_2194").color = "common_text_2194", "common_text_2194", "#ffff00"
	i18n("common_text_2194").__default, ("common_text_2194").color = "common_text_2194", "#d7c39b"
	self.Text_context:setString(i18n_html("annihilation_text_07", SoraDGetChildByName(self.ScrollView_load, "Text_context")))
	self.Text_questTitle = SoraDGetChildByName(self.ScrollView_load, "Text_questTitle")
	self.Text_questTitle:setString(i18n("annihilation_title_01"))
	self.Text_questProgress = SoraDGetChildByName(self.ScrollView_load, "Text_questProgress")
	self.Text_fightNum = SoraDGetChildByName(self.ScrollView_load, "Text_fightNum")
	self.Node_progress = SoraDGetChildByName(self.ScrollView_load, "Node_progress")
	self.LoadingBar_progress = SoraDGetChildByName(self.Node_progress, "LoadingBar_progress")
	self.Button_goto = SoraDGetChildByName(self, "Button_goto")
	self.Button_goto:setTitleText(i18n("annihilation_btn_01"))
	self.Button_goto:addTouchEventListener(handler(self, self.btnGotoClick))
	self.Top_Node_rank = SoraDGetChildByName(self, "Top_Node_rank")
	self.Text_personint = SoraDGetChildByName(self.Top_Node_rank, "Text_personint")
	self.Text_personint:setString(i18n("common_text_2195"))
	self.Text_personname = SoraDGetChildByName(self.Top_Node_rank, "Text_personname")
	self.Text_personname:setString(i18n("rides_title_03"))
	self.Text_personrank = SoraDGetChildByName(self.Top_Node_rank, "Text_personrank")
	self.Text_personrank:setString(i18n("common_text_2193"))
	self.ScrollView_rank = SoraDGetChildByName(self.Top_Node_rank, "ScrollView_rank")
	self.ScrollView_rank = include("commonAutoScrollList").new(self.ScrollView_rank)
	self.ScrollView_rank:setSingleCCS("totalSweepRankSingle")
	self.Text_noPersonalRecord = SoraDGetChildByName(self.Top_Node_rank, "Text_noPersonalRecord")
	self.Text_noPersonalRecord:setString(i18n("common_text_1464"))
	self.Node_bottom_self = SoraDGetChildByName(self.Top_Node_rank, "Node_bottom_self")
	self.Button_personPrice = SoraDGetChildByName(self.Node_bottom_self, "Button_personPrice")
	self.Button_personPrice:setTitleText(i18n("common_text_2194"))
	self.Button_personPrice:addTouchEventListener(handler(self, self.btnRankAwardClick))
	SoraDAutoSizeButtonText(self.Button_personPrice, cc.size(210, 50))
	self.Text_rankTip = SoraDChangeTextToHtml(SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip"))
	_ENV = SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")
	_ENV, _ENV, SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip").num = 500000, string.formatnumberthousands(500000), string.formatnumberthousands(500000)
	;(500000).color = "#ffff00"
	_ENV, string.formatnumberthousands(500000).num, (500000).i = 500000, 500000, "true"
	string.formatnumberthousands(500000).__default, (500000).color = 500000, "#d7c39b"
	self.Text_rankTip:setString(i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")))
	self.Node_selfPerson = SoraDGetChildByName(self.Node_bottom_self, "Node_selfPerson")
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self.Node_selfPerson, "CCS_commonHead_head")
	self.ccs_head:setPlayerID()
	self.ccs_head:setHeadSprite()
	self.Text_lordNum = SoraDGetChildByName(self.Node_selfPerson, "Text_lordNum")
	self.Image_lordNum = SoraDGetChildByName(self.Node_selfPerson, "Image_lordNum")
	self.Image_lordNum:setVisible(false)
	self.Text_name = SoraDGetChildByName(self.Node_selfPerson, "Text_name")
	local lordInfo = lordInfoCtrl:getBaseInfo()
	self.Text_name:setString(lordInfo.nickName)
	self.Text_point = SoraDGetChildByName(self.Node_selfPerson, "Text_point")
	self.btns = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	_ENV = "CCS_commonTabBtn_btns"
	;("CCS_commonTabBtn_btns").tabNum = 2
	_ENV, _ENV, ("CCS_commonTabBtn_btns").defaultClick = i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip"))
	i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")).title = i18n("annihilation_title_01")
	i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")).handle = handler(self, self.btnClickCallBack)
	i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")).fontSize = 22
	_ENV, i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip"))[1], i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")).tag = i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip"))
	i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")).title = i18n("annihilation_title_02")
	i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")).handle = handler(self, self.btnClickCallBack)
	i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")).fontSize = 22
	;("CCS_commonTabBtn_btns").tabsetArray, i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip"))[2], i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip")).tag = i18n_html("annihilation_text_02", SoraDGetChildByName(self.Node_bottom_self, "Text_rankTip"))
	self.btns:initView("CCS_commonTabBtn_btns")
	self:suitView()
	self:setTime()
	self:initData()
end
function totalSweepView:suitView()
	self.ScrollView_load:setContentSize(cc.size(640, display.height - 370))
	self.ScrollView_load:setInnerContainerSize(cc.size(640, math.max(590, display.height - 370)))
	self.Node_progressContent:setPositionY(math.max(590, display.height - 370))
	self.ScrollView_rank:setContentSize(cc.size(640, display.height - 610))
	self.Text_noPersonalRecord:setPositionY(-self.Top_Node_rank:getPositionY() / 2 + 110)
	self.Node_bottom_self:setPositionY(-self.Top_Node_rank:getPositionY() + 130)
end
function totalSweepView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ANNIHILATION_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
end
function totalSweepView:initData(target, data)
	SoraDCloseLoading(self)
	if self.isRank then
		self.myRank = annihilationCtrl:getMyRankData()
		self.rankData = annihilationCtrl:getRankData()
		self:initRankView()
	else
		self.score = annihilationCtrl:getScore()
		self.boxData = annihilationRead.getRewardBoxInfo()
		self:initView()
	end
	self:refreshTabPoint()
end
function totalSweepView:initRankView()
	self.myRank.rank = self.myRank.rank or 0
	self.myRank.score = self.myRank.score or 0
	local rankStr = (self.myRank.rank < 1 or self.myRank.rank > 300) and i18n("rides_btn_01") or self.myRank.rank
	self.Text_lordNum:setString(rankStr)
	local isTopThree = self.myRank.rank > 0 and self.myRank.rank <= RANK_TOP_SPECIAL
	self.Image_lordNum:setVisible(isTopThree)
	self.Text_lordNum:setVisible(not isTopThree)
	if isTopThree then
		self.Image_lordNum:loadTexture("icon_ranking_" .. self.myRank.rank .. ".png", ccui.TextureResType.plistType)
	end
	self.Text_point:setString(string.formatnumberthousands(self.myRank.score))
	self.Text_noPersonalRecord:setVisible(not next(self.rankData))
	self.ScrollView_rank:updateScrollView(cc.size(570, 80), self.rankData)
end
function totalSweepView:initView()
	_ENV = nil
	;(nil).num = string.formatnumberthousands(self.score)
	self.Text_fightNum:setString(i18n("annihilation_text_04", nil))
	_ENV = i18n("annihilation_text_04", nil)
	i18n("annihilation_text_04", nil).num = annihilationRead.getRewardBoxPlan(self.score)
	self.Text_questProgress:setString(i18n("common_text_4424", i18n("annihilation_text_04", nil)))
	self:setLoadingBar()
	self:setAwardBox()
end
function totalSweepView:setLoadingBar()
	local percent = 0
	if self.score <= annihilationRead.getRewardBoxInfo(1).num then
		percent = 0
	elseif self.score >= annihilationRead.getMaxRewardBoxScore() then
		percent = 1
	else
		local per = 1 / (#self.boxData - 1)
		local curIndex = 0
		for k, v in ipairs(self.boxData) do
			if self.score <= v.num then
				curIndex = k
				break
			end
		end
		local boxData = annihilationRead.getRewardBoxInfo(curIndex - 1)
		local nextBoxData = annihilationRead.getRewardBoxInfo(curIndex)
		percent = per * (curIndex - 2) + per * (self.score - boxData.num) / (nextBoxData.num - boxData.num)
	end
	self.LoadingBar_progress:setPercent(percent * 100)
end
function totalSweepView:setTime()
	local eventTimer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ANNIHILATION)
	local stime = activityShowCtrl:getBeginTimeSecond(gActivityTimeActivityID.ANNIHILATION)
	local etime = activityShowCtrl:getEndTimeSecond(gActivityTimeActivityID.ANNIHILATION)
	local timeTick = eventTimer.timerNode.timer:getRemainTime()
	self.Text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return os.date("%Y.%m.%d", stime) .. "-" .. os.date("%Y.%m.%d", etime) .. "\n" .. i18n("common_text_607", nil)
	end)
	self.Text_time:beginTime(timeTick)
end
function totalSweepView:judgeEventClose(target, data)
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.ANNIHILATION)
	if gActivityState.CLOSE == state then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function totalSweepView:btnClickCallBack(tag, name)
	if 1 == tag then
		self.isRank = false
		self.Top_Node_load:setVisible(true)
		self.Top_Node_rank:setVisible(false)
	elseif 2 == tag then
		self.isRank = true
		SoraDShowLoading(self)
		annihilationCtrl:sendReqRankDataMsg()
		self.Top_Node_load:setVisible(false)
		self.Top_Node_rank:setVisible(true)
	end
end
function totalSweepView:setAwardBox()
	for i = 1, #self.boxData do
		if not self.awardBoxArray[i] then
			self.awardBoxArray[i] = SoraDCreatePanel("totalSweepAwardBox")
			self.awardBoxArray[i]:setIndex(i)
			self.awardBoxArray[i]:setPosition(SoraDFPosX(210 - (i - 1) * 420 / (#self.boxData - 1), 0), -90)
			self.awardBoxArray[i]:addTo(self.Node_progress, 9)
		end
		self.awardBoxArray[i]:initData(self.boxData[i])
	end
end
function totalSweepView:refreshTabPoint()
	local ret, num = annihilationCtrl:isCanClaimBox()
	self.btns:setRedPointState(1, ret)
end
function totalSweepView:btnGotoClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPanelFromManager()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD, nil)
	end
end
function totalSweepView:btnRankAwardClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("totalSweepRankReward"):show()
	end
end
function totalSweepView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "annihilation_text_10"
		;("annihilation_text_10").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("annihilation_text_10"), "annihilation_text_10")
	end
end
return totalSweepView
