local pyramidRareTreasureCtrl = SoraDGetCtrl("pyramidRareTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
PYRAMID_UNLOCKED_LUCKY_COIN = 1618
local pyramidTreasureShopView = class("pyramidTreasureShopView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidTreasureShopView")
	end
	return target
end)
function pyramidTreasureShopView:ctor()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_shop")
	self.ccs_title:setTitle(i18n("Pyramid_treasure_text_13"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("pyramidTreasureShopSingle")
	self.Node_own = SoraDGetChildByName(self, "Node_own")
	self.Text_own = SoraDGetChildByName(self, "Text_own")
	self.Button_quest = SoraDGetChildByName(self, "Button_quest")
	self.Button_quest:addTouchEventListener(handler(self, self.btnLogClick))
	_UPVALUE2_ = self.Button_quest.addTouchEventListener
	self.Button_quest.addTouchEventListener[1] = "Particle_bex"
	local self.Button_quest.addTouchEventListener[2], etArray = "Particle_cex", self.Button_quest.addTouchEventListener
	for k, v in ipairs(etArray) do
		local et_par = SoraDGetChildByName(self, v)
		if et_par then
			et_par:setAutoCull(false)
		end
	end
	self:initData()
end
function pyramidTreasureShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_TREASURE_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function pyramidTreasureShopView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function pyramidTreasureShopView:initData()
	SoraDCloseLoading(self)
	local activityExchangeMallRead = include("activityExchangeMallRead")
	local tableCurItems = activityExchangeMallRead:getShopItemList(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY)
	table.sort(tableCurItems, function(a, b)
		local buyNumA = activityExchangeMallCtrl:getExchangeNum(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY, a.shopItemID)
		local buyNumB = activityExchangeMallCtrl:getExchangeNum(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY, b.shopItemID)
		if buyNumA >= a.limitnum and buyNumB >= b.limitnum then
			return a.shopitem < b.shopitem
		elseif buyNumA >= a.limitnum and buyNumB < b.limitnum then
			return false
		elseif buyNumA < a.limitnum and buyNumB >= b.limitnum then
			return true
		else
			return a.shopitem < b.shopitem
		end
	end)
	local _ENV, showTB = table.sort, table.sort
	local index = 1
	for i = 1, #tableCurItems, 2 do
		if tableCurItems[i] then
			_ENV = tableCurItems[i]
			tableCurItems[i].item1 = tableCurItems[i]
			tableCurItems[i].item2 = tableCurItems[i + 1]
			showTB[index], tableCurItems[i].sort = tableCurItems[i], index
			index = index + 1
		end
	end
	_ENV = tableCurItems[i + 1]
	tableCurItems[i + 1].scroll = self.scroll
	tableCurItems[i + 1].view = self
	self.scroll:updateScrollView(cc.size(640, 220), showTB, 1, tableCurItems[i + 1])
	_ENV = 1
	;(1).num = string.formatnumberthousands(pyramidRareTreasureCtrl:getUnLockLuckyCoin())
	self.Text_own:setString(i18n("Pyramid_treasure_text_10", 1))
	SoraDToCenter(self.Node_own)
end
function pyramidTreasureShopView:btnLogClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidTreasureCoinRecordView"):show()
	end
end
return pyramidTreasureShopView
