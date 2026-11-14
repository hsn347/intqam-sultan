local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local starCompetitionRead = include("starCompetitionRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ActivityStarCompetitionPanel = class("ActivityStarCompetitionPanel", baseFguiPanel)
function ActivityStarCompetitionPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ActivityStarCompetitionPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GLORIOUS_CONTEST
	self.minIndex = 1
end
function ActivityStarCompetitionPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ActivityStarCompetitionPanel:onInit()
	print("=======ActivityStarCompetitionPanel:onInit")
	local activityname = activityTimeRead.getActivityNameByID(self.activityID)
	self.fields.Com_title:initData(i18n(activityname), handler(self, self.onClickClose))
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		_ENV = "common_text_2669"
		;("common_text_2669").color = "#FFC864"
		local timePrefix = SoraDWrapHtmlTagByStyle(i18n("common_text_2669"), "common_text_2669")
		self.fields.Label_time:setTimeLast(function(time)
			return timePrefix .. time
		end)
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.Label_time:beginTime(leftTime)
	end
	local proxy = uiManager:getOrCreateProxy("HomePopup")
	local data = proxy:getConfigData(self.activityID)
	local artWord = SoraDFIsRA() and data.artWord_ar or data.artWord_en
	self.fields.Load_title:setURL(artWord)
	self.fields.List_rewards:setScrollEnable(false)
	self.fields.List_rewards:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.Button_left:addClickListener(handler(self, self.onBtnLeftClick))
	self.fields.Button_right:addClickListener(handler(self, self.onBtnRightClick))
	self.fields.Label_finished:setString(i18n("common_text_2210"))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onBtnGoClick))
end
function ActivityStarCompetitionPanel:onShow()
	print("=======ActivityStarCompetitionPanel:onShow")
	activityShowCtrl:sendStarCMP()
	SoraDShowLoading()
end
function ActivityStarCompetitionPanel:onNormalItemRenderer(index, obj)
	local reward = self.rewards[index + 1]
	local itemID = reward.id
	local qualityPng = publicRead.getBg(itemID)
	obj:getChild("Image_quality"):setURL(qualityPng)
	local iconPng = publicRead.getIcon(itemID)
	obj:getChild("Image_icon"):setURL(iconPng)
	obj:getChild("Text_num"):setString(reward.count)
	obj.id = itemID
	obj.num = reward.count
	if not obj.isInit then
		obj.isInit = true
		obj:addLongPressListener(function(button, startPos, endPos)
			SoraDPlaySound()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
			;(nil).id = obj.id
			;(nil).num = obj.num
			;(nil).pos = startPos
			SoraDSendMessage(nil)
		end)
	end
end
function ActivityStarCompetitionPanel:refreshData(target, data)
	local serKingdomLv = activityShowCtrl:getActivityKingdomLv()
	local myStarLv = SoraDGetBuildStarLv()
	local nextConfigIndex = starCompetitionRead.getNextConfigByLv(myStarLv)
	self.index = math.min(starCompetitionRead.getConfigNum(serKingdomLv), nextConfigIndex)
	self.ownIndex = math.max(nextConfigIndex, self.index)
	self.maxIndex = math.max(starCompetitionRead.getConfigNum(serKingdomLv), self.minIndex)
	self:refreshView()
end
function ActivityStarCompetitionPanel:refreshView()
	local config = starCompetitionRead.getConfigByIndex(self.index)
	local isFinished = activityShowCtrl:isStarFinish(config.starlv)
	if not isFinished and self.ownIndex > self.index then
		starCompetitionRead = nil
		;(nil).lv = config.starlv
		if i18n("soldier_competition_08", nil) then
			goto lbl_28
		end
	end
	::lbl_28::
	self.fields.Text_tip:setString((i18n("soldier_competition_02")))
	self.controllers.c_black:setSelectedIndex((self.ownIndex > self.index or isFinished) and 1 or 0)
	self.controllers.c_finished:setSelectedIndex(isFinished and 1 or 0)
	starCompetitionRead = nil
	;(nil).lv = config.starlv
	self.fields.Text_des:setString(i18n("soldier_competition_03", nil))
	self.rewards = config.reward
	self.fields.List_rewards:setNumItems(#self.rewards)
end
function ActivityStarCompetitionPanel:onBtnLeftClick(EventContext)
	SoraDPlaySound()
	self.index = self.index - 1
	if self.index < self.minIndex then
		self.index = self.maxIndex
	end
	self:refreshView()
end
function ActivityStarCompetitionPanel:onBtnRightClick(EventContext)
	SoraDPlaySound()
	self.index = self.index + 1
	if self.index > self.maxIndex then
		self.index = self.minIndex
	end
	self:refreshView()
end
function ActivityStarCompetitionPanel:onBtnGoClick(EventContext)
	SoraDPlaySound()
	if SoraDCheckIsOpenBuildStar() then
		SoraDRemoveAllPanelFromManager()
		local xOffset = display.size.width * 0.5
		local yOffset = -480 + (960 - display.height) * 0.5
		local showCastleStarUpgrade = function()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			;(nil).bid = BUILDID.CASTLE
			mildGuideManager:starToUpgradeStar(nil)
		end
		local currentScene = display.getRunningScene()
		local currentView = currentScene:currentSceneShowView()
		if currentView.__cname == "worldMapView" then
			_ENV = currentView.__cname
			currentView.__cname.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			currentView.__cname.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			currentView.__cname.scale = 1.0
			currentView.__cname.xOffset = xOffset
			currentView.__cname.yOffset = display.size.height + yOffset
			currentView.__cname.buildIndex = 1050
			currentView.__cname.noOffsetDuration = true
			currentView.__cname.noScaleDuration = true
			currentView.__cname.handle = showCastleStarUpgrade
			local currentView.__cname.delay, data = 0.5, currentView.__cname
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
			;(nil).viewType = VIEW_TYPE_CITY
			;(nil).otherData = data
			SoraDSendMessage(nil)
		else
			_ENV = SoraDSendMessage
			SoraDSendMessage.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			SoraDSendMessage.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			SoraDSendMessage.scale = 1.0
			SoraDSendMessage.xOffset = xOffset
			SoraDSendMessage.yOffset = display.size.height + yOffset
			SoraDSendMessage.buildIndex = 1050
			SoraDSendMessage.noOffsetDuration = true
			SoraDSendMessage.noScaleDuration = true
			SoraDSendMessage(SoraDSendMessage)
			showCastleStarUpgrade()
		end
	else
		_ENV = display.getRunningScene()
		display.getRunningScene().lv = 6
		SoraDShowMsgTip(i18n("soldier_competition_07", (display.getRunningScene())))
	end
end
return ActivityStarCompetitionPanel
