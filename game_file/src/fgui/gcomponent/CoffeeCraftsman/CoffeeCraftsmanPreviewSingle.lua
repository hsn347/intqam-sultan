local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local mainUIDef = include("mainUIDef")
local baseComponent = require("fgui.base.baseComponent")
local CoffeeCraftsmanPreviewSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CoffeeCraftsman/CoffeeCraftsmanPreviewSingle", CoffeeCraftsmanPreviewSingle)
function CoffeeCraftsmanPreviewSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	print("CoffeeCraftsmanPreviewSingle:onInit")
	self:fixChildrenPos()
end
function CoffeeCraftsmanPreviewSingle:onItemRenderer(index, obj)
	local item = self.cfg.reward[index + 1]
	obj:initData(tonumber(item.id), tonumber(item.count))
end
function CoffeeCraftsmanPreviewSingle:onShow()
end
function CoffeeCraftsmanPreviewSingle:initData(cfg)
	self.controllers.Ctrl_line:setSelectedIndex(cfg.pool == 1 and 1 or 0)
	self.cfg = cfg
	self.fields.Label_cost:setString(cfg.itemNeed)
	local icon = coffeeCraftsmanRead:getCoffeeIcon(cfg.pool)
	self.fields.Com_coffee:initData(cfg.pool)
	self.fields.List_reward:setNumItems(#self.cfg.reward)
	self.fields.List_reward:resizeToFit(#self.cfg.reward)
end
