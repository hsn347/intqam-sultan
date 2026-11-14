local baseComponent = require("fgui.base.baseComponent")
local Com_achiItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleChange/Com_achiItem", Com_achiItem)
function Com_achiItem:onInit()
	self.fields.mv_d:setAllFrameName("dh_zhuangban6_%.2d.png", 0)
	self.fields.mv_l:setAllFrameName("dh_zhuangban4_%.2d.png", 0)
	self.fields.mv_r:setAllFrameName("dh_zhuangban4_%.2d.png", 0)
	self.fields.Com_item:setClickCallback(handler(self, self.btnClick))
end
function Com_achiItem:onShow()
end
function Com_achiItem:initData(cfg, numCanGet)
	self.controllers.c1:setSelectedIndex(numCanGet and 1 or 0)
	self.fields.Com_item:initData(cfg[1], cfg[2])
	if numCanGet then
		self.fields.Com_item:setEffect(2)
	else
		self.fields.Com_item:hideEffect()
	end
end
function Com_achiItem:btnClick()
	SoraDPlaySound()
	uiManager:show("CastleChangeTaskView")
end
return Com_achiItem
