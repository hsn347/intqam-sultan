local baseComponent = require("fgui.base.baseComponent")
local Btn_equipmentLock = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_equipmentLock", Btn_equipmentLock)
function Btn_equipmentLock:onInit()
	self:addClickEventListener(handler(self, self.onClick))
end
function Btn_equipmentLock:onShow()
end
function Btn_equipmentLock:initData(data, selectMap, callback)
	self.data = data
	self.fields.equip:initData(data)
	local isSelected = selectMap[self.data:getEPID()]
	self:setSelected(isSelected)
	self.selectMap = selectMap
	self.callback = callback
end
function Btn_equipmentLock:onClick()
	local isSelected = self.selectMap[self.data:getEPID()]
	self:setSelected(not isSelected)
	self.selectMap[self.data:getEPID()] = not isSelected
	if self.callback then
		self.callback(self.data:getEPID(), not isSelected)
	end
end
function Btn_equipmentLock:setSelected(selected)
	self.controllers.select:setSelectedIndex(selected and 1 or 0)
end
return Btn_equipmentLock
