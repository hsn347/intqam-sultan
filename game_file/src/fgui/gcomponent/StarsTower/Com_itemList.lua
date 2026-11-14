local baseComponent = require("fgui.base.baseComponent")
local Com_itemList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarsTower/Com_itemList", Com_itemList)
function Com_itemList:onInit()
	self.fields.item1:fixPos()
	self.fields.item2:fixPos()
end
function Com_itemList:onShow()
end
function Com_itemList:initData(data)
	for i = 1, 2 do
		if data["cfg" .. i] then
			self.fields["item" .. i]:setVisible(true)
			self.fields["item" .. i]:initData(data["cfg" .. i])
		else
			self.fields["item" .. i]:setVisible(false)
		end
	end
end
return Com_itemList
