local rechargeRead = include("rechargeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_menu = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_menu", Com_menu)
function Com_menu:onInit()
	self.curIndex = 0
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRendererItem))
end
function Com_menu:initData(data, btnCallBack, curIndex)
	dump(data, "Com_menu:initData")
	self.curIndex = curIndex or self.curIndex
	self.listData = data
	self.btnHandle = btnCallBack
	self.clickMenuItem = btnCallBack
	self.fields.List_item:setNumItems(table.nums(self.listData))
	self.fields.List_item:setSelectedIndex(self.curIndex)
end
function Com_menu:onItemRendererItem(index, object)
	local v = self.listData[index + 1]
	local info = rechargeRead.getInheritPageViewData(v.rid)
	rechargeRead = nil
	;(nil).tag = index + 1
	;(nil).title = i18n(info.activeName)
	object:initData(index + 1, nil, self.btnHandle)
end
function Com_menu:setCurSelection(curIndex)
	self.curIndex = curIndex
	self.fields.List_item:setSelectedIndex(self.curIndex)
end
function Com_menu:onShow()
end
return Com_menu
