local baseComponent = require("fgui.base.baseComponent")
local Com_fight = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_fight", Com_fight)
function Com_fight:onInit()
	self.transitions.t0:setHook("reset", function()
		self.fields.Particle_1:setVisible(true)
		self.fields.Particle_1:resetSystem()
		self.fields.Particle_2:setVisible(true)
		self.fields.Particle_2:resetSystem()
	end)
end
function Com_fight:onShow()
end
return Com_fight
