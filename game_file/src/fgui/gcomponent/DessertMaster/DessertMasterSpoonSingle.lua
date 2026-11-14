local rechargeRead = include("rechargeRead")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local DessertMasterSpoonSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DessertMaster/DessertMasterSpoonSingle", DessertMasterSpoonSingle)
function DessertMasterSpoonSingle:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_recharge:addClickListener(handler(self, self.onClickRecharge))
	self:fixChildrenPos()
end
function DessertMasterSpoonSingle:onClickRecharge()
	SoraDPlaySound()
	if self.controllers.Ctrl_empty:getSelectedIndex() == 1 then
		SoraDShowMsgTip(i18n("back_recharge_text13"))
		return
	end
	if self.rechargeData then
		if SoraDCheckOAPIsOpen(self.rechargeData.ID) and self.payType == 2 then
			_ENV = i18n("back_recharge_text13")
			i18n("back_recharge_text13").fromCenter = gRechargeActiveFromEnum.ROAD37
			i18n("back_recharge_text13").isPageTurn = false
			i18n("back_recharge_text13").activityID = gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY
			SoraDShowH5PurchaseView(self.rechargeData.ID, nil, i18n("back_recharge_text13"))
		else
			paymentManager.normalGiftBuyClassify(self.rechargeData.ID)
			paymentManager.OnemtReadyBuy(self.rechargeData.ID, gRechargeActiveFromEnum.ROAD37, false, nil, nil, gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY)
		end
	end
end
function DessertMasterSpoonSingle:onItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(tonumber(item.id), tonumber(item.count))
	local bHightList = false
	for k, v in pairs(self.highlight) do
		if v == index + 1 then
			bHightList = true
			break
		end
	end
	obj:setEffectShow(bHightList)
end
function DessertMasterSpoonSingle:onShow()
end
function DessertMasterSpoonSingle:initData(id, payType)
	print("DessertMasterSpoonSingle:initData", id)
	self.payType = payType
	self.fields.Button_recharge:getController("c1"):setSelectedIndex(payType == 1 and 0 or 1)
	local rechargeData = rechargeActivityCtrl:getRechargeActivityData(id)
	self.rechargeData = rechargeData
	if not rechargeData then
		print("rechargeData nil", id)
		return
	end
	self.highlight, _ENV = print, print
	for k, v in pairs(rechargeData.highlight) do
		self.highlight[k] = tonumber(v)
	end
	self.rewards = rechargeData.gift
	if not rechargeData.gift then
		_ENV = rechargeData.gift
	end
	local tmpList = SoraDStringSplit(rechargeData.gift, ",")
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(tmpList, nil)
	dump(rechargeData, "rechargeData")
	if rechargeData.gold and 0 < tonumber(rechargeData.gold) then
		_ENV = "id"
		;("id").id = 1001
		;("id").count = rechargeData.gold
		table.insert(self.rewards, 1, "id")
		for k, v in pairs(self.highlight) do
			self.highlight[k] = v + 1
		end
	end
	self.fields.List_award:setNumItems(#self.rewards)
	local showPrice, isGetPrice = paymentManager.judgePrice(id, rechargeData.price)
	self.fields.Button_recharge:initData(showPrice, nil, id)
	local cur = tonumber(rechargeData.extraData)
	local total = tonumber(rechargeData.oldExtraData) or 0
	local buyNum = total - cur
	local isEmpty = total <= buyNum
	self.controllers.Ctrl_empty:setSelectedIndex(isEmpty and 1 or 0)
	_ENV = nil
	;(nil).cur = buyNum
	;(nil).total = total
	self.fields.Text_limit:setString(i18n("common_text_4417", nil))
end
