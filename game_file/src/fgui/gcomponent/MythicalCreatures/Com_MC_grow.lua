local baseComponent = require("fgui.base.baseComponent")
local Com_MC_grow = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_grow", Com_MC_grow)
function Com_MC_grow:onInit()
	self.isMax = false
end
function Com_MC_grow:onShow()
end
function Com_MC_grow:initData(lv, maxlv, isSelected)
	self.isMax = lv == maxlv
	self.controllers.c1:setSelectedIndex(isSelected and 1 or 2)
	self.fields.lv:setString("" .. lv .. "/" .. maxlv)
end
function Com_MC_grow:setStepLvMax()
	self.controllers.c1:setSelectedIndex(3)
end
function Com_MC_grow:getIsMax()
	return self.isMax
end
function Com_MC_grow:showGrowEffect()
	self.fields.effect_brin:setVisible(true)
	self.fields.effect_brin:setAllFrameNameOnce("dh_tianpinzwjdt_%02d.png", 0, false)
end
return Com_MC_grow
