local buildLogic = include("buildLogic")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local radiantDecreeRead = include("radiantDecreeRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RadiantDecreeBlessLightPanel = class("RadiantDecreeBlessLightPanel", baseFguiPanel)
function RadiantDecreeBlessLightPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RadiantDecreeBlessLightPanel:ctor", self.viewName)
end
function RadiantDecreeBlessLightPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ArtisanHouse"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "WiseTutor"
	end
	return self._packageList
end
function RadiantDecreeBlessLightPanel:onInit()
	self.fields.Button_Buy:fixPos()
	self.fields.Buff_Item1:fixPos()
	self.fields.Buff_Item2:fixPos()
	self.fields.Buff_Item3:fixPos()
	self.fields.Buff_Item4:fixPos()
	local lang = SoraDGetDefaultLanguage()
	if lang ~= "ar" and radiantDecreeCtrl:isMaxEffect() then
		self.fields.n29:setPositionX(self.fields.Text_GoldNum:getPositionX() + self.fields.Text_GoldNum:getWidth() + 80)
	end
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Title3:setString(i18n("GloriousDecree_05"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_Tips:setColorinfo("#FFF0A9", "#FFF0A9")
	self.fields.Button_Buy:addClickListener(handler(self, self.onGuyGift))
	self.fields.Button_help:addClickListener(handler(self, self.onClickHelp))
	self.fields.Button_BuyOAP:addClickListener(handler(self, self.onGuyGift))
	self.controllers.c2:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function RadiantDecreeBlessLightPanel:onShow()
	local showNum = radiantDecreeCtrl:getShowNum()
	self.controllers.c3:setSelectedIndex(showNum == 3 and 0 or 1)
	if showNum == 3 then
		radiantDecreeCtrl = showNum == 3 and 0 or 1
		radiantDecreeCtrl, radiantDecreeCtrl, (showNum == 3 and 0 or 1).defaultClick = nil, nil, 1
		;(nil).title = i18n("rechare_activename_19047")
		radiantDecreeCtrl, (nil)[1], (nil).tag = nil, nil, 1
		;(nil).title = i18n("rechare_activename_19064")
		;(showNum == 3 and 0 or 1).tabsetArray, (nil)[2], (nil).tag = nil, nil, 2
		;(showNum == 3 and 0 or 1).callback = handler(self, self.onClickTab)
		self.fields.com_Tab:initView(showNum == 3 and 0 or 1)
		self.fields.Text_Title:setString(i18n("GloriousDecree_03"))
	else
		if showNum == 1 then
			self.fields.Text_Title:setString(i18n("GloriousDecree_20"))
		else
			self.fields.Text_Title:setString(i18n("GloriousDecree_21"))
		end
		self:onClickTab(showNum)
	end
end
function RadiantDecreeBlessLightPanel:updateView()
	self.fields.Text_Tips:initData(self.isStatusGift)
	local effectInfo = radiantDecreeRead.getNowEffectInfo()
	if self.isStatusGift then
		effectInfo = radiantDecreeRead.getNowStatueEffectInfo()
	end
	self.fields.Buff_Item1:initData2(effectInfo.EffectIcon[1] .. ".png", effectInfo.PrivilegeEffect[1], "#E6C8A1", "#BEBEBE")
	self.fields.Buff_Item2:initData2(effectInfo.EffectIcon[2] .. ".png", effectInfo.PrivilegeEffect[2], "#E6C8A1", "#BEBEBE")
	if effectInfo.EffectIcon[3] then
		self.fields.Buff_Item3:initData2(effectInfo.EffectIcon[3] .. ".png", effectInfo.PrivilegeEffect[3], "#E6C8A1", "#BEBEBE")
	else
		self.fields.Buff_Item3:setVisible(false)
	end
	if effectInfo.EffectIcon[4] then
		self.fields.Buff_Item4:initData2(effectInfo.EffectIcon[4] .. ".png", effectInfo.PrivilegeEffect[4], "#E6C8A1", "#BEBEBE")
	else
		self.fields.Buff_Item4:setVisible(false)
	end
	self.giftInfo = radiantDecreeRead.getGiftAwardInfo(radiantDecreeCtrl:getGiftIndex(self.isStatusGift), self.isStatusGift)
	dump(self.giftInfo, "Fjksdjfkrtrtrdjfkdjfk")
	self.fields.Button_BuyOAP:initData(nil, nil, self.giftInfo.RechargeID)
	local nowPrice = paymentManager.judgePrice(self.giftInfo.RechargeID, self.giftInfo.Price)
	local discount = self.giftInfo.OriginalPrice / self.giftInfo.Price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.RechargeID, nowPrice, discount, self.giftInfo.OriginalPrice)
	self.fields.Button_Buy:initData(nowPrice, oriPrice, self.giftInfo.RechargeID)
	_ENV = nowPrice
	nowPrice[1] = "id"
	nowPrice[2] = "count"
	self.giftAward = serviceFunctions.tableFormat(self.giftInfo.Rewards, nowPrice)
	self.fields.Text_GoldNum:setString(string.formatnumberthousands(self.giftInfo.Gold))
	_, self.allSpecialAward = radiantDecreeRead.getAllAwardByIndex(radiantDecreeCtrl:getLevelIndex())
	_ENV = radiantDecreeCtrl:getLevelIndex()
	radiantDecreeCtrl:getLevelIndex()[1] = "id"
	radiantDecreeCtrl:getLevelIndex()[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(self.allSpecialAward, radiantDecreeCtrl:getLevelIndex())
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
end
function RadiantDecreeBlessLightPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function RadiantDecreeBlessLightPanel:onItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1].id, self.allSpecialAward[index + 1].count)
end
function RadiantDecreeBlessLightPanel:onGuyGift(eventContext)
	local name = eventContext:getSender():getName()
	SoraDPlaySound()
	if self.isStatusGift then
		if radiantDecreeCtrl:isUnLockStatue() then
			_ENV = nil
			;(nil).name = i18n("GloriousDecree_30")
			SoraDShowMsgTip(i18n("GloriousDecree_13", nil))
			return
		end
	elseif radiantDecreeCtrl:isUnLock() then
		_ENV = i18n("GloriousDecree_13", nil)
		i18n("GloriousDecree_13", nil).name = i18n("GloriousDecree_29")
		SoraDShowMsgTip(i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)))
		return
	end
	if not self.isStatusGift and SoraDGetBuildStarLv() >= radiantDecreeRead.getMaxEffectLevel() then
		_ENV = i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil))
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).cancleColorIndex = 0
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).content = i18n("GloriousDecree_31")
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).confirmString = i18n("common_text_204")
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).cancelString = i18n("common_text_185")
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).confirmFunc = function()
			self:showBuyMessageBox(name)
		end
		uiManager:show("MessageBox", i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)))
	elseif self.isStatusGift and SoraDGetBuildStarLv(BUILDID.STAR_BRAVE_STATUE) >= radiantDecreeRead.getMaxEffectLevel(true) then
		_ENV = i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil))
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).cancleColorIndex = 0
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).content = i18n("GloriousDecree_41")
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).confirmString = i18n("common_text_204")
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).cancelString = i18n("common_text_185")
		i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)).confirmFunc = function()
			self:showBuyMessageBox(name)
		end
		uiManager:show("MessageBox", i18n("GloriousDecree_13", i18n("GloriousDecree_13", nil)))
	else
		self:showBuyMessageBox(name)
	end
