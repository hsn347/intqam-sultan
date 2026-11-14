local activityCommonMergeRead = include("activityCommonMergeRead")
local activityCommonMergeCtrl = SoraDGetCtrl("activityCommonMergeCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001663_mainPanel = class("Activity_9001663_mainPanel", baseFguiPanel)
function Activity_9001663_mainPanel:ctor(...)
	Activity_9001663_mainPanel.super.ctor(self, ...)
	print("Activity_9001663_mainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.BUBBLE_CARNIVAL
end
function Activity_9001663_mainPanel:onInit()
	print("=======Activity_9001663_mainPanel:onInit")
	self.postList, _ENV, self.needList, _ENV, self.tag = print, print, print, print, 1
	self.initShowAct = true
	_ENV = nil
	;(nil).byUID = true
	self.bubbleIndex = SoraDConfigGet("Game:Activity_9001663:bubbleType~integer", nil) or 1
	self.bubbleCount = activityCommonMergeRead.getCfgNum(self.activityID)
	self.fields.Com_title:initData(i18n("activity_name_9001663"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	fguiHelper.SoraDSetComFields(self)
	self.fields.Lab_need:setString(i18n("daily_reward_name_07"))
	self.fields.Button_map:setString(i18n("bubble_party_text_25"))
	self.fields.Button_map:addClickListener(handler(self, self.btnMapClick))
	self.fields.Btn_left:addClickListener(handler(self, self.btnLClick))
	self.fields.Btn_right:addClickListener(handler(self, self.btnRClick))
	self.fields.List_need:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_compose:setString(i18n("common_text_1352"))
	self.fields.Button_compose:addClickListener(handler(self, self.btnComposeClick))
	self.fields.Button_compose:setBright(false)
	self.fields.Usm_merge:setVisible(false)
	self.fields.Usm_merge:setCompleteCallback(function()
		self.fields.Usm_merge:setVisible(false)
	end)
	self.fields.Com_exchange:setActivityID(self.activityID, self)
	self.fields.Button_map:fixPos()
end
function Activity_9001663_mainPanel:onShow()
	print("=======Activity_9001663_mainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.tag = self.param and self.param.tag or 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("bubble_party_text_02")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("bubble_party_text_31")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
end
function Activity_9001663_mainPanel:onHide()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:Activity_9001663:bubbleType~integer", self.bubbleIndex, nil)
end
function Activity_9001663_mainPanel:onItemRenderer(index, obj)
	local data = self.needList[index + 1]
	obj:initData(data.id, backpackCtrl:getItemCount(data.id), data.count)
	if self.isComPoseMsg then
		obj:setMAct(self.fields.Usm_merge)
	end
end
function Activity_9001663_mainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:updateView()
end
function Activity_9001663_mainPanel:setBubbleShow()
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil).b = 0.27
	;(nil).c = 0
	;(nil).s = 0.73
	_UPVALUE0_, (nil)[1], (nil).h = nil, nil, -1
	;(nil).b = -0.16
	;(nil).c = 0.08
	;(nil).s = 0.61
	_UPVALUE0_, (nil)[2], (nil).h = nil, nil, 0.72
	;(nil).b = 0
	;(nil).c = 0
	;(nil).s = 0
	_UPVALUE0_, (nil)[3], (nil).h = nil, nil, 0.32
	;(nil).b = 0
	;(nil).c = 0
	;(nil).s = 0
	_UPVALUE0_, (nil)[4], (nil).h = nil, nil, 0
	;(nil).b = 0
	;(nil).c = 0
	;(nil).s = 0
	;(nil)[5], (nil).h = nil, -0.5
	local cfg
	local showCfg = cfg[self.bubbleIndex] or cfg[1]
	self.fields.bubble:setColorFilter(showCfg.b, showCfg.c, showCfg.s, showCfg.h)
end
function Activity_9001663_mainPanel:updateView(target, data)
	SoraDCloseLoading(self)
	self.isComPoseMsg = false
	if self.tag == 1 then
		if data and self.cfg.bubbleType == data.bubbleType then
			self.isComPoseMsg = true
		end
		self.fields.Label_time:initCommonActivityTime(self.activityID)
		self.cfg = activityCommonMergeRead.getCfg(self.activityID, self.bubbleIndex)
		if #self.cfg.bubbleName > 0 then
			self.fields.Text_name:setString(i18n(self.cfg.bubbleName))
		end
		local reward = self.cfg.rewaryd
		local colorIndex = math.min(self.cfg.bubbleType - 1, 4)
		self.fields.Mod_center:getController("c1"):setSelectedIndex(colorIndex)
		local countIndex = math.max(0, math.min(#reward - 3, 2))
		self.fields.Mod_center:getController("c2"):setSelectedIndex(#reward - 3)
		for k, v in ipairs(reward) do
			if self.fields["bubble_" .. k] then
				self.fields["bubble_" .. k]:initData(v.id)
				if self.initShowAct then
					self.fields["bubble_" .. k]:playT0()
				end
			end
		end
		if G_IS_UNITY then
			self:setBubbleShow()
		end
		self.initShowAct = false
		self.leftCount = math.max(self.cfg.limit - activityCommonMergeCtrl:getComposeCount(self.activityID, self.cfg.bubbleType), 0)
		_ENV = self.activityID
		self.activityID.num = fguiHelper.getColorString(0 < self.leftCount and "#F0E6D2" or "#E02B2B", self.leftCount)
		self.fields.Text_leftCount:setString(i18n("bubble_party_text_03", self.activityID))
		self.needList = self.cfg.formula
		self.fields.List_need:setNumItems(#self.needList)
		self.isEnough = true
		for k, v in ipairs(self.needList) do
			if backpackCtrl:getItemCount(v.id) < v.count then
				self.isEnough = false
				break
			end
		end
		self.fields.Button_compose:setBright(0 < self.leftCount and self.isEnough)
		self.fields.Button_compose:setReddot(0 < self.leftCount and self.isEnough, -1)
		self.fields.Button_map:setReddot(activityCommonMergeCtrl:getReceiveStatusAndNum(self.activityID))
	else
		self.fields.Com_exchange:updateView()
	end
end
function Activity_9001663_mainPanel:btnLClick()
	SoraDPlaySound()
	self.bubbleIndex = self.bubbleIndex - 1
	if self.bubbleIndex < 1 then
		self.bubbleIndex = self.bubbleCount
	end
	self:updateView()
end
function Activity_9001663_mainPanel:btnRClick()
	SoraDPlaySound()
	self.bubbleIndex = self.bubbleIndex + 1
	if self.bubbleIndex > self.bubbleCount then
		self.bubbleIndex = 1
	end
	self:updateView()
end
function Activity_9001663_mainPanel:btnMapClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001663_map")
end
function Activity_9001663_mainPanel:btnComposeClick()
	SoraDPlaySound()
	if self.leftCount <= 0 then
		SoraDShowMsgTip(i18n("bubble_party_text_04"))
		return
	end
	if not self.isEnough then
		SoraDShowMsgTip(i18n("bubble_party_text_05"))
		return
	end
	activityCommonMergeCtrl:reqCompose(self.activityID, self.cfg.bubbleType)
	SoraDShowLoading(self)
end
function Activity_9001663_mainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("bubble_party_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001663_mainPanel:onMsgMergeUpdate(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	_UPVALUE0_ = event.activityID
	event.activityID.compose = true
	event.activityID.exchangeDeal = true
	event.activityID.exchangePost = true
	event.activityID.exchangeCancel = true
	local event.activityID.notify, config = true, event.activityID
	if config[event.subMsg] then
		self:updateView(target, event)
	end
end
return Activity_9001663_mainPanel
