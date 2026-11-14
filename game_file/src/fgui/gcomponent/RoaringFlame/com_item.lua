local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local com_item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/com_item", com_item)
function com_item:onInit()
	self.fields.Com_item:setClickCallback(handler(self, self.btnClick))
end
function com_item:onShow()
end
function com_item:initData(data, status)
	self.status = status
	self.fields.Com_item:initData(data.id, data.count)
	if status == 1 then
		self.fields.Com_item:setEffect(1)
	else
		self.fields.Com_item:hideEffect()
	end
	self.controllers.c1:setSelectedIndex(status)
end
function com_item:btnClick()
	local weekGift = roaringFlameWarCtrl:getWeeklyGift()
	if self.status == 1 and not weekGift.isBuy then
		SoraDPlaySound()
		roaringFlameWarCtrl = nil
		;(nil).name = i18n("flames_dunes_text51")
		SoraDShowMsgTip(i18n("star_treasury_6", nil))
	end
end
return com_item
