local baseComponent = require("fgui.base.baseComponent")
local Com_scrollPane = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_scrollPane", Com_scrollPane)
function Com_scrollPane:onInit()
	self.pane = self:getScrollPane()
	self:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEnd))
end
function Com_scrollPane:fitDevice()
	local offsetX = self:getWidth() / 2
	for i = 1, 5 do
		self.fields["cube" .. i]:setPositionX(offsetX + (i - 1) * 200)
	end
	self.fields.refer:setPositionX(self.fields.cube5:getPositionX() + offsetX - self.fields.refer:getWidth() / 2)
end
function Com_scrollPane:onScrollEnd()
end
function Com_scrollPane:onShow()
	self:fitDevice()
end
return Com_scrollPane
