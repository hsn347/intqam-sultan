local activity_9001704_Ctrl = SoraDGetCtrl("activity_9001704_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001704_MainPanel = class("Activity_9001704_MainPanel", baseFguiPanel)
function Activity_9001704_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001704_MainPanel.super.ctor(self, ...)
	print("Activity_9001704_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001704
	self.itemID, self.itemNum = activity_9001704_Ctrl:getCostItemID()
	self.diceCount = 0
end
function Activity_9001704_MainPanel:onInit()
	print("=======Activity_9001704_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Check_tick:setString(i18n("sky_island_text12"))
	self.tick = self.fields.Check_tick:getChild("tick")
	self.tick:addClickListener(handler(self, self.onClickCheckTick))
	self.fields.Com_have:initData(self.itemID)
	self.fields.Com_have:hideBtnAdd()
	self.fields.Button_cancel:setString(i18n("sky_island_text13"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickBtnCancel))
	self.fields.Button_go:setString(i18n("sky_island_text07"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	if not SoraDFIsRA() then
		self.fields.Check_tick:fixChildrenPos()
		self.fields.Check_tick:fixChildren()
	end
end
function Activity_9001704_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("sky_island_text02")
	uiManager:show("RuleView", nil)
end
function Activity_9001704_MainPanel:endShow()
	print("=======Activity_9001704_MainPanel:endShow")
	SoraDCloseLoading(self)
	local defaultClick = 1
	if activity_9001704_Ctrl:getReceiveStatusAndNum_sign() then
		defaultClick = 2
	end
	_ENV = activity_9001704_Ctrl:getReceiveStatusAndNum_sign()
	_ENV, _ENV, activity_9001704_Ctrl:getReceiveStatusAndNum_sign().defaultClick = nil, activity_9001704_Ctrl, defaultClick
	_ENV, activity_9001704_Ctrl[1], (nil).title = nil, nil, i18n("sky_island_text03")
	activity_9001704_Ctrl:getReceiveStatusAndNum_sign().tabsetArray, activity_9001704_Ctrl[2], (nil).title = activity_9001704_Ctrl, nil, i18n("common_text_2477")
	local activity_9001704_Ctrl:getReceiveStatusAndNum_sign().callback, param = handler(self, self.onClickTab), activity_9001704_Ctrl:getReceiveStatusAndNum_sign()
	self.fields.Com_title:initTab(param)
	self:updateBtnRedDot()
	local dailyRemindManager = include("dailyRemindManager")
	local rType = dailyRemindManager.REMIND_TYPE.activity_9001704
	if dailyRemindManager.checkNeedRemindOnce(rType, self.activityID) then
		dailyRemindManager.addRemindOnceToManager(rType, self.activityID)
		SoraDConfigSet("Game:activity9001704:autoCruise~bool", false)
		self.tick:setSelected(false)
	else
		local autoCruise = SoraDConfigGet("Game:activity9001704:autoCruise~bool") or false
		self.tick:setSelected(autoCruise)
	end
end
function Activity_9001704_MainPanel:onClickTab(tag)
	print("==Activity_9001704_MainPanel:onClickTab==", tag)
	self.curTag = tag
	self.controllers.viewType:setSelectedIndex(tag - 1)
	if self.curTag == 1 then
		self.isAutoCruise = false
		self.fields.Com_have:updateNum()
		self:updateCostNum()
		self.fields.Com_map:updateSteps()
		self.fields.Com_map:setTouchEnabled(true)
		self.fields.Button_go:setTouchEnabled(true)
		self.fields.ani_dice:setVisible(false)
		self.fields.icon_dice:setVisible(false)
		self.fields.icon_dice:stopAllActions()
		self:updateBtnCruise()
	end
end
function Activity_9001704_MainPanel:onClickCheckTick()
	SoraDPlaySound()
	if self.isAutoCruise then
		self.isAutoCruise = self.tick:isSelected()
		self:updateBtnCruise()
	end
	SoraDConfigSet("Game:activity9001704:autoCruise~bool", self.tick:isSelected())
end
function Activity_9001704_MainPanel:onClickBtnCancel()
	SoraDPlaySound()
	self.isAutoCruise = false
	self:updateBtnCruise()
end
function Activity_9001704_MainPanel:onClickBtnGo()
	SoraDPlaySound()
	if not self.fields.Button_go:checkItem(true) then
		return
	end
	self.isAutoCruise = self.tick:isSelected()
	self:updateBtnCruise()
	self:reqCruise()
end
function Activity_9001704_MainPanel:updateBtnCruise()
	if self.isAutoCruise then
		self.fields.Button_cancel:setVisible(true)
		self.fields.Button_go:setVisible(false)
	else
		self.fields.Button_cancel:setVisible(false)
		self.fields.Button_go:setVisible(true)
	end
end
function Activity_9001704_MainPanel:reqCruise()
	SoraDShowLoading(self)
	activity_9001704_Ctrl:reqCruise()
end
function Activity_9001704_MainPanel:updateCostNum()
	self.fields.Button_go:setCost(self.itemID, self.itemNum)
end
function Activity_9001704_MainPanel:updateBtnRedDot()
	local isRed = activity_9001704_Ctrl:getReceiveStatusAndNum_map()
	self.fields.Com_title:setBtnRedDot(1, isRed)
	local isRed = activity_9001704_Ctrl:getReceiveStatusAndNum_sign()
	self.fields.Com_title:setBtnRedDot(2, isRed)
end
function Activity_9001704_MainPanel:onMsgUpdateView(target, event)
	local subMsg = event.subMsg
	if subMsg == "cruise" then
		SoraDCloseLoading(self)
		self.fields.Com_have:updateNum()
		self:updateCostNum()
		self:updateBtnRedDot()
		local rspdata = event.rspdata
		local rewards = rspdata.rewards
		local forwardSteps = rspdata.forwardSteps or 0
		self:startThrowDiceAnimation(rewards, forwardSteps)
	elseif subMsg == "reward" then
		self.fields.Com_sign:updateReceive()
		self:updateBtnRedDot()
	elseif subMsg == "daysReward" then
		self.fields.Com_sign:updateDaysReward()
		self:updateBtnRedDot()
	elseif subMsg == "buyGift" then
		self.fields.Com_map:updateBuyGift()
		self.fields.Com_sign:updateBuyGift()
	elseif subMsg == "payReward" then
		self.fields.Com_map:updatePayReward()
	end
end
function Activity_9001704_MainPanel:startThrowDiceAnimation(rewards, diceCount)
	self.fields.ani_dice:setFrames("dh_4znsz_%.5d.png", false, 0)
	self.fields.Com_map:setTouchEnabled(false)
	self.fields.Button_go:setTouchEnabled(false)
	_UPVALUE3_ = false
	;(false)[1] = ffa.delay(0.7333333333333333)
	;(false)[2] = ffa.callFunc(function()
		self.fields.ani_dice:setVisible(false)
		self.fields.icon_dice:setURL("dh_dice_new_" .. diceCount .. ".png")
		self.fields.icon_dice:setVisible(true)
		self.fields.Com_map:updateSteps(true, function()
			self.fields.Com_map:setTouchEnabled(true)
			self.fields.Button_go:setTouchEnabled(true)
			SoraDMailGainItems(rewards, true)
			self:checkAutoCruise()
		end)
	end)
	;(false)[3] = ffa.delay(0.5)
	;(false)[4] = ffa.callFunc(function()
		self.fields.icon_dice:setVisible(false)
	end)
	;(false)[5] = ffa.callFunc(function()
		self.fields.icon_dice:setVisible(false)
	end)
	self.fields.icon_dice:runAction(ffa.seq(false))
end
function Activity_9001704_MainPanel:checkAutoCruise()
	if not self.isAutoCruise then
		return
	end
	if not self.fields.Button_go:checkItem() then
		self.isAutoCruise = false
		self:updateBtnCruise()
		return
	end
	self:reqCruise()
end
return Activity_9001704_MainPanel
