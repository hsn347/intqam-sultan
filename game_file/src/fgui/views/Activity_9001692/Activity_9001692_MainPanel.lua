local activityCommonMergeCtrl = SoraDGetCtrl("activityCommonMergeCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityCommonMergeRead = include("activityCommonMergeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001692_MainPanel = class("Activity_9001692_MainPanel", baseFguiPanel)
function Activity_9001692_MainPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "Activity_9001663"
	return nil
end
function Activity_9001692_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001692_MainPanel.super.ctor(self, ...)
	print("Activity_9001692_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001692
	self.leftCount = 0
	self.postList, Activity_9001692_MainPanel, self.needList, Activity_9001692_MainPanel, self.tag = gActivityTimeActivityID.NORMAL_ACTIVITY_9001692, gActivityTimeActivityID.NORMAL_ACTIVITY_9001692, gActivityTimeActivityID.NORMAL_ACTIVITY_9001692, gActivityTimeActivityID.NORMAL_ACTIVITY_9001692, 1
	Activity_9001692_MainPanel = self.viewName
	self.viewName.byUID = true
	self.bubbleIndex = SoraDConfigGet("Game:Activity_9001692:bubbleType~integer", self.viewName) or 1
	self.bubbleCount = activityCommonMergeRead.getCfgNum(self.activityID)
end
function Activity_9001692_MainPanel:onInit()
	print("=======Activity_9001692_MainPanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_map:setString(i18n("collect_colored_ribbon_text_03"))
	self.fields.Button_map:addClickListener(handler(self, self.btnMapClick))
	self.fields.Btn_left:addClickListener(handler(self, self.btnLClick))
	self.fields.Btn_right:addClickListener(handler(self, self.btnRClick))
	self.fields.List_point:setNeedAutoFix(false)
	self.fields.Text_need:setString(i18n("daily_reward_name_07"))
	self.fields.List_need:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_compose:setString(i18n("common_text_1352"))
	self.fields.Button_compose:addClickListener(handler(self, self.btnComposeClick))
	self.fields.Button_compose:setBright(false)
	self.fields.Usm_merge:setVisible(false)
	self.fields.Usm_merge:setCompleteCallback(function()
		self.fields.Usm_merge:setVisible(false)
	end)
	self.fields.Com_exchange:setActivityID(self.activityID, self)
	local Btn_bubble = self.fields.bubble_1
	if Btn_bubble then
		local mv_paopao = Btn_bubble:getChild("mv_paopao")
		mv_paopao:setAllFrameName("9001692_paopao_%02d.png", 1)
	end
end
function Activity_9001692_MainPanel:endShow()
	print("=======Activity_9001692_MainPanel:endShow")
	self.effectPos = self.fields.Mod_center:getPosition()
	self.isComPoseMsg = false
	self.tag = self.param and self.param.tag or 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	_ENV, self.tag[1], (nil).title = nil, nil, i18n("collect_colored_ribbon_text_02")
	;(nil).tabsetArray, self.tag[2], (nil).title = self.tag, nil, i18n("bubble_party_text_31")
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_title:initTab(nil)
end
function Activity_9001692_MainPanel:onHide()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:Activity_9001692:bubbleType~integer", self.bubbleIndex, nil)
end
function Activity_9001692_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("collect_colored_ribbon_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001692_MainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:updateView()
end
function Activity_9001692_MainPanel:updateView()
	print("==Activity_9001692_MainPanel:updateView==", self.tag)
	if self.tag == 1 then
		self.fields.List_point:setSelectedIndex(self.bubbleIndex - 1)
		self.cfg = activityCommonMergeRead.getCfg(self.activityID, self.bubbleIndex)
		if #self.cfg.bubbleName > 0 then
			self.fields.Text_name:setString(i18n(self.cfg.bubbleName))
		end
		local reward = self.cfg.rewaryd
		local colorIndex = math.min(self.cfg.bubbleType - 1, 4)
		self.fields.Mod_center:getController("c1"):setSelectedIndex(colorIndex)
		local countIndex = math.max(0, math.min(#reward - 3, 2))
		self.fields.Mod_center:getController("c2"):setSelectedIndex(countIndex)
		for k, v in ipairs(reward) do
			local Btn_bubble = self.fields["bubble_" .. k]
			if Btn_bubble then
				Btn_bubble:getChild("item"):initData(v.id)
			end
		end
		local composeCount = activityCommonMergeCtrl:getComposeCount(self.activityID, self.cfg.bubbleType)
		self.leftCount = math.max(self.cfg.limit - composeCount, 0)
		local numStr = fguiHelper.getColorString(0 < self.leftCount and "#F0E6D2" or "#E02B2B", self.leftCount)
		_ENV = Btn_bubble:getChild("item").initData
		Btn_bubble:getChild("item").initData.num = numStr
		self.fields.Text_leftCount:setString(i18n("bubble_party_text_03", Btn_bubble:getChild("item").initData))
		self.needList = self.cfg.formula
		self.fields.List_need:setNumItems(#self.needList)
		self.isEnough = true
		for k, v in ipairs(self.needList) do
			if backpackCtrl:getItemCount(v.id) < v.count then
				self.isEnough = false
				break
			end
		end
		local isBright = 0 < self.leftCount and self.isEnough
		self.fields.Button_compose:setBright(isBright)
		self.fields.Button_compose:setReddot(isBright, -1)
		self.fields.Button_map:setReddot(activityCommonMergeCtrl:getReceiveStatusAndNum(self.activityID))
	else
		self.fields.Com_exchange:updateView()
	end
end
function Activity_9001692_MainPanel:btnMapClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("Activity_9001663_map", nil)
end
function Activity_9001692_MainPanel:btnLClick()
	SoraDPlaySound()
	self.bubbleIndex = self.bubbleIndex - 1
	if self.bubbleIndex < 1 then
		self.bubbleIndex = self.bubbleCount
	end
	self.isComPoseMsg = false
	self:updateView()
	self:playBoxAct(true)
end
function Activity_9001692_MainPanel:btnRClick()
	SoraDPlaySound()
	self.bubbleIndex = self.bubbleIndex + 1
	if self.bubbleIndex > self.bubbleCount then
		self.bubbleIndex = 1
	end
	self.isComPoseMsg = false
	self:updateView()
	self:playBoxAct()
end
function Activity_9001692_MainPanel:onItemRenderer(index, obj)
	local data = self.needList[index + 1]
	local itemCount = backpackCtrl:getItemCount(data.id)
	obj:initData(data.id, itemCount, data.count)
	if self.isComPoseMsg then
		obj:setMAct(self.fields.Usm_merge)
	end
end
function Activity_9001692_MainPanel:btnComposeClick()
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
function Activity_9001692_MainPanel:onMsgMergeUpdate(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	SoraDCloseLoading(self)
	_ENV, self.isComPoseMsg = SoraDCloseLoading, false
	SoraDCloseLoading.compose = true
	SoraDCloseLoading.exchangeDeal = true
	SoraDCloseLoading.exchangePost = true
	SoraDCloseLoading.exchangeCancel = true
	local SoraDCloseLoading.notify, config = true, SoraDCloseLoading
	if config[event.subMsg] then
		if self.tag == 1 and event and self.cfg.bubbleType == event.bubbleType then
			self.isComPoseMsg = true
		end
		self:updateView()
	end
end
function Activity_9001692_MainPanel:playBoxAct(isLeft)
	local Mod_center = self.fields.Mod_center
	Mod_center:stopAllActions()
	Mod_center:setOpacity(0)
	Mod_center:runAction(ffa.fadeIn(0.3))
	local offsetX = 100
	if isLeft then
		offsetX = -100
	end
	Mod_center:setPositionX(self.effectPos.x + offsetX)
	Mod_center:runAction(ffa.moveTo(0.3, self.effectPos.x, self.effectPos.y))
end
return Activity_9001692_MainPanel
