local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonStageReward2Panel = class("CommonStageReward2Panel", baseFguiPanel)
function CommonStageReward2Panel:ctor(...)
	CommonStageReward2Panel.super.ctor(self, ...)
	print("CommonStageReward2Panel:ctor", self.viewName)
	self.rewardList, CommonStageReward2Panel, self.debug = print, print, true
end
function CommonStageReward2Panel:onInit()
	print("=======CommonStageReward2Panel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_get:addClickListener(handler(self, self.onClickButtonGet))
end
function CommonStageReward2Panel:onShow()
	print("=======CommonStageReward2Panel:onShow")
	if not self.param then
		_ENV = self.param
	end
	self:initData(self.param)
end
function CommonStageReward2Panel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
function CommonStageReward2Panel:onClickButtonGet()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001638 then
		local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
		activityCommonBubbleCtrl:reqStageReward(self.activityID, self.boxIndex)
		self:closePanel()
		return
	else
		if self.btnHandle then
			self.btnHandle()
		end
		self:closePanel()
	end
end
function CommonStageReward2Panel:initData(data)
	self.activityID = data.activityID
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001638 then
		local activityCommonBubbleRead = include("activityCommonBubbleRead")
		local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
		local boxIndex = data.boxIndex or 1
		self.boxIndex = boxIndex
		local score = activityCommonBubbleRead.getStagePoint(self.activityID, boxIndex)
		local numStr = fguiHelper.getColorString("#EBE53B", string.formatnumberthousands(score))
		_ENV = string.formatnumberthousands(score)
		string.formatnumberthousands(score).num = numStr
		local tipStr = i18n("pet_flip_text_04", string.formatnumberthousands(score))
		local curScore = activityCommonBubbleCtrl:getScore(self.activityID)
		_ENV = string.formatnumberthousands(score)
		string.formatnumberthousands(score).num = string.formatnumberthousands(curScore)
		local curScoreStr = i18n("Bubble_Bobble_text_02", string.formatnumberthousands(score))
		self.fields.Text_tip:setString(tipStr .. "\n" .. curScoreStr)
		self.rewardList = activityCommonBubbleRead.getStageReward(self.activityID, boxIndex)
		local state = activityCommonBubbleCtrl:getBoxState(self.activityID, boxIndex)
		self:updateButtonGet(state)
	else
		if not data.rewards then
			_ENV = data.rewards
		end
		self.rewardList = data.rewards
		local tipStr = data.tipStr
		self.fields.Text_tip:setVisible(tipStr ~= nil)
		if tipStr then
			self.fields.Text_tip:setString(tipStr)
		end
		local btnStr = data.btnStr
		self.fields.Button_get:setVisible(btnStr ~= nil)
		self.fields.n15:setVisible(btnStr ~= nil)
		if btnStr then
			self.fields.Button_get:setString(btnStr)
		end
		self.btnHandle = data.btnHandle
		local btnEnabled = data.btnEnabled
		if btnEnabled ~= nil then
			self.fields.Button_get:setEnabled(btnEnabled)
		else
			self.fields.Button_get:setEnabled(true)
		end
	end
	self.fields.List_reward:setNumItems(#self.rewardList)
end
function CommonStageReward2Panel:updateButtonGet(state)
	if state == gBtnTargetStatusDef.GOT then
		self.fields.Button_get:setString(i18n("common_text_1892"))
		self.fields.Button_get:setEnabled(false)
	elseif state == gBtnTargetStatusDef.GET then
		self.fields.Button_get:setString(i18n("common_text_1146"))
	elseif state == gBtnTargetStatusDef.GO then
		self.fields.Button_get:setString(i18n("common_text_1146"))
		self.fields.Button_get:setEnabled(false)
	end
end
return CommonStageReward2Panel
