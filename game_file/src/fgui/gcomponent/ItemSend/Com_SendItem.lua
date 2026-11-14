local baseComponent = require("fgui.base.baseComponent")
local Com_SendItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ItemSend/Com_SendItem", Com_SendItem)
function Com_SendItem:onInit()
	self.fields.Com_item1:addClickEventListener(handler(self, self.onClickItem))
end
function Com_SendItem:onShow()
end
function Com_SendItem:initData(result, index, curIndex)
	local itemID = result.id
	local itemNum = result.num
	local isLock = result.isLock
	self.index = index
	self.fields.Com_item1:initData(itemID, itemNum)
	self.fields.Com_item1:setSelected(curIndex == index)
	self.fields.lock:setVisible(isLock)
	self.fields.Com_item1:setSelectShow(true)
	self.isLock = isLock
end
function Com_SendItem:setClickCallback(callback)
	self.clickCallback = callback
end
function Com_SendItem:onClickItem()
	if self.clickCallback then
		self.clickCallback(self.index)
	end
end
return Com_SendItem
