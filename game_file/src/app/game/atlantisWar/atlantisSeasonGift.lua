local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisSeasonGift = class("atlantisSeasonGift", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisSeasonGift")
	end
	return target
end)
function atlantisSeasonGift:ctor(target, activityID)
	print("==atlantisSeasonGift:ctor==", target, activityID)
	self.activityID = activityID
	self:initWidget()
	self:initData()
end
function atlantisSeasonGift:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_BUYGIFT_SUCCESS", handler(self, self.purchaseBack))
end
function atlantisSeasonGift:initWidget()
	_UPVALUE1_ = nil
	;(nil)[1] = "Center_Node"
	self.Center_Node = SoraDGetChildByFullPath(self._ccsView, nil)
	_UPVALUE4_ = self._ccsView
	self._ccsView[1] = "Text_title"
	self._ccsView[2] = "Node_lock"
	self._ccsView[3] = "Node_reward"
	self._ccsView[4] = "Button_buy"
	for i, v in ipairs(self._ccsView) do
		_UPVALUE1_ = nil
		;(nil)[1] = v
		self[v] = SoraDGetChildByFullPath(self.Center_Node, nil)
	end
	SoraDGetAllChildFromWidget(self.Button_buy, self)
	self.Text_title:setString(i18n("rechare_activename_14361"))
	_UPVALUE1_ = i18n("rechare_activename_14361")
	i18n("rechare_activename_14361")[1] = "Text_lock"
	self.Text_lock = SoraDGetChildByFullPath(self.Node_lock, i18n("rechare_activename_14361"))
	_UPVALUE2_ = self.Node_lock
	self.Node_lock[1] = "CCS_atlantisSkillSingle_1"
	self.Node_lock[2] = "CCS_atlantisSkillSingle_2"
	for i, v in ipairs(self.Node_lock) do
		local skillSingle = SoraDGetExtendChildFromCCSByName(self.Node_lock, v)
		skillSingle:initSeasonGift()
	end
	_UPVALUE1_ = ipairs(self.Node_lock)
	ipairs(self.Node_lock)[1] = "Text_reward"
	self.Text_reward = SoraDGetChildByFullPath(self.Node_reward, ipairs(self.Node_lock))
	self.Text_reward:setString(i18n("atlantiswar_skill_text_012"))
	_UPVALUE1_ = i18n("atlantiswar_skill_text_012")
	i18n("atlantiswar_skill_text_012")[1] = "ScrollView_award"
	self.scroll = SoraDGetChildByFullPath(self.Node_reward, i18n("atlantiswar_skill_text_012"))
	self.Button_buy:addTouchEventListener(handler(self, self.onClickBuyGift))
	_UPVALUE2_ = handler(self, self.onClickBuyGift)
	handler(self, self.onClickBuyGift)[1] = "Node_frame"
	handler(self, self.onClickBuyGift)[2] = "Image_bg"
	local Image_bg = SoraDGetChildByFullPath(self.Center_Node, handler(self, self.onClickBuyGift))
	Image_bg:setFillType(1)
	_UPVALUE1_ = 1
	;(1)[1] = "Node_effect"
	self.Node_effect = SoraDGetChildByFullPath(self.Center_Node, 1)
	self:showEffect()
	if not SoraDFIsRA() then
		self.Text_oriPrice:setAnchorPoint(cc.p(1, 0.5))
		self.Text_oriPrice:setPositionX(147)
		self.Text_nowPrice:setAnchorPoint(cc.p(0, 0.5))
		self.Text_nowPrice:setPositionX(191)
		self.Sprite_line:setPositionX(97)
		self.Image_arrow:setFlippedX(true)
	end
