local baseComponent = require("fgui.base.baseComponent")
local Button_rank = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NebulaCompetition/Button_rank", Button_rank)
function Button_rank:onInit()
	self.fields.MovieClip_rank:setAllFrameName("dh_xingyunbzph_%02d.png", 1)
end
function Button_rank:onShow()
end
return Button_rank
