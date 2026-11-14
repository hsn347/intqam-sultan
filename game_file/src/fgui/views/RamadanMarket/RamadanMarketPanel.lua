local publicRead = include("publicRead")
local msgNotice = include("msgNotice")
local everydayTaskCtrl = SoraDGetCtrl("everydayTaskCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local ramadanMarketCtrl = SoraDGetCtrl("ramadanMarketCtrl")
local ramadanMarketltCtrl = include("ramadanMarketltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanMarketPanel = class("RamadanMarketPanel", baseFguiPanel)
function RamadanMarketPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RamadanMarketPanel:ctor", self.viewName)
end
function RamadanMarketPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanMarketPanel:onInit()
	print("=======RamadanMarketPanel:onInit")
	self.activityID = gActivityTimeActivityID.RAMADAN_MARKET_ACTIVITY
	ramadanMarketCtrl:sendDataMsg()
	self.functionCol = self:initFunc()
	self.fields.Usm_1:setPrepareCallback(function()
		self.fields.n30:setVisible(false)
		self.fields.Usm_1:getCriSprite():start()
	end)
	self.fields.Com_title:initData(i18n("activity_name_9001416"), handler(self, self.onClickClose))
	self.fields.Text_tip:setString(i18n("ramddantent_text_01"))
	self.fields.Text_point:setString(i18n("ramadan_shop01"))
	self.fields.Text_num:setString(everydayTaskCtrl:calCurPoint())
	self.fields.Button_go:setTitleText(i18n("common_text_477"))
	self.fields.Button_gold:addClickEventListener(handler(self, self.onClickRecharge))
	self.fields.Button_go:addClickEventListener(handler(self, self.onClickGo))
	self.btnHandle = handler(self, self.onClickBuyGoods)
	self.fields.Label_time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("Tycoon_text_25", nil, nil)
	end)
	if display.width / display.height > 0.75 then
		self.fields.Label_time:setScale(1.1)
	end
	self.fields.List_discount:setItemRenderer(handler(self, self.onItemRenderer))
end
function RamadanMarketPanel:resizeBannerEffect()
	if not self.originSize then
		self.originSize = self.fields.n30:getSize()
	end
	local scale = self.view:getWidth() / self.originSize.width
	self.fields.Usm_1:setScale(scale, scale)
	self.fields.n30:setSize(self.view:getWidth(), self.originSize.height * scale)
	self.fields.Usm_1:setPositionY(self.fields.Usm_1:getPositionY() - (self.originSize.height - self.originSize.height * scale) * 0.5)
end
function RamadanMarketPanel:initData()
	self.fields.Label_time:initActivityTime(self.activityID)
	local haveGold = string.formatnumberthousands(string.format("%d", lordInfoCtrl:getBaseInfo().gold))
	self.fields.Button_gold:setTitleText(tostring(haveGold))
	self.onSaleData = ramadanMarketCtrl:getOnSaleInfo()
	self.onSaleArray = self:getSortArray()
	self.totalNum = table.nums(self.onSaleData)
	self.singleNum = (table.nums(self.onSaleData) + 1) / 2
	self.fields.List_discount:setNumItems(self.singleNum)
end
function RamadanMarketPanel:getSortArray()
	local _ENV, onSaleArray
	local index = 1
	for i, v in pairs(self.onSaleData) do
		onSaleArray[index] = v
		index = index + 1
	end
	table.sort(onSaleArray, function(a, b)
		return a.position < b.position
	end)
	return onSaleArray
end
function RamadanMarketPanel:initFunc()
	msgNotice = nil
	;(nil).init = function()
		self:initData()
	end
	;(nil).buy = function()
		self:initData()
		self = nil
		;(nil).itemID = self.itemID
		;(nil).count = self.buyCount
		msgNotice.notice("notice_0116", nil, gNoticeIconTypeDef.ICON_ITEM, self.itemID)
		self, msgNotice = nil, "notice_0116"
		;(nil).id = self.itemID
		;(nil).count = self.buyCount
		;("notice_0116")[1] = nil
		SoraDMailGainItems("notice_0116", true)
	end
	;(nil).refresh = function()
		self:initData()
	end
	local (nil).newday, functionCol = function()
		SoraDShowMsgTip("New day")
	end, nil
	return functionCol
end
function RamadanMarketPanel:showRewards()
	if not self.rewards then
		return
	end
	local _ENV, t = self.rewards, self.rewards
	for i, v in pairs(self.rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
end
function RamadanMarketPanel:refreshView(data)
	if not data then
		return
	end
	dump(data, "RamadanMarketPanel:refreshView")
	self.itemID = data.itemID
	self.buyCount = data.buyCount
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function RamadanMarketPanel:onClickBuyGoods(config)
	SoraDPlaySound()
	dump(config, "RamadanMarketPanel:onClickBuyGoods")
	if config.curActive < config.activeNum then
		_ENV = nil
		;(nil).content = i18n("ramadan_shop02")
		;(nil).confirmFunc = function()
			self:onClickGo()
		end
		;(nil).cancelFunc = function()
		end
		uiManager:show("MessageBox", nil)
		return
	end
	if config.alreadyBuyCount >= config.limitNum then
		SoraDShowMsgTip(i18n("common_text_2632"))
		return
	end
	if config.haveGold < config.discount then
		SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_424"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
			end
		end)
		return
	end
	local aviNum = math.floor(lordInfoCtrl:getBaseInfo().gold / config.discount)
	if aviNum >= config.limitNum then
		aviNum = config.limitNum
	end
	aviNum = aviNum - config.alreadyBuyCount
	_ENV, _ENV, _ENV = i18n("common_text_2632")
	i18n("common_text_2632").targetID = config.itemID
	i18n("common_text_2632").exchangeID = gIDDef.GOLD
	i18n("common_text_2632").singCount = config.discount
	i18n("common_text_2632").curNum = aviNum
	i18n("common_text_2632").huntCount = 10
	i18n("common_text_2632").exchangeData, i18n("common_text_2632").singleGet = i18n("common_text_2632")
	;(function(type)
		if type == MSGBOX_CALLBACK_YES then
			if GLOBAL_GAME_RECHARGE_MODE then
				uiManager:show("rechargeView")
			else
				SoraDCreatePanel("rechargeView"):show()
			end
		end
	end).exchangeCfg, i18n("common_text_2632").exchangeHandler = i18n("common_text_2632")
	uiManager:show("newShopSingleBuy", function(type)
		if type == MSGBOX_CALLBACK_YES then
			if GLOBAL_GAME_RECHARGE_MODE then
				uiManager:show("rechargeView")
			else
				SoraDCreatePanel("rechargeView"):show()
			end
		end
	end)
end
function RamadanMarketPanel:onItemRenderer(index, object)
	if index * 2 + 2 <= self.totalNum then
		object:initData(index + 1, self.btnHandle, self:getItemData(index * 2 + 1), self:getItemData(index * 2 + 2))
	else
		object:initData(index + 1, self.btnHandle, self:getItemData(index * 2 + 1), nil)
	end
end
function RamadanMarketPanel:getItemData(index)
	local id = tostring(self.onSaleArray[index].shopItemID)
	self.onSaleData[id].haveGold = lordInfoCtrl:getBaseInfo().gold
	self.onSaleData[id].curActive = everydayTaskCtrl:calCurPoint()
	return self.onSaleData[id]
end
function RamadanMarketPanel:onClickRecharge()
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
function RamadanMarketPanel:onClickGo()
	SoraDPlaySound()
	local guideId = "id:8"
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function RamadanMarketPanel:onShow()
	print("=======RamadanMarketPanel:onShow")
	self:resizeBannerEffect()
end
function RamadanMarketPanel:onHide()
	print("=======RamadanMarketPanel:onHide")
end
function RamadanMarketPanel:onDispose()
	print("=======RamadanMarketPanel:onDispose")
end
return RamadanMarketPanel
