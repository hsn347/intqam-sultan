local gametop = gModuleMgr.getObject("gametop")
local celebrationActivenessTable = require_data("celebration_activeness", true)
local publicRead = include("publicRead")
local rechargeRead = include("rechargeRead")
local anniversaryCtrl = gametop.playertop_:getModule("anniversaryCtrl")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local anniversaryPackagePopView = class("anniversaryPackagePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("anniversaryPackagePopView")
	end
	return target
end)
local PANEL_HEIGHT = 120
function anniversaryPackagePopView:ctor()
	self:initControls()
end
function anniversaryPackagePopView:initControls()
	self.panelCut = SoraDGetChildByName(self, "Panel_cut")
	self.singleItem = SoraDGetChildByName(self, "scroll_Item")
	self.scroll = SoraDGetChildByName(self, "scroll")
	self.txtDiscount = SoraDGetChildByName(self, "Text_num")
	self.txtTitle = SoraDGetChildByName(self, "text_title")
	self.txtOriginalPrice = SoraDGetChildByName(self, "btn_text_left")
	self.txtNowPrice = SoraDGetChildByName(self, "btn_text_right")
	self.btnBuy = SoraDGetChildByName(self, "btn_Buy")
	self.txtState = SoraDGetChildByName(self, "Text_name")
	self.panelCut:setPositionY(display.height / 2)
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyCallback))
	self.packageData = nil
end
function anniversaryPackagePopView:initScroll()
	self.scroll:removeAllChildren()
	local rewardList = SoraDArrary2Table(self.packageData.gift)
	local scrollH = math.max(#rewardList * PANEL_HEIGHT, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for i = 1, #rewardList do
		local cell = self.singleItem:clone()
		cell:setPosition(cc.p(270, scrollH - (i - 1) * PANEL_HEIGHT))
		cell:addTo(self.scroll)
		local single = SoraDCreatePanel("eventGeocentricCell")
		single:initData(tonumber(rewardList[i].id), tonumber(rewardList[i].num))
		single:setClickDelegate(handler(self, self.singleCellClick))
		single:setPosition(cc.p(-200, -30))
		single:sendParentToButton(self)
		single:setScale(0.7)
		single:hideInChristmasTreeMaking()
		single:addTo(cell)
		local txtName = SoraDGetChildByName(cell, "text_name")
		txtName:setString(publicRead.getName(tonumber(rewardList[i].id)))
		local txtNum = SoraDGetChildByName(cell, "text_num")
		txtNum:setString("x" .. tonumber(rewardList[i].num))
	end
end
function anniversaryPackagePopView:initData(packageData, buyIndex)
	self.packageData = packageData
	local maxPoint = self:getCelebrationActivenessMaxByIndex(buyIndex)
	self.maxPoint = maxPoint
	self.buyIndex = buyIndex
	self.txtDiscount:setString(self.packageData.discount[2] .. "%")
	self.txtOriginalPrice:setString("US $" .. self.packageData.originalPrice)
	self.txtNowPrice:setString("US $" .. self.packageData.price)
	self.btnBuy:setTag(self.packageData.ID)
	if anniversaryCtrl:getPlayerActiveness() < self.maxPoint then
		self.txtState:setString(i18n("celebration_text_06"))
		self.btnBuy:setColor(cc.c3b(120, 120, 120))
	else
		self.txtState:setString(i18n("celebration_text_02"))
		self.btnBuy:setColor(cc.c3b(255, 255, 255))
	end
	local info = rechargeRead.getPageViewData(self.packageData.ID)
	if info then
		self.txtTitle:setString(i18n(info.activeName))
	end
	self:initScroll()
end
function anniversaryPackagePopView:singleCellClick(pItem)
end
function anniversaryPackagePopView:btnBuyCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local totalData = self:getRechargeListDataByIndex(self.buyIndex)
		if anniversaryCtrl:getPlayerActiveness() < self.maxPoint then
			SoraDShowMsgTip(i18n("celebration_text_03"))
			return
		end
		if totalData.isCantBuy then
			SoraDShowMsgTip(i18n("common_text_3833"))
			return
		end
		paymentManager.normalGiftBuyClassify(button:getTag())
	end
end
function anniversaryPackagePopView:getRechargeListDataByIndex(index)
	local list = rechargeActivityCtrl:getAnniversaryPackageList()
	return list[index]
end
function anniversaryPackagePopView:getCelebrationActivenessMaxByIndex(index)
	if celebrationActivenessTable.data[index] then
		return celebrationActivenessTable.data[index].Unlockpoint
	else
		return 0
	end
end
return anniversaryPackagePopView
