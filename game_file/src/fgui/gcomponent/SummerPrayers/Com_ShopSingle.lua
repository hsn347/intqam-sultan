local baseComponent = require("fgui.base.baseComponent")
local publicRead = include("publicRead")
local rechargeRead = include("rechargeRead")
local summerPrayRead = include("summerPrayRead")
local Com_ShopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SummerPrayers/Com_ShopSingle", Com_ShopSingle)
function Com_ShopSingle:onInit()
	self:fixChildrenPos()
	self.fields.Button_Buy:addTouchEventListener(handler(self, self.btnBuyClick))
end
function Com_ShopSingle:onShow()
end
function Com_ShopSingle:initData(giftData, index, payType)
	self.payType = payType
	self.fields.Button_Buy:getController("c1"):setSelectedIndex(payType == 1 and 0 or 1)
	self.giftID = giftData.ID
	self.fields.bmFont_goldNum:setString(string.formatnumberthousands(giftData.gold))
	self.fields.Image_Icon:setURL(summerPrayRead.getGiftIcon(index))
	local nowPrice = paymentManager.judgePrice(giftData.ID, giftData.price)
	self.fields.Button_Buy:initData(nowPrice, nil, giftData.ID)
	local rechargeInfo = rechargeRead.getPageViewData(giftData.ID)
	self.fields.Text_Name:setString(i18n(rechargeInfo.activeName))
	self.fields.Text_Num:setString(i18n(publicRead.getName(giftData.gift[1].id)) .. "x" .. giftData.gift[1].count)
	local limitKey = "shop_text_15"
	if giftData.payType == gRechargeActivityBuyType.LIMIT then
		limitKey = "Icefestival2024_text26"
	else
		limitKey = "shop_text_15"
	end
	_ENV = publicRead.getName(giftData.gift[1].id)
	publicRead.getName(giftData.gift[1].id).num = giftData.extraData
	publicRead.getName(giftData.gift[1].id).limitNum = giftData.oldExtraData
	self.fields.Text_LimitTime:setString(i18n(limitKey, publicRead.getName(giftData.gift[1].id)))
	self.fields.Text_LimitTime:setColor(tonumber(giftData.extraData) == 0 and cc.c3b(255, 0, 0) or cc.c3b(245, 206, 121))
	self.fields.Button_Buy:setEnabled(0 < tonumber(giftData.extraData))
	_ENV, summerPrayRead = 0 < tonumber(giftData.extraData), self.fields.Button_Buy
	;(0 < tonumber(giftData.extraData)).rechargeID = giftData.ID
	self.fields.Button_Buy[1] = 0 < tonumber(giftData.extraData)
	_G.SoraDCreateRechargePresentNode(self.fields.Button_Buy, self.fields.n10:displayObject(), cc.p(SoraDFPosX(546, 0), 0), 0.7, SoraDFPosX(2, 5))
end
function Com_ShopSingle:btnBuyClick()
	SoraDPlaySound()
	if SoraDCheckOAPIsOpen(self.giftID) and self.payType == 2 then
		_ENV = nil
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD35
		;(nil).activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
		SoraDShowH5PurchaseView(self.giftID, param, nil)
	else
		paymentManager.normalGiftBuyClassify(self.giftID)
		paymentManager.OnemtReadyBuy(self.giftID, gRechargeActiveFromEnum.ROAD35, false, nil, nil, gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY)
	end
end
return Com_ShopSingle
