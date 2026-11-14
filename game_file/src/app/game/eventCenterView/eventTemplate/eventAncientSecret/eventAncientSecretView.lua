local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
local ancientTreasureRead = include("ancientTreasureRead")
local eventAncientSecretView = class("eventAncientSecretView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventAncientSecretView")
	end
	return target
end)
function eventAncientSecretView:ctor()
	self.awardBoxArray, _ENV, self.activityID = gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY, gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY, gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY
	self.retTag = nil
	self.curTag = 1
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("activity_name_9001201"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.onFAQClick))
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.Image_event:loadTexture("bg_activity_9001201.png", ccui.TextureResType.plistType)
	self.Text_leftTime = SoraDGetChildByName(self, "Text_leftTime")
	self.Text_leftTime:setString(i18n("rides_text_09"))
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Sprite_time = SoraDGetChildByName(self, "Sprite_time")
	self.prepareScroll = SoraDGetChildByName(self, "ScrollView_content_prepare")
	self.Node_content = SoraDGetChildByName(self.prepareScroll, "Node_content")
	self.stageScroll = SoraDGetChildByName(self, "ScrollView_content_stage")
	self.Node_stage = SoraDGetChildByName(self.stageScroll, "Node_content")
	self.showScroll = SoraDGetChildByName(self, "ScrollView_content_show")
	self.showScroll = include("commonAutoScrollList").new(self.showScroll)
	self.showScroll:setSingleCCS("eventAncientSecretTaskSingle")
	self.Node_openTab = SoraDGetChildByName(self, "Node_openTab")
	self.Node_bLine = SoraDGetChildByName(self, "Node_bLine")
	self.Node_btn = SoraDGetChildByName(self, "Node_btn")
	self.Button_GetTool = SoraDGetChildByName(self, "Button_GetTool")
	self.Button_GetTool:setTitleText(i18n("AncienTreasure_text_18"))
	SoraDAutoSizeButtonText(self.Button_GetTool)
	self.Button_GetTool:addTouchEventListener(handler(self, self.onGetToolClick))
	self.Node_gift = SoraDGetChildByName(self, "Node_gift")
	self.Button_Gift = SoraDGetChildByName(self, "Button_Gift")
	self.Text_gift = SoraDGetChildByName(self, "Text_gift")
	self.Text_gift:setString(i18n("anniversary_fire_text_16"))
	self.Button_Gift:addTouchEventListener(handler(self, self.onGiftClick))
	self.ccs_red = SoraDGetExtendChildFromCCSByName(self, "CCS_commonRedPoint_red")
	self.Button_Detail = SoraDGetChildByName(self, "Button_Detail")
	self.Button_Detail:setTitleText(i18n("common_text_779"))
	self.Button_Detail:addTouchEventListener(handler(self, self.onFAQClick))
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	self.ccs_tab:setContentSize(cc.size(608, 72))
	self.ccs_tab:setVisible(false)
	self.Node_topEffect = SoraDGetChildByName(self, "Node_topEffect")
	self.Node_bottomEffect = SoraDGetChildByName(self, "Node_bottomEffect")
	local bNode = SoraDCreatAnimation("shanggu_bottom")
	SoraDMixtureGLONEByParentEx(bNode)
	bNode:addTo(self.Node_bottomEffect)
	self:suitView()
	ancientTreasureCtrl:sendReqInitDataMsg()
	if ancientTreasureCtrl:isTreasureStageOpen() then
		ancientTreasureCtrl:sendGetGiftInfoMsg()
	end
end
function eventAncientSecretView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPoint))
end
function eventAncientSecretView:updateRedPoint(target, data)
	if data and data.eventID == self.activityID then
		self.ccs_tab:setBigRedPointCount(2, ancientTreasureCtrl:getFinishTaskNum())
		self.ccs_tab:setBigRedPointCount(1, ancientTreasureCtrl:getRewardCount())
		self:updateBtnGift()
	end
end
function eventAncientSecretView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function eventAncientSecretView:updateTopEffect(ret)
	if self.retTag == ret then
		return
	end
	self.Node_topEffect:removeAllChildren()
	local ccsName = ret and "shanggu_top" or "shanggu_topex"
	local bNode = SoraDCreatAnimation(ccsName)
	SoraDMixtureGLONEByParentEx(bNode)
	bNode:addTo(self.Node_topEffect)
	self.retTag = ret
