local activity_9001711_Read = include("activity_9001711_Read")
local activity_9001711_Ctrl = SoraDGetCtrl("activity_9001711_Ctrl")
local rechargeRead = include("rechargeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001711_MainPanel = class("Activity_9001711_MainPanel", baseFguiPanel)
function Activity_9001711_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001711_MainPanel.super.ctor(self, ...)
	print("Activity_9001711_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001711
end
function Activity_9001711_MainPanel:onInit()
	print("=======Activity_9001711_MainPanel:onInit")
	self.comFilelds = fguiHelper.get_fields(self.fields.Com_9001711_Main)
	self.text_time = SoraDCreateTimerLabel(self, self.comFilelds.text_time)
	self.text_time:setTimeLast(function(ticket, timeNumber)
		return SoraDConvertSecondToString(timeNumber, " ")
	end)
	self.comFilelds.text_title:fixPos()
	self.comFilelds.text_des:fixPos()
	self.comFilelds.text_tip:setString(i18n("common_text_789"))
	self.comFilelds.List_point:setNeedAutoFix(false)
	self.comFilelds.btn_left:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and 1 or -1)
	self.comFilelds.btn_right:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and -1 or 1)
	self.comFilelds.list_rewards:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001711_MainPanel:endShow()
	print("=======Activity_9001711_MainPanel:endShow")
	self.curPage = 1
	self.popGfit = self.param and self.param.popGfit
	self:updateData()
end
function Activity_9001711_MainPanel:updateData()
	local giftList = activity_9001711_Ctrl:getGiftList()
	self.showGfitList, activity_9001711_Ctrl = activity_9001711_Ctrl, activity_9001711_Ctrl
	local systemTime = serviceFunctions.systemTime()
	for _, v in pairs(giftList) do
		if systemTime < v.buyEndTime then
			for rid, v2 in pairs(v.giftMap) do
				if v2.remainNum > 0 then
					local activity_9001711_Ctrl, data = v2.remainNum, v2.remainNum
					data.rid = tonumber(rid)
					data.remainNum = v2.remainNum
					data.buyEndTime = v.buyEndTime
					data.cfg = activity_9001711_Read.getRechargeCfg(rid)
					table.insert(self.showGfitList, data)
				end
			end
		end
	end
	table.sort(self.showGfitList, function(a, b)
		if a.cfg.operation_type == b.cfg.operation_type then
			return a.cfg.price < b.cfg.price
		else
			return a.cfg.operation_type < b.cfg.operation_type
		end
	end)
	if #self.showGfitList > 0 then
		self.comFilelds.List_point:setNumItems(#self.showGfitList)
		if self.popGfit then
			for i, v in ipairs(self.showGfitList) do
				if self.popGfit.giftMap[tostring(v.rid)] then
					self.curPage = i
					break
				end
			end
			self.popGfit = nil
		end
		self:updateView()
	else
		self:close()
	end
end
function Activity_9001711_MainPanel:updateView()
	self.curPage = math.min(self.curPage, #self.showGfitList)
	local isAddEnable = self.showGfitList[self.curPage + 1] ~= nil
	local isMinEnable = self.showGfitList[self.curPage - 1] ~= nil
	if SoraDFIsRA() then
		self.comFilelds.btn_left:setVisible(isAddEnable)
		self.comFilelds.btn_right:setVisible(isMinEnable)
		self.comFilelds.List_point:setSelectedIndex(#self.showGfitList - self.curPage)
	else
		self.comFilelds.btn_left:setVisible(isMinEnable)
		self.comFilelds.btn_right:setVisible(isAddEnable)
		self.comFilelds.List_point:setSelectedIndex(self.curPage - 1)
	end
	self.curGift = self.showGfitList[self.curPage]
	self.rid = self.curGift.rid
	self.rewards = clone(self.curGift.cfg.rewards)
	_ENV = self.curPage - 1
	;(self.curPage - 1).id = gIDDef.GOLD
	;(self.curPage - 1).count = self.curGift.cfg.gold
	table.insert(self.rewards, self.curPage - 1)
	self.comFilelds.list_rewards:setNumItems(#self.rewards)
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, self.curGift.remainNum, self.curGift.remainNum
	self.curGift.remainNum.num, (nil).color = nil, "#FFD43E"
	self.comFilelds.text_num:setString(i18n_html("common_text_2516", nil, self.curGift.remainNum))
	self.text_time:beginTime(self.curGift.buyEndTime - serviceFunctions.systemTime())
	local giftCfg = self.curGift.cfg
	self.giftCfg = giftCfg
	local rechargeCfg = rechargeRead.getPageViewData(self.rid)
	_ENV = rechargeCfg.activeName
	rechargeCfg.activeName.color = "#FFFB90,#EB6C14"
	self.comFilelds.text_title:setString(SoraDWrapHtmlTagByStyle(i18n(rechargeCfg.activeName), rechargeCfg.activeName))
	self.comFilelds.text_des:setString(i18n(rechargeCfg.activeExplain))
	self.comFilelds.Lab_discount:setTitle(tostring(math.floor(giftCfg.discount[2] / giftCfg.discount[1])) .. "%")
	local showPrice, isGetPrice = paymentManager.judgePrice(self.rid, giftCfg.price)
	local discount = giftCfg.originalPrice / giftCfg.price
	local oriShowPrice = paymentManager.calculateDiscount(self.rid, showPrice, discount, giftCfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
end
function Activity_9001711_MainPanel:onPageClick(sender, params)
	SoraDPlaySound()
	local curIndex = self.curPage + params
	if self.showGfitList[curIndex] == nil then
		if curIndex >= #self.showGfitList then
			curIndex = #self.showGfitList
		else
			curIndex = 1
		end
	end
	self.curPage = curIndex
	self:updateView()
end
function Activity_9001711_MainPanel:onItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
	if index < (self.curGift.cfg.highlight or 0) then
		obj:setEffect(2)
	else
		obj:hideEffect()
	end
end
function Activity_9001711_MainPanel:updateOutAppPurchase()
	self.comFilelds.Com_OutAppPurchaseButtons:setVisible(true)
	_ENV = true
	;(true).rid = self.giftCfg.rechargeID
	;(true).nowPrice = self.nowPrice
	_ENV, (true).oriPrice = self.oriPrice, self.oriPrice
	;(true).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD61
	;(true).handleBuyClick = handler(self, self.btnBuyClick)
	;(true).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.comFilelds.Com_OutAppPurchaseButtons:initData(true)
end
function Activity_9001711_MainPanel:onClickItemBuyGift()
	SoraDPlaySound()
	return true
end
function Activity_9001711_MainPanel:btnBuyClick()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.rid)
	paymentManager.OnemtReadyBuy(self.rid, gRechargeActiveFromEnum.ROAD61)
end
return Activity_9001711_MainPanel
