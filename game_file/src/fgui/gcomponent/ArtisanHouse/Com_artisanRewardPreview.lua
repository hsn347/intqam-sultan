local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local artisanHouseltCtrl = include("artisanHouseltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_artisanRewardPreview = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ArtisanHouse/Com_artisanRewardPreview", Com_artisanRewardPreview)
function Com_artisanRewardPreview:onInit()
	self.fields.List_normal:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.List_special:setItemRenderer(handler(self, self.onSpecialItemRenderer))
end
function Com_artisanRewardPreview:onShow()
	self.fields.Text_High:setString(i18n("Artisan_House_06"))
	self.fields.Text_Normal:setString(i18n("Artisan_House_09"))
	local normalAward, specialAward = artisanHouseltCtrl.getAllAwardByIndex(artisanHouseCtrl:getLevelIndex())
	artisanHouseCtrl = artisanHouseCtrl:getLevelIndex()
	artisanHouseCtrl:getLevelIndex()[1] = "id"
	artisanHouseCtrl:getLevelIndex()[2] = "count"
	self.normalAward = serviceFunctions.tableFormat(normalAward, artisanHouseCtrl:getLevelIndex())
	artisanHouseCtrl = artisanHouseCtrl:getLevelIndex()
	artisanHouseCtrl:getLevelIndex()[1] = "id"
	artisanHouseCtrl:getLevelIndex()[2] = "count"
	self.specialAward = serviceFunctions.tableFormat(specialAward, artisanHouseCtrl:getLevelIndex())
	self.fields.List_normal:setNumItems(#self.normalAward)
	self.fields.List_normal:resizeToFit(#self.normalAward)
	self.fields.List_special:setNumItems(#self.specialAward)
	self.fields.List_special:resizeToFit(#self.specialAward)
end
function Com_artisanRewardPreview:onNormalItemRenderer(index, obj)
	local item = self.normalAward[index + 1]
	obj:initData(item.id, item.count, index + 1)
end
function Com_artisanRewardPreview:onSpecialItemRenderer(index, obj)
	local item = self.specialAward[index + 1]
	obj:initData(item.id, item.count, index + 1)
end
return Com_artisanRewardPreview
