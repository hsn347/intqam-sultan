local gametop = gModuleMgr.getObject("gametop")
local allianceActiveltCtrl = include("allianceActiveltCtrl")
local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
local allianceActiveView = class("allianceActiveView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceActiveView")
	end
	return target
end)
function allianceActiveView:ctor()
	self.boxArray, _ENV = nil, nil
	self.mIndex = 1
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.nodeTitle:setTitle(i18n("alliance_text_21"))
	self.nodeTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.Text_boxTip = SoraDGetChildByName(self, "Text_boxTip")
	self.Text_published = SoraDGetChildByName(self, "Text_published")
	self.Text_active = SoraDGetChildByName(self, "Text_active")
	self.Text_active:setString(i18n("alliance_text_22"))
	self.Font_level = SoraDGetChildByName(self, "Font_level")
	self.LoadingBar_barLv = SoraDGetChildByName(self, "LoadingBar_barLv")
	self.Text_lvBar = SoraDGetChildByName(self, "Text_lvBar")
	self.Button_level = SoraDGetChildByName(self, "Button_level")
	self.Button_level:addTouchEventListener(handler(self, self.btnLevelClick))
	self.Button_log = SoraDGetChildByName(self, "Button_log")
	self.Button_log:addTouchEventListener(handler(self, self.btnLogClick))
	self.Node_common = SoraDGetChildByName(self, "Node_common")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("allianceActiveSingle")
	self.Node_manager = SoraDGetChildByName(self, "Node_manager")
	self.Node_None = SoraDGetChildByName(self, "Node_None")
	self.Text_None = SoraDGetChildByName(self, "Text_None")
	self.Text_None:setString(i18n("alliance_text_31"))
	self.Node_None:setVisible(false)
	self.Button_contactLord = SoraDGetChildByName(self, "Button_contactLord")
	self.Button_contactLord:setTitleText(i18n("common_text_179"))
	self.Button_contactLord:addTouchEventListener(handler(self, self.btnContactClick))
	self.Node_active = SoraDGetChildByName(self, "Node_active")
	self.Node_progress = SoraDGetChildByName(self, "Node_progress")
	self.LoadingBar_progress = SoraDGetChildByName(self, "LoadingBar_progress")
	self.btnRank = SoraDGetChildByName(self, "Button_Rank")
	self.btnRank:setTitleText(i18n("alliance_active_text_001"))
	SoraDAutoSizeButtonText(self.btnRank, cc.size(115, 37))
	self.btnRank:addTouchEventListener(handler(self, self.btnRankClick))
	self:fixView()
	self:initBox()
end
function allianceActiveView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_ACTIVE_TASK_UPDATE", handler(self, self.updateTask))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_ACTIVE_OFFICE_UPDATE", handler(self, self.updateOffice))
end
function allianceActiveView:updateOffice(target, data)
	self:fixView()
