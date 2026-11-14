local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local coffeeCraftsmanCtrl = SoraDGetCtrl("coffeeCraftsmanCtrl")
local baseComponent = require("fgui.base.baseComponent")
local DessertMasterPreviewSub = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DessertMaster/DessertMasterPreviewSub", DessertMasterPreviewSub)
function DessertMasterPreviewSub:onInit()
	self.fields.Com_titleNormal:setTitle(i18n("cityUp_title_03"))
	self.fields.Com_titleSpecial:setTitle(i18n("back_recharge_text07"))
	self.fields.List_normal:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.List_special:setItemRenderer(handler(self, self.onSpecialItemRenderer))
end
function DessertMasterPreviewSub:onNormalItemRenderer(index, obj)
	local item = self.normalConfig.reward[index + 1]
	obj:setGroupOn()
	obj:initData(item.id, item.count)
end
function DessertMasterPreviewSub:onSpecialItemRenderer(index, obj)
	local config = coffeeCraftsmanCtrl:getConfig(index + 1)
	obj:initData(config)
end
function DessertMasterPreviewSub:onShow()
	print("=======DessertMasterPreviewSub:onShow")
	self.normalConfig = coffeeCraftsmanCtrl:getConfig(0)
	self.fields.List_normal:setNumItems(#self.normalConfig.reward)
	local h = self.fields.List_normal:getHeight()
	self.fields.List_normal:resizeToFit(#self.normalConfig.reward)
	print("List_normal", h, self.fields.List_normal:getHeight())
	self.fields.List_special:setNumItems(4)
	local h = self.fields.List_special:getHeight()
	self.fields.List_special:resizeToFit(4)
	print("List_special", h, self.fields.List_special:getHeight())
end
return DessertMasterPreviewSub
