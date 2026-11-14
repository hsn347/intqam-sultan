local baseComponent = require("fgui.base.baseComponent")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local exclusiveVipRead = include("exclusiveVipRead")
local publicRead = include("publicRead")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local rechargeRead = include("rechargeRead")
local backpackltCtrl = include("backpackltCtrl")
local Com_nodePackage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://svipCenterView/Com_nodePackage", Com_nodePackage)
function Com_nodePackage:onInit()
	self.Panel_1 = self.fields.Panel_1
	self.txtHigher = self.fields.txtHigher
	self.Text_name = self.fields.Text_name
	self.Bottom_Button_buy = self.fields.Bottom_Button_buy
	self.Top_Button_left = self.fields.Top_Button_left
	self.Top_Button_right = self.fields.Top_Button_right
	self.txtNoPackge = self.fields.txtNoPackge
	self.imgPackage = self.fields.imgPackage
	self.scrollPackage = self.fields.scrollPackage
	self.text_resourceTotal = self.fields.text_resourceTotal
	self.Text_once = self.fields.Text_once
	self.Text_gold = self.fields.Text_gold
	self.text_instance = self.fields.text_instance
	self.Node_discount_icon = self.fields.Node_discount_icon
	self.Text_discount = self.fields.Text_discount
	self.outAppPurchaseButtons = self.fields.outAppPurchaseButtons
	self.frame_mrth_bg_01_59 = self.fields.frame_mrth_bg_01_59
	local tmpFields = fguiHelper.get_fields(self.fields.Bottom_Button_buy)
	self.Text_oriPrice = tmpFields.Text_Orige
	self.Text_nowPrice = tmpFields.Text_Price
	self.text_instance:setString(i18n("common_text_4061"))
	self.curPackageIndex = 1
	self.txtHigher:setString(i18n("privilege_text_26"))
	self.Bottom_Button_buy:addClickEventListener(handler(self, self.btnBuyClick))
	self.Top_Button_left:addClickEventListener(handler(self, self.btnLeftClick))
	self.Top_Button_right:addClickEventListener(handler(self, self.btnRightClick))
	self.fields.Text_once:fixPos()
	self.fields.Text_gold:fixPos()
	self.fields.text_instance:fixPos()
	self.fields.p_image_gold:fixPos()
	self.fields.rechargeGift:fixPos()
	self.fields.rechargeGift:fixNodePos()
end
function Com_nodePackage:onShow()
end
function Com_nodePackage:initData()
	local totalRecharge = premiumStoreCtrl:getDollor()
	local packageList = exclusiveVipRead:getRechargeGiftInfo(totalRecharge)
	if not packageList[self.curPackageIndex] then
		self.curPackageIndex = 1
	end
	self:initPrivilegePackages(packageList)
