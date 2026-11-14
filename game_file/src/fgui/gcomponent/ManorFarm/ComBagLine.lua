local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ComBagLine = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComBagLine", ComBagLine)
function ComBagLine:onInit()
	self.fields.list:setItemRenderer(handler(self, self.itemRenderer_list))
	self.fields.list:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_list))
end
function ComBagLine:onShow()
end
function ComBagLine:itemRenderer_list(index, obj)
	local data = self.data.list[index + 1]
	obj:setMovieBorder(false)
	obj:getChild("isGet"):setVisible(false)
	if data then
		obj:initData(data.id, data.count)
		if data.seedData and not data.fruitData then
			local received = manorCityCtrl:getReceivedFarmBookItem(data.seedData.fruitID)
			obj:getChild("isGet"):setVisible(received)
		end
	else
		obj:setEmpty()
	end
end
function ComBagLine:onClickItem_list(context)
	if self.onClickItem then
		self.onClickItem(context, self.index)
	end
end
function ComBagLine:initData(data, index)
	self.data = data
	self.index = index
	self.fields.list:setNumItems(0)
	self.fields.list:setNumItems(self.data.num)
end
function ComBagLine:setOnClickItem(func)
	self.onClickItem = func
end
return ComBagLine
