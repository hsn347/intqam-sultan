local baseComponent = require("fgui.base.baseComponent")
local Label_fitHeightBanner = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Label_fitHeightBanner", Label_fitHeightBanner)
function Label_fitHeightBanner:onInit()
end
function Label_fitHeightBanner:onShow()
	if not self.originSize then
		self.originSize = self:getSize()
	end
	local fitHeight = 1136
	if fitHeight <= display.height then
		return
	end
	local scale = fitHeight / display.height
	if self.originSize.width > 640 then
		self:setSize(self.originSize.width, self.originSize.height * scale)
	else
		self:setSize(self.originSize.width * scale, self.originSize.height * scale)
	end
	self.fields.icon:setSize(self:getSize())
end
return Label_fitHeightBanner