end
function allianceActiveView:fixView()
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	self.isManager = ownRank >= gAllianceRank.R5
	if self.isManager then
		self.Node_manager:setVisible(true)
		self.Node_common:setPositionY(-395)
		self.scroll:setContentSize(cc.size(640, display.height - 467))
		self.mIndex = 1
		local bg_tab = SoraDGetChildByName(self, "bg_tab")
		bg_tab:setFillType(1)
		self.Image_select = SoraDGetChildByName(self, "Image_select")
		self.Button_tab_publish = SoraDGetChildByName(self, "Button_tab_publish")
		self.Button_tab_publish:setPressedActionEnabled(false)
		self.Text_publish = self.Button_tab_publish:getChildByName("Text_name")
		self.Sprite_red = SoraDGetChildByName(self.Button_tab_publish, "Sprite_red")
		self.Text_num = SoraDGetChildByName(self.Sprite_red, "Text_num")
		self.Text_publish:setString(i18n("alliance_title_06"))
		self.Button_tab_today = SoraDGetChildByName(self, "Button_tab_today")
		self.Button_tab_today:setPressedActionEnabled(false)
		self.Text_today = self.Button_tab_today:getChildByName("Text_name")
		self.Text_today:setString(i18n("alliance_title_05"))
		self.Button_tab_publish:addTouchEventListener(handler(self, self.onPublishClick))
		self.Button_tab_today:addTouchEventListener(handler(self, self.onTodayPublishClick))
		self:onTodayPublishClick(self.Button_tab_today, ccui.TouchEventType.ended, true)
	else
		self.Node_manager:setVisible(false)
		self.Node_common:setPositionY(-355)
		self.scroll:setContentSize(cc.size(640, display.height - 427))
		self.mIndex = 1
		local publishList = allianceActiveCtrl:getCurPublishList()
		gametop = cc.size(640, display.height - 427)
		cc.size(640, display.height - 427).scroll = self.scroll
		cc.size(640, display.height - 427).view = self
		self.scroll:updateScrollView(cc.size(640, 160), publishList, 1, cc.size(640, display.height - 427))
		self.Node_None:setVisible(#publishList <= 0)
		self.Button_contactLord:setTitleText(i18n("common_text_179"))
	end
	self:setStaticData()
end
function allianceActiveView:setStaticData()
	if self.isManager and self.mIndex == 2 then
		_ENV = nil
		;(nil).num = allianceActiveCtrl:getCurPublishNum()
		;(nil).max = ALLIANCE_ACTIVE_MAX_PUBLISH_NUM
		self.Text_published:setString(i18n("alliance_text_27", nil))
		self.Button_log:setVisible(true)
		self.Button_log:setPositionX(SoraDFSign(self.Text_published:getContentSize().width * 0.5 + 30))
	else
		_ENV = SoraDFSign(self.Text_published:getContentSize().width * 0.5 + 30)
		SoraDFSign(self.Text_published:getContentSize().width * 0.5 + 30).num = allianceActiveCtrl:getMyTodayAcceptNum()
		SoraDFSign(self.Text_published:getContentSize().width * 0.5 + 30).max = ALLIANCE_ACTIVE_PERSON_DAILY_MAX_ACCEPT_NUM
		self.Text_published:setString(i18n("alliance_text_30", SoraDFSign(self.Text_published:getContentSize().width * 0.5 + 30)))
		self.Button_log:setVisible(false)
	end
	_ENV = i18n("alliance_text_30", SoraDFSign(self.Text_published:getContentSize().width * 0.5 + 30))
	i18n("alliance_text_30", SoraDFSign(self.Text_published:getContentSize().width * 0.5 + 30)).num = string.formatnumberthousands(allianceActiveCtrl:getActiveTodayPoint())
	self.Text_boxTip:setString(i18n("alliance_title_04", i18n("alliance_text_30", SoraDFSign(self.Text_published:getContentSize().width * 0.5 + 30))))
	local lv = allianceActiveCtrl:getActiveLevel()
	self.Font_level:setString(lv)
	local aPoint = allianceActiveCtrl:getActivePoint()
	local tPoint = allianceActiveltCtrl.getActiveLvPoint(lv + 1)
	self.LoadingBar_barLv:setPercent(math.floor(aPoint * 100 / tPoint))
	if aPoint >= tPoint then
		self.Text_lvBar:setString(i18n("hero_text_41"))
	else
		_ENV = i18n("hero_text_41")
		i18n("hero_text_41").member = aPoint
		i18n("hero_text_41").total = tPoint
		self.Text_lvBar:setString(i18n("common_text_155", i18n("hero_text_41")))
	end
end
function allianceActiveView:initBox()
	local curPoint = allianceActiveCtrl:getActiveTodayPoint()
	local curLv = allianceActiveCtrl:getActiveLevel()
	local boxesInfo, boxedPoint = allianceActiveltCtrl.getActiveBoxesInfo(curLv)
	local tempWidth = 400 / (#boxesInfo - 1) - 5
	local nextPoint = allianceActiveltCtrl.getActiveLvPoint(curLv + 1)
	local percent = SoraDGetStagePercent(curPoint, boxedPoint)
	self.LoadingBar_progress:setPercent(percent)
	for i = 1, #boxesInfo do
		if not self.boxArray[i] then
			local box = include("allianceActiveStageBox").new()
			box:setScale(1)
			box:setPosition(SoraDFPosX(200 - tempWidth * (i - 1), 0), -15)
			box:addTo(self.Node_progress, 2)
			self.boxArray[i] = box
		end
		self.boxArray[i]:initData(boxesInfo[i], curPoint)
	end
end
function allianceActiveView:updateManagerTab()
	local target = self.mIndex == 1 and self.Button_tab_publish or self.Button_tab_today
	local chooseColor = cc.c3b(255, 200, 100)
	local unChooseColor = cc.c3b(215, 195, 155)
	self.Image_select:setPositionX(target:getPositionX())
	self.Text_publish:setColor(self.mIndex == 1 and chooseColor or unChooseColor)
	self.Text_today:setColor(self.mIndex == 2 and chooseColor or unChooseColor)
	self:setStaticData()
end
function allianceActiveView:btnLevelClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceActiveLevelView"):show()
	end
end
function allianceActiveView:btnLogClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceActiveLogView"):show()
	end
end
function allianceActiveView:btnContactClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isManager then
			self:onTodayPublishClick(self.Button_tab_today, ccui.TouchEventType.ended, true)
		else
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
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
				local panel = SoraDCreateChatView(data)
			end
		end
	end
end
function allianceActiveView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "alliance_title_02"
		;("alliance_title_02")[1] = i18n("alliance_text_37")
		;("alliance_title_02")[2] = i18n("alliance_text_37")
		SoraDShowFixWindow(i18n("alliance_title_02"), "alliance_title_02")
	end
end
function allianceActiveView:updateTask(target, data)
	local allianceActiveCtrl, dataList
	local isPublish = false
	if self.mIndex == 1 then
		dataList = allianceActiveCtrl:getCurPublishList()
		self.Node_None:setVisible(#dataList <= 0)
	elseif self.mIndex == 2 then
		dataList = allianceActiveCtrl:getCurShowList()
		isPublish = true
	end
	self.scroll:resetScroll()
	allianceActiveCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).isPublish = isPublish
	self.scroll:updateScrollView(cc.size(640, 160), dataList, 1, nil)
	self:setStaticData()
	self:updateRedNum()
	self:initBox()
end
function allianceActiveView:updateRedNum()
	if self.isManager then
		local rewardNum = allianceActiveCtrl:getCanReceiveTaskNum()
		self.Sprite_red:setVisible(0 < rewardNum)
		self.Text_num:setString(rewardNum)
	end
end
function allianceActiveView:onPublishClick(button, event, isTest)
	if event == ccui.TouchEventType.ended then
		if not isTest then
			SoraDPlaySound()
		end
		self.mIndex = 1
		self:updateManagerTab()
		local publishList = allianceActiveCtrl:getCurPublishList()
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		self.scroll:updateScrollView(cc.size(640, 160), publishList, 1, nil)
		self.scroll:jumpToTop()
		self.Node_None:setVisible(#publishList <= 0)
		self.Button_contactLord:setTitleText(i18n("alliance_btn_01"))
	end
end
function allianceActiveView:onTodayPublishClick(button, event, isTest)
	if event == ccui.TouchEventType.ended then
		if not isTest then
			SoraDPlaySound()
		end
		self.mIndex = 2
		self:updateManagerTab()
		self.Node_None:setVisible(false)
		local showList = allianceActiveCtrl:getCurShowList()
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		;(nil).isPublish = true
		self.scroll:updateScrollView(cc.size(640, 160), showList, 1, nil)
		self.scroll:jumpToTop()
		self:updateRedNum()
	end
end
function allianceActiveView:btnRankClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDCreatePanel("allianceActiveRankView"):show()
	end
end
return allianceActiveView
