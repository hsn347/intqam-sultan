local rechargePresentUtil = include("rechargePresentUtil")
local activity_9001628_Ctrl = SoraDGetCtrl("activity_9001628_Ctrl")
local activity_9001628_Read = include("activity_9001628_Read")
local baseComponent = require("fgui.base.baseComponent")
local baseComponent = require("fgui.base.baseComponent")
local Com_BuySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001628/Com_BuySingle", Com_BuySingle)
function Com_BuySingle:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_recharge:addClickListener(handler(self, self.onClickRecharge))
	self:fixChildrenPos()
end
function Com_BuySingle:onShow()
end
function Com_BuySingle:initData(giftData, payType)
	self.controllers.c1:setSelectedIndex(next(giftData) and 0 or 1)
	if next(giftData) then
		self.giftID = giftData.packageID
		self.payType = payType
		self.isAlreadyBuy = giftData.purchased
		self.fields.Button_recharge:getController("c1"):setSelectedIndex(payType == 1 and 0 or 1)
		local curPackageInfo = activity_9001628_Read:getTreasureHuntPackageInfo(giftData.packageID)
		_UPVALUE2_ = giftData
		giftData[1] = "id"
		giftData[2] = "count"
		local rewardList = serviceFunctions.tableFormat(curPackageInfo.result, giftData)
		local rechargePresentUtil = include("rechargePresentUtil")
		local fixData = rechargePresentUtil.fixRechargePresentData(giftData.packageID, rewardList)
		self.rewardList = fixData.gift
		self.fields.List_award:setNumItems(#self.rewardList)
		local curPrice = paymentManager.judgePrice(curPackageInfo.index, curPackageInfo.price)
		local discount = curPackageInfo.originalPrice / curPackageInfo.price
		local oriPrice = paymentManager.calculateDiscount(curPackageInfo.index, curPrice, discount, curPackageInfo.originalPrice)
		_UPVALUE2_ = curPrice
		curPrice[1] = curPrice
		curPrice[2] = oriPrice
		dump(curPrice, "Com_BuySingle:initData")
		if SoraDFIsRA() then
			self.fields.text_discount:setString("%" .. curPackageInfo.discount[2])
		else
			self.fields.text_discount:setString(curPackageInfo.discount[2] .. "%")
		end
		self.fields.Button_recharge:initData(curPrice, oriPrice, giftData.packageID)
		self.fields.Button_recharge:setGrayed(giftData.purchased)
	else
		self.fields.textLimit:setString(i18n("anniversary_text_12"))
	end
end
function Com_BuySingle:onItemRenderer(index, obj)
	local item = self.rewardList[#self.rewardList - index]
	obj:initData(tonumber(item.id), tonumber(item.count))
	if rechargePresentUtil.checkShowHighLight(item.id) then
		obj:showCoolSquare(true)
	else
		obj:showCoolSquare(false)
	end
end
function Com_BuySingle:onClickRecharge()
	SoraDPlaySound()
	if self.isAlreadyBuy then
		SoraDShowMsgTip(i18n("anniversary_dice_text_19"))
		return
	end
	if SoraDCheckOAPIsOpen(self.giftID) and self.payType == 2 then
		local param
		SoraDShowH5PurchaseView(self.giftID, param)
	else
		activity_9001628_Ctrl:reqBuyPackageMsg(self.giftID)
		SoraDShowLoading()
	end
end
return Com_BuySingle
