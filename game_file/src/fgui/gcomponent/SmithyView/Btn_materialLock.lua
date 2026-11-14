local baseComponent = require("fgui.base.baseComponent")
local Btn_materialLock = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_materialLock", Btn_materialLock)
function Btn_materialLock:onInit()
	self:addClickEventListener(handler(self, self.onClick))
end
function Btn_materialLock:initData(data, selectMap, callback)
	self.data = data
	self.fields.material:initData(data)
	local isSelected = selectMap[self.data.id]
	self:setSelected(isSelected)
	self.selectMap = selectMap
	self.callback = callback
end
function Btn_materialLock:onShow()
end
function Btn_materialLock:onClick()
	local isSelected = self.selectMap[self.data.id]
	self:setSelected(not isSelected)
	self.selectMap[self.data.id] = not isSelected
	if self.callback then
		self.callback(self.data.id, not isSelected)
	end
end
function Btn_materialLock:setSelected(selected)
	self.controllers.select:setSelectedIndex(selected and 1 or 0)
end
return Btn_materialLock
