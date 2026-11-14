local baseComponent = require("fgui.base.baseComponent")
local Button_gold_top = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_gold_top", Button_gold_top)
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
function Button_gold_top:onInit()
	self.oriDataGold = 0
	self.openOff = true
	self:updateGold()
	self:addClickEventListener(handler(self, self.btnGoldClick))
end
function Button_gold_top:onShow()
end
function Button_gold_top:onHide()
end
function Button_gold_top:updateGold()
	if self.rid and self.rid ~= gIDDef.GOLD then
		return
	end
	self.dataGold = lordInfoCtrl:getBaseInfo().gold
	self:refreshGoldTxt()
end
function Button_gold_top:refreshGoldTxt()
	if self.oriDataGold == 0 then
		self.fields.title:setString(string.formatnumberthousands(self.dataGold))
	elseif self.oriDataGold and self.dataGold then
		SoraDCreateScoreLabel(self.fields.title, true):runScoreAnimation(self.oriDataGold, self.dataGold, 1)
	end
	self.oriDataGold = self.dataGold
end
function Button_gold_top:getGold()
	self:updateGold()
	return self.dataGold
end
function Button_gold_top:btnGoldClick(button, type)
	SoraDPlaySound("uicontrol", 25)
	if self.handleGoldClick then
		self.handleGoldClick()
		return
	end
	_ENV = "uicontrol"
	;("uicontrol").msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage("uicontrol")
	if self.openOff then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
		paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD07)
	end
end
function Button_gold_top:initData(rid, handleGoldClick)
	self.handleGoldClick = handleGoldClick
	self.rid = rid
end
function Button_gold_top:updateOther()
	if not self.rid then
		return
	end
	local count = SoraDGetCtrl("backpackCtrl"):getItemCount(self.rid)
	self:setIcon(include("publicRead").getIcon(self.rid))
	self.fields.title:setString(string.formatnumberthousands(count))
end
return Button_gold_top
