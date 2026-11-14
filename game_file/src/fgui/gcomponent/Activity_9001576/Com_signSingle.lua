local activity_9001576_Ctrl = SoraDGetCtrl("activity_9001576_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_signSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001576/Com_signSingle", Com_signSingle)
function Com_signSingle:onInit()
	self.fields.Text_bq:setString(i18n("common_text_2875"))
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_signSingle:onShow()
end
function Com_signSingle:initData(data)
	self.data = data
	_ENV = nil
	;(nil).count = self.data.day
	self.fields.Text_day:setString(i18n("common_text_523", nil))
	self.status = activity_9001576_Ctrl:getSignStatusByDay(self.data.day)
	self.controllers.c1:setSelectedIndex(self.status)
end
function Com_signSingle:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).cfg = self.data
	uiManager:show("Activity_9001576_signPop", nil)
end
return Com_signSingle
