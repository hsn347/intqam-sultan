local baseComponent = require("fgui.base.baseComponent")
local Com_FP_DressNow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_DressNow", Com_FP_DressNow)
function Com_FP_DressNow:onInit()
	self.fields.text:setString(i18n("exitic_pavillion_text_0126"))
end
function Com_FP_DressNow:onShow()
end
return Com_FP_DressNow
