local baseComponent = require("fgui.base.baseComponent")
local Lab_attr = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/Lab_attr", Lab_attr)
function Lab_attr:onInit()
end
function Lab_attr:onShow()
end
function Lab_attr:initData(cfg)
	self.fields.Lab_title:setVisible(cfg.isTitle or false)
	if cfg.isTitle then
		self.fields.bg:setVisible(false)
		self.fields.title:setVisible(false)
		self.fields.Lab_title:setString(cfg.des)
	else
		self.fields.bg:setVisible(cfg.index % 2 == 0)
		self.fields.title:setVisible(true)
		self.fields.title:setString(cfg.des)
	end
end
return Lab_attr
