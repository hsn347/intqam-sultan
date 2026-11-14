local baseComponent = require("fgui.base.baseComponent")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local Com_bagItemLock = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/Com_bagItemLock", Com_bagItemLock)
function Com_bagItemLock:onInit()
	self:addClickEventListener(handler(self, self.onItemClick))
end
function Com_bagItemLock:onShow()
end
function Com_bagItemLock:initData(data)
	self.data = data
	self.fields.Com_item:initData(data.id)
	local isLock = backpackCtrl:isItemLock(data.id)
	self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
end
function Com_bagItemLock:setItemClickCallback(callback)
	self.callback = callback
end
function Com_bagItemLock:onItemClick()
	if self.callback then
		self.callback(self, self.data)
	end
end
function Com_bagItemLock:setIsSelected(isSelected)
	self.controllers.c4:setSelectedIndex(isSelected and 1 or 0)
end
return Com_bagItemLock
