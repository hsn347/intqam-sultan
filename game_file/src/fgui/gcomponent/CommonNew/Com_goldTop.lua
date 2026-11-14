local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_goldTop = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Com_goldTop", Com_goldTop)
function Com_goldTop:onInit()
	self.dataGold = 0
	self.oriDataGold = 0
	self.scoreTextGold = SoraDCreateScoreLabel(self.fields.Text_gold, true)
	self:updateGold()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_goldTop:onShow()
end
function Com_goldTop:registerEvent()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateGold))
end
function Com_goldTop:updateGold()
	self.dataGold = lordInfoCtrl:getBaseInfo().gold
	self:refreshGoldTxt()
end
function Com_goldTop:refreshGoldTxt()
	if self.oriDataGold == 0 then
		self.fields.Text_gold:setString(string.formatnumberthousands(self.dataGold))
		self.oriDataGold = self.dataGold
	elseif self.oriDataGold and self.dataGold then
		self.scoreTextGold:runScoreAnimation(self.oriDataGold, self.dataGold, 1)
		self.oriDataGold = 0
	end
end
function Com_goldTop:onBtnClick()
	SoraDPlaySound("uicontrol", 25)
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_coin_btn)
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
	paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD07)
end
return Com_goldTop
