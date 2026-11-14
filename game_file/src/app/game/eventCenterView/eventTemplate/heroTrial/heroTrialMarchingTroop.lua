local gametop = gModuleMgr.getObject("gametop")
local heroTrialCtrl = gametop.playertop_:getModule("heroTrialCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local HeroTrialMarchingTroop = class("heroTrialMarchingTroop", function(target)
	if target == nil then
		return SoraDCreateBasePanel("marchingTroopsSingle")
	end
	return target
end)
function HeroTrialMarchingTroop:ctor()
	SoraDGetAllChildFromWidget(self, self)
	self.Button_setting:setVisible(false)
	local btnIcon = SoraDFIsRA() and "img_xingjunduilie_jiasu.png" or "img_xingjunduilie_jiasu_en.png"
	self.Sprite_troops:setSpriteFrame(btnIcon)
	self.Text_state:setString(i18n("common_text_1726"))
	self.Button_troops:addTouchEventListener(handler(self, self.OnBtnTroops))
	self.Button_jump:addTouchEventListener(handler(self, self.onJump))
	self:setVisible(false)
end
function HeroTrialMarchingTroop:updateTime()
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.trial_march)
	if not self.queue then
		return
	end
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	local totalTime = self.queue.totaltime
	local percent = 100 * (totalTime - leftTime) / totalTime
	local panelSize = self.Panel_troops:getContentSize()
	local effectW = self.Panel_effect:getContentSize().width
	local troopW = effectW + 12
	local panelW = troopW * percent / 100
	self.Panel_troops:setContentSize(cc.size(panelW, panelSize.height))
	self.Image_troops:setPositionX(panelW)
	self.Node_Effect:setPositionX(effectW - panelW)
	self.Text_time:setString(SoraDConvertSecondToString(leftTime))
	if leftTime <= 0 then
		self:setVisible(false)
	end
end
function HeroTrialMarchingTroop:OnBtnTroops(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		_ENV, (nil).itemType = gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP
		;(nil).troopData, gItemType.MARCH_SPEED_UP.speedUpType = gItemType.MARCH_SPEED_UP, true
		uiManager:show("speedUpReCallBuyView", nil)
	end
end
function HeroTrialMarchingTroop:onJump(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_HEROTRIAL_MOVETO_MARCH"
		SoraDSendMessage(nil)
	end
end
return HeroTrialMarchingTroop
