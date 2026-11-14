local queueCtrl = SoraDGetCtrl("queueCtrl")
local heroTrialCtrl = SoraDGetCtrl("heroTrialCtrl")
local baseComponent = require("fgui.base.baseComponent")
local marchTroop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/marchTroop", marchTroop)
function marchTroop:onInit()
	self.fields.Text_state:setString(i18n("common_text_1726"))
	self.fields.Button_troops:setIcon(SoraDFIsRA() and "img_xingjunduilie_jiasu.png" or "img_xingjunduilie_jiasu_en.png")
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeUpdateListener(handler(self, self.updateTroopBar))
	self.Text_time:setTimeEndListener(handler(self, self.updateTimeEnd))
	self.fields.Button_troops:addClickListener(handler(self, self.OnBtnTroops))
	self.fields.Button_jump:addClickListener(handler(self, self.onJump))
	self:fixChildrenPos()
	self.fields.n0:fix()
	self.fields.Bar_et:setScaleX(SoraDFIsRA() and 1 or -1)
end
function marchTroop:onShow()
end
function marchTroop:updateTroopBar(times)
	local percent = (self.totalTime - times) / self.totalTime
	self.fields.Bar_et:setPercent(percent)
end
function marchTroop:updateTimeEnd()
	self:setVisible(false)
end
function marchTroop:initData()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.trial_march)
	if queue then
		local leftTime = queue.timerNode.timer:getRemainTime()
		self.totalTime = queue.totaltime
		if 0 < leftTime then
			self:setVisible(true)
			self.Text_time:beginTime(leftTime)
		else
			self:setVisible(false)
		end
	else
		self:setVisible(false)
	end
end
function marchTroop:OnBtnTroops()
	SoraDPlaySound()
	_ENV = nil
	_ENV, (nil).itemType = gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP
	;(nil).troopData, gItemType.MARCH_SPEED_UP.speedUpType = gItemType.MARCH_SPEED_UP, true
	uiManager:show("speedUpReCallBuyView", nil)
end
function marchTroop:onJump()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_HEROTRIAL_MOVETO_MARCH"
	SoraDSendMessage(nil)
end
return marchTroop
