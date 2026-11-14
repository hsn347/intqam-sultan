local baseComponent = require("fgui.base.baseComponent")
local Com_optionsTick = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceCreateView/Com_optionsTick", Com_optionsTick)
function Com_optionsTick:onInit()
	self.fields.Check_tick:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_optionsTick:onShow()
end
function Com_optionsTick:initData(data, index)
	self.index = index
	self.data = data
	self.fields.title:setString(self.data.title)
	self.fields.Check_tick:setSelected(self.data.isSel)
end
function Com_optionsTick:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_UI_JOIN_OPTIONS_SELECT"
	;(nil).index = self.index
	;(nil).val = self.data.val
	;(nil).isSel = self.fields.Check_tick:isSelected()
	SoraDSendMessage(nil)
end
return Com_optionsTick