end
function Com_nodePackage:initPrivilegePackages(packageList)
	self.Panel_1:setVisible(0 < #packageList)
	self.txtNoPackge:setVisible(#packageList <= 0)
	self.txtNoPackge:setString(i18n("privilege_text_132"))
	if packageList and next(packageList) then
		self.Top_Button_left:setVisible(1 < #packageList)
		self.Top_Button_right:setVisible(1 < #packageList)
		print("索引是什么：", self.curPackageIndex)
		local packageInfo = packageList[self.curPackageIndex]
		local curPrice = paymentManager.judgePrice(packageInfo.rechargeID, packageInfo.price)
		local discount = packageInfo.originalPrice / packageInfo.price
		local oriPrice = paymentManager.calculateDiscount(packageInfo.rechargeID, curPrice, discount, packageInfo.originalPrice)
		local packageName = i18n(rechargeRead.getPageViewData(packageList[self.curPackageIndex].rechargeID).activeName)
		local alreadyBuyTimes = exaltedPrivilegeCtrl:getPackageBoughtNums(packageInfo.rechargeID)
		local remainTimes = packageInfo.extraData - alreadyBuyTimes
		local imgBanner = rechargeRead.getPageViewData(packageInfo.rechargeID).popBanner
		self.Text_name:setString(packageName)
		self.Text_oriPrice:setString(oriPrice)
		self.Text_nowPrice:setString(curPrice)
		self.nowPrice = curPrice
		self.oriPrice = oriPrice
		_ENV = i18n("privilege_text_132")
		_ENV, _ENV, i18n("privilege_text_132").num = i18n("privilege_text_132")
		i18n("privilege_text_132").num, i18n("privilege_text_132").color = i18n("privilege_text_132")
		self.text_resourceTotal:setString(i18n_html("common_text_4484", i18n("privilege_text_132")))
		_ENV = i18n_html("common_text_4484", i18n("privilege_text_132"))
		i18n_html("common_text_4484", i18n("privilege_text_132")).num = packageInfo.extraData
		self.Text_once:setString(i18n("common_text_4485", i18n_html("common_text_4484", i18n("privilege_text_132"))))
		self.imgPackage:setIcon(imgBanner)
		if 1 == packageInfo.discount[1] then
			self.Text_discount:setVisible(true)
			self.Node_discount_icon:setVisible(false)
			self.frame_mrth_bg_01_59:setVisible(true)
			_ENV = i18n("common_text_4485", i18n_html("common_text_4484", i18n("privilege_text_132")))
			i18n("common_text_4485", i18n_html("common_text_4484", i18n("privilege_text_132"))).num = math.floor(packageInfo.discount[2])
			i18n("common_text_4485", i18n_html("common_text_4484", i18n("privilege_text_132"))).char = "%"
			self.Text_discount:setString(i18n("common_text_1470", i18n("common_text_4485", i18n_html("common_text_4484", i18n("privilege_text_132")))))
		elseif 2 == packageInfo.discount[1] then
			self.Text_discount:setVisible(false)
			self.Node_discount_icon:setVisible(true)
			self.frame_mrth_bg_01_59:setVisible(false)
			if self.imgOcx then
				self.imgOcx:removeFromParent()
				self.imgOcx = nil
			end
			local rechargeRead = include("rechargeRead")
			local img = rechargeRead.getPromoIcon(packageInfo.discount[2]).icon
			self.Node_discount_icon:setURL(img)
		end
		self.Text_gold:setString(string.formatnumberthousands(packageInfo.gold))
		self.Bottom_Button_buy:setTag(packageInfo.rechargeID)
		self.rechargeID = packageInfo.rechargeID
		self:initPackageScroll(packageInfo.rewards, packageInfo.rechargeID)
		if exclusiveVipRead:checkMoreRechargeGift(premiumStoreCtrl:getDollor()) then
			self.txtHigher:setString(i18n("privilege_text_26"))
		else
			self.txtHigher:setString(i18n("privilege_text_141"))
		end
		self:updateOutAppPurchase()
	end
	self.fields.Com_indicator:reserLastIndex()
	_ENV = packageInfo.originalPrice / packageInfo.price
	;(packageInfo.originalPrice / packageInfo.price).count = packageList and table.nums(packageList) or 1
	;(packageInfo.originalPrice / packageInfo.price).intervalWidth = 8
	;(packageInfo.originalPrice / packageInfo.price).begin = self.curPackageIndex or 1
	self.fields.Com_indicator:initData(packageInfo.originalPrice / packageInfo.price)
end
function Com_nodePackage:btnLeftClick(button, eventType)
	SoraDPlaySound()
	print("向左")
	local totalRecharge = premiumStoreCtrl:getDollor()
	local packageList = exclusiveVipRead:getRechargeGiftInfo(totalRecharge)
	self.curPackageIndex = self.curPackageIndex - 1
	if self.curPackageIndex < 1 then
		self.curPackageIndex = #packageList
	end
	self:initPrivilegePackages(packageList)
end
function Com_nodePackage:btnRightClick(button, eventType)
	SoraDPlaySound()
	print("向右")
	local totalRecharge = premiumStoreCtrl:getDollor()
	local packageList = exclusiveVipRead:getRechargeGiftInfo(totalRecharge)
	self.curPackageIndex = self.curPackageIndex + 1
	if self.curPackageIndex > #packageList then
		self.curPackageIndex = 1
	end
	self:initPrivilegePackages(packageList)
end
function Com_nodePackage:purchaseBack()
	SoraDShowMsgTip(i18n("privilege_text_25"))
	local totalRecharge = premiumStoreCtrl:getDollor()
	local packageList = exclusiveVipRead:getRechargeGiftInfo(totalRecharge)
	if not packageList[self.curPackageIndex] then
		self.curPackageIndex = 1
	end
	self.Panel_1:setVisible(0 < #packageList)
	self.txtNoPackge:setVisible(#packageList <= 0)
	self:initPrivilegePackages(packageList)
end
function Com_nodePackage:btnBuyClick(button, eventType)
	SoraDPlaySound()
	exaltedPrivilegeCtrl:reqBuyGift(self.rechargeID)
	SoraDShowLoading()
end
function Com_nodePackage:initPackageScroll(rewards, id)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	rewards = serviceFunctions.tableFormat(rewards, nil)
	local rechargePresentUtil = include("rechargePresentUtil")
	local fixData = rechargePresentUtil.fixRechargePresentData(id, rewards)
	rewards = fixData.gift
	self.scrollPackage:setItemRenderer(function(index, item)
		local v = rewards[index + 1]
		item:fixChildrenPos()
		local fields = fguiHelper.get_fields(item)
		fields.Image_itemBuff:initData(v.id)
		fields.cell_bg:setVisible(index % 2 == 0)
		fields.Text_itemName:setString(publicRead.getName(v.id))
		if publicRead.checkLevelCondition(v.id) then
			fields.Text_itemName:setColor(display.COLOR_RED)
		end
		fields.Text_itemCount:setString("x" .. v.count)
		item:setTouchEnabled(true)
		if not item._added then
			item._added = true
			item:addClickEventListener(handler(self, self.itemClick))
		end
		item._goodID = tonumber(v.id)
		if rechargePresentUtil.checkShowHighLight(v.id) then
			local etNode = item.etNode
			if not etNode then
				etNode = SoraDCreatAnimation("animationCZS")
				item.etNode = etNode
				etNode:setName("etNode")
				etNode:setScale(SoraDFIsRA() and 0.9 or -0.9)
				fields.Node_effect:setContent(etNode)
			end
			fields.Node_effect:setVisible(true)
		else
			fields.Node_effect:setVisible(false)
		end
	end)
	self.scrollPackage:setNumItems(#rewards)
end
function Com_nodePackage:itemClick(button, type)
	local resultType = backpackltCtrl:getResultType(button._goodID)
	if IsArClient and resultType == gItemEffectDef.KEY_OPEN or resultType == gItemEffectDef.SOLOMON_KEY then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("solomonKeyView")
		panel:initData(button._goodID)
		panel:show()
	end
end
function Com_nodePackage:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.rechargeID) then
		self.outAppPurchaseButtons:setVisible(true)
		self.Bottom_Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.rechargeID
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
	else
		self.outAppPurchaseButtons:setVisible(false)
	end
	_ENV, _UPVALUE1_ = self.outAppPurchaseButtons, self.outAppPurchaseButtons.setVisible
	self.outAppPurchaseButtons.rechargeID = self.rechargeID
	local self.outAppPurchaseButtons.setVisible[1], rechargeIDList = self.outAppPurchaseButtons, self.outAppPurchaseButtons.setVisible
	self.fields.rechargeGift:initData(rechargeIDList)
end
return Com_nodePackage
