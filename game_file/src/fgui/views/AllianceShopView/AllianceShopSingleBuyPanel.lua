local allianceltCtrl = include("allianceltCtrl")
local itemDesRead = include("itemDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceStore = gametop.playertop_:getModule("allianceStore")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceShopSingleBuyPanel = class("AllianceShopSingleBuyPanel", baseFguiPanel)
function AllianceShopSingleBuyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceShopSingleBuyPanel:ctor", self.viewName)
end
function AllianceShopSingleBuyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceShopSingleBuyPanel:onInit()
	print("=======AllianceShopSingleBuyPanel:onInit")
	self.fields.Button_Buy:addClickListener(handler(self, self.onBuy))
	self.fields.item:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.slider:setInpuBoxFixPos()
	self.fields.slider:setSliderCallBack(handler(self, self.payGoldChange))
end
function AllianceShopSingleBuyPanel:onShow()
	print("=======AllianceShopSingleBuyPanel:onShow")
	self.tableData = self.proxy.param.itemData
	dump(self.tableData, "self.tableData")
	self.curType = self.proxy.param.curType
	if self.curType and self.tableData.endtime then
		self.controllers.c1:setSelectedIndex(1)
		self:setLimited(self.tableData.endtime)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self:initData()
end
function AllianceShopSingleBuyPanel:initData()
	local havePoint = self.tableData.totalPoint
	self.fields.item:initData(self.tableData.itemID)
	local personalLimit = allianceltCtrl:getMaxBuyCount(self.tableData.itemID)
	local cMember = memberMgr:getOwnMember()
	local maxCount = self.tableData.itemCount or 9999
	if havePoint and self.tableData.price then
		maxCount = math.min(maxCount, math.max(1, math.floor(havePoint / self.tableData.price)))
	end
	if personalLimit and self.curType == gIDDef.ALLIANCE_HONOR then
		local aStoreBuyInfo = cMember:getProperty("aStoreBuyInfo")
		local itemID = tostring(self.tableData.itemID)
		local lastBuyTime = aStoreBuyInfo[itemID] and aStoreBuyInfo[itemID].time or 0
		local buyCount = 0
		if serviceFunctions.isSameDay(lastBuyTime) then
			buyCount = aStoreBuyInfo[itemID] and aStoreBuyInfo[itemID].count or 0
		end
		maxCount = math.min(maxCount, personalLimit - buyCount)
		self.fields.Text_resNotice:setVisible(true)
		allianceltCtrl = math.max(1, math.floor(havePoint / self.tableData.price))
		math.max(1, math.floor(havePoint / self.tableData.price)).left = personalLimit - buyCount
		allianceltCtrl, allianceltCtrl, math.max(1, math.floor(havePoint / self.tableData.price)).total = math.max(1, math.floor(havePoint / self.tableData.price))
		;(personalLimit - buyCount).left, math.max(1, math.floor(havePoint / self.tableData.price)).color = math.max(1, math.floor(havePoint / self.tableData.price))
		self.fields.Text_resNotice:setString(i18n_html("pray_text_14", math.max(1, math.floor(havePoint / self.tableData.price))))
	else
		self.fields.Text_resNotice:setVisible(false)
	end
	if self.curType == gIDDef.ALLIANCE_HONOR then
		self.fields.Button_Buy:getController("c1"):setSelectedIndex(0)
		allianceltCtrl = self.fields.Text_resNotice.setString
		self.fields.Text_resNotice.setString.item = itemDesRead.getName(self.tableData.itemID)
		self.fields.Text_resTotal:setString(i18n("common_text_662", self.fields.Text_resNotice.setString))
		self.fields.Button_Buy:setIcon("icon_alliance_honor.png")
		self.fields.Button_Buy:setString(i18n("common_text_1889"))
	elseif self.curType == gIDDef.ALLIANCE_SCORE then
		self.fields.Button_Buy:getController("c1"):setSelectedIndex(0)
		allianceltCtrl = i18n("common_text_1889")
		i18n("common_text_1889").item = itemDesRead.getName(self.tableData.itemID)
		self.fields.Text_resTotal:setString(i18n("common_text_663", i18n("common_text_1889")))
		self.fields.Button_Buy:setIcon("icon_alliance_point.png")
		self.fields.Button_Buy:setString(i18n("allianceshop_btn_01"))
	else
		self.fields.Button_Buy:getController("c1"):setSelectedIndex(1)
		self.fields.Button_Buy:setString(i18n("alliance_store_returns_button"))
	end
	allianceltCtrl = i18n("alliance_store_returns_button")
	i18n("alliance_store_returns_button").maxValue = maxCount
	i18n("alliance_store_returns_button").minValue = 1
	i18n("alliance_store_returns_button").curValue = 1
	self.fields.slider:initData(i18n("alliance_store_returns_button"))
	self.fields.Panel_bg:setString(itemDesRead.getName(self.tableData.itemID))
	self.fields.Text_des:setString(itemDesRead.getDes(self.tableData.itemID))
end
function AllianceShopSingleBuyPanel:onBuy()
	SoraDPlaySound()
	if self.needBuy > 0 then
		if self.handle then
			self.handle(self.tableData.itemID, self.needBuy)
		elseif self.curType == gIDDef.ALLIANCE_HONOR then
			allianceStore:reqAllianceStoreBuy(self.tableData.itemID, self.needBuy)
		elseif self.curType == gIDDef.ALLIANCE_SCORE then
			allianceStore:reqAllianceItemShopBuy(self.tableData.itemID, self.needBuy)
		else
			allianceStore:reqReturnGoods(self.tableData.itemID, self.needBuy)
		end
	elseif self.curType then
		SoraDShowMsgTip(i18n("common_text_2632"), itemDesRead.getIcon(self.tableData.itemID, true))
	end
	self:removeFromParent()
end
function AllianceShopSingleBuyPanel:setLimited(endtime)
	local leftTime = endtime - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.fields.Text_notice:setTimeLast(function(time)
			_ENV = nil
			;(nil).var1 = time
			return i18n("allianceShop_timeLimit_name", nil)
		end)
		self.fields.Text_notice:beginTime(leftTime)
		self.fields.Text_notice:setTimeEndListener(function()
			self:removeFromParent()
		end)
	else
		self:removeFromParent()
	end
end
function AllianceShopSingleBuyPanel:payGoldChange(needBuy)
	self.needBuy = needBuy
	if self.curType then
		self.fields.Button_Buy:getChild("Text_gold"):setString(string.formatnumberthousands(self.needBuy * self.tableData.price))
	else
		local pay = allianceltCtrl.getPrice(self.tableData.itemID, gIDDef.ALLIANCE_HONOR)
		_ENV = string.formatnumberthousands(self.needBuy * self.tableData.price)
		string.formatnumberthousands(self.needBuy * self.tableData.price).var1 = string.formatnumberthousands(self.needBuy)
		string.formatnumberthousands(self.needBuy * self.tableData.price).var2 = itemDesRead.getName(self.tableData.itemID)
		string.formatnumberthousands(self.needBuy * self.tableData.price).var3 = string.formatnumberthousands(self.needBuy * pay)
		string.formatnumberthousands(self.needBuy * self.tableData.price).var4 = i18n("common_text_032")
		self.fields.Button_Buy:getChild("Text_gold"):setString(i18n("alliance_store_returns_description_1", string.formatnumberthousands(self.needBuy * self.tableData.price)))
	end
end
return AllianceShopSingleBuyPanel
