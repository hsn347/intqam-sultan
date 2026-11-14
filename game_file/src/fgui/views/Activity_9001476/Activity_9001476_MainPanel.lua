local activity_9001476_Ctrl = SoraDGetCtrl("activity_9001476_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001476_MainPanel = class("Activity_9001476_MainPanel", baseFguiPanel)
function Activity_9001476_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001476_MainPanel:ctor", self.viewName)
	self.rewards, _ENV = print, print
	self.itemID = activity_9001476_Ctrl:getItemID()
	self.Com_boxs, _ENV, self.Com_rewards, _ENV, self.boxConfig = activity_9001476_Ctrl:getBoxConfig(), activity_9001476_Ctrl:getBoxConfig(), activity_9001476_Ctrl:getBoxConfig(), activity_9001476_Ctrl:getBoxConfig(), activity_9001476_Ctrl:getBoxConfig()
end
function Activity_9001476_MainPanel:onInit()
	print("=======Activity_9001476_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001476"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initActivityTime(gActivityTimeActivityID.ONE_GOAL_TO_FAME_ACTIVITY)
	for i = 1, 10 do
		local Com_reward = self.fields["Com_reward" .. i]
		Com_reward.item = Com_reward:getChild("item")
		Com_reward.item:setVisible(false)
		Com_reward:fixPos()
		self.Com_rewards[i] = Com_reward
	end
	local itemIcon = itemDesRead.getIcon(self.itemID)
	self.fields.icon_item:setURL(itemIcon)
	self.fields.Button_add:addClickListener(handler(self, self.onClickBtnAdd))
	_UPVALUE2_ = self.fields.Button_add
	self.fields.Button_add[1] = self.fields.Button_draw
	self.fields.Button_add[2] = self.fields.Button_drawTen
	for i, Button_draw in ipairs(self.fields.Button_add) do
		local count = i == 1 and 1 or 10
		_ENV = handler(self, self.onClickBtnAdd)
		handler(self, self.onClickBtnAdd).num = count
		Button_draw:setString(i18n("onegoaltofame_01", handler(self, self.onClickBtnAdd)))
		Button_draw:addClickListener(handlerEx(self, self.onClickBtnDraw, count))
		Button_draw:setCostNum(count)
		Button_draw:setCostIcon(itemIcon)
	end
	self:updateItemCount()
	for i = 2, 4 do
		local Com_box = self.fields["Com_box" .. i]
		Com_box:setString(tostring(self.boxConfig[i]))
		Com_box:setIcon(string.format("icon_goal_goal_%d.png", i))
		Com_box:fixPos()
		Com_box.c_state = Com_box:getController("c_state")
		self.Com_boxs[i] = Com_box
	end
	self.fields.Com_bar:setValue(0)
	self.fields.Com_bar:fixChildrenPos()
	_UPVALUE7_ = self.fields.Com_bar
	self.fields.Com_bar[1] = "bg_drawCount"
	self.fields.Com_bar[2] = "Text_drawCount"
	self.fields.Com_bar[3] = "Button_add"
	self.fields.Com_bar[4] = "Text_item"
	self.fields.Com_bar[5] = "icon_item"
	self.fields.Com_bar[6] = "Button_draw"
	self.fields.Com_bar[7] = "Button_drawTen"
	for i, v in ipairs(self.fields.Com_bar) do
		self.fields[v]:fixPos()
	end
	self.fields.Usm_ball:setCompleteCallback(function()
		self.fields.Usm_ball:setVisible(false)
	end)
	self.fields.Usm_effect:setCompleteCallback(function()
		self.fields.Group_ball:setVisible(true)
		self.fields.Usm_effect:setVisible(false)
		SoraDCloseLoading(self:displayObject())
		if self.isDrawTen then
			self = self:displayObject()
			self:displayObject().rewards = self.drawRewards
			uiManager:show("Activity_9001476_Reward", self:displayObject())
		else
			SoraDMailGainItems(self.drawRewards, true)
		end
	end)
	self.fields.Usm_goal:setCompleteCallback(function()
		self.fields.Usm_goal:setVisible(false)
	end)
end
function Activity_9001476_MainPanel:onShow()
	print("=======Activity_9001476_MainPanel:onShow")
	activity_9001476_Ctrl:reqInit()
	SoraDShowLoading(self:displayObject())
end
function Activity_9001476_MainPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("onegoaltofame_03"))
end
function Activity_9001476_MainPanel:onClickBtnAdd(...)
	SoraDPlaySound()
	self:openSourceGuideView()
end
function Activity_9001476_MainPanel:openSourceGuideView(...)
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function Activity_9001476_MainPanel:onClickBtnDraw(count)
	SoraDPlaySound()
	if count > self.haveCount then
		self:openSourceGuideView()
		return
	end
	if count == 1 then
		activity_9001476_Ctrl:reqDraw()
	elseif count == 10 then
		activity_9001476_Ctrl:reqDrawTen()
	else
		return
	end
	SoraDShowLoading(self:displayObject())
end
function Activity_9001476_MainPanel:updateInit(target, event)
	SoraDCloseLoading(self:displayObject())
	if event.isDraw or event.isDrawTen then
		self.isDrawTen = event.isDrawTen
		self.drawRewards = event.rewards
		self:showBallEffect()
		SoraDShowLoading(self:displayObject(), nil, nil, true)
	end
	local drawCount = activity_9001476_Ctrl:getDrawCount()
	local drawLv = activity_9001476_Ctrl:getDrawLv(drawCount + 1)
	self.rewards = activity_9001476_Ctrl:getDrawReward(drawCount + 1)
	for i = 1, 10 do
		local Com_reward = self.Com_rewards[i]
		local reward = self.rewards[i]
		if reward then
			Com_reward.item:setVisible(true)
			Com_reward.item:initData(reward.id, reward.count)
			Com_reward.item:hideFrameAndQuality()
		end
	end
	_ENV = 1
	_ENV, _ENV, (1).num = drawCount, string.formatnumberthousands(drawCount), string.formatnumberthousands(drawCount)
	drawCount.size = 28
	string.formatnumberthousands(drawCount).num, drawCount.color = drawCount, "#FFDF2D"
	local countStr = i18n_html("onegoaltofame_02", 1, (string.formatnumberthousands(drawCount)))
	self.fields.Text_drawCount:setString(countStr)
	local stepPercent = 0.3333333333333333
	local percent = (drawLv - 1) * stepPercent
	if percent < 1 then
		local curValue = self.boxConfig[drawLv]
		local nextValue = self.boxConfig[drawLv + 1]
		percent = percent + (drawCount - curValue) / (nextValue - curValue) * stepPercent
	end
	self.fields.Com_bar:setValue(percent * 100)
	for i = 2, 4 do
		local index = 0
		if drawLv > i then
			index = 2
		elseif drawLv == i then
			index = 1
		end
		self.Com_boxs[i].c_state:setSelectedIndex(index)
	end
	self.preDrawLv = self.preDrawLv or drawLv
	if drawLv > self.preDrawLv then
		self.preDrawLv = drawLv
		self:showGoalUpgrade()
	else
		self.fields.Load_goal:setURL(string.format("frame_goal_goal_%d.png", drawLv))
	end
end
function Activity_9001476_MainPanel:updateItemCount(...)
	self.haveCount = backpackCtrl:getItemCount(self.itemID)
	self.fields.Text_item:setString(string.formatnumberthousands(self.haveCount))
end
function Activity_9001476_MainPanel:showBallEffect(...)
	self.fields.Group_ball:setVisible(false)
	self.fields.Usm_ball:play()
	self.fields.Usm_effect:play()
end
function Activity_9001476_MainPanel:showGoalUpgrade(...)
	self.fields.Usm_goal:play()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.5)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Load_goal:setURL(string.format("frame_goal_goal_%d.png", self.preDrawLv))
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Load_goal:setURL(string.format("frame_goal_goal_%d.png", self.preDrawLv))
	end)
	self.fields.Usm_goal:runAction(ffa.seq(nil))
end
return Activity_9001476_MainPanel
