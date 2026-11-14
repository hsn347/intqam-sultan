local baseComponent = require("fgui.base.baseComponent")
local Com_box = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RechargeView/Com_box", Com_box)
function Com_box:onInit()
	self.fields.et_box:setAllFrameName("dh_jinbidiaoxl_%.2d.png", 1)
	self.fields.title:setString(i18n("enjoyable_store_04"))
	self:addClickListener(handler(self, self.btnClick))
end
function Com_box:onShow()
end
function Com_box:initData(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
function Com_box:btnClick()
	SoraDPlaySound()
	uiManager:show("rechargeVipSpecialView")
end
return Com_box
