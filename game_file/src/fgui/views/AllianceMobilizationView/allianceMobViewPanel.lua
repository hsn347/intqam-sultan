local playerMobilizationCtrl = SoraDGetCtrl("playerMobilizationCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceDesRead = include("allianceDesRead")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceMobViewPanel = class("allianceMobViewPanel", baseFguiPanel)
function allianceMobViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceMobViewPanel:ctor", self.viewName)
end
function allianceMobViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceMobViewPanel:onInit()
	print("=======allianceMobViewPanel:onInit")
	self.alliRankList, _ENV, self.memberRankList, _ENV, self.taskList, _ENV, self.tag = print, print, print, print, print, print, 1
	self.fields.Com_title:initData(i18n("mail_text_417"), handler(self, self.onClickClose), handler(self, self.onFAQClick))
	self.fields.Text_level:setString(i18n("common_text_279"))
	self.fields.Button_price:setTitle(i18n("common_text_2078"))
	self.fields.Button_price:addClickListener(handler(self, self.onBtnPriceClick))
	self.fields.Text_tip:setString(i18n("alliance_mobilize_text_06"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onBtnRefreshClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onTaskRenderer))
	self.fields.List_rankMember:setVirtual()
	self.fields.List_rankMember:setItemRenderer(handler(self, self.onMemberRenderer))
	self.fields.List_rankAlli:setVirtual()
	self.fields.List_rankAlli:setItemRenderer(handler(self, self.onAlliRenderer))
	self.fields.Text_rank:setString(i18n("common_text_3154"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_des:setString(i18n("common_text_1764"))
	self.fields.Text_level:fixPos()
	self.fields.BitmapFontLabel_level:fixPos()
	self.fields.Button_price:fixPos()
	self.fields.Text_tip:fixPos()
	self.fields.Button_refresh:fixPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_des:fixPos()
end
function allianceMobViewPanel:onShow()
	print("=======allianceMobViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("alliance_mobilize_text_04")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("alliance_mobilize_text_05")
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("common_text_1153")
	;(nil).tabsetArray, self.tag[3], (nil).tag = self.tag, nil, 3
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
end
function allianceMobViewPanel:endShow()
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
function allianceMobViewPanel:onTaskRenderer(index, obj)
	obj:initData(self.taskList[index + 1], self)
end
function allianceMobViewPanel:onMemberRenderer(index, obj)
	obj:initData(self.memberRankList[index + 1])
end
function allianceMobViewPanel:onAlliRenderer(index, obj)
	obj:initData(self.alliRankList[index + 1])
end
function allianceMobViewPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		self:initGeneralView()
	elseif self.tag == 2 then
		playerMobilizationCtrl:reqRankInfo()
	elseif self.tag == 3 then
		playerMobilizationCtrl:reqGroupRankInfo()
	end
end
function allianceMobViewPanel:initGeneralView(target, data)
	SoraDCloseLoading(self)
	local ret, status, time = playerMobilizationCtrl:getShowTime()
	self.fields.timer:setVisible(ret)
	if ret then
		self.fields.timer:setTimeLast(function(ticket)
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
		self.fields.timer:beginTime(time)
	end
	local allianceMatchlv = playerMobilizationCtrl:getAllianceMatchlev()
	self.fields.Button_iconLevel:setAniLv(allianceMatchlv)
	local allianceScore = playerMobilizationCtrl:getAllianceScore()
	local stage, stageScore, isReachMax = mobilizationltCtrl:getCurrentStageMax(allianceScore, allianceMatchlv)
	self.fields.BitmapFontLabel_level:setString(isReachMax and stage or stage - 1)
	local percent, delta, stageDelta = mobilizationltCtrl:getCurrentStagePercent(allianceScore, allianceMatchlv)
	_ENV = nil
	;(nil).member = string.formatnumberthousands(delta)
	;(nil).total = string.formatnumberthousands(stageDelta)
	self.fields.Text_progress:setString(i18n("common_text_155", nil))
	self.fields.Bar:setValue(delta * 100 / stageDelta)
	local personScore = playerMobilizationCtrl:getPersonScore()
	_ENV = i18n("common_text_155", nil)
	i18n("common_text_155", nil).num = fguiHelper.getColorString("#FFC864", string.formatnumberthousands(personScore))
	self.fields.Com_score:setString(i18n("common_text_1256", i18n("common_text_155", nil)))
	local resetTimes = playerMobilizationCtrl:getPersonResetTimes()
	self.resetGold = mobilizationltCtrl:getResetGold(allianceMatchlv, resetTimes + 1)
	self.fields.Button_refresh:setString(self.resetGold)
	self.taskList, _ENV = self.fields.Button_refresh.setString, self.fields.Button_refresh.setString
	local missionData = playerMobilizationCtrl:getMissionset()
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
		table.insert(self.taskList, v)
	end
	table.sort(self.taskList, function(a, b)
		if a.taskstatus == b.taskstatus then
			return a.tasktypeid < b.tasktypeid
		else
			return a.taskstatus > b.taskstatus
		end
	end)
	self.fields.List:setNumItems(#self.taskList)
	self.fields.List:jumpToTop()
end
function allianceMobViewPanel:initAMRankView(target, data)
	local rankList = playerMobilizationCtrl:getAllianceRankInfo()
	local myScore = playerMobilizationCtrl:getPersonScore()
	local myRank = rankList.currank or 0
	if not rankList.rankdata then
		playerMobilizationCtrl = rankList.rankdata
	end
	self.memberRankList = rankList.rankdata
	local myRankInfo = self.memberRankList[myRank]
	if not myRankInfo then
		local ownmember = memberMgr:getOwnMember()
		playerMobilizationCtrl = memberMgr
		memberMgr.rank = 0
		memberMgr.score = myScore
		memberMgr.uid = lordInfoCtrl:getLordInfo().base.uid
		playerMobilizationCtrl, memberMgr.alliancerank = ownmember.minfo.rank, ownmember.minfo.rank
		ownmember.minfo.rank.avatar = lordInfoCtrl:getBaseInfo().avatar
		ownmember.minfo.rank.headid = lordInfoCtrl:getBaseInfo().imageId
		myRankInfo, memberMgr.uInfo, ownmember.minfo.rank.nickName = memberMgr, ownmember.minfo.rank, lordInfoCtrl:getBaseInfo().nickName
	end
	self.fields.Com_self:initData(myRankInfo)
	self.fields.List_rankMember:setNumItems(#self.memberRankList)
end
function allianceMobViewPanel:initAGRankView(target, data)
	local groupInfo = playerMobilizationCtrl:getGroupRankInfo()
	local myScore = playerMobilizationCtrl:getAllianceScore()
	local myRank = groupInfo.currank or 0
	if not groupInfo.rankdata then
		playerMobilizationCtrl = groupInfo.rankdata
	end
	self.alliRankList = groupInfo.rankdata
	local myRankInfo = self.alliRankList[myRank]
	if not myRankInfo then
		local allianceInfo = allianceMgr:getAlliance()
		playerMobilizationCtrl = allianceMgr
		allianceMgr.rank = 0
		allianceMgr.score = myScore
		allianceMgr.aid = allianceMgr:getOwnAid()
		playerMobilizationCtrl, allianceMgr.leadername = allianceMgr:getAllianceLeaderName(), allianceMgr:getAllianceLeaderName()
		allianceMgr:getAllianceLeaderName().allianceAbbr = allianceInfo:getProperty("abbr")
		allianceMgr:getAllianceLeaderName().allianceFlag = allianceInfo:getProperty("flag")
		myRankInfo, allianceMgr.aInfo, allianceMgr:getAllianceLeaderName().allianceName = allianceMgr, allianceMgr:getAllianceLeaderName(), allianceInfo:getProperty("name")
	end
	self.fields.Com_myAlli:initData(myRankInfo)
	self.fields.List_rankAlli:setNumItems(#self.alliRankList)
end
function allianceMobViewPanel:onBtnRefreshClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("allianceMobResetView")
	panel:initData(self.resetGold, self)
	panel:show()
end
function allianceMobViewPanel:onBtnPriceClick()
	SoraDPlaySound()
	uiManager:show("allianceMobAwardView")
end
function allianceMobViewPanel:onFAQClick()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_MOBILIZATION)
end
return allianceMobViewPanel