end
function eventAncientSecretView:setPrepareContentView()
	self.prepareScroll:setVisible(true)
	self.stageScroll:setVisible(false)
	self.showScroll:setVisible(false)
	self.Node_openTab:setVisible(false)
	self:updateTopEffect(false)
	self.Node_bLine:setPositionY(117)
	self.Node_btn:setVisible(true)
	self.Button_GetTool:setVisible(false)
	self.Node_gift:setVisible(false)
	self.Button_Detail:setVisible(true)
	self.ccs_tab:setVisible(false)
	local _ENV, boxArray = self.ccs_tab.setVisible, self.ccs_tab.setVisible
	for i = 1, 3 do
		boxArray[i] = SoraDGetExtendChildFromCCSByName(self, "CCS_eventAncientSecretBox_" .. i)
		boxArray[i]:initData(i)
	end
	self:setStaticContent(self.Node_content)
end
function eventAncientSecretView:setStaticContent(target)
	local Text_adTime = SoraDGetChildByName(target, "Text_adTime")
	Text_adTime:setString(i18n("AncienTreasure_text_02"))
	local Text_adDes = SoraDGetChildByName(target, "Text_adDes")
	Text_adDes:setString(i18n("AncienTreasure_text_03"))
	local Text_tipTitle = SoraDGetChildByName(target, "Text_tipTitle")
	Text_tipTitle:setString(i18n("AncienTreasure_text_10"))
	local Text_bossTime = SoraDGetChildByName(target, "Text_bossTime")
	local beginTime = ancientTreasureRead.getWolfBeginTime()
	Text_bossTime:setString(string.format("%s:00", tostring(beginTime)))
	local Text_bossTip = SoraDGetChildByName(target, "Text_bossTip")
	Text_bossTip:setString(i18n("AncienTreasure_text_11"))
end
function eventAncientSecretView:setOpenDetailView(ret)
	_ENV = nil
	_ENV, _ENV, (nil).tabNum = nil, nil, 2
	;(nil).title = i18n("common_text_779")
	;(nil).tag = 1
	_ENV, (nil)[1], (nil).handle = nil, nil, handler(self, self.showDetailView)
	;(nil).title = i18n("AncienTreasure_text_12")
	;(nil).tag = 2
	;(nil).tabsetArray, (nil)[2], (nil).handle = nil, nil, handler(self, self.showToolView)
	self.ccs_tab:initView(nil)
	self.ccs_tab:setBigRedPointCount(2, ancientTreasureCtrl:getFinishTaskNum())
	self.ccs_tab:setBigRedPointCount(1, ancientTreasureCtrl:getRewardCount())
	if ret then
		self.ccs_tab:switchTab(2)
		self:showToolView()
	else
		self:setOpenDetailContent()
	end
end
function eventAncientSecretView:setOpenDetailContent()
	self.prepareScroll:setVisible(false)
	self.stageScroll:setVisible(true)
	self.showScroll:setVisible(false)
	self.Node_openTab:setVisible(true)
	self:updateTopEffect(true)
	self.Node_bLine:setPositionY(117)
	self.Node_btn:setVisible(true)
	self.Button_GetTool:setVisible(true)
	self.Node_gift:setVisible(true)
	self.Button_Detail:setVisible(false)
	self.ccs_tab:setVisible(true)
	self:setStaticContent(self.Node_stage)
	local Text_rewardTip = SoraDGetChildByName(self.Node_stage, "Text_rewardTip")
	Text_rewardTip:setString(i18n("AncienTreasure_text_13"))
	local Text_digged = SoraDGetChildByName(self.Node_stage, "Text_digged")
	local openCount = ancientTreasureCtrl:getTreasureOpenCount()
	_ENV = i18n("AncienTreasure_text_13")
	i18n("AncienTreasure_text_13").num = openCount
	Text_digged:setString(i18n("AncienTreasure_text_14", i18n("AncienTreasure_text_13")))
	local Node_progress = SoraDGetChildByName(self.Node_stage, "Node_progress")
	local progressBar = SoraDGetChildByName(self.Node_stage, "LoadingBar_progress")
	local percent = ancientTreasureRead.getPercentByOpenCount(openCount)
	progressBar:setPercent(percent)
	local unOpenIndex = ancientTreasureRead.getMinBoxByOpenCount(openCount)
	for i = 1, 4 do
		if not self.awardBoxArray[i] then
			self.awardBoxArray[i] = SoraDCreatePanel("eventAncientSecretStageBox")
			self.awardBoxArray[i]:setIndex(i, unOpenIndex)
			self.awardBoxArray[i]:setPosition(SoraDFPosX(210 - (i - 1) * 420 / 3, 0), 0)
			self.awardBoxArray[i]:addTo(Node_progress, 9)
		end
	end
