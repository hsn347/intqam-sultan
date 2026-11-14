local buildRead = include("buildDescribeRead")
local baseComponent = require("fgui.base.baseComponent")
local buildCreateScrollSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://BuildViewCommon/buildCreateScrollSingle", buildCreateScrollSingle)
function buildCreateScrollSingle:onInit()
	self.tableSingleData, _UPVALUE0_ = nil, nil
end
function buildCreateScrollSingle:onShow()
end
function buildCreateScrollSingle:initData(singleData)
	self.tableSingleData = singleData
	self.fields.Image_build:setURL(buildRead.getIcon(self.tableSingleData.bid))
	if self.tableSingleData.iscanbuild then
		self.controllers.c_lock:setSelectedIndex(0)
	else
		self.controllers.c_lock:setSelectedIndex(1)
	end
end
return buildCreateScrollSingle
