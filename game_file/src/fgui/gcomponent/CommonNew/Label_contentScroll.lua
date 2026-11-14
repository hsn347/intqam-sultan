local baseComponent = require("fgui.base.baseComponent")
local Label_contentScroll = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Label_contentScroll", Label_contentScroll)
function Label_contentScroll:onInit()
end
function Label_contentScroll:onShow()
end
function Label_contentScroll:setString(...)
	self.fields.title:setText(...)
	if self.fields.title:getContentSize().height > self:getContentSize().height then
		self:setScrollEnable(true)
	else
		self:setScrollEnable(false)
	end
end
function Label_contentScroll:setAlign(...)
	self.fields.title:setAlign(...)
end
return Label_contentScroll
