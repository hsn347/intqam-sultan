local gametop = gModuleMgr.getObject("gametop")
local growupFundCtrl = gametop.playertop_:getModule("growupFundCtrl")
local eventGrowupFund = class("eventGrowupFund", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventGrowupFund")
	end
	return target
end)
_ENV = "eventGrowupFund"
;("eventGrowupFund").enableBuy = 1
;("eventGrowupFund").enableReward = 2
local ("eventGrowupFund").received, fundStatus = 3, "eventGrowupFund"
function eventGrowupFund:ctor()
	self.isAddToPopManager = true
	self:bindBtnClose()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_eventGrowupFund")
	self.ccs_title:setTitle(i18n("common_text_2560"))
	self.Image_eventBg = SoraDGetChildByName(self, "Image_eventBg")
	self.Image_eventBg:loadTexture(SoraDCheckPNG("bg_growUp_01.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.node_bg_effect = SoraDGetChildByName(self, "Node_bg_effect")
	self.node_bg_effect:setVisible(true)
	self.node_time = SoraDGetChildByName(self, "Node_time")
	self.node_time:setVisible(false)
	self.text_time = SoraDGetChildByName(self, "Text_leftTime")
	self.icon_time = SoraDGetChildByName(self, "icon_hourglass")
	self.text_info = SoraDGetChildByName(self, "Text_info")
	self.text_tip = SoraDGetChildByName(self, "Text_tip")
	self.text_tip:setString(i18n("common_text_2561"))
	self.dh_gold, _ENV = self.text_tip.setString, self.text_tip.setString
	for i = 1, 5 do
		self.dh_gold[i] = SoraDGetChildByName(self, "dh_jinbi_0" .. i)
		_ENV = self
		self.beginOpacity = 0.7
		self.endOpacity = 1
		self.fadeIn = 0.5
		self.fadeOut = 0.5
		self.delay = 0.2
		SoraDFadeINOUT(self.dh_gold[i], self)
	end
	self.img_selected = SoraDGetChildByName(self, "sprite_selected")
	self.img_selected:setVisible(false)
	self.btn_buy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_buy")
	_ENV = "CCS_commonGoldNormalBtn_buy"
	self.btn_buy:initData("CCS_commonGoldNormalBtn_buy", 1)
	self.btn_buy:addTouchEventListener(handler(self, self.onBtnBuyClick))
	self:initBtn(fundStatus.received)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_growupfund")
	local scrollH = math.max(self.scroll:getContentSize().height, 600)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	self.node_content = SoraDGetChildByName(self.scroll, "Node_content")
	self.node_content:setPositionY(scrollH)
	self:addDoubleFireEffect()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_GROWUPFUND_BUY_BACK", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_GROWUPFUND_RECEIVE_BACK", handler(self, self.refreshView))
	self.rewards, _ENV = SoraDAddMessage, SoraDAddMessage
	self.curLv = 0
	self.curCastleLv = 0
	self.timer = nil
	self.isEnableReceive = false
	self.isAllReceived = false
	self:initData()
	self:initRewards()
end
function eventGrowupFund:addDoubleFireEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_flame1_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 48
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_flame2_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 78
	;(nil).x = 2.5
	_ENV, (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 2.5
	_ENV, (nil).plist = nil, "et_flame3_display.plist"
	;(nil).x = 33
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 48
	local param
	local parNode1 = SoraDCreateEffectNode(param)
	parNode1:addTo(SoraDGetChildByName(self, "frame_lace_base_1"), -2)
	local parNode2 = SoraDCreateEffectNode(param)
	parNode2:addTo(SoraDGetChildByName(self, "frame_lace_base_2"), -2)
end
function eventGrowupFund:initData()
	local leftTime = growupFundCtrl:getBuyLeftTime()
	if 0 < leftTime and not self.timer then
		self.node_time:setVisible(true)
		self:activeTimeUp()
		self.icon_time:setPositionX(self.text_time:getPositionX() - self.text_time:getContentSize().width - 25)
		if SoraDFIsRA() then
			self.icon_time:setPositionX(self.text_time:getPositionX() + self.text_time:getContentSize().width + 25)
		end
		self.timer = SoradCreateTimer(self, handler(self, self.activeTimeUp))
	else
		self.node_time:setVisible(false)
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
	end
	local buyNeed = growupFundCtrl:getBuyCostArray()
	local needGold = buyNeed.costnum
	growupFundCtrl = handler(self, self.activeTimeUp)
	handler(self, self.activeTimeUp).gold = needGold
	handler(self, self.activeTimeUp).reward = GROWUPFUND_AWARD_GOLD
	self.text_info:setString(i18n("common_text_3472", handler(self, self.activeTimeUp)))
	self:refreshView()
end
function eventGrowupFund:activeTimeUp()
	local leftTime = growupFundCtrl:getBuyLeftTime()
	growupFundCtrl = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.text_time:setString(i18n("common_text_607", nil))
end
function eventGrowupFund:refreshView(target, data)
	self.isAllReceived = growupFundCtrl:getAllReceive()
	self.img_selected:setVisible(false)
	local rewardLvArray = growupFundCtrl:getRewardLvArray()
	self.isBought = growupFundCtrl:isAlreadyBuy()
	self.text_tip:setVisible(not self.isBought)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	self.curCastleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if not self.isBought then
		self:initBtn(fundStatus.enableBuy)
	else
		self.node_time:setVisible(false)
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		self.isEnableReceive = false
		for i = 1, #rewardLvArray do
			if not growupFundCtrl:isReceive(rewardLvArray[i]) then
				self.curLv = rewardLvArray[i]
				if self.curCastleLv >= self.curLv then
					self.isEnableReceive = true
				end
				break
			end
		end
		if self.isEnableReceive then
			self.img_selected:setVisible(true)
			self:initBtn(fundStatus.enableReward)
		else
			self:initBtn(fundStatus.received)
		end
	end
	for i = 1, #self.rewards do
		if self.rewards[i] then
			local isCanGet = growupFundCtrl:isCanReceive()
			local isReceive = growupFundCtrl:isReceive(rewardLvArray[i])
			if isCanGet and not isReceive and self.curCastleLv >= rewardLvArray[i] then
				self.rewards[i].setStatus(fundStatus.enableReward)
			end
			if self.curCastleLv >= rewardLvArray[i] and (not isCanGet or isReceive) then
				self.rewards[i].setStatus(fundStatus.received)
			end
			if self.curCastleLv < rewardLvArray[i] then
				self.rewards[i].setStatus(fundStatus.enableBuy)
			end
		end
	end
end
function eventGrowupFund:initBtn(status)
	local status = status or fundStatus.enableBuy
	if status == fundStatus.enableBuy then
		fundStatus = nil
		self.btn_buy:initData(nil, 1)
	else
		fundStatus = nil
		self.btn_buy:initData(nil, 0)
	end
	if status == fundStatus.enableBuy then
		local buyNeed = growupFundCtrl:getBuyCostArray()
		local needGold = buyNeed.costnum
		self.btn_buy:setTitleStr(i18n("common_text_282"))
		self.btn_buy:setGoldText(needGold)
		self.btn_buy:setTouchEnabled(true)
		self.btn_buy:setBright(true)
		self.btn_buy:setTag(fundStatus.enableBuy)
	elseif status == fundStatus.enableReward then
		self.btn_buy:setTitleText(i18n("common_text_1146"))
		self.btn_buy:setTitleColor(cc.c3b(230, 230, 230))
		self.btn_buy:setTouchEnabled(true)
		self.btn_buy:setBright(true)
		self.btn_buy:setTag(fundStatus.enableReward)
	elseif status == fundStatus.received then
		self.btn_buy:setTitleText(i18n("common_text_1146"))
		self.btn_buy:setTitleColor(cc.c3b(110, 110, 110))
		self.btn_buy:setBright(false)
		self.btn_buy:setTag(fundStatus.received)
	end
end
function eventGrowupFund:initRewards()
	local rewardLvArray = growupFundCtrl:getRewardLvArray()
	local quality = 1
	for i = 1, 8 do
		local _h = math.ceil(i / 4)
		local _l = i % 4
		if _l == 0 then
			_l = 4
		end
		if 3 < i then
			quality = i - 2
		end
		self.rewards[i] = self:getAwardSingle()
		self.rewards[i]:setPosition(cc.p(130 * _l - 325, -160 * _h - 20))
		if SoraDFIsRA() then
			self.rewards[i]:setPosition(cc.p(-130 * _l + 325, -160 * _h - 20))
		end
		self.rewards[i]:addTo(self.node_content)
		local lvReward = growupFundCtrl:getRewardByLv(rewardLvArray[i])
		self.rewards[i].setItem(lvReward, quality, rewardLvArray[i])
		if not self.isBought then
			self.rewards[i].setStatus(fundStatus.enableBuy)
		else
			local isCanGet = growupFundCtrl:isCanReceive()
			local isReceive = growupFundCtrl:isReceive(rewardLvArray[i])
			if isCanGet and not isReceive and self.curCastleLv >= rewardLvArray[i] then
				self.rewards[i].setStatus(fundStatus.enableReward)
			end
			if self.curCastleLv >= rewardLvArray[i] and (not isCanGet or isReceive) then
				self.rewards[i].setStatus(fundStatus.received)
			end
			if self.curCastleLv < rewardLvArray[i] then
				self.rewards[i].setStatus(fundStatus.enableBuy)
			end
		end
	end
end
function eventGrowupFund:onBtnBuyClick(button, event)
	if event == ccui.TouchEventType.ended then
		if button:getTag() == fundStatus.enableBuy then
			growupFundCtrl:sendBuyGrowUpFund()
		elseif button:getTag() == fundStatus.enableReward then
			growupFundCtrl:sendReceive(self.curLv)
		elseif button:getTag() == fundStatus.received and not self.isAllReceived then
			_ENV = nil
			;(nil).lv = self.curLv
			SoraDShowMsgTip(i18n("common_text_2563", nil))
		end
	end
end
function eventGrowupFund:getAwardSingle()
	local single = SoraDGetChildByName(self, "Node_award"):clone()
	local base_bg = SoraDGetChildByName(single, "item_base_bg")
	local item = SoraDGetChildByName(single, "Image_item")
	local btn_show = SoraDGetChildByName(single, "Button_touch")
	btn_show:setSwallowTouches(false)
	btn_show:addTouchEventListener(function(button, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local award = growupFundCtrl:getRewardByLv(single.lv)
			if award and next(award) then
				local _ENV, reward = next(award), next(award)
				table.insert(reward, award.rewardid)
				table.insert(reward, award.rewardnum)
				local panel = SoraDCreatePanel("rewardDetailView")
				panel:initData(reward)
				panel:show()
			end
		end
	end)
	function single.setItem(award, quality, lv)
		base_bg:loadTexture("frame_item_base_0" .. quality .. ".png", ccui.TextureResType.plistType)
		local itemNum = SoraDGetChildByName(single, "Text_count")
		itemNum:setString(award.rewardnum)
		local labLv = SoraDGetChildByName(single, "Text_lv")
		base_bg = nil
		;(nil).lv = lv
		labLv:setString(i18n("common_text_100", nil))
		single.lv = lv
	end
	function single.setStatus(status)
		local sp_selected = SoraDGetChildByName(single, "sprite_selected")
		local img_got = SoraDGetChildByName(single, "Image_got")
		if status == fundStatus.enableReward then
			sp_selected:setVisible(true)
			img_got:setVisible(false)
		elseif status == fundStatus.received then
			sp_selected:setVisible(false)
			img_got:setVisible(true)
			base_bg:getVirtualRenderer():setState(1)
			item:getVirtualRenderer():setState(1)
		else
			sp_selected:setVisible(false)
			img_got:setVisible(false)
		end
	end
	return single
end
return eventGrowupFund
