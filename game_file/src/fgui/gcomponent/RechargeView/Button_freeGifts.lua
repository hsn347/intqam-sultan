local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local dailyDiscountGiftCtrl = SoraDGetCtrl("dailyDiscountGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_freeGifts = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RechargeView/Button_freeGifts", Button_freeGifts)
function Button_freeGifts:onInit()
	self.status = 0
	self:addClickListener(handler(self, self.btnClick))
end
function Button_freeGifts:onShow()
end
function Button_freeGifts:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH", handler(self, self.updateData))
end
function Button_freeGifts:updateData(bShow, noJumpCondition)
	self.status = 0
	if bShow and noJumpCondition == true then
		self.status = 0
	else
		self.status = 1
	end
	self.controllers.c1:setSelectedIndex(self.status)
	self.fields.title:setString(self.status == 0 and i18n("common_text_4374") or i18n("common_text_4375"))
end
function Button_freeGifts:setHandle(handle)
	self.handle = handle
end
function Button_freeGifts:btnClick()
	SoraDPlaySound()
	if self.handle then
		self.handle()
	end
end
return Button_freeGifts
