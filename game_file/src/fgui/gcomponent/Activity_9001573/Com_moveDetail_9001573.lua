local baseComponent = require("fgui.base.baseComponent")
local Com_moveDetail_9001573 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001573/Com_moveDetail_9001573", Com_moveDetail_9001573)
function Com_moveDetail_9001573:onInit()
	self:fixChildrenPos()
	self.fields.txt_point:addEventListener(fgui.UIEventType.Click, handler(self, self.onPointClick))
end
function Com_moveDetail_9001573:onShow()
end
function Com_moveDetail_9001573:initData(data)
	self.data = data
	_ENV = nil
	;(nil).x = data.x
	;(nil).y = data.y
	self.fields.txt_point:setString(i18n("common_text_2155", nil))
	self.fields.label_timer:beginTime(data.statusEndTime - serviceFunctions.systemTime())
	local count = 0
	for i, v in ipairs(data.army) do
		count = count + v.num
	end
	self.fields.txt_num:setString(string.formatnumberthousands(count))
end
function Com_moveDetail_9001573:onPointClick()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(cc.p(self.data.x, self.data.y))
	SoraDRemoveAllPanelFromManager()
end
return Com_moveDetail_9001573
