local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001588/Com_list", Com_list)
function Com_list:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_list:onShow()
end
function Com_list:initData(data)
	self.awardList = data.reward
	self.fields.Text_name:setString(i18n(include("newLotteryRead").getTextByPrize(data.prize)))
	self.fields.Icon:setURL(string.format("icon_nebula_walk_%d.png", data.prize))
	self.fields.List:setNumItems(#self.awardList)
	if SoraDFIsRA() then
		self.fields.List:getScrollPane():setPercX(1)
	else
		self.fields.List:getScrollPane():setPercX(0)
	end
end
function Com_list:onItemRenderer(index, obj)
	obj:initData(self.awardList[index + 1].id, self.awardList[index + 1].count)
end
return Com_list
