local baseComponent = require("fgui.base.baseComponent")
local Bar_blood = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://RoadRoughGame/Bar_blood", Bar_blood)
function Bar_blood:onInit()
end
function Bar_blood:onShow()
end
function Bar_blood:setBarColor(type)
	self.fields.bar:setURL(type == 1 and "frame_shmc_bargreen.png" or "frame_shmc_barred.png")
end
function Bar_blood:addBloodShow()
	self.fields.shine:setVisible(true)
	self.fields.shine:setAllFrameName("dh_ljbp_sz_%02d.png", 1)
	self.fields.shine:setPlaySettings(0, -1, 1)
	self.transitions.show:play(function()
		self.fields.shine:setVisible(false)
	end)
end
return Bar_blood
