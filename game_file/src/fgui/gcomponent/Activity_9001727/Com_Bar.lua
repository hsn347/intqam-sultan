local activity_9001727_Ctrl = SoraDGetCtrl("activity_9001727_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Bar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001727/Com_Bar", Com_Bar)
function Com_Bar:onInit()
	self.fields.Bar:hideTitle()
	self:fixChildrenPos()
end
function Com_Bar:onShow()
end
function Com_Bar:initData()
	local lv, showExp, needExp = activity_9001727_Ctrl:getLv()
	activity_9001727_Ctrl = nil
	;(nil).lv = lv
	self.fields.Text_lv:setString(i18n("common_text_101", nil))
	activity_9001727_Ctrl = i18n("common_text_101", nil)
	i18n("common_text_101", nil).member = showExp
	i18n("common_text_101", nil).total = needExp
	self.fields.Text_exp:setString(i18n("common_text_155", i18n("common_text_101", nil)))
	self.fields.Bar:setMax(needExp)
	self.fields.Bar:setValue(math.min(showExp, needExp))
end
return Com_Bar
