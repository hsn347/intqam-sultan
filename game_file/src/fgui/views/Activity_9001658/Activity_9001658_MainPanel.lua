local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001658_Read = include("activity_9001658_Read")
local activity_9001658_Ctrl = SoraDGetCtrl("activity_9001658_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001658_MainPanel = class("Activity_9001658_MainPanel", baseFguiPanel)
function Activity_9001658_MainPanel:ctor(...)
	Activity_9001658_MainPanel.super.ctor(self, ...)
	print("Activity_9001658_MainPanel:ctor", self.viewName)
	self.debug = true
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001658
	self.itemID = 871001
end
function Activity_9001658_MainPanel:onInit()
	print("=======Activity_9001658_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_monster:setString(i18n("BUBBLE_LEGEND_TEXT_99"))
	self.fields.Text_item:setString(i18n("BUBBLE_LEGEND_TEXT_28"))
	self.fields.Com_have:initData(self.itemID)
	self:updateItemCount()
	self.curStage = activity_9001658_Ctrl:getCurStage()
	if self.curStage <= 1 then
		self.fields.Node_bottom:setVisible(false)
	else
		local curTime = activity_9001658_Ctrl:getCurTime()
		local totalTime = activity_9001658_Read.getStageTime(9)
		local leftTime = math.max(0, totalTime - curTime)
		self.fields.Node_bottom:setVisible(0 < leftTime)
		if 0 < leftTime then
			self.fields.bar:setTime(leftTime, totalTime)
			self.fields.bar:hideLabelTime()
			self.fields.bar:setTimeUpdateListener(function(time)
				self:timeUpdate(time, totalTime)
			end)
			self:timeUpdate(leftTime, totalTime)
		end
	end
	self:initActivityButton()
	self:updateBtnPlotRed()
	if not SoraDFIsRA() then
		self.fields.Image_monster:fixPos()
		self.fields.Text_monster:fixPos()
		self.fields.bar:fixPos()
	end
end
function Activity_9001658_MainPanel:onShow()
	print("=======Activity_9001658_MainPanel:onShow")
	self:runAction(ffa.callFunc(function()
		self:checkGuide()
	end))
end
function Activity_9001658_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("BUBBLE_LEGEND_TEXT_26")
	uiManager:show("RuleView", nil)
end
function Activity_9001658_MainPanel:initActivityButton(...)
	self.fields.Button_plot:setString(i18n("BUBBLE_LEGEND_TEXT_98"))
	self.fields.Button_plot:addClickListener(handler(self, self.onClickBtnPlot))
	_UPVALUE2_ = self.fields.Button_plot.addClickListener
	self.fields.Button_plot.addClickListener[1] = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010003
	local self.fields.Button_plot.addClickListener[2], config = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010002, self.fields.Button_plot.addClickListener
	for i, activityID in ipairs(config) do
		local Button_activity = self.fields["Button_activity" .. i]
		if Button_activity then
			local cfg = activityTimeRead.getNormalEventConfig(activityID)
			Button_activity:setString(cfg.name)
			Button_activity:addClickListener(function(...)
				SoraDPlaySound()
				self:singleClickEvent(activityID)
			end)
		end
	end
	self:updateExchangBtnRed()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self:updateActivityIDList()
end
function Activity_9001658_MainPanel:onClickBtnPlot()
	SoraDPlaySound()
	uiManager:show("Activity_9001658_PlotMain")
end
function Activity_9001658_MainPanel:onItemRenderer(index, obj)
	local activityID = self.activityIDList[index + 1]
	local cfg = activityTimeRead.getNormalEventConfig(activityID)
	obj:setString(cfg.name)
	obj:setIcon(cfg.icon)
end
function Activity_9001658_MainPanel:onClickItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local index = self.fields.List:getChildIndex(obj)
	local activityID = self.activityIDList[index + 1]
	clientEventMgr.singleClickEvent(activityID)
end
function Activity_9001658_MainPanel:singleClickEvent(activityID)
	if activityID == gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010002 then
		local eventState = activityShowCtrl:getStateByID(activityID)
		if not clientEventMgr.judgeIsOnShow(eventState) then
			SoraDShowMsgTip(i18n("common_text_2486"))
			return
		end
		uiManager:show("Activity_9001658_Shop1")
	elseif activityID == gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010003 then
		if not clientEventMgr.judgeIsOpen(activityID) then
			SoraDShowMsgTip(i18n("common_text_2486"))
			return
		end
		local commonExchangeUtil = include("commonExchangeUtil")
		commonExchangeUtil.openView(activityID)
	end
end
function Activity_9001658_MainPanel:timeUpdate(curTime, totalTime)
	if curTime >= totalTime * 0.7 then
		self.fields.bar:setBarColor(2)
	elseif curTime >= totalTime * 0.4 then
		self.fields.bar:setBarColor(3)
	else
		self.fields.bar:setBarColor(1)
	end
end
function Activity_9001658_MainPanel:checkGuide(...)
	local serverStage = activity_9001658_Ctrl:getServerStage()
	local curStage = activity_9001658_Ctrl:getCurStage()
	print("==checkGuide=curStage,serverStage==", curStage, serverStage)
	if serverStage < curStage then
		activity_9001658_Ctrl:reqGuide(curStage)
		if curStage == 1 then
			activity_9001658_Ctrl = serverStage
			serverStage.storyID = 1
			function serverStage.callback(...)
				_ENV = nil
				;(nil).storyID = curStage
				uiManager:show("Activity_9001658_Guide", nil)
			end
			uiManager:show("Activity_9001658_Story", serverStage)
		elseif curStage == 9 then
			activity_9001658_Ctrl = serverStage
			serverStage.storyID = 2
			function serverStage.callback(...)
				_ENV = nil
				;(nil).storyID = curStage
				uiManager:show("Activity_9001658_Guide", nil)
			end
			uiManager:show("Activity_9001658_Story2", serverStage)
		else
			activity_9001658_Ctrl = serverStage
			serverStage.storyID = curStage
			uiManager:show("Activity_9001658_Guide", serverStage)
		end
	end
end
function Activity_9001658_MainPanel:updateStage(...)
	local newStage = activity_9001658_Ctrl:getCurStage()
	if self.curStage ~= newStage then
		self.curStage = newStage
		self.fields.Com_map:initMap()
		self:updateBtnPlotRed()
	end
end
function Activity_9001658_MainPanel:updateExchangBtnRed(...)
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	_UPVALUE2_ = "activityExchangeMallCtrl"
	;("activityExchangeMallCtrl")[1] = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010003
	local ("activityExchangeMallCtrl")[2], config = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010002, "activityExchangeMallCtrl"
	for i, activityID in ipairs(config) do
		local Button_activity = self.fields["Button_activity" .. i]
		if Button_activity then
			if clientEventMgr.judgeIsOpen(activityID) then
				local ret, num = activityExchangeMallCtrl:getReceiveStatusAndNum(activityID)
				Button_activity:setReddot(ret or false)
			else
				Button_activity:setReddot(false)
			end
		end
	end
end
function Activity_9001658_MainPanel:updateActivityIDList(...)
	_UPVALUE2_ = nil
	;(nil)[1] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001669
	local (nil)[2], config = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION, nil
	self.activityIDConfig = config
	local _ENV, ret = gActivityTimeActivityID.NORMAL_ACTIVITY_9001669, gActivityTimeActivityID.NORMAL_ACTIVITY_9001669
	for __, activityID in ipairs(config) do
		if clientEventMgr.judgeIsOpen(activityID) then
			table.insert(ret, activityID)
		end
	end
	self.activityIDList = ret
	self.fields.List:setNumItems(#self.activityIDList)
end
function Activity_9001658_MainPanel:updateItemCount(...)
	local needNum = 20
	local curNum = backpackCtrl:getItemCount(self.itemID)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010002) then
		curNum = needNum
	end
	local curNumStr = ""
	if needNum <= curNum then
		self.fields.Text_tip:setString(i18n("BUBBLE_LEGEND_TEXT_33"))
		curNumStr = string.formatnumberthousands(curNum)
	else
		self.fields.Text_tip:setString(i18n("BUBBLE_LEGEND_TEXT_29"))
		backpackCtrl = i18n("BUBBLE_LEGEND_TEXT_29")
		i18n("BUBBLE_LEGEND_TEXT_29").color = "#FF0000"
		curNumStr = SoraDWrapHtmlTagByStyle(curNum, i18n("BUBBLE_LEGEND_TEXT_29"))
	end
	backpackCtrl = i18n("BUBBLE_LEGEND_TEXT_29")
	i18n("BUBBLE_LEGEND_TEXT_29").member = needNum
	i18n("BUBBLE_LEGEND_TEXT_29").total = curNumStr
	local numStr = i18n("common_text_155", i18n("BUBBLE_LEGEND_TEXT_29"))
	self.fields.Com_have:setString(numStr)
end
function Activity_9001658_MainPanel:onIntoPanel(panelName)
	print("==Activity_9001658_MainPanel:onIntoPanel==", panelName)
	self:checkGuide()
	self:updateExchangBtnRed()
	if panelName == "Activity_9001658_PlotMainPanel" then
		self:updateBtnPlotRed()
	end
end
function Activity_9001658_MainPanel:updateBtnPlotRed(...)
	local showRed = false
	local chapterNewMap = activity_9001658_Ctrl:getChapterNewMap()
	for chapter = 1, self.curStage do
		if not chapterNewMap[chapter] then
			showRed = true
			break
		end
	end
	self.fields.Button_plot:setReddot(showRed)
end
return Activity_9001658_MainPanel
