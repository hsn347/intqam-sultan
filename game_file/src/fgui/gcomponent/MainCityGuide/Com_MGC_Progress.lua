local baseComponent = require("fgui.base.baseComponent")
local Com_MGC_Progress = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://MainCityGuide/Com_MGC_Progress", Com_MGC_Progress)
function Com_MGC_Progress:onInit()
	self.fields.n7:setTexture("SinglePicture/frame_cqjs_jdt_zz.png")
end
function Com_MGC_Progress:onShow()
end
function Com_MGC_Progress:initData(value, max)
	self:setMax(max)
	self:tweenValue(value, 0.5)
end
return Com_MGC_Progress
