local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
local activityCommonBubbleRead = include("activityCommonBubbleRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001638_MainPanel = class("Activity_9001638_MainPanel", baseFguiPanel)
function Activity_9001638_MainPanel:ctor(...)
	Activity_9001638_MainPanel.super.ctor(self, ...)
	print("Activity_9001638_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001638
	self.itemID = activityCommonBubbleCtrl:getItemID(self.activityID)
	self.scoreList = activityCommonBubbleRead.getScoreList(self.activityID)
	self.debug = true
end
function Activity_9001638_MainPanel:onInit()
	print("=======Activity_9001638_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_shop:setString(i18n("common_text_1809"))
	self.fields.Button_shop:addClickListener(handler(self, self.onClickBtnShop))
	self.fields.Button_day:addClickListener(handler(self, self.onClickBtnDay))
	self.Text_day = SoraDCreateTimerLabel(self, self.fields.Button_day:getChild("title"))
	self.Text_day:setTimeEndListener(function()
		self:updateButtonDay()
	end)
	self.fields.Check_tick:addClickListener(handler(self, self.onClickBtnCheckTick))
	self.fields.Text_tick:setString(i18n("Bubble_Bobble_text_03"))
	self.fields.List_box:setItemRenderer(handler(self, self.onItemBoxRenderer))
	self.fields.Com_have:initData(self.itemID)
	self.fields.Text_cancer:setString(i18n("Bubble_Bobble_text_05"))
	self.fields.Text_ten:setString(i18n("Bubble_Bobble_text_04"))
	self.fields.Text_ten:setVisible(false)
	self.fields.Image_ten:setVisible(false)
	if not SoraDFIsRA() then
		self.fields.bar:getChild("bar"):fixPos()
		self.fields.Text_cancer:fixPos()
		self.fields.Text_tick:setAlign(cc.TEXT_ALIGNMENT_LEFT)
	end
end
function Activity_9001638_MainPanel:onShow()
	print("=======Activity_9001638_MainPanel:onShow")
	local mapData = activityCommonBubbleCtrl:getBubbleMap(self.activityID)
	self.fields.Com_map:initMapData(mapData)
	self:updateTextScore()
	self:updateItemCount()
	self:updateButtonDay()
	activityCommonBubbleCtrl:checkGuide(self.activityID)
end
function Activity_9001638_MainPanel:getTestMapData(...)
	_UPVALUE8_, _UPVALUE5_ = nil, nil
	_UPVALUE7_, (nil)[1] = 2, 2
	_UPVALUE7_, (nil)[2] = 2, 2
	_UPVALUE7_, (nil)[3] = 2, 1
	_UPVALUE7_, (nil)[4] = 2, 1
	_UPVALUE7_, (nil)[5] = 2, 1
	_UPVALUE7_, (nil)[6] = 2, 1
	_UPVALUE7_, (nil)[7] = 2, 1
	_UPVALUE7_, (nil)[8] = 2, 1
	_UPVALUE8_, (2)[1] = 2, 2
	_UPVALUE8_, (2)[2] = 2, 2
	_UPVALUE8_, (2)[3] = 2, 1
	_UPVALUE8_, (2)[4] = 2, 1
	_UPVALUE8_, (2)[5] = 2, 1
	_UPVALUE8_, (2)[6] = 2, 2
	_UPVALUE8_, (2)[7] = 2, 2
	_UPVALUE7_, (2)[1] = 1, 1
	_UPVALUE7_, (2)[2] = 1, 2
	_UPVALUE7_, (2)[3] = 1, 3
	_UPVALUE7_, (2)[4] = 1, 3
	_UPVALUE7_, (2)[5] = 1, 0
	_UPVALUE7_, (2)[6] = 1, 0
	_UPVALUE7_, (2)[7] = 1, 1
	_UPVALUE7_, (2)[8] = 1, 1
	_UPVALUE8_, (1)[1] = 0, 0
	_UPVALUE8_, (1)[2] = 0, 1
	_UPVALUE8_, (1)[3] = 0, 1
	_UPVALUE8_, (1)[4] = 0, 3
	_UPVALUE8_, (1)[5] = 0, 3
	_UPVALUE8_, (1)[6] = 0, 0
	_UPVALUE8_, (1)[7] = 0, 1
	;(0)[1] = 0
	;(0)[2] = 0
	;(0)[3] = 0
	;(0)[4] = 0
	;(0)[5] = 0
	;(0)[6] = 1
	;(0)[7] = 0
	;(0)[8] = 0
	;(nil)[1] = nil
	;(nil)[2] = 2
	;(nil)[3] = 2
	;(nil)[4] = 1
	local (nil)[5], mapData = 0, nil
	local _ENV, ret
	for y, v in ipairs(mapData) do
		if not ret[y] then
			_ENV = ret[y]
		end
		ret[y] = ret[y]
		for x, colorType in ipairs(v) do
			_ENV = 0
			ret[y][x], (0).color = 0, colorType
		end
	end
	return mapData
end
function Activity_9001638_MainPanel:initCheatButtons(...)
	self.fields.Button_cheat1:setString("恢复场景")
	self.fields.Button_cheat1:addClickListener(handler(self, self.onClickBtnCheat))
	self.fields.Button_cheat2:setString("重置颜色")
	self.fields.Button_cheat2:addClickListener(handler(self, self.onClickBtnCheat))
	self.fields.Button_cheat3:setString("点击泡泡改变颜色")
	self.fields.Button_cheat3:addClickListener(handler(self, self.onClickBtnCheat))
end
function Activity_9001638_MainPanel:onClickBtnCheat(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	if button == self.fields.Button_cheat1 then
		self.fields.Com_map:resetMyBubble()
		self.fields.Com_map:recoverMap()
	elseif button == self.fields.Button_cheat2 then
		self.fields.Com_map:resetMyBubble()
		self.fields.Com_map:resetBubbleSelect()
		self.fields.Com_map:resetBubbleColor()
	elseif button == self.fields.Button_cheat3 then
		self.fields.Com_map:reverseChangeModel()
		if self.fields.Com_map:getIsChangeModel() then
			self.fields.Button_cheat3:setString("再点一次结束改变颜色")
		else
			self.fields.Button_cheat3:setString("点击泡泡改变颜色")
		end
	end
end
function Activity_9001638_MainPanel:onClickHelp()
	SoraDPlaySound()
	activityCommonBubbleRead.getShowFAQ(self.activityID)
end
function Activity_9001638_MainPanel:onClickBtnShop(...)
	SoraDPlaySound()
	local activityID = gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9010000
	clientEventMgr.singleClickEvent(activityID)
end
function Activity_9001638_MainPanel:onClickBtnDay(...)
	SoraDPlaySound()
	local isFree = activityCommonBubbleCtrl:checkFreeReceiveTime(self.activityID)
	if isFree then
		activityCommonBubbleCtrl:reqFreeReward(self.activityID)
	end
end
function Activity_9001638_MainPanel:onClickBtnCheckTick(...)
	SoraDPlaySound()
	local selected = self.fields.Check_tick:isSelected()
	if selected then
		local itemCount = backpackCtrl:getItemCount(self.itemID)
		if itemCount < 10 then
			SoraDShowMsgTip(i18n("notice_0120"))
			self.fields.Check_tick:setSelected(false)
			return
		end
	end
	self.fields.Com_map:setCheckTickSelected(selected)
	self.fields.Text_ten:setVisible(selected)
	self.fields.Image_ten:setVisible(selected)
end
function Activity_9001638_MainPanel:onItemBoxRenderer(index, obj)
	local stage = index + 1
	local point = activityCommonBubbleRead.getStagePoint(self.activityID, stage)
	local state = activityCommonBubbleCtrl:getBoxState(self.activityID, stage)
	obj:initData(stage, point, state, function(_index)
		_ENV = nil
		;(nil).activityID = self.activityID
		;(nil).boxIndex = _index
		uiManager:show("CommonStageReward2", nil)
	end)
end
function Activity_9001638_MainPanel:updateTextScore(...)
	local score = activityCommonBubbleCtrl:getScore(self.activityID)
	activityCommonBubbleCtrl = nil
	activityCommonBubbleCtrl, activityCommonBubbleCtrl, (nil).num = score, string.formatnumberthousands(score), string.formatnumberthousands(score)
	string.formatnumberthousands(score).num, score.color = score, "#FFDF2D"
	local scoreStr = i18n_html("common_text_2557", nil, (string.formatnumberthousands(score)))
	self.fields.Text_score:setString(scoreStr)
	local percent = SoraDGetStageValue(score, self.scoreList)
	self.fields.bar:setValue(percent)
	self:updateListBox()
end
function Activity_9001638_MainPanel:updateListBox(...)
	self.fields.List_box:setNumItems(#self.scoreList)
end
function Activity_9001638_MainPanel:updateItemCount(...)
	self.fields.Com_have:updateNum()
end
function Activity_9001638_MainPanel:updateMapData(...)
	self.fields.Com_map:updateMapData()
end
function Activity_9001638_MainPanel:updateButtonDay(...)
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
function Activity_9001638_MainPanel:onMsgUpdateView(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	local subMsg = event.subMsg
	if subMsg == "init" then
	elseif subMsg == "shoot" then
		self:updateTextScore()
		self:updateMapData()
	elseif subMsg == "stage" then
		self:updateListBox()
	elseif subMsg == "free" then
		self:updateButtonDay()
	end
end
function Activity_9001638_MainPanel:gameGuide_getTarget(itemName, parameters)
	print("==Activity_9001638_MainPanel:gameGuide_getTarget==", itemName, parameters)
	_ENV = print
	local print.Button_right, mapConfig = true, print
	if mapConfig[itemName] then
		return self.fields.Com_map:gameGuide_getTarget(itemName, parameters)
	end
	if itemName == "Button_ten" then
		return self.fields.Check_tick
	end
	return self.fields[itemName]
end
return Activity_9001638_MainPanel
