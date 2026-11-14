local baseComponent = require("fgui.base.baseComponent")
local Com_BuySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LuckyFalcon/Com_BuySingle", Com_BuySingle)
function Com_BuySingle:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_recharge:addClickListener(handler(self, self.onClickRecharge))
	self:fixChildrenPos()
end
function Com_BuySingle:onShow()
end
function Com_BuySingle:initData(itemShow, giftData, payType)
	self.giftID = giftData.ID
	self.payType = payType
	self.fields.Button_recharge:getController("c1"):setSelectedIndex(payType == 1 and 0 or 1)
	_UPVALUE2_ = payType == 1 and 0 or 1
	;(payType == 1 and 0 or 1)[1] = "id"
	;(payType == 1 and 0 or 1)[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(itemShow, payType == 1 and 0 or 1)
	self.fields.List_award:setNumItems(#self.rewardList)
	local showPrice = paymentManager.judgePrice(giftData.ID, giftData.price)
	local remainTime = tonumber(giftData.extraData)
	local totalTime = tonumber(giftData.oldExtraData)
	local tempColor = remainTime <= 0 and "#FF0000" or "#FFFFFF"
	self.fields.Button_recharge:initData(showPrice, nil, giftData.ID)
	self.fields.Button_recharge:setEnabled(0 < remainTime)
	_ENV = giftData.ID
	giftData.ID.cur = remainTime
	_ENV, _ENV, giftData.ID.total = nil, nil, totalTime
	_ENV, (nil).cur, (nil).color = nil, nil, tempColor
	;(nil).__default, (nil).color = nil, tempColor
	self.fields.Text_limit:setString(i18n_html("common_text_4417", giftData.ID, nil))
end
function Com_BuySingle:onItemRenderer(index, obj)
	local item = self.rewardList[index + 1]
	obj:initData(tonumber(item.id), tonumber(item.count))
	if item.id == 836101 then
		obj:showCoolSquare(true)
	end
end
function Com_BuySingle:onClickRecharge()
	SoraDPlaySound()
	if SoraDCheckOAPIsOpen(self.giftID) and self.payType == 2 then
		_ENV = nil
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD35
		;(nil).isPageTurn = false
		;(nil).activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
		SoraDShowH5PurchaseView(self.giftID, param, nil)
	else
		paymentManager.normalGiftBuyClassify(self.giftID)
		paymentManager.OnemtReadyBuy(self.giftID, gRechargeActiveFromEnum.ROAD35, false, nil, nil, gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY)
	end
end
return Com_BuySingle
