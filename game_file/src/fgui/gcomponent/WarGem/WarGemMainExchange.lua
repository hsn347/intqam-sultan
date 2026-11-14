local activityExchangeMallRead = include("activityExchangeMallRead")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityID = gActivityTimeActivityID.GEM_EXCHANGE_MALL
local baseComponent = require("fgui.base.baseComponent")
local WarGemMainExchange = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemMainExchange", WarGemMainExchange)
function WarGemMainExchange:onInit()
	self.fields.List:setVirtual()
	self.fields.Text_tip:setString(i18n("gemEnchant_text_61"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function WarGemMainExchange:registerEvent()
	print("WarGemMainExchange:registerMessage")
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.onActivityRefresh))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA_BAG", handler(self, self.onBag))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onBag))
end
function WarGemMainExchange:onActivityRefresh()
	self:updateView()
end
function WarGemMainExchange:onBag()
	self:updateList()
end
function WarGemMainExchange:onItemRenderer(index, obj)
	obj:initData(self.cfgs[index + 1])
end
function WarGemMainExchange:onShow()
end
local hasCount = function(cfg)
	if cfg.type == 0 then
		return true
	end
	return activityExchangeMallCtrl:getExchangeNum(activityID, cfg.shopItemID) < cfg.limitnum
end
function WarGemMainExchange:updateView()
	self.cfgs = activityExchangeMallRead:getShopItemList(activityID)
	table.sort(self.cfgs, function(a, b)
		if hasCount(a) and not hasCount(b) then
			return true
		elseif hasCount(b) and not hasCount(a) then
			return false
		end
		return a.shopItemID < b.shopItemID
	end)
	self.fields.List:setNumItems(#self.cfgs)
end
function WarGemMainExchange:updateList()
	self.fields.List:setNumItems(#self.cfgs)
end
return WarGemMainExchange