end
function RadiantDecreeBlessLightPanel:showBuyMessageBox(name)
	dump(name, "Fksdlfdjfkdjfk")
	local giftName = self.isStatusGift and "GloriousDecree_30" or "GloriousDecree_29"
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY)
	local leftTime = eventTime.timerNode.timer:getRemainTime()
	_ENV = nil
	;(nil).cancleColorIndex = 0
	_ENV = nil
	;(nil).name = i18n(giftName)
	_ENV = giftName
	giftName.name = i18n(giftName)
	_ENV, _ENV, giftName.time = leftTime, SoraDConvertSecondToString(leftTime), SoraDConvertSecondToString(leftTime)
	_ENV, leftTime.color = nil, "#70C723"
	SoraDConvertSecondToString(leftTime).time, leftTime.__default, (nil).color = leftTime, nil, "#D7C39B"
	;(nil).content = i18n("GloriousDecree_10", nil) .. "\n" .. i18n_html("GloriousDecree_11", giftName, (SoraDConvertSecondToString(leftTime)))
	;(nil).confirmString = i18n("common_text_282")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		if name == "Button_Buy" then
			if self.isStatusGift then
				radiantDecreeCtrl:reqRadiantDecreeStatueGift()
			else
				radiantDecreeCtrl:reqRadiantDecreeGift()
			end
			paymentManager.OnemtReadyBuy(self.giftInfo.RechargeID, gRechargeActiveFromEnum.ROAD32)
		elseif name == "Button_BuyOAP" then
			dump(self.giftInfo.RechargeID, "fjksdfjkdjfkdjfk")
			name = nil
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD32
			SoraDShowH5PurchaseView(self.giftInfo.RechargeID, param, nil)
		end
		self:removeFromParent()
	end
	uiManager:show("MessageBox", nil)
end
function RadiantDecreeBlessLightPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.title = i18n("Battle_Towers_23")
	local SoraDPlaySound.isStatue, param = self.isStatusGift, SoraDPlaySound
	uiManager:show("RadiantDecreeBuffPreview", param):setOwnerKey(self)
end
function RadiantDecreeBlessLightPanel:onClickTab(tag)
	self.isStatusGift = tag ~= 1
	print("self.isStatusGift", self.isStatusGift, tag, tag == 1)
	self.controllers.c4:setSelectedIndex(tag - 1)
	self:updateView()
end
return RadiantDecreeBlessLightPanel
