local activityCommonKitchenCtrl = SoraDGetCtrl("activityCommonKitchenCtrl")
local activityCommonKitchenRead = include("activityCommonKitchenRead")
local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001669_MainPanel = class("Activity_9001669_MainPanel", baseFguiPanel)
function Activity_9001669_MainPanel:ctor(...)
	Activity_9001669_MainPanel.super.ctor(self, ...)
	print("Activity_9001669_MainPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001669_MainPanel:onInit()
	print("=======Activity_9001669_MainPanel:onInit")
	if not self.param then
		_ENV = self.param
	end
	self.param = self.param
	self.activityID = self.param.activityID or gActivityTimeActivityID.NORMAL_ACTIVITY_9001669
	self.cookItemID = activityCommonKitchenCtrl:getCookItemID(self.activityID)
	self.stageData = activityCommonKitchenRead.getStageData(self.activityID)
	self.useMax = backpackltCtrl:getUseMax(self.cookItemID)
	local Com_title = self.fields.Com_title
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		Com_title = self.fields.Com_title1
		self.controllers.c1:setSelectedIndex(1)
		self:initTab()
	else
		Com_title = self.fields.Com_title
		self.controllers.c1:setSelectedIndex(0)
	end
	Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_food:setString(i18n("octopus_kitchen_text_02"))
	self.fields.Button_food:addClickListener(handler(self, self.onClickBtnFood))
	self.fields.Button_achi:setString(i18n("common_text_1752"))
	self.fields.Button_achi:addClickListener(handler(self, self.onClickBtnAchi))
	self.fields.Button_auto:setString(i18n("octopus_kitchen_text_04"))
	self.fields.Button_auto:addClickListener(handler(self, self.onClickBtnAuto))
	self.fields.Button_cook:setString(i18n("btn_cooking"))
	self.fields.Button_cook:addClickListener(handler(self, self.onClickBtnCook))
	self.fields.Button_cook:setCostIcon(self.cookItemID)
	self.fields.Com_slider:setSliderCallBack(handler(self, self.sliderCallBack))
	_ENV = handler(self, self.sliderCallBack)
	handler(self, self.sliderCallBack).activityID = self.activityID
	handler(self, self.sliderCallBack).stageMax = #self.stageData
	self.fields.Com_boxList:initData(handler(self, self.sliderCallBack))
	self.proxy:registerActivityCloseEvent(self.activityID)
end
function Activity_9001669_MainPanel:onShow()
	print("=======Activity_9001669_MainPanel:onShow")
	self:initTaskActivityID()
	self:updateScore()
	self:updateTask()
	self:updateSlider()
	self:updateBtnAchi()
end
function Activity_9001669_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("octopus_kitchen_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001669_MainPanel:onClickBtnFood(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("Activity_9001669_Food", nil)
end
function Activity_9001669_MainPanel:onClickBtnAchi(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("Activity_9001669_Achi", nil)
end
function Activity_9001669_MainPanel:onClickBtnAuto(...)
	SoraDPlaySound()
	local needCount = activityCommonKitchenCtrl:getAutoNeedCount(self.activityID)
	local curCount = activityCommonKitchenCtrl:getCompleteCount(self.activityID, self.cookItemID)
	if needCount > curCount then
		_ENV = nil
		;(nil).num = needCount - curCount
		SoraDShowMsgTip(i18n("octopus_kitchen_text_23", nil))
		return
	end
	local confirmFunc = function(...)
		local isEnough = false
		local foodIDList = activityCommonKitchenRead.getNormalFoodIDList(self.activityID)
		for i, v in ipairs(foodIDList) do
			local itemCount = backpackCtrl:getItemCount(v)
			if 0 < itemCount then
				isEnough = true
				break
			end
		end
		if not isEnough then
			SoraDShowMsgTip(i18n("octopus_kitchen_text_26"))
			return
		end
		local isEnough = false
		local taskList = activityCommonKitchenCtrl:getTaskList(self.activityID)
		for __, v in ipairs(taskList) do
			local nextTime = v.nextTime
			if not nextTime or not (nextTime > serviceFunctions.systemTime()) then
				isEnough = true
				break
			end
		end
		if not isEnough then
			local refreshItemID = activityCommonKitchenCtrl:getRefreshItemID(self.activityID)
			local itemCount = backpackCtrl:getItemCount(refreshItemID)
			if 0 < itemCount then
				isEnough = true
			end
		end
		if not isEnough then
			SoraDShowMsgTip(i18n("octopus_kitchen_text_24"))
			return
		end
		activityCommonKitchenCtrl:reqAutoComplete(self.activityID)
	end
	_ENV = i18n("octopus_kitchen_text_23", nil)
	i18n("octopus_kitchen_text_23", nil).content = i18n("octopus_kitchen_text_25")
	i18n("octopus_kitchen_text_23", nil).cancel = true
	i18n("octopus_kitchen_text_23", nil).confirmFunc = function()
		confirmFunc()
	end
	uiManager:show("MessageBox", i18n("octopus_kitchen_text_23", nil))
end
function Activity_9001669_MainPanel:onClickBtnCook(...)
	SoraDPlaySound()
	local curValue = self.fields.Com_slider:getSliderCurValue()
	if curValue <= 0 then
		local itemName = itemDesRead.getName(self.cookItemID)
		_ENV = nil
		;(nil).item = itemName
		SoraDShowMsgTip(i18n("explore_ore_text7", nil))
		_ENV = i18n("explore_ore_text7", nil)
		i18n("explore_ore_text7", nil).itemID = self.cookItemID
		uiManager:show("CommonSourceGuide", i18n("explore_ore_text7", nil))
		return
	end
	SoraDShowLoading()
	activityCommonKitchenCtrl:reqCooking(self.activityID, curValue)
end
function Activity_9001669_MainPanel:sliderCallBack(curValue)
	local ret = curValue > self.useMax
	if ret then
		curValue = self.useMax
		_UPVALUE0_ = nil
		;(nil).notBack = true
		self.fields.Com_slider:setSliderCurValue(curValue, nil)
	end
	self.fields.Button_cook:setCostNum(curValue)
	if ret then
		return true
	end
end
function Activity_9001669_MainPanel:updateScore(...)
	local point = activityCommonKitchenCtrl:getStageScore(self.activityID)
	activityCommonKitchenCtrl = point
	point.color = "#FFDF2D"
	local pointStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(point), point)
	activityCommonKitchenCtrl = nil
	;(nil).num = pointStr
	self.fields.Text_point:setString(i18n("eidTycoon2024_text_02", nil))
	for __, data in ipairs(self.stageData) do
		data.state = activityCommonKitchenCtrl:getBoxRewardDataStatus(self.activityID, data.stage, data.point)
	end
	activityCommonKitchenCtrl = ipairs(self.stageData)
	ipairs(self.stageData).score = point
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
end
function Activity_9001669_MainPanel:initTaskActivityID(...)
	for taskID = 1, 3 do
		local Com_task = self.fields["Com_task" .. taskID]
		if Com_task then
			Com_task:initActivityID(self.activityID)
		end
	end
end
function Activity_9001669_MainPanel:updateTask(...)
	for taskID = 1, 3 do
		self:updateTaskSingle(taskID)
	end
end
function Activity_9001669_MainPanel:updateTaskSingle(taskID)
	local Com_task = self.fields["Com_task" .. taskID]
	if Com_task then
		local data = activityCommonKitchenCtrl:getTaskData(self.activityID, taskID)
		if data then
			Com_task:setVisible(true)
			Com_task:initData(taskID, data)
		else
			Com_task:setVisible(false)
		end
	end
end
function Activity_9001669_MainPanel:updateSlider(...)
	self.itemCount = backpackCtrl:getItemCount(self.cookItemID)
	local maxValue = self.itemCount
	local minValue = math.min(1, maxValue)
	backpackCtrl = nil
	;(nil).maxValue = maxValue
	;(nil).minValue = minValue
	;(nil).curValue = minValue
	;(nil).allowZero = true
	self.fields.Com_slider:initData(nil)
end
function Activity_9001669_MainPanel:updateBtnAchi(...)
	local ret, num = activityCommonKitchenCtrl:getAchivevementRedNum(self.activityID)
	self.fields.Button_achi:setReddot(ret, num)
end
function Activity_9001669_MainPanel:onMsgUpdateData(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	SoraDCloseLoading()
	local subMsg = event.subMsg
	if subMsg == "cook" then
		self:showCookEffect(function(...)
			SoraDMailGainItems(event.rewards, true)
			if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
				self:updateScore()
			end
			self:updateSlider()
			self:updateBtnAchi()
		end)
	elseif subMsg == "stage" then
		self:updateScore()
	elseif subMsg == "completeTask" then
		self:updateTaskSingle(event.taskID)
		self:updateBtnAchi()
		self:updateScore()
	elseif subMsg == "refreshTask" then
		self:updateTaskSingle(event.taskID)
	elseif subMsg == "auto" then
		self:updateTask()
		self:updateBtnAchi()
		self:updateScore()
	elseif subMsg == "achievementReward" then
		self:updateBtnAchi()
	end
end
function Activity_9001669_MainPanel:onMsgUpdateItemCount(...)
	local itemCount = backpackCtrl:getItemCount(self.cookItemID)
	if self.itemCount ~= itemCount then
		self:updateSlider()
	end
	for taskID = 1, 3 do
		local Com_task = self.fields["Com_task" .. taskID]
		if Com_task then
			Com_task:updateItemCount()
		end
	end
end
function Activity_9001669_MainPanel:showCookEffect(callFunc)
	SoraDShowLoading(self, nil, nil, true)
	self.fields.Image_qj1:setVisible(true)
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.fadeOut(0.5)
	;(nil)[2] = ffa.delay(1)
	;(nil)[3] = ffa.fadeIn(0.5)
	;(nil)[4] = ffa.callFunc(function(...)
		SoraDCloseLoading(self)
		self.fields.Image_qj1:setVisible(false)
		callFunc()
	end)
	;(nil)[5] = ffa.callFunc(function(...)
		SoraDCloseLoading(self)
		self.fields.Image_qj1:setVisible(false)
		callFunc()
	end)
	self.fields.Image_qj2:runAction(ffa.seq(nil))
	self.fields.Usm_cook:setAlpha(0)
	_UPVALUE2_ = ffa.seq(nil)
	ffa.seq(nil)[1] = ffa.fadeIn(0.3)
	ffa.seq(nil)[2] = ffa.delay(1.2)
	ffa.seq(nil)[3] = ffa.fadeOut(0.5)
	ffa.seq(nil)[4] = ffa.fadeOut(0.5)
	ffa.seq(nil)[5] = ffa.fadeOut(0.5)
	self.fields.Usm_cook:runAction(ffa.seq(ffa.seq(nil)))
	self.fields.Usm_cook:setCompleteCallback(function(...)
		self.fields.Usm_cook:setVisible(false)
	end)
	self.fields.Usm_cook:play()
end
function Activity_9001669_MainPanel:initTab(...)
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, nil, 2
	_ENV, (nil)[1], (nil).title = nil, nil, i18n("eidal_kitchen_text_01")
	;(nil).tabsetArray, (nil)[2], (nil).title = nil, nil, i18n("eidal_kitchen_text_02")
	local (nil).callback, param = handler(self, self.onClickTab), nil
	self.fields.Com_title1:initTab(param)
	local isRed = activityCommonKitchenCtrl:getReceiveStatusAndNum2(self.activityID, true)
	self.fields.Com_title1:setBtnRedDot(1, isRed)
end
function Activity_9001669_MainPanel:onClickTab(tag)
	if tag == 1 then
		_ENV = nil
		;(nil).activityID = self.activityID
		uiManager:show("Activity_9001699_Main", nil)
		self:closePanel()
	end
end
return Activity_9001669_MainPanel
