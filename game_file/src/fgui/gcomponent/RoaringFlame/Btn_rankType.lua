local baseComponent = require("fgui.base.baseComponent")
local Btn_rankType = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoaringFlame/Btn_rankType", Btn_rankType)
function Btn_rankType:onInit()
	self.fields.mv_xz:setAllFrameName("G_9001674_xuanzhong_%.2d.png", 1)
	self:addClickListener(handler(self, self.btnExTypeClick))
end
function Btn_rankType:onShow()
end
function Btn_rankType:initData(cfg, index, extype, handlerEx)
	self.cfg = cfg
	self.index = index
	self.handlerEx = handlerEx
	self:setIcon(cfg.png)
	self:setTitle(cfg.title)
	self:setSelected(extype == index)
end
function Btn_rankType:btnExTypeClick()
	SoraDPlaySound()
	if self.handlerEx then
		self.handlerEx(self.index)
	end
end
return Btn_rankType
