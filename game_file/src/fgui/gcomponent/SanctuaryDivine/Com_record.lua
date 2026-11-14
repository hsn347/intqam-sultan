local baseComponent = require("fgui.base.baseComponent")
local Com_record = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SanctuaryDivine/Com_record", Com_record)
function Com_record:onInit()
	self.fields.text_recordStr:setString(i18n("almirajChange_text03"))
	self:fixChildrenPos()
end
function Com_record:onShow()
end
function Com_record:initData(score)
	self.fields.text_record:setString(score)
end
return Com_record
