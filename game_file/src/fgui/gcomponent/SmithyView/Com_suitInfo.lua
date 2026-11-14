local baseComponent = require("fgui.base.baseComponent")
local Com_suitInfo = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://SmithyView/Com_suitInfo", Com_suitInfo)
function Com_suitInfo:onInit()
	self:fixChildrenPos()
end
function Com_suitInfo:onShow()
end
function Com_suitInfo:initData(data)
	self.fields.title:setString(data.title)
	self.fields.title:setColor(data.color)
	if data.icon then
		self.fields.icon:setVisible(true)
		self.fields.icon:setSpriteFrame(data.icon)
	else
		self.fields.icon:setVisible(false)
	end
end
return Com_suitInfo
