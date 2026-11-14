local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local privilegeGiftRead = include("privilegeGiftRead")
local privilegeGiftCtrl = gametop.playertop_:getModule("privilegeGiftCtrl")
local castleLevelUpView = class("castleLevelUpView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("castleLevelUpView")
	end
	return target
end)
function castleLevelUpView:ctor()
	self.isAddToPopManager = true
	self:setBackGround(127.5)
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Center_Node:setScale(0)
	self.text_title = SoraDGetChildByName(self, "Text_title")
	self.text_title:setString(i18n("common_text_530"))
	self.btnClose = SoraDGetChildByName(self, "Button_closeBtn")
	self.btnClose:addTouchEventListener(handler(self, self.closeView))
	self.text_lvup = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_lvup"))
	self.node_atonce = SoraDGetChildByName(self, "Node_atonce")
	self.text_atonce = SoraDGetChildByName(self.node_atonce, "Text_atonce")
	self.text_atonce:setString(i18n("common_text_4061"))
	self.text_gold = SoraDGetChildByName(self.node_atonce, "text_gold")
	self.node_discount_icon = SoraDGetChildByName(self, "Node_discount_icon")
	self.text_discount = SoraDGetChildByName(self, "text_discount")
	self.once = SoraDGetChildByName(self, "Text_once")
	self.once:setString(i18n("common_text_3990"))
	self.text_tip = SoraDGetChildByName(self, "Text_tips")
	self.btn_buy = SoraDGetChildByName(self, "Button_buy")
	self.btn_buy:addTouchEventListener(handler(self, self.readyBuy))
	self.text_oriPrice = SoraDGetChildByName(self.btn_buy, "Text_oriPrice")
	self.text_nowPrice = SoraDGetChildByName(self.btn_buy, "Text_nowPrice")
	self.scroll = SoraDGetChildByName(self, "ScrollView_goods")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonItemSingle")
	SoraDRechargeBtnEffect(self.btn_buy)
	self:initData()
end
function castleLevelUpView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITY_CASTLE_GIFT_MSG", function(target, data)
		if not tolua.isnull(self) and data and data.success then
			self:removeFromParent()
		end
	end)
end
function castleLevelUpView:initData()
	_ENV = nil
	;(nil).byUID = true
	local castleTb = SoraDConfigGet("Game:CastleLvUpView:castleLvList~table", nil)
	local lv, rid = privilegeGiftCtrl:getUpgradeLvAndRid()
	lv = lv or castleTb.lv
	rid = rid or castleTb.rid
	if lv and rid then
		self.castleLv = lv
		self.curGiftID = rid
		self:initView()
		self.Center_Node:runAction(cc.EaseBackOut:create(cca.scaleTo(0.5, 1)))
	else
		self:removeFromParent()
	end
