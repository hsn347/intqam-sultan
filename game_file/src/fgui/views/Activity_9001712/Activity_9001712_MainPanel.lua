local activity_9001712_Read = include("activity_9001712_Read")
local activity_9001712_Ctrl = SoraDGetCtrl("activity_9001712_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001712_MainPanel = class("Activity_9001712_MainPanel", baseFguiPanel)
function Activity_9001712_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001712_MainPanel.super.ctor(self, ...)
	print("Activity_9001712_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY
end
function Activity_9001712_MainPanel:onInit()
	print("=======Activity_9001712_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:setTitleWidthHeight(480, 40)
	self.fields.Button_reward:setTitle(i18n("anniversary_ten_daily_05"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClick_Button_reward))
	self.fields.Button_Missing:setTitle(i18n("anniversary_ten_daily_06"))
	self.fields.Button_Missing:addClickListener(handler(self, self.onClick_Button_Missing))
	self.fields.btnScratch:setTitle(i18n("anniversary_ten_daily_23"))
	self.fields.btnScratch:addClickListener(handler(self, self.onClick_btnScratch))
	self.fields.btnDetail:addClickListener(handler(self, self.onClick_btnDetail))
	self.fields.txtTip:setString(i18n("anniversary_ten_daily_03"))
	self.fields.txtTotalTip:setString(i18n("anniversary_ten_daily_02"))
	self.fields.comReward:addClickListener(handler(self, self.onClick_ComReward))
	self.fields.listReward:setItemRenderer(handler(self, self.onRenderListItem))
	self.fields.card1:addClickListener(handler(self, self.onClick_Card))
	self.fields.card2:addClickListener(handler(self, self.onClick_Card))
	self.fields.card3:addClickListener(handler(self, self.onClick_Card))
	self.fields.card4:addClickListener(handler(self, self.onClick_Card))
	self.fields.card5:addClickListener(handler(self, self.onClick_Card))
	SoraDAddMessage("MESSAGE_ACTIVITY_9001712_UPDATE", handler(self, self.initData))
end
function Activity_9001712_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("anniversary_ten_daily_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001712_MainPanel:endShow()
	print("=======Activity_9001712_MainPanel:endShow")
	self:initData()
end
function Activity_9001712_MainPanel:onShow()
	print("=======Activity_9001712_MainPanel:endShow")
	self.fields.card1:setSelected(false)
	self.fields.card2:setSelected(false)
	self.fields.card3:setSelected(false)
	self.fields.card4:setSelected(false)
	self.fields.card5:setSelected(false)
	self.selectedCard = nil
end
function Activity_9001712_MainPanel:onClick_Button_reward(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("Activity_9001712_DayReward", nil)
end
function Activity_9001712_MainPanel:onClick_Button_Missing(context)
	SoraDPlaySound()
	if activity_9001712_Ctrl:getCanByNum() > 0 then
		activity_9001712_Ctrl:clearMissingReddot()
		self.fields.Button_Missing:getChild("Label_reddot"):setVisible(false)
		_ENV = nil
		;(nil).activityID = self.activityID
		uiManager:show("Activity_9001712_Missing", nil)
	end
end
function Activity_9001712_MainPanel:onClick_btnScratch(context)
	SoraDPlaySound()
	if not self.selectedCard then
		SoraDShowMsgTip(i18n("anniversary_ten_daily_14"))
		return
	end
	if activity_9001712_Ctrl:getLeftScratchTimes() > 0 then
		activity_9001712_Ctrl:reqReward(self.selectedCard:getIndex())
	else
		SoraDShowMsgTip(i18n("anniversary_ten_daily_13"))
	end
end
function Activity_9001712_MainPanel:onClick_btnDetail(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("Activity_9001712_TotalReward", nil)
end
function Activity_9001712_MainPanel:onClick_ComReward(context)
	SoraDPlaySound()
	local nextStageReward, allReceived = activity_9001712_Ctrl:getNextStageReward()
	if activity_9001712_Ctrl:hasAvaliableStageReward() then
		activity_9001712_Ctrl:reqStageReward(nextStageReward.stageIndex)
	elseif allReceived then
		SoraDShowMsgTip(i18n("anniversary_ten_daily_21"))
	else
		SoraDShowMsgTip(i18n("anniversary_ten_daily_15"))
	end
end
function Activity_9001712_MainPanel:onRenderListItem(index, obj)
	obj:initData(self.stageReward[index * 2 + 1], self.stageReward[index * 2 + 2])
	obj:setClickCallback(handler(self, self.onClickItem))
end
function Activity_9001712_MainPanel:onClickItem(context)
	SoraDPlaySound()
	local nextStageReward, allReceived = activity_9001712_Ctrl:getNextStageReward()
	if activity_9001712_Ctrl:hasAvaliableStageReward() then
		activity_9001712_Ctrl:reqStageReward(nextStageReward.stageIndex)
	elseif allReceived then
		SoraDShowMsgTip(i18n("anniversary_ten_daily_21"))
	else
		SoraDShowMsgTip(i18n("anniversary_ten_daily_15"))
	end
end
function Activity_9001712_MainPanel:onClick_Card(context)
	SoraDPlaySound()
	if self.selectedCard == context.sender then
		if self.selectedCard then
			self.selectedCard:setSelected(false)
		end
		self.selectedCard = nil
		print("Activity_9001712_MainPanel:onClick_Card 取消选中了第" .. context.sender:getIndex() .. "张卡牌")
	else
		if self.selectedCard then
			self.selectedCard:setSelected(false)
		end
		self.selectedCard = context.sender
		self.selectedCard:setSelected(true)
		print("Activity_9001712_MainPanel:onClick_Card 选中了第" .. context.sender:getIndex() .. "张卡牌")
	end
end
function Activity_9001712_MainPanel:initData()
