local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Lab_list = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://DecompositionOfAKey/Lab_list", Lab_list)
function Lab_list:onInit()
end
function Lab_list:onShow()
end
function Lab_list:initData(quality, findList)
	self.quality = quality
	_ENV = nil
	;(nil).name = equipDesRead.getQualityName(quality)
	;(nil).num = findList[self.quality] or 0
	self.fields.title:setString(i18n("disassemble_fast_9", nil))
	self.fields.title:setColor(gQualityTextColorDef[quality])
end
return Lab_list
