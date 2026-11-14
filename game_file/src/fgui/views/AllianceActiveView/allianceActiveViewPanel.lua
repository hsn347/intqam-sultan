local allianceActiveltCtrl = include("allianceActiveltCtrl")
local allianceActiveCtrl = SoraDGetCtrl("allianceActiveCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceActiveViewPanel = class("allianceActiveViewPanel", baseFguiPanel)
function allianceActiveViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceActiveViewPanel:ctor", self.viewName)
end
function allianceActiveViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceActiveViewPanel:onInit()
	print("=======allianceActiveViewPanel:onInit")
	self.boxArray, _ENV = print, print
	self.mIndex = 1
	self.taskList, _ENV, self.isPublish = print, print, false
	self.fields.Com_title:initData(i18n("alliance_text_21"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.fields.Text_active:setString(i18n("alliance_text_22"))
	self.fields.Button_level:addClickListener(handler(self, self.btnLevelClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	self.fields.Text_None:setString(i18n("alliance_text_31"))
	self.fields.Text_None:setVisible(false)
	self.fields.Button_contactLord:setString(i18n("common_text_179"))
	self.fields.Button_contactLord:addClickListener(handler(self, self.btnContactClick))
	self.fields.Button_contactLord:setVisible(false)
	self.fields.Button_Rank:setString(i18n("alliance_active_text_001"))
	self.fields.Button_Rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.ntbbg:fixPos()
	self.fields.Text_boxTip:fixPos()
	self.fields.LoadingBar_progress:fixPos()
	self.fields.LoadingBar_progress:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.List_box:fixPos()
	self.fields.Text_active:fixPos()
	self.fields.n8:fixPos()
	self.fields.Font_level:fixPos()
	self.fields.Button_level:fixPos()
	self.fields.LoadingBar_barLv:fixPos()
	self.fields.LoadingBar_barLv:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_lvBar:fixPos()
	self.fields.Button_Rank:fixPos()
end
function allianceActiveViewPanel:onShow()
	print("=======allianceActiveViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:fixView()
	self:initBox()
end
function allianceActiveViewPanel:fixView()
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	self.isManager = ownRank >= gAllianceRank.R5
	if self.isManager then
		self.mIndex = 2
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Button_contactLord:setString(i18n("common_text_179"))
		memberMgr = i18n("common_text_179")
		memberMgr, memberMgr, i18n("common_text_179").defaultClick = i18n("common_text_179")
		i18n("common_text_179").title = i18n("alliance_title_06")
		memberMgr, self.mIndex[1], i18n("common_text_179").tag = i18n("common_text_179")
		i18n("common_text_179").title = i18n("alliance_title_05")
		i18n("common_text_179").tabsetArray, self.mIndex[2], i18n("common_text_179").tag = self.mIndex, i18n("common_text_179")
		i18n("common_text_179").callback = handler(self, self.onTabClick)
		self.fields.Com_tab:initView(i18n("common_text_179"))
		self:updateRedNum()
	else
		self.mIndex = 1
		self.controllers.c1:setSelectedIndex(0)
		self.taskList = allianceActiveCtrl:getCurPublishList()
		self.isPublish = false
		self.fields.List:setNumItems(#self.taskList)
		self.fields.List:jumpToTop()
		self.fields.Text_None:setVisible(0 >= #self.taskList)
		self.fields.Button_contactLord:setVisible(0 >= #self.taskList)
		self.fields.Button_contactLord:setString(i18n("common_text_179"))
	end
	self.fields.Text_published:setPositionX(self:getWidth() / 2)
	self:setStaticData()
end
function allianceActiveViewPanel:setStaticData()
	self:updatePublished()
	_ENV = nil
	;(nil).num = string.formatnumberthousands(allianceActiveCtrl:getActiveTodayPoint())
	self.fields.Text_boxTip:setString(i18n("alliance_title_04", nil))
	local lv = allianceActiveCtrl:getActiveLevel()
	self.fields.Font_level:setString(lv)
	local aPoint = allianceActiveCtrl:getActivePoint()
	local tPoint = allianceActiveltCtrl.getActiveLvPoint(lv + 1)
	self.fields.LoadingBar_barLv:setValue(math.floor(aPoint * 100 / tPoint))
	if aPoint >= tPoint then
		self.fields.Text_lvBar:setString(i18n("hero_text_41"))
	else
		_ENV = i18n("hero_text_41")
		i18n("hero_text_41").member = aPoint
		i18n("hero_text_41").total = tPoint
		self.fields.Text_lvBar:setString(i18n("common_text_155", i18n("hero_text_41")))
	end
end
function allianceActiveViewPanel:updatePublished()
	if self.isManager and self.mIndex == 2 then
		_ENV = nil
		;(nil).num = allianceActiveCtrl:getCurPublishNum()
		;(nil).max = ALLIANCE_ACTIVE_MAX_PUBLISH_NUM
		self.fields.Text_published:initData(i18n("alliance_text_27", nil), true)
	else
		_ENV = nil
		;(nil).num = allianceActiveCtrl:getMyTodayAcceptNum()
		;(nil).max = ALLIANCE_ACTIVE_PERSON_DAILY_MAX_ACCEPT_NUM
		self.fields.Text_published:initData(i18n("alliance_text_30", nil))
	end
end
function allianceActiveViewPanel:onTabClick(tag)
	self.mIndex = tag
	if self.mIndex == 2 then
		self.taskList = allianceActiveCtrl:getCurShowList()
		self.isPublish = true
	else
		self.taskList = allianceActiveCtrl:getCurPublishList()
		self.isPublish = false
		self:updateRedNum()
	end
	self.fields.List:setNumItems(#self.taskList)
	self.fields.List:jumpToTop()
	self.fields.Text_None:setVisible(#self.taskList <= 0)
	self.fields.Button_contactLord:setVisible(#self.taskList <= 0)
	self.fields.Button_contactLord:setString(i18n("alliance_btn_01"))
	self:updatePublished()
end
function allianceActiveViewPanel:updateRedNum()
	if self.isManager then
		local rewardNum = allianceActiveCtrl:getCanReceiveTaskNum()
		self.fields.Com_tab:setBtnRedDot(1, 0 < rewardNum, rewardNum)
	end
end
function allianceActiveViewPanel:initBox()
	self.curPoint = allianceActiveCtrl:getActiveTodayPoint()
	local curLv = allianceActiveCtrl:getActiveLevel()
	local boxesInfo, boxedPoint = allianceActiveltCtrl.getActiveBoxesInfo(curLv)
	local nextPoint = allianceActiveltCtrl.getActiveLvPoint(curLv + 1)
	local percent = SoraDGetStageValue(self.curPoint, boxedPoint)
	self.fields.LoadingBar_progress:setValue(percent)
	self.boxArray = boxesInfo
	self.fields.List_box:setNumItems(#self.boxArray)
end
function allianceActiveViewPanel:onItemRenderer(index, obj)
	obj:initData(self.taskList[index + 1], self.isPublish)
end
function allianceActiveViewPanel:onBoxRenderer(index, obj)
	obj:initData(self.boxArray[index + 1], self.curPoint)
end
function allianceActiveViewPanel:updateTask(target, data)
	self:onTabClick(self.mIndex)
	self:setStaticData()
	self:updateRedNum()
	self:initBox()
end
function allianceActiveViewPanel:updateOffice(target, data)
	self:fixView()
end
function allianceActiveViewPanel:btnContactClick()
	SoraDPlaySound()
	if self.isManager then
		self.fields.Com_tab:setDefaultClick(2, 2)
	else
		local alliance = allianceMgr:getAlliance()
		if alliance then
			local playerId = alliance:getProperty("leader")
			local nickName = alliance:getProperty("leaderName")
			local allianceAbbr = alliance:getProperty("abbr")
			local chatFunctions = include("chatFunctions")
			if playerId == chatFunctions:getSelfId() then
				SoraDShowMsgTip(i18n("common_text_4265"))
				return
			end
			_ENV = SoraDShowMsgTip
			SoraDShowMsgTip.targetType = gMailType.CHAT
			SoraDShowMsgTip.target = playerId
			SoraDShowMsgTip.nickName = nickName
			local SoraDShowMsgTip.allianceAbbr, data = allianceAbbr, SoraDShowMsgTip
			SoraDCreateChatView(data)
		end
	end
end
function allianceActiveViewPanel:btnRankClick()
	SoraDPlaySound()
	uiManager:show("allianceActiveRankView")
end
function allianceActiveViewPanel:btnLevelClick()
	SoraDPlaySound()
	uiManager:show("allianceActiveLevelView")
end
function allianceActiveViewPanel:btnHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("alliance_text_37")
	;(nil).title = i18n("alliance_title_02")
	uiManager:show("RuleView", nil)
end
return allianceActiveViewPanel
