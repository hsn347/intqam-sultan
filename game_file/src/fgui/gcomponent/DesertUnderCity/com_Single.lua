local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local com_Single = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://DesertUnderCity/com_Single", com_Single)
function com_Single:onInit()
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickListener(handler(self, self.onClick))
	self.fields.Usm_1:setCompleteCallback(function()
		self.fields.Usm_1:setVisible(false)
	end)
end
function com_Single:onShow()
end
function com_Single:initData(floorInfo, index)
