local baseComponent = require("fgui.base.baseComponent")
local Com_item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DesertUnderCity/Com_item", Com_item)
function Com_item:onInit()
	self.fields.item:setClickCallback(handler(self, self.onClickBack))
end
function Com_item:onShow()
end
function Com_item:initData(award, index, chooseIndex)
	self.fields.item:initData(award.id, award.count)
	self.index = index
	self.controllers.c1:setSelectedIndex(chooseIndex == index and 1 or 0)
end
function Com_item:onClickBack()
	if self.handle then
		self.handle(self.index)
	end
end
function Com_item:setHandle(handle)
	self.handle = handle
end
return Com_item
