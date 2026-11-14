local rechargeltCtrl = include("rechargeltCtrl")
local heroGiftCtrl = SoraDGetCtrl("heroGiftCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroGiftRechargePanel = class("HeroGiftRechargePanel", baseFguiPanel)
function HeroGiftRechargePanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroGiftRechargePanel:ctor", self.viewName)
end
function HeroGiftRechargePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroGiftRechargePanel:onInit()
	print("=======HeroGiftRechargePanel:onInit")
	self.rechargeList = heroGiftCtrl:getRechargeList()
	self.pageIndex = 1
	self.fields.Button_right:addClickListener(handler(self, self.btnRightClick))
	self.fields.Button_left:addClickListener(handler(self, self.btnLeftClick))
	self.fields.List_point:setNeedAutoFix(false)
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
end
function HeroGiftRechargePanel:onShow()
	print("=======HeroGiftRechargePanel:onShow")
	if self.proxy.param and self.proxy.param.giftID then
		self:initDataWithGiftID(self.proxy.param.giftID)
	else
		self:updateView()
	end
end
function HeroGiftRechargePanel:initDataWithGiftID(giftID)
	print("giftID", giftID)
	self.pageIndex = self:getIndexByGiftID(giftID)
	self:updateView()
end
function HeroGiftRechargePanel:updateView()
	self.fields.List_point:setNumItems(math.min(23, #self.rechargeList))
	self:checkRechargeList()
	local giftInfo = rechargeltCtrl.getHeroRecruitInfo(self.rechargeList[self.pageIndex].heroID)
	_ENV = math.min(23, #self.rechargeList)
	math.min(23, #self.rechargeList).num = giftInfo.limitNum - self.rechargeList[self.pageIndex].buyNum
	math.min(23, #self.rechargeList).limitNum = giftInfo.limitNum
	self.fields.Text_Tips:setString(i18n("shop_text_16", math.min(23, #self.rechargeList)))
	self:updateHeroSpine()
	self.fields.Com_info:initData(self.rechargeList[self.pageIndex])
	self:updateOutAppPurchase()
end
function HeroGiftRechargePanel:checkRechargeList()
	if not self.rechargeList or not next(self.rechargeList) then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	if self.pageIndex > #self.rechargeList then
		self.pageIndex = #self.rechargeList
	end
	self.fields.List_point:setSelectedIndex(math.min(22, self.pageIndex - 1))
	if #self.rechargeList > 1 then
		self.fields.List_point:setVisible(true)
		self.fields.Button_right:setVisible(true)
		self.fields.Button_left:setVisible(true)
	else
		self.fields.List_point:setVisible(false)
		self.fields.Button_right:setVisible(false)
		self.fields.Button_left:setVisible(false)
	end
end
function HeroGiftRechargePanel:updateHeroSpine()
	local heroID = self.rechargeList[self.pageIndex].heroID
	local dressID = heroCtrl:getHeroDressSeting(heroID)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	self.fields.Spine:setVisible(not isUsm)
	self.fields.Usm:setVisible(isUsm)
	if isUsm then
		self.fields.Usm:clearEffect()
		if cfg.maxChunkSize then
			self.fields.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.fields.Usm:setEffectPath(spineCfg)
		self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm:setScale(cfg.detail[1])
		self.fields.Usm:setUsmAP(cc.p(0.5, 0))
		self.fields.Usm:setUsmPos(cc.p(cfg.detail[2], cfg.detail[3]))
	else
		self.fields.Spine:setEffectPath(spineCfg)
		self.fields.Spine:setScale(cfg.detail[1])
		self.fields.Spine:setSpinePos(cc.p(cfg.detail[2], cfg.detail[3]))
		self.fields.Spine.effect:setAutoCull(false)
	end
end
function HeroGiftRechargePanel:updateOutAppPurchase()
	local giftInfo = rechargeltCtrl.getHeroRecruitInfo(self.rechargeList[self.pageIndex].heroID)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.rechargeList[self.pageIndex].giftId, giftInfo.price)
	local discount = giftInfo.originalPrice / giftInfo.price
	local oriShowPrice = paymentManager.calculateDiscount(self.curGiftID, showPrice, discount, giftInfo.originalPrice)
	if SoraDCheckOAPIsOpen(self.rechargeList[self.pageIndex].giftId) then
		self.fields.Com_OutAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		rechargeltCtrl = false
		;(false).rid = self.rechargeList[self.pageIndex].giftId
		;(false).nowPrice = showPrice
		rechargeltCtrl, (false).oriPrice = self.rechargeList[self.pageIndex].giftId, oriShowPrice
		;(false).logInfo, self.rechargeList[self.pageIndex].giftId.fromCenter = self.rechargeList[self.pageIndex].giftId, gRechargeActiveFromEnum.ROAD48
		;(false).handlePurchaseBack = handler(self, self.updateView)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.fields.Com_OutAppPurchaseButtons:initData(false)
	else
		self.fields.Com_OutAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:getChild("textNowPrice"):setString(showPrice)
		self.fields.Button_buy:getChild("oriShowPrice"):setString(oriShowPrice)
	end
end
function HeroGiftRechargePanel:btnBuyClick()
	SoraDPlaySound()
	SoraDShowLoading(self)
	_ENV = nil
	;(nil).rid = self.rechargeList[self.pageIndex].giftId
	heroGiftCtrl:reqHeroGiftBuy(nil)
end
function HeroGiftRechargePanel:btnRightClick()
	SoraDPlaySound()
	print("self.pageIndex", self.pageIndex)
	self.pageIndex = self.pageIndex + 1
	if self.pageIndex > #self.rechargeList then
		self.pageIndex = 1
	end
	self:updateView()
end
function HeroGiftRechargePanel:btnLeftClick()
	SoraDPlaySound()
	self.pageIndex = self.pageIndex - 1
	if self.pageIndex < 1 then
		self.pageIndex = #self.rechargeList
	end
	self:updateView()
end
function HeroGiftRechargePanel:getIndexByGiftID(giftID)
	for i, v in ipairs(self.rechargeList) do
		if v.giftId == tonumber(giftID) then
			return i
		end
	end
	return 1
end
function HeroGiftRechargePanel:msgCallBack(target, data)
	SoraDCloseLoading(self)
	if not heroGiftCtrl:getRechargeList() then
		local _ENV, rechargeList = heroGiftCtrl:getRechargeList(), heroGiftCtrl:getRechargeList()
	end
	if #rechargeList == 0 then
		self:close()
	else
		self.rechargeList = rechargeList
		self:updateView()
	end
end
return HeroGiftRechargePanel
