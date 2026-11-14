local activity_9001702_Read = include("activity_9001702_Read")
local activity_9001702_Ctrl = SoraDGetCtrl("activity_9001702_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001702_page2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001702/Com_9001702_page2", Com_9001702_page2)
function Com_9001702_page2:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001702_UPDATE", handler(self, self.onMsgUpdate))
end
function Com_9001702_page2:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001702
	self.drawItemID = activity_9001702_Read.getDrawItemID()
	self.draw2Count = 5
	self.fields.Button_reward:setString(i18n("soldier_rush_text_11"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.Button_record:setString(i18n("common_text_836"))
	self.fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
	self.fields.Button_gift:setString(i18n("Eidal_celebration_text_37"))
	self.fields.Button_gift:addClickListener(handler(self, self.onClickBtnGift))
	self.fields.Click_machine:addClickListener(handler(self, self.onClickMachine))
	self.fields.Button_draw:setString(i18n("Eidal_celebration_text_08"))
	self.fields.Button_draw:addClickListener(handler(self, self.onClickBtnDraw))
	_ENV = handler(self, self.onClickBtnDraw)
	handler(self, self.onClickBtnDraw).num = self.draw2Count
	self.fields.Button_draw2:setString(i18n("Eidal_celebration_text_09", handler(self, self.onClickBtnDraw)))
	self.fields.Button_draw2:addClickListener(handler(self, self.onClickBtnDraw2))
	if not SoraDFIsRA() then
		self.fields.Button_draw:fixPos()
		self.fields.Button_draw2:fixPos()
	end
end
function Com_9001702_page2:onShow()
	local configKey = "Game:activity9001702:skipAction~bool"
	local dailyRemindManager = include("dailyRemindManager")
	local rType = dailyRemindManager.REMIND_TYPE.activity_9001702_1
	if dailyRemindManager.checkNeedRemindOnce(rType, self.activityID) then
		dailyRemindManager.addRemindOnceToManager(rType, self.activityID)
		SoraDConfigSet(configKey, false)
		self.skipAction = false
	else
		self.skipAction = SoraDConfigGet(configKey) or false
	end
	self.fields.Com_skip:initData(self.skipAction, i18n("Canyon_Treasur_text_27"), function(isSelected)
		self.skipAction = isSelected
		SoraDConfigSet(configKey, self.skipAction)
	end)
end
function Com_9001702_page2:switchTab()
	self.fields.Com_have:initData(self.drawItemID, function()
		SoraDShowMsgTip(i18n("Eidal_celebration_text_31"))
	end)
	self:updateDrawItemCount()
	self:removeFinger()
	self:updateBtnGiftRed()
	if not activity_9001702_Ctrl:checkDoStage0() then
		uiManager:show("Activity_9001702_Reward")
	end
end
function Com_9001702_page2:onClickBtnReward()
	SoraDPlaySound()
	uiManager:show("Activity_9001702_Reward")
end
function Com_9001702_page2:onClickBtnRecord()
	SoraDPlaySound()
	uiManager:show("Activity_9001702_Record")
end
function Com_9001702_page2:onClickBtnGift()
	SoraDPlaySound()
	if activity_9001702_Ctrl:getCanReceiveItemCount() <= 0 then
		SoraDShowMsgTip(i18n("Eidal_celebration_text_26"))
	else
		uiManager:show("Activity_9001702_Gift")
	end
end
function Com_9001702_page2:onClickMachine()
	SoraDPlaySound()
	uiManager:show("Activity_9001702_Machine")
end
function Com_9001702_page2:onClickBtnDraw()
	SoraDPlaySound()
	self:removeFinger()
	if self.fields.Button_draw:checkItem(true) then
		activity_9001702_Ctrl:reqDraw(1)
		SoraDShowLoading()
	end
end
function Com_9001702_page2:onClickBtnDraw2()
	SoraDPlaySound()
	self:removeFinger()
	if self.fields.Button_draw2:checkItem(true) then
		activity_9001702_Ctrl:reqDraw(self.draw2Count)
		SoraDShowLoading()
	end
end
function Com_9001702_page2:updateDrawItemCount()
	self.fields.Com_have:updateNum()
	self.fields.Button_draw:setCost(self.drawItemID, 1)
	self.fields.Button_draw2:setCost(self.drawItemID, self.draw2Count)
end
function Com_9001702_page2:onMsgUpdate(target, event)
	local subMsg = event.subMsg
	if subMsg == "draw" then
		self:updateDrawItemCount()
		if not event.rspdata.result then
			local _ENV, result = event.rspdata.result, event.rspdata.result
		end
		if self.skipAction then
			_ENV = nil
			;(nil).result = result
			uiManager:show("Activity_9001702_Result", nil)
		else
			SoraDShowLoading(nil, nil, nil, true)
			self.fields.Com_bg2:setCompleteCallback(function()
				SoraDCloseLoading()
				_ENV = nil
				;(nil).result = result
				uiManager:show("Activity_9001702_Result", nil)
			end)
			self.fields.Com_bg2:playFlipAnimation(1, true)
		end
	elseif subMsg == "itemCount" then
		if event.itemID == self.drawItemID then
			self:updateDrawItemCount()
		end
	elseif subMsg == "showFinger" then
		self:showBtnDraw2Finger()
	elseif subMsg == "init" then
		self:updateBtnGiftRed()
	elseif subMsg == "receive" then
		self:updateBtnGiftRed()
	end
end
function Com_9001702_page2:showBtnDraw2Finger()
	if not self.finger then
		local finger = SoraDFingerAction()
		local target = self.fields.Button_draw2
		finger:addTo(target)
		finger:setPosition(target:getWidth() / 2, target:getHeight() / 2)
		self.finger = finger
	end
end
function Com_9001702_page2:removeFinger()
	if self.finger then
		self.finger:removeFromParent()
		self.finger = nil
	end
end
function Com_9001702_page2:updateBtnGiftRed()
	local count = activity_9001702_Ctrl:getCanReceiveItemCount()
	self.fields.Button_gift:setReddot(0 < count)
end
function Com_9001702_page2:updateDoStage()
	local isStage0 = activity_9001702_Ctrl:checkDoStage0()
	self.fields.Button_record:setEnabled(isStage0)
	self.fields.Button_gift:setEnabled(isStage0)
	self.fields.Click_machine:setEnabled(isStage0)
	self.fields.Button_draw:setEnabled(isStage0)
	self.fields.Button_draw2:setEnabled(isStage0)
end
return Com_9001702_page2
