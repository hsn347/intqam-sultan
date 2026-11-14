local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local radiantDecreeRead = include("radiantDecreeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_decreeRewardPreview = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RadiantDecree/Com_decreeRewardPreview", Com_decreeRewardPreview)
function Com_decreeRewardPreview:onInit()
	self.fields.List_normal:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.List_special:setItemRenderer(handler(self, self.onSpecialItemRenderer))
end
function Com_decreeRewardPreview:onShow()
	self.fields.Text_High:setString(i18n("GloriousDecree_05"))
	self.fields.Text_Normal:setString(i18n("GloriousDecree_06"))
	local normalAward, specialAward = radiantDecreeRead.getAllAwardByIndex(radiantDecreeCtrl:getLevelIndex())
	dump(self.normalAward, "fkdsfjkdjfkdfjk")
	dump(self.specialAward, "fkdsfjk4545djfkdfjk")
	radiantDecreeCtrl = "fkdsfjk4545djfkdfjk"
	;("fkdsfjk4545djfkdfjk")[1] = "id"
	;("fkdsfjk4545djfkdfjk")[2] = "count"
	self.normalAward = serviceFunctions.tableFormat(normalAward, "fkdsfjk4545djfkdfjk")
	radiantDecreeCtrl = "fkdsfjk4545djfkdfjk"
	;("fkdsfjk4545djfkdfjk")[1] = "id"
	;("fkdsfjk4545djfkdfjk")[2] = "count"
	self.specialAward = serviceFunctions.tableFormat(specialAward, "fkdsfjk4545djfkdfjk")
	self.fields.List_normal:setNumItems(#self.normalAward)
	self.fields.List_normal:resizeToFit(#self.normalAward)
	self.fields.List_special:setNumItems(#self.specialAward)
	self.fields.List_special:resizeToFit(#self.specialAward)
end
function Com_decreeRewardPreview:onNormalItemRenderer(index, obj)
	local item = self.normalAward[index + 1]
	obj:initData(item.id, item.count, index + 1)
end
function Com_decreeRewardPreview:onSpecialItemRenderer(index, obj)
	local item = self.specialAward[index + 1]
	obj:initData(item.id, item.count, index + 1)
end
return Com_decreeRewardPreview
