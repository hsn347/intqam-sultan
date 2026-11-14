local desertTreasureltCtrl = include("desertTreasureltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_luckList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DesertSecretTreasure/Com_luckList", Com_luckList)
function Com_luckList:onInit()
	self:fixChildrenPos()
	self.fields.Text_luck:setString(i18n("Mermaid_title_06"))
	self.fields.Text_reward:setString(i18n("common_text_2078"))
	self.data = desertTreasureltCtrl.getLuckyCfg()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setNumItems(table.nums(self.data))
	self.fields.List_reward:resizeToFit(table.nums(self.data), 100)
end
function Com_luckList:onItemRenderer(index, object)
	object:initData(index + 1, self.data[index + 1])
end
function Com_luckList:onShow()
end
return Com_luckList
