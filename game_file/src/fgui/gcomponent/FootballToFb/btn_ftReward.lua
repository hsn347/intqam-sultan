local baseComponent = require("fgui.base.baseComponent")
local btn_ftReward = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://FootballToFb/btn_ftReward", btn_ftReward)
function btn_ftReward:onInit()
	self.fields.Usm_1:setVisible(false)
end
function btn_ftReward:onShow()
end
function btn_ftReward:initData(isGot, id, num, isShowGot)
	if isGot and isShowGot then
		self.fields.Usm_1:play()
	end
	self.controllers.c1:setSelectedIndex(isGot and 1 or 0)
	self.fields.item:initData(id, num)
end
return btn_ftReward
