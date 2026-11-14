local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_msg2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_msg2", Com_msg2)
function Com_msg2:onInit()
	self:fixChildrenPos()
end
function Com_msg2:onShow()
end
function Com_msg2:initData(data)
	if data.isReach then
		self.fields.icon:setVisible(true)
		self.fields.icon:setSpriteFrame(equipDesRead.getBg(data.isReach))
		self.fields.title:setColor(gQualityTextColorDef[data.isReach])
	else
		self.fields.title:setColor(cc.c3b(116, 110, 101))
		self.fields.icon:setVisible(false)
	end
	self.fields.title:setString(data.title)
end
return Com_msg2
