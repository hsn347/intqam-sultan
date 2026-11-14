local baseComponent = require("fgui.base.baseComponent")
local Com_vip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://vipCenterView/Com_vip", Com_vip)
function Com_vip:onInit()
	self.fields.Button_vipGift:addClickListener(handler(self, self.btnVipClick))
end
function Com_vip:onShow()
end
function Com_vip:initData()
	local vipLevel, isActive = SoraDGetVipLv()
	if vipLevel > VIP_SVIP_LV then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Lab_lv:initData(vipLevel - VIP_SVIP_LV, true)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Lab_lv:initData(vipLevel)
	end
	self.controllers.c2:setSelectedIndex(isActive and 1 or 0)
	self.fields.Button_vipGift:setString(not isActive and i18n("Newbie_task_content_13") or i18n("vip_text_01"))
end
function Com_vip:getBtnVipGift()
	return self.fields.Button_vipGift
end
function Com_vip:btnVipClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemType = gItemType.VIP_TIME
	uiManager:show("vipBuyView", nil)
end
return Com_vip
