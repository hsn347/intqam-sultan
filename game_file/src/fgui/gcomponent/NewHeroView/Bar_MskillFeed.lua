local baseComponent = require("fgui.base.baseComponent")
local Bar_MskillFeed = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://NewHeroView/Bar_MskillFeed", Bar_MskillFeed)
function Bar_MskillFeed:onInit()
	self.fields.lg:setAllFrameName("dh_jindutiao_%.2d.png", 0)
	self.fields.lg:setVisible(false)
	self.transitions.t0:stop()
end
function Bar_MskillFeed:onShow()
end
function Bar_MskillFeed:playAct()
	self.fields.lg:setVisible(true)
	self.fields.lg:setPlaySettings(0, -1, 1, -1, function()
		self.fields.lg:setVisible(false)
	end)
	self.transitions.t0:play()
end
return Bar_MskillFeed
