local baseComponent = require("fgui.base.baseComponent")
local Com_key = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_key", Com_key)
function Com_key:onInit()
	self.maxLen = 6
	self.fields.Input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.Sprite_correct:fixPos()
end
function Com_key:onShow()
end
function Com_key:onChanged()
	local len = string.utf8len(self:getText())
	self:setGVisible(len == self.maxLen and self.maxLen ~= 20)
end
function Com_key:initData(maxLen, default)
	self.maxLen = maxLen
	self.fields.Input:setMaxLength(self.maxLen)
	self.fields.Input:setPassword(true)
	self.fields.Input:setPrompt(fguiHelper.getColorString("#746e65", default))
end
function Com_key:setText(str)
	self.fields.Input:setText(str)
end
function Com_key:getText()
	return self.fields.Input:getText()
end
function Com_key:setGVisible(ret)
	self.fields.Sprite_correct:setVisible(ret)
end
return Com_key
