local baseComponent = require("fgui.base.baseComponent")
local Harm_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001642/Harm_list", Harm_list)
function Harm_list:onInit()
	self.fields.Text_best:setString(i18n("Phonex_Challenge_text_17"))
	self:fixChildrenPos()
end
function Harm_list:onShow()
end
function Harm_list:initData(data)
	self.controllers.c1:setSelectedIndex(data.isBest and 1 or 0)
	self.fields.Text_date:setString(data.date)
	_ENV = nil
	;(nil).num = data.score
	self.fields.Text_harm:setString(i18n("Phonex_Challenge_text_32", nil))
end
return Harm_list