end
function atlantisSeasonGift:initData()
	if self.activityID == gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY then
		local roaringFlameWarRead = include("roaringFlameWarRead")
		self.giftData = roaringFlameWarRead.getRechargeConfig(2)
		self.curGiftID = self.giftData.rechargeID
		self.Text_title:setString(i18n("flames_dunes_text112"))
		self.Text_lock:setString(i18n("flames_dunes_text113"))
	else
		local ARG = require_data("atlantiswar_recharge_gift", true).data
		self.giftData = ARG[1]
		self.curGiftID = self.giftData.rechargeID
		_ENV = i18n("flames_dunes_text113")
		i18n("flames_dunes_text113").var = "S" .. atlantisActivityCtrl:getSeason()
		self.Text_lock:setString(i18n("atlantiswar_skill_text_011", i18n("flames_dunes_text113")))
	end
	self:initScroll()
	self:initPrice()
	self:updateOutAppPurchase()
	_ENV, atlantisActivityCtrl = self.Text_lock, self
	self.Text_lock.rechargeID = self.curGiftID
	self[1] = self.Text_lock
	_G.SoraDCreateRechargeGiftNode(self, self.Center_Node, cc.p(SoraDFPosX(530, 640), -330), 0.7)
end
function atlantisSeasonGift:initScroll()
	local col_count = 5
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewards = serviceFunctions.tableFormat(self.giftData.rewards, nil)
	_ENV = "count"
	;("count").id = 1001
	;("count").count = self.giftData.gold
	table.insert(rewards, 1, "count")
	local itemCount = #rewards
	local lastCol = (itemCount - 1) % col_count + 1
	local lastRow = math.ceil(itemCount / col_count)
	local itemSize = cc.size(90, 95)
	local sSize = self.scroll:getContentSize()
	local totalH = lastRow * itemSize.height + 10
	local scrollH = math.max(sSize.height, totalH)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, scrollH))
	local offsetx = (col_count - lastCol) * itemSize.width * 0.5
	for i, v in ipairs(rewards) do
		local itemAward = SoraDCreatePanel("commonItemAward")
		itemAward:addTo(self.scroll)
		local col = (i - 1) % col_count + 1
		local row = math.ceil(i / col_count)
		local posx = sSize.width / 2 + SoraDFSign(3 - col) * itemSize.width
		if row == lastRow then
			posx = posx - SoraDFSign(offsetx)
		end
		local posy = scrollH - (row - 0.5) * itemSize.height - 10
		itemAward:setPosition(posx, posy)
		itemAward:setOwnScroll(self.scroll)
		itemAward:setOwnView(self)
		itemAward:setScale(0.85)
		itemAward:initData(v.id, v.count)
	end
end
function atlantisSeasonGift:initPrice()
	local nowPrice = paymentManager.judgePrice(self.curGiftID, self.giftData.price)
	self.Text_nowPrice:setString(nowPrice)
	local discount = self.giftData.originalPrice / self.giftData.price
	local oriPrice = paymentManager.calculateDiscount(self.curGiftID, nowPrice, discount, self.giftData.originalPrice)
	self.Text_oriPrice:setString(oriPrice)
	self.nowPrice = nowPrice
	self.oriPrice = oriPrice
end
function atlantisSeasonGift:onClickBuyGift(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(self.curGiftID)
		paymentManager.OnemtReadyBuy(self.curGiftID, gRechargeActiveFromEnum.ROAD36)
	end
end
function atlantisSeasonGift:showEffect()
	SoraDCreatAnimation(self.__cname, self._ccsView, true)
	_UPVALUE3_ = self.__cname
	self.__cname[1] = "Particle_1"
	self.__cname[2] = "Particle_1_0"
	self.__cname[3] = "Particle_1_0_0"
	for i, v in ipairs(self.__cname) do
		SoraDGetChildByName(self.Node_effect, v):setAutoCull(false)
	end
end
function atlantisSeasonGift:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.curGiftID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.Button_buy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(320, -330))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.curGiftID
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD36
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.onClickBuyGift)
		self.outAppPurchaseButtons:initData(false)
	end
end
function atlantisSeasonGift:purchaseBack()
	self:closePanel()
end
return atlantisSeasonGift
