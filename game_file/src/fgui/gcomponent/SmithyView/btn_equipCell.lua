local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local btn_equipCell = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/btn_equipCell", btn_equipCell)
function btn_equipCell:onInit()
	self.fields.Text_time:setVisible(false)
	self.fields.sheer_tbg:setVisible(false)
	self.fields.wear:setVisible(false)
end
function btn_equipCell:onShow()
end
function btn_equipCell:initData(data, index, selectIndex)
	if data.isEmpty then
		self:setVisible(false)
	else
		self:setVisible(true)
		self.fields.icon:setSpriteFrame(equipDesRead.getIcon(data:getEID()))
		self.controllers.c1:setSelectedIndex(index == selectIndex and 1 or 0)
		self.fields.wear:setVisible(data:isWearing())
		local endTime = data:getEquipmentEndTimeProperty() or 0
		local leftTime = endTime - serviceFunctions.systemTime()
		if 0 < leftTime then
			self.fields.Text_time:beginTime(leftTime)
			self.fields.Text_time:setVisible(true)
			self.fields.sheer_tbg:setVisible(true)
		else
			self.fields.Text_time:setVisible(false)
			self.fields.sheer_tbg:setVisible(false)
		end
	end
end
return btn_equipCell
