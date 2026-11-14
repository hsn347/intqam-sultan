local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftBag = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AnniversaryCountdown2022/Com_giftBag", Com_giftBag)
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function Com_giftBag:onInit()
	self.fields.Button_bag:fixPos()
	self.bagItemID = 857901
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_2022_ACTIVITY
	self.fields.Label_time:setTimeEndListener(function()
		self:initData()
	end)
	self.fields.txt_time = txt_time
	self.Text_bagNum = self.fields.Button_bag:getChild("n2")
	self.fields.Button_bag:addClickListener(handler(self, self.onBtnBagClick))
	self.fields.Button_go:setText(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onBtnGoClick))
end
function Com_giftBag:initData()
	local eventState = activityShowCtrl:getStateByID(self.activityID)
	if eventState == gActivityState.PREPARE then
		self.fields.Label_time:initActivityTimeStyle(self.activityID, "common_text_1043", "#FFFFFF")
		return
	end
	local nextBagsTime = activityShowCtrl:getGiftBagsInfo(self.activityID)
	if nextBagsTime then
		self.fields.Text_des:setString(i18n("goldenyears_text_15"))
	else
		self.fields.Text_des:setString(i18n("goldenyears_text_14"))
	end
	if nextBagsTime and nextBagsTime - serviceFunctions.systemTime() > 0 then
		self.fields.Label_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("gift_send_text_03", nil)
		end)
		self.fields.Label_time:beginTime(nextBagsTime - serviceFunctions.systemTime())
	else
		self.fields.Label_time:initActivityTimeStyle(self.activityID, "gift_send_text_04", "#FFFFFF")
		self.fields.Button_go:setText(i18n("Anchor_text_21"))
		self.fields.Button_go:setEnabled(false)
		self.fields.Label_time:setVisible(false)
		self.fields.sheer:setVisible(false)
	end
	self:refreshGiftNum()
end
function Com_giftBag:refreshGiftNum(...)
	local giftNum = backpackCtrl:getItemCount(self.bagItemID)
	self.Text_bagNum:setString(i18n("radomGift_text_02") .. ":" .. giftNum)
end
function Com_giftBag:onBtnBagClick()
	SoraDPlaySound()
	local giftNum = backpackCtrl:getItemCount(self.bagItemID)
	if 0 < giftNum then
		_ENV = nil
		;(nil).name = publicRead:getName(857901)
		SoraDShowMsgBox(i18n("goldenyears_text_16", nil), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				_ENV = nil
				;(nil).itemID = self.bagItemID
				uiManager:show("SendRedPacketView", nil)
			end
		end)
	else
		SoraDShowMsgBox(i18n("Icesnow_carnival_text_19"), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				_UPVALUE12_ = MSGBOX_CALLBACK_YES
				MSGBOX_CALLBACK_YES[1] = 14484
				MSGBOX_CALLBACK_YES[2] = 14485
				MSGBOX_CALLBACK_YES[3] = 14494
				MSGBOX_CALLBACK_YES[4] = 14495
				MSGBOX_CALLBACK_YES[5] = 14496
				MSGBOX_CALLBACK_YES[6] = 14497
				MSGBOX_CALLBACK_YES[7] = 14498
				MSGBOX_CALLBACK_YES[8] = 14499
				MSGBOX_CALLBACK_YES[9] = 14500
				MSGBOX_CALLBACK_YES[10] = 14501
				MSGBOX_CALLBACK_YES[11] = 14502
				local MSGBOX_CALLBACK_YES[12], giftArray = 14503, MSGBOX_CALLBACK_YES
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = 14495
					;(14495).rechargeIDList = giftArray
					uiManager:show("rechargeView", 14495)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:jumpToLimitNodeByList(12, giftArray)
					panel:show()
				end
			end
		end)
	end
end
function Com_giftBag:onBtnGoClick(button, event)
	SoraDPlaySound()
	local panel = SoraDSearchPanelFromManagerByName("chatView")
	if panel then
		panel:removeFromParent()
	end
	panel = SoraDCreatePanel("chatView")
	panel:show()
	_ENV = nil
	;(nil).chatChannel = gChatChannel.KINGDOM
	panel:init(nil)
end
function Com_giftBag:onItemChange(target, data)
	self:refreshGiftNum()
end
function Com_giftBag:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemChange))
end
function Com_giftBag:onShow()
	self.fields.Usm_1:setVisible(true)
	self.soundId = SoraDPlaySound("sixYear", "sfx_years")
end
function Com_giftBag:onHide()
	if self.soundId then
		AudioEngine.stopEffect(self.soundId)
	end
	self.fields.Usm_1:setVisible(false)
end
return Com_giftBag
