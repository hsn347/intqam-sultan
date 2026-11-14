local collectSalaryCtrl = SoraDGetCtrl("collectSalaryCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local collectSalaryMainView = class("collectSalaryMainView", function(target)
	return target or SoraDCreateBasePanel("collectSalaryMainView")
end)
function collectSalaryMainView:ctor()
	self.collectSalaryMainPage = SoraDGetExtendChildFromCCSByName(self, "CCS_collectSalaryMainPage")
	self.collectSalaryRankPage = SoraDGetExtendChildFromCCSByName(self, "CCS_collectSalaryRankPage")
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnClickHelp))
	self.btnTab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.ccs_title:setTitle(i18n("activity_name_9001206"))
	_ENV = self.ccs_title.setTitle
	self.ccs_title.setTitle.tabNum = 3
	_ENV, _ENV, self.ccs_title.setTitle.defaultClick = i18n("activity_name_9001206")
	i18n("activity_name_9001206").title = i18n("activity_name_9001206")
	i18n("activity_name_9001206").handle = handler(self, self.btnClickTab)
	i18n("activity_name_9001206").fontSize = 22
	_ENV, self.ccs_title[1], i18n("activity_name_9001206").tag = i18n("activity_name_9001206")
	i18n("activity_name_9001206").title = i18n("rides_title_01")
	i18n("activity_name_9001206").handle = handler(self, self.btnClickTab)
	i18n("activity_name_9001206").fontSize = 22
	_ENV, self.ccs_title[2], i18n("activity_name_9001206").tag = i18n("activity_name_9001206")
	i18n("activity_name_9001206").title = i18n("rides_title_02")
	i18n("activity_name_9001206").handle = handler(self, self.btnClickTab)
	i18n("activity_name_9001206").fontSize = 22
	self.ccs_title.setTitle.tabsetArray, self.ccs_title[3], i18n("activity_name_9001206").tag = self.ccs_title, i18n("activity_name_9001206")
	local param = self.ccs_title.setTitle
	self.btnTab:initView(param)
end
function collectSalaryMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_COLLECT_RANK_MESSAGE", handler(self, self.callBackJumpToRank))
end
function collectSalaryMainView:btnClickTab(tag, name)
	self.collectSalaryMainPage:setVisible(tag == 3)
	self.collectSalaryRankPage:setVisible(tag ~= 3)
	if tag ~= 3 then
		self.collectSalaryRankPage:initData(tag)
	end
end
function collectSalaryMainView:btnClickHelp(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "treasuremap_text_03"
		;("treasuremap_text_03").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("treasuremap_text_03"), "treasuremap_text_03")
	end
end
function collectSalaryMainView:callBackJumpToRank(target, data)
	if data.subMsg == "Jump" then
		if data.rankType == gCollectSalaryRankType.ALLIANCE_MEMBER_RANK_TYPE then
			local hasAlliance = allianceMgr:hasJoinAlliance()
			if hasAlliance then
				_ENV = nil
				;(nil).rankType = gCollectSalaryRankType.ALLIANCE_MEMBER_RANK_TYPE
				collectSalaryCtrl:reqGetRankData(nil)
				SoraDCreatePanel("collectSalaryAllianceRank"):show()
			else
				SoraDShowMsgTip(i18n("Newbie_task_content_19"))
			end
		else
			self.btnTab:clickByTag(data.rankType)
		end
	end
end
function collectSalaryMainView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return collectSalaryMainView
