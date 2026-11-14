local baseComponent = require("fgui.base.baseComponent")
local Com_select = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DecompositionOfAKey/Com_select", Com_select)
function Com_select:onInit()
	self.fields.Check_tick:addClickListener(handler(self, self.onTickClick))
	self:fixChildrenPos()
end
function Com_select:onShow()
end
function Com_select:setTitleStr(str)
	self.fields.title:setString(str)
end
function Com_select:initData(sType)
	self.sType = sType
end
function Com_select:setSelect(ret)
	self.fields.Check_tick:setSelected(ret)
end
function Com_select:onTickClick()
	SoraDPlaySound()
	local isSelected = self.fields.Check_tick:isSelected()
	if not isSelected then
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_RESOLVE_EXTRA_CHOOSE"
		;(nil).sType = self.sType
		;(nil).isDel = true
		SoraDSendMessage(nil)
		return
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_RESOLVE_EXTRA_CHOOSE"
	;(nil).sType = self.sType
	SoraDSendMessage(nil)
end
return Com_select
