local activity_9001717_Read = include("activity_9001717_Read")
local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_BuySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001717/Com_BuySingle", Com_BuySingle)
function Com_BuySingle:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_recharge:addClickListener(handler(self, self.onClickRecharge))
	self:fixChildrenPos()
end
function Com_BuySingle:onShow()
end
function Com_BuySingle:initData(cfg, payType)
	self.rechargeID = cfg.rechargeID
	self.payType = payType
	self.fields.Button_recharge:getController("c1"):setSelectedIndex(payType == 1 and 0 or 1)
	_UPVALUE2_ = payType == 1 and 0 or 1
	;(payType == 1 and 0 or 1)[1] = "id"
	;(payType == 1 and 0 or 1)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(cfg.reward, payType == 1 and 0 or 1)
	for __, item in ipairs(rewardList) do
		item.itemType = 1
	end
	_UPVALUE2_ = ipairs(rewardList)
	ipairs(rewardList)[1] = "id"
	ipairs(rewardList)[2] = "count"
	local giftList = serviceFunctions.tableFormat(cfg.gift, ipairs(rewardList))
	for __, gift in ipairs(giftList) do
		_ENV = nil
		;(nil).itemType = 2
		;(nil).id = gift.id
		;(nil).count = gift.count
		table.insert(rewardList, 1, nil)
	end
	if 0 < cfg.gold then
		_ENV = "count"
		;("count").itemType = 1
		;("count").id = gIDDef.GOLD
		;("count").count = cfg.gold
		table.insert(rewardList, 1, "count")
	end
	self.rewardList = rewardList
	self.fields.List_award:setNumItems(#self.rewardList)
	self.fields.List_award:scrollToView(0)
	local curPrice = paymentManager.judgePrice(cfg.rechargeID, cfg.rechargePrice)
	local discount = cfg.originalPrice / cfg.rechargePrice
	local oriPrice = paymentManager.calculateDiscount(cfg.rechargeID, curPrice, discount, cfg.originalPrice)
	local _discount = math.floor(discount * 100 + 0.5)
	if SoraDFIsRA() then
		self.fields.text_discount:setString("%" .. _discount)
	else
		self.fields.text_discount:setString(_discount .. "%")
	end
	self.fields.Button_recharge:initData(curPrice, oriPrice, self.rechargeID)
end
function Com_BuySingle:onItemRenderer(index, obj)
	local item = self.rewardList[index + 1]
	if item.itemType == 1 then
		obj:initData(item.id, item.count)
	elseif item.itemType == 2 then
		local giftType = item.id
		obj:initData(giftType, item.count)
		obj:setIcon(activity_9001717_Read.getGiftIcon(giftType))
		obj:setQuality(giftType)
		obj:setCustomName(activity_9001717_Read.getGiftName(giftType))
		obj:setCustomTip("Bubble_island_rebuild_text_58")
	end
end
function Com_BuySingle:onClickRecharge()
	SoraDPlaySound()
	if not activity_9001717_Ctrl:checkRechargeDeadLine() then
		return
	end
	if SoraDCheckOAPIsOpen() and self.payType == 2 then
		SoraDShowH5PurchaseView(self.rechargeID)
	else
		paymentManager.normalGiftBuyClassify(self.rechargeID)
		paymentManager.OnemtReadyBuy(self.rechargeID, gRechargeActiveFromEnum.ROAD18)
	end
end
return Com_BuySingle
