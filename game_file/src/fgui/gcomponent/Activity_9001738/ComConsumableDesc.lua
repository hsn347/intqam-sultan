local baseComponent = require("fgui.base.baseComponent")
local ComConsumableDesc = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/ComConsumableDesc", ComConsumableDesc)
local publicRead = include("publicRead")
function ComConsumableDesc:onInit()
	self.fields.comItem:fixPos()
	self.fields.txtName:fixPos()
	self.fields.txtDesc:fixPos()
end
function ComConsumableDesc:onShow()
end
function ComConsumableDesc:initData(data)
	self.data = data
	self.itemID = data.itemID or data.id or 0
	self.fields.comItem:initData(self.itemID)
	self.fields.txtName:setString(publicRead.getName(self.itemID))
	self.fields.txtDesc:setString(publicRead.getDes(self.itemID))
end
return ComConsumableDesc
