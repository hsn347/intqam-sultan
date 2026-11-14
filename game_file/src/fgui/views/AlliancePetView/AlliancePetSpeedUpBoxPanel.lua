local gametop = gModuleMgr.getObject("gametop")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local CommonSpeedUpBoxPanel = include_fgui("CommonSpeedUpBoxPanel")
local AlliancePetSpeedUpBoxPanel = class("AlliancePetSpeedUpBoxPanel", CommonSpeedUpBoxPanel)
function AlliancePetSpeedUpBoxPanel:ctor(...)
	AlliancePetSpeedUpBoxPanel.super.ctor(self, ...)
	print("AlliancePetSpeedUpBoxPanel:ctor", self.viewName)
end
function AlliancePetSpeedUpBoxPanel:openTimeUp(dt)
	local leftTime = alliancePetCtrl:getDonateTimeCD()
	alliancePetCtrl = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.fields.Text_Time:setString(i18n("common_text_766", nil))
	local goldPay = serviceFunctions.timeConvertToGold(leftTime, false, true) or 0
	self.fields.Button_Speed:setCost(gIDDef.GOLD, math.floor(goldPay))
	if leftTime <= 0 or self.tableQueueData == nil then
		self:buildTimerEnd()
	end
end
function AlliancePetSpeedUpBoxPanel:btnClickCallBack()
	SoraDPlaySound()
	local leftTime = alliancePetCtrl:getDonateTimeCD()
	if SoraDEnoughGold(serviceFunctions.timeConvertToGold(leftTime, false, true)) then
		alliancePetCtrl:sendReqCleanWorshipCD()
		self:exitView(MSGBOX_CALLBACK_SPEEDUP)
		self:close()
	end
end
return AlliancePetSpeedUpBoxPanel
