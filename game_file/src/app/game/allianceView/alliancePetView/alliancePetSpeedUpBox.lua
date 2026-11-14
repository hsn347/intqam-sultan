local gametop = gModuleMgr.getObject("gametop")
local commonSpeedUpBox = include("commonSpeedUpBox")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local alliancePetSpeedUpBox = class("alliancePetSpeedUpBox", commonSpeedUpBox)
function alliancePetSpeedUpBox:ctor()
	alliancePetSpeedUpBox.super.ctor(self)
end
function alliancePetSpeedUpBox:initData(queueData)
	alliancePetSpeedUpBox.super.initData(self, queueData)
end
function alliancePetSpeedUpBox:openTimeUp(dt)
	local leftTime = alliancePetCtrl:getDonateTimeCD()
	alliancePetCtrl = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.labelTime:setString(i18n("common_text_766", nil))
	local goldPay = serviceFunctions.timeConvertToGold(leftTime, false, true) or 0
	self.btnSpeedUp:setGoldText(string.formatnumberthousands(math.floor(goldPay)))
	if leftTime <= 0 or self.tableQueueData == nil then
		self:buildTimerEnd()
	end
end
function alliancePetSpeedUpBox:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local leftTime = alliancePetCtrl:getDonateTimeCD()
		if SoraDEnoughGold(serviceFunctions.timeConvertToGold(leftTime, false, true)) then
			button:setTouchEnabled(false)
			alliancePetCtrl:sendReqCleanWorshipCD()
			self:exitView(MSGBOX_CALLBACK_SPEEDUP)
			self:close(button, type)
		end
	end
end
return alliancePetSpeedUpBox
