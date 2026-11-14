local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LuckyWretch/Com_list", Com_list)
function Com_list:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_list:onShow()
end
function Com_list:initData(data)
	self.awardList = data.reward
	self.fields.Icon:setURL(string.format("twist_egg_grade%d.png", data.grade))
	self.fields.List:setNumItems(#self.awardList / 2)
end
function Com_list:onItemRenderer(index, obj)
	obj:initData(self.awardList[index * 2 + 1], self.awardList[index * 2 + 2])
end
return Com_list