end
function castleLevelUpView:initView()
	local isShowWarLv, textLv = SoraDGetBuildWarLv(self.castleLv)
	local giftInfo = privilegeGiftRead.getRechargeGiftByID(self.curGiftID)
	if isShowWarLv then
		_ENV = nil
		_ENV, _ENV, (nil).lv = nil, nil, textLv
		;(nil).lv, (nil).color = nil, "#ffffff"
		self.text_lvup:setString(i18n_html("common_text_3994", nil, nil))
	else
		_ENV = i18n_html("common_text_3994", nil, nil)
		_ENV, _ENV, i18n_html("common_text_3994", nil, nil).lv = i18n_html("common_text_3994", nil, nil)
		i18n_html("common_text_3994", nil, nil).lv, i18n_html("common_text_3994", nil, nil).color = i18n_html("common_text_3994", nil, nil)
		self.text_lvup:setString(i18n_html("common_text_3988", i18n_html("common_text_3994", nil, nil)))
	end
	local curStarlv = SoraDGetBuildStarLv(BUILDID.CASTLE)
	if 0 < curStarlv then
		_ENV = i18n_html("common_text_3988", i18n_html("common_text_3994", nil, nil))
		_ENV, _ENV, i18n_html("common_text_3988", i18n_html("common_text_3994", nil, nil)).lv = i18n_html("common_text_3988", i18n_html("common_text_3994", nil, nil))
		i18n_html("common_text_3988", i18n_html("common_text_3994", nil, nil)).lv, i18n_html("common_text_3988", i18n_html("common_text_3994", nil, nil)).color = i18n_html("common_text_3988", i18n_html("common_text_3994", nil, nil))
		self.text_lvup:setString(i18n_html("privilege_text_159", i18n_html("common_text_3988", i18n_html("common_text_3994", nil, nil))))
	end
	self.text_gold:setString(string.formatnumberthousands(giftInfo.gold))
	SoraDToCenter(self.node_atonce, 5)
	local str_resource = SoraDConvertNumberWithUnit(giftInfo.totalResource)
	local str_hour = math.floor(giftInfo.totalSpeed / 3600)
	_ENV = string.formatnumberthousands(giftInfo.gold)
	string.formatnumberthousands(giftInfo.gold).resource = str_resource
	string.formatnumberthousands(giftInfo.gold).hour = str_hour
	self.text_tip:setString(i18n("common_text_3989", string.formatnumberthousands(giftInfo.gold)))
	local showPrice, isGetPrice = paymentManager.judgePrice(self.curGiftID, giftInfo.price)
	self.text_nowPrice:setString(showPrice)
	local discount = giftInfo.originalPrice / giftInfo.price
	local oriShowPrice = paymentManager.calculateDiscount(self.curGiftID, showPrice, discount, giftInfo.originalPrice)
	self.text_oriPrice:setString(oriShowPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	if giftInfo.extraData then
		local alreadyBuy = privilegeGiftCtrl:getBoughtNums(self.curGiftID)
		_ENV = i18n("common_text_3989", string.formatnumberthousands(giftInfo.gold))
		i18n("common_text_3989", string.formatnumberthousands(giftInfo.gold)).num = giftInfo.extraData - alreadyBuy
		self.once:setString(i18n("common_text_2516", i18n("common_text_3989", string.formatnumberthousands(giftInfo.gold))))
	end
	if 1 == giftInfo.discount[1] then
		self.text_discount:setVisible(true)
		self.node_discount_icon:setVisible(false)
		_ENV = i18n("common_text_2516", i18n("common_text_3989", string.formatnumberthousands(giftInfo.gold)))
		i18n("common_text_2516", i18n("common_text_3989", string.formatnumberthousands(giftInfo.gold))).num = math.floor(giftInfo.discount[2])
		i18n("common_text_2516", i18n("common_text_3989", string.formatnumberthousands(giftInfo.gold))).char = "%"
		self.text_discount:setString(i18n("common_text_1470", i18n("common_text_2516", i18n("common_text_3989", string.formatnumberthousands(giftInfo.gold)))))
	elseif 2 == giftInfo.discount[1] then
		self.text_discount:setVisible(false)
		self.node_discount_icon:setVisible(true)
		local rechargeRead = include("rechargeRead")
		local img = rechargeRead.getPromoIcon(giftInfo.discount[2]).icon
		local imgOcx = display.newSprite("#" .. img)
		imgOcx:addTo(self.node_discount_icon)
	end
	self:initAwards(giftInfo.rewards)
	self:updateOutAppPurchase()
end
function castleLevelUpView:initAwards(rewards)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(rewards, nil)
	_ENV = nil
	;(nil).view = self
	;(nil).scroll = self.scroll
	;(nil).scale = 0.8
	;(nil).offset = cc.p(45, 45)
	self.scroll:updateScrollView(cc.size(90, 90), rewardList, 4, nil)
end
function castleLevelUpView:readyBuy(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(self.curGiftID)
		paymentManager.OnemtReadyBuy(self.curGiftID, gRechargeActiveFromEnum.ROAD16)
	end
end
function castleLevelUpView:onExitPanel()
	_ENV, _ENV = nil, nil
	;(nil).byUID = true
	SoraDConfigSet("Game:CastleLvUpView:castleLvList~table", nil, nil)
end
function castleLevelUpView:closeView(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function castleLevelUpView:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.curGiftID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.Center_Node)
			self.outAppPurchaseButtons:setPosition(cc.p(0, -222))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btn_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.curGiftID
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD16
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.readyBuy)
		self.outAppPurchaseButtons:initData(false)
	end
end
function castleLevelUpView:purchaseBack()
	self:removeFromParent()
end
return castleLevelUpView
