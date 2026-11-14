local gametop = gModuleMgr.getObject("gametop")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local petraRareTreasureShopSingle = class("petraRareTreasureShopSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("petraRareTreasureShopSingle")
	end
	local commonTaskSingle = include("royalSummonsShopSingleCommon")
	target = commonTaskSingle.new(target)
	return target
end)
function petraRareTreasureShopSingle:ctor()
end
function petraRareTreasureShopSingle:initData(data, otherData)
	dump(data, "petraRareTreasureShopSingle", 10)
	if otherData then
		self.view = otherData.view
	end
	data.itemId = data.shopitem
	data.exchangeType = data.exchangeitem
	data.buyNum = activityExchangeMallCtrl:getExchangeNum(gActivityTimeActivityID.PETRA_RARE_TREASURE, data.shopItemID)
	data.hasExchangeNum = activityExchangeMallCtrl:getExchangeItemNum(data.exchangeitem)
	self.item:setScale(1.3)
	self:initData_imp(data, otherData)
end
function petraRareTreasureShopSingle:onClickOperate()
	if self.itemData and self.itemData.hasExchangeNum < self.itemData.exchangenum then
		local publicRead = include("publicRead")
		local itemID = self.itemData.exchangeType
		local itemName = publicRead.getName(itemID)
		_ENV = nil
		;(nil).name = itemName
		SoraDShowMsgTip(i18n("commom_text_4302", nil))
	elseif self.canBuyNum == 0 then
		SoraDShowMsgTip(i18n("spices_text_07"))
	else
		self:showBuyView()
	end
end
function petraRareTreasureShopSingle:onBuyItem(data, num)
	print("选择了数量:", num)
	activityExchangeMallCtrl:reqActivityExchange(data.shopItemID, num)
	SoraDShowLoading(self.view)
end
return petraRareTreasureShopSingle
