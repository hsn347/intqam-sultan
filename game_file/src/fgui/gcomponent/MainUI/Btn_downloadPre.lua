local baseComponent = require("fgui.base.baseComponent")
local Btn_downloadPre = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_downloadPre", Btn_downloadPre)
function Btn_downloadPre:onInit()
	self.fields.csd:setEffectPath("preDownloadMainWidget")
end
function Btn_downloadPre:onShow()
	self.fields.csd:getEffect():initData()
end
return Btn_downloadPre
