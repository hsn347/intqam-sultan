local heroJailCtrl = SoraDGetCtrl("heroJailCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroRansomBoardPanel = class("HeroRansomBoardPanel", baseFguiPanel)
function HeroRansomBoardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroRansomBoardPanel:ctor", self.viewName)
end
function HeroRansomBoardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroRansomBoardPanel:onInit()
	print("=======HeroRansomBoardPanel:onInit")
	self.resNodes, _ENV = print, print
	self.minResNum = 0
	self.curResId = nil
	self.heroFlagID = self.proxy.param.heroFlagID
	self.heroID = self.proxy.param.heroID
	if self.heroID then
		self.fields.Panel_bg:setString(i18n("hero_btn_02"))
		self.fields.Text_selectTip:setString(i18n("hero_text_20"))
		self.fields.Text_Tips:setString(i18n("hero_text_19"))
	elseif self.heroFlagID then
		self.fields.Panel_bg:setString(i18n("prison_btn_03"))
		self.fields.Text_selectTip:setString(i18n("prison_text_15"))
		self.fields.Text_Tips:setString(i18n("prison_text_13"))
	end
	self.fields.Panel_touch:addClickListener(handler(self, self.onClickPanel))
	self.fields.Button_ok:setTitleText(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.Label_realGain:getChild("Text_realGain"):setString(i18n("prison_text_16"))
	_ENV = i18n("prison_text_16")
	i18n("prison_text_16").tax = gHeroRansomTax * 100
	self.fields.Text_tax:setString(i18n("hero_text_21", i18n("prison_text_16")))
	self.fields.Com_slider:setSliderCallBack(handler(self, self.sliderBack))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addEventListener(fgui.UIEventType.Click, handler(self, self.onClickItem))
	self.fields.List:setNumItems(#gHeroRansomRes)
end
function HeroRansomBoardPanel:onShow()
	print("=======HeroRansomBoardPanel:onShow")
	if self.heroID then
		self.heroInfo = heroJailCtrl:getHerosInOtherPrisonByID(self.heroID)
	elseif self.heroFlagID then
		self.heroInfo = heroJailCtrl:getHerosInMyPrisonByID(self.heroFlagID)
	end
	self:initView()
end
function HeroRansomBoardPanel:initView(...)
	if self.heroFlagID and self.heroInfo.ransomData and next(self.heroInfo.ransomData) then
		for i, v in ipairs(gHeroRansomRes) do
			if v == self.heroInfo.ransomData.id then
				self.fields.List:setSelectedIndex(i - 1)
				self:updateChooseIndex(i, self.heroInfo.ransomData.num)
			end
		end
	elseif self.heroID and self.heroInfo.rewardData and next(self.heroInfo.rewardData) then
		self.fields.Panel_touch:setVisible(true)
		for i, v in ipairs(gHeroRansomRes) do
			if v == self.heroInfo.rewardData.id then
				self.fields.List:setSelectedIndex(i - 1)
				self.minResNum = self.heroInfo.rewardData.num or 0
				self:updateChooseIndex(i, self.heroInfo.rewardData.num)
			end
		end
	else
		self.fields.List:setSelectedIndex(0)
		self:updateChooseIndex(1, gHeroRewardRansomMinMoney)
	end
end
function HeroRansomBoardPanel:onItemRederer(index, target)
	target:getChildByName("item"):initData(gHeroRansomRes[index + 1], 0)
end
function HeroRansomBoardPanel:onClickItem()
	local index = self.fields.List:getSelectedIndex() + 1
	SoraDPlaySound()
	self:updateChooseIndex(index)
end
function HeroRansomBoardPanel:onClickPanel()
	SoraDPlaySound()
	SoraDShowMsgTip(i18n("hero_text_56"))
end
function HeroRansomBoardPanel:updateChooseIndex(index, curValue)
	self.curResId = gHeroRansomRes[index]
	print("self.curResId", self.curResId)
	_ENV = self.curResId
	self.curResId.maxValue = gHeroRewardRansomMaxMoney[self.curResId]
	self.curResId.minValue = 1
	self.curResId.curValue = curValue or self.fields.Com_slider:getSliderCurValue()
	self.fields.Com_slider:initData(self.curResId)
	self.fields.Label_realGain:setIcon(publicRead.getSmallIcon(self.curResId))
end
function HeroRansomBoardPanel:sliderBack(curValue)
	self.fields.Label_realGain:setText(string.formatnumberthousands(math.floor(curValue * (1 - gHeroRansomTax))))
end
function HeroRansomBoardPanel:btnOkClick()
	SoraDPlaySound()
	if not self.curResId then
		SoraDShowMsgTip(i18n("hero_text_57"))
		return
	end
	local resNum = tonumber(self.fields.Com_slider:getSliderCurValue())
	if not resNum then
		SoraDShowMsgTip(i18n("hero_text_58"))
		return
	elseif resNum <= self.minResNum then
		_ENV = i18n("hero_text_58")
		i18n("hero_text_58").num = self.minResNum
		SoraDShowMsgTip(i18n("hero_text_59", i18n("hero_text_58")))
		return
	elseif resNum > gHeroRewardRansomMaxMoney[self.curResId] then
		_ENV = i18n("hero_text_59", i18n("hero_text_58"))
		i18n("hero_text_59", i18n("hero_text_58")).num = string.formatnumberthousands(gHeroRewardRansomMaxMoney[self.curResId])
		SoraDShowMsgTip(i18n("hero_text_60", i18n("hero_text_59", i18n("hero_text_58"))))
		return
	elseif resNum < gHeroRewardRansomMinMoney then
		_ENV = i18n("hero_text_60", i18n("hero_text_59", i18n("hero_text_58")))
		i18n("hero_text_60", i18n("hero_text_59", i18n("hero_text_58"))).num = string.formatnumberthousands(gHeroRewardRansomMinMoney)
		SoraDShowMsgTip(i18n("hero_text_61", i18n("hero_text_60", i18n("hero_text_59", i18n("hero_text_58")))))
		return
	end
	_ENV = SoraDShowMsgTip
	SoraDShowMsgTip.id = self.curResId
	local SoraDShowMsgTip.num, resList = resNum, SoraDShowMsgTip
	if self.heroID then
		local resCount = math.floor(cityCtrl:getResCount(self.curResId))
		local safeNum = math.floor(cityCtrl:getSafeRes(self.curResId))
		local resCurNum = resCount - safeNum
		if resNum > resCurNum then
			SoraDShowMsgTip(i18n("hero_text_90"))
			return
		end
		_ENV = i18n("hero_text_90")
		i18n("hero_text_90").content = i18n("hero_text_22")
		i18n("hero_text_90").confirmString = i18n("common_text_204")
		i18n("hero_text_90").confirmFunc = function()
			SoraDShowLoading(self)
			heroJailCtrl:reqOfferReward(self.heroInfo.heroID, self.heroInfo.wardenUid, resList)
		end
		uiManager:show("MessageBox", i18n("hero_text_90")):setOwnerKey(self)
	elseif self.heroFlagID then
		SoraDShowLoading(self)
		heroJailCtrl:reqSetRansom(self.heroInfo.heroID, self.heroInfo.ownerUid, resList)
	end
end
return HeroRansomBoardPanel
