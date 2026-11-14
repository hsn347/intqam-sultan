local eventQuestRead = include("eventQuestRead")
local radianceWarDef = include("radianceWarDef")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local radianceWarTaskMainView = class("radianceWarTaskMainView", function(target)
	return target or SoraDCreateBasePanel("radianceWarTaskMainView")
end)
local TASK_TYPE = radianceWarDef.TASK_TYPE
function radianceWarTaskMainView:ctor(properties)
	self.activityID = gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	_ENV = nil
	;(nil).num = radianceActivityCtrl:getActivitySeasonRound()
	self.nodeCommonFramTitle:setTitle(i18n("brightWar_text_24", nil))
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("radianceWarTaskSingle")
	self.textTimeEnd = SoraDGetChildByName(self, "Text_TimeEnd")
	_ENV, self.nodeCommonTabBtn = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabNum = 2
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").defaultClick = "Top_CCS_commonTabBtn", self, 1
	;("Top_CCS_commonTabBtn").title = i18n("brightWar_text_202")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").fontSize = 22
	_ENV, self[1], ("Top_CCS_commonTabBtn").tag = "Top_CCS_commonTabBtn", "Top_CCS_commonTabBtn", TASK_TYPE.DAILY
	;("Top_CCS_commonTabBtn").title = i18n("summoned_text_28")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").fontSize = 22
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabsetArray, self[2], ("Top_CCS_commonTabBtn").tag = self, "Top_CCS_commonTabBtn", TASK_TYPE.SEASON
	local tableData = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.nodeCommonTabBtn:initView(tableData)
	self:initData()
end
function radianceWarTaskMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_STATUS_ACTIVITY", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updataRedPoint))
end
function radianceWarTaskMainView:initData(target, data)
	local lefttime = radianceActivityCtrl.radianceWarStateInfo.settleTime
	local strTime = os.date("%Y-%m-%d", lefttime)
	radianceActivityCtrl = nil
	;(nil).time = strTime
	self.textTimeEnd:setString(i18n("summoned_text_09", nil))
	self:updataRedPoint()
end
function radianceWarTaskMainView:updataScroll()
	SoraDCloseLoading(self)
	if not radianceActivityCtrl:getQuestData(self.showViewType) then
		_ENV = radianceActivityCtrl:getQuestData(self.showViewType)
	end
	self.taskList = radianceActivityCtrl:getQuestData(self.showViewType)
	dump(self.taskList, "self.taskList", 10)
	self.scroll:jumpToTop()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(640, 170), self.taskList, 1, nil)
end
function radianceWarTaskMainView:updataRedPoint()
	local retDaily = radianceActivityCtrl:getTaskReceiveStatusAndNum(TASK_TYPE.DAILY)
	local retSeason = radianceActivityCtrl:getTaskReceiveStatusAndNum(TASK_TYPE.SEASON)
	self.nodeCommonTabBtn:setRedPointState(TASK_TYPE.DAILY, retDaily)
	self.nodeCommonTabBtn:setRedPointState(TASK_TYPE.SEASON, retSeason)
end
function radianceWarTaskMainView:btnTabClick(tag, name)
	self.showViewType = tag
	self:updataScroll()
end
function radianceWarTaskMainView:msgCallBack(target, data)
	if radianceActivityCtrl:getWarStatus() == include("radianceWarDef").RADIANCE_WAR_STATE.FINISH then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return radianceWarTaskMainView
