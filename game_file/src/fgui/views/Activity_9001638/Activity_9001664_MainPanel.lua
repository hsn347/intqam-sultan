local activityCommonBubbleRead = include("activityCommonBubbleRead")
local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001664_MainPanel = class("Activity_9001664_MainPanel", baseFguiPanel)
function Activity_9001664_MainPanel:ctor(...)
	Activity_9001664_MainPanel.super.ctor(self, ...)
	print("Activity_9001664_MainPanel:ctor", self.viewName)
	self.debug = true
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001664
	self.itemID = activityCommonBubbleCtrl:getItemID(self.activityID)
end
function Activity_9001664_MainPanel:onInit()
	print("=======Activity_9001664_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).lv = ""
	self.fields.Text_lv:setString(i18n("common_text_100", handler(self, self.onClickHelp)))
	self.fields.Button_reward:setString(i18n("devilvalley_text_27"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.Button_day:addClickListener(handler(self, self.onClickBtnDay))
	self.Text_day = SoraDCreateTimerLabel(self, self.fields.Button_day:getChild("title"))
	self.Text_day:setTimeEndListener(function()
		self:updateButtonDay()
	end)
	self.fields.Com_have:initData(self.itemID)
	self.fields.Com_have:hideBtnAdd()
	self.fields.Text_cancer:setString(i18n("Bubble_Bobble_text_05"))
	if not SoraDFIsRA() then
		self.fields.Text_cancer:fixPos()
	end
end
function Activity_9001664_MainPanel:onShow()
	print("=======Activity_9001664_MainPanel:onShow")
	self.fields.Com_map:initActivityID(self.activityID)
	self:updateTextScore()
	self:updateItemCount()
	self:updateButtonDay()
	activityCommonBubbleCtrl:checkGuide(self.activityID)
end
function Activity_9001664_MainPanel:onClickHelp()
	SoraDPlaySound()
	activityCommonBubbleRead.getShowFAQ(self.activityID)
end
function Activity_9001664_MainPanel:onClickBtnReward(...)
	SoraDPlaySound()
	local curLevel = activityCommonBubbleCtrl:getLevel(self.activityID)
	local rewardList = activityCommonBubbleRead.getLevelRewardConfig(self.activityID)
	_ENV = nil
	;(nil).level = curLevel
	;(nil).levelCfgs = rewardList
	uiManager:show("EliminateGamePreview", nil)
end
function Activity_9001664_MainPanel:onClickBtnDay(...)
	SoraDPlaySound()
	local isFree = activityCommonBubbleCtrl:checkFreeReceiveTime(self.activityID)
	if isFree then
		activityCommonBubbleCtrl:reqFreeReward(self.activityID)
	end
end
function Activity_9001664_MainPanel:updateTextScore(...)
	local level = activityCommonBubbleCtrl:getLevel(self.activityID)
	if activityCommonBubbleCtrl:getSkin(self.activityID) == 2 then
		activityCommonBubbleCtrl = nil
		;(nil).lv = level
		self.fields.Text_lv:setString(i18n("common_text_100", nil))
	else
		self.fields.Text_score:setString(level)
	end
end
function Activity_9001664_MainPanel:updateItemCount(...)
	self.fields.Com_have:updateNum()
end
function Activity_9001664_MainPanel:updateMapData(...)
	self.fields.Com_map:updateMapData()
end
function Activity_9001664_MainPanel:updateButtonDay(...)
	local isFree = activityCommonBubbleCtrl:checkFreeReceiveTime(self.activityID)
	self.fields.Button_day:setEnabled(isFree)
	self.fields.Button_day:setReddot(isFree)
	if isFree then
		self.Text_day:setString(i18n("datepalm_tree_text18"))
	else
		local time = serviceFunctions.getTomorrowZeroHourUTC() - serviceFunctions.systemTime()
		self.Text_day:beginTime(time)
	end
end
function Activity_9001664_MainPanel:onMsgUpdateView(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	local subMsg = event.subMsg
	if subMsg == "init" then
	elseif subMsg == "shoot" then
		self:updateTextScore()
		self:updateMapData()
	elseif subMsg == "free" then
		self:updateButtonDay()
	end
end
function Activity_9001664_MainPanel:gameGuide_getTarget(itemName, parameters)
	print("==Activity_9001664_MainPanel:gameGuide_getTarget==", itemName, parameters)
	_ENV = print
	local print.Button_right, mapConfig = true, print
	if mapConfig[itemName] then
		return self.fields.Com_map:gameGuide_getTarget(itemName, parameters)
	end
	return self.fields[itemName]
end
return Activity_9001664_MainPanel
