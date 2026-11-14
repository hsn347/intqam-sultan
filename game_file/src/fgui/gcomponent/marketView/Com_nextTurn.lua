local baseComponent = require("fgui.base.baseComponent")
local Com_nextTurn = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://marketView/Com_nextTurn", Com_nextTurn)
function Com_nextTurn:onInit()
	_ENV = nil
	;(nil).time = ""
	self.fields.Text_time1:setString(i18n("auction_text_03", nil))
	self.fields.Text_time2:setString(i18n("auction_text_29"))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
end
function Com_nextTurn:onShow()
end
function Com_nextTurn:initData(leftTime)
	self.fields.Text_time:beginTime(leftTime)
end
return Com_nextTurn