end
function eventAncientSecretView:setOpenToolView()
	self.prepareScroll:setVisible(false)
	self.stageScroll:setVisible(false)
	self.showScroll:setVisible(true)
	self.Node_openTab:setVisible(true)
	self:updateTopEffect(true)
	self.Node_bLine:setPositionY(20)
	self.Node_btn:setVisible(false)
	self.Button_GetTool:setVisible(false)
	self.Node_gift:setVisible(false)
	self.Button_Detail:setVisible(false)
end
function eventAncientSecretView:suitView()
	local Image_left = SoraDGetChildByName(self, "Image_left")
	local Image_right = SoraDGetChildByName(self, "Image_right")
	Image_left:setContentSize(cc.size(display.height - 405, 80))
	Image_right:setContentSize(cc.size(display.height - 405, 80))
	self.prepareScroll:setContentSize(cc.size(630, display.height - 540))
	self.prepareScroll:setInnerContainerSize(cc.size(630, 590))
	self.Node_content:setPositionY(590)
	self.prepareScroll:setBounceEnabled(590 > self.prepareScroll:getContentSize().height)
	self.stageScroll:setContentSize(cc.size(630, display.height - 540))
	self.stageScroll:setInnerContainerSize(cc.size(630, 590))
	self.Node_stage:setPositionY(590)
	self.stageScroll:setBounceEnabled(590 > self.stageScroll:getContentSize().height)
	self.showScroll:setContentSize(cc.size(630, display.height - 440))
end
function eventAncientSecretView:initData(target, data)
	SoraDCloseLoading(self)
	local isOpen = ancientTreasureCtrl:isTreasureStageOpen()
	if isOpen then
		self:setOpenDetailView(data and data.isTask or self.curTag == 2)
		self:updateBtnGift()
	else
		self:setPrepareContentView()
	end
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		if SoraDFIsRA() then
			self.Sprite_time:setPositionX(self.Text_time:getPositionX() - self.Text_time:getContentSize().width - 10)
		else
			self.Sprite_time:setPositionX(self.Text_time:getPositionX() + self.Text_time:getContentSize().width + 10)
		end
	end
end
function eventAncientSecretView:updateBtnGift()
	local count = ancientTreasureCtrl:getRewardCount()
	self.ccs_red:updateRedPoint(count)
end
function eventAncientSecretView:showDetailView()
	self.curTag = 1
	self:setOpenDetailContent()
end
function eventAncientSecretView:showToolView()
	self.curTag = 2
	self:setOpenToolView()
	local taskData = ancientTreasureRead.getAllTask()
	table.sort(taskData, function(a, b)
		local statusA = ancientTreasureCtrl:getTaskStatus(a.index, ancientTreasureCtrl:getCountByEvent(a.event), a.condition)
		local statusB = ancientTreasureCtrl:getTaskStatus(b.index, ancientTreasureCtrl:getCountByEvent(b.event), b.condition)
		if statusA == statusB then
			return a.index < b.index
		else
			return statusA < statusB
		end
	end)
	ancientTreasureRead = nil
	;(nil).scroll = self.showScroll
	;(nil).view = self
	self.showScroll:updateScrollView(cc.size(630, 160), taskData, 1, nil)
	self.showScroll:jumpToTop()
end
function eventAncientSecretView:onGetToolClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.ccs_tab:switchTab(2)
		self:setOpenToolView()
		self:showToolView()
	end
end
function eventAncientSecretView:onGiftClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local count = ancientTreasureCtrl:getRewardCount()
		if 0 < count then
			SoraDShowLoading(self)
			ancientTreasureCtrl:sendGetGiftRewardMsg()
		else
			SoraDShowMsgTip(i18n("alliancerewards_text_02"))
		end
	end
end
function eventAncientSecretView:onFAQClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("弹FAQ=====")
		userSDKManager.showSingleFAQ(IsArClient and 5308 or 5339)
	end
end
return eventAncientSecretView
