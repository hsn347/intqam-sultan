local activityExchangeMallRead = include("activityExchangeMallRead")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_ShopPanel = class("RoaringFlame_ShopPanel", baseFguiPanel)
function RoaringFlame_ShopPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_ShopPanel.super.ctor(self, ...)
	print("RoaringFlame_ShopPanel:ctor", self.viewName)
end
function RoaringFlame_ShopPanel:onInit()
	print("=======RoaringFlame_ShopPanel:onInit")
	self.activityID = gActivityTimeActivityID.ROARING_FLAME_WAR_EXCHANGE
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("flames_dunes_text114"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("flames_dunes_text117", nil)
	end)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RoaringFlame_ShopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExchangeShopNew"
	end
	return self._packageList
end
function RoaringFlame_ShopPanel:onItemRenderer(index, obj)
	_UPVALUE0_ = index + 1
	;(index + 1).activityID = self.activityID
	obj:initData(self.shopList[index + 1], index + 1)
end
function RoaringFlame_ShopPanel:endShow()
	print("=======RoaringFlame_ShopPanel:endShow")
	self.tag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("flames_dunes_text115")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("flames_dunes_text116")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(nil)
end
function RoaringFlame_ShopPanel:onTabClick(tag)
	self.tag = tag
	self.fields.Label_time:beginTime(self.tag == 1 and serviceFunctions.getNextWeekDayUTC(1) - serviceFunctions.systemTime() or serviceFunctions.getNextSeasonFirstDayTime())
	self:initView()
end
function RoaringFlame_ShopPanel:initView()
	self.shopList, activityExchangeMallCtrl = nil, nil
	if not activityExchangeMallCtrl:getConfigByActivityID(self.activityID, self.tag) then
		local activityExchangeMallCtrl, shopList = activityExchangeMallCtrl:getConfigByActivityID(self.activityID, self.tag), activityExchangeMallCtrl:getConfigByActivityID(self.activityID, self.tag)
	end
	for _, v in ipairs(shopList) do
		if v.exLimit and next(v.exLimit) then
			if v.exLimit[1] == 1 then
				local vipLevel, isActive = SoraDGetVipLv()
				if vipLevel >= v.exLimit[2] then
					table.insert(self.shopList, v)
				end
			elseif v.exLimit[1] == 2 then
				if SoraDGetCastleLv() >= v.exLimit[2] then
					table.insert(self.shopList, v)
				end
			elseif v.exLimit[1] == 3 or v.exLimit[1] == 4 then
				activityExchangeMallCtrl = v.exLimit[1]
				v.exLimit[1][3] = gBestID.ONE
				local v.exLimit[1][4], limitMap = gBestID.TWO, v.exLimit[1]
				if divineBeastCtrl:getStepLv(limitMap[v.exLimit[1]]) >= v.exLimit[2] then
					table.insert(self.shopList, v)
				end
			end
		else
			table.insert(self.shopList, v)
		end
	end
	self.fields.List:setNumItems(#self.shopList)
	self.itemID = self.shopList[1].exchangeitem
	activityExchangeMallCtrl = nil
	;(nil).name = publicRead.getName(self.itemID)
	;(nil).num = backpackCtrl:getItemCount(self.itemID)
	self.fields.Text_num:setString(i18n("%{name}:%{num}", nil))
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.itemID))
	local shopNum1 = roaringFlameWarCtrl:getExchangeNum(1)
	self.fields.com_Tab:setBtnRedDot(1, 0 < shopNum1, shopNum1)
	local shopNum2 = roaringFlameWarCtrl:getExchangeNum(2)
	self.fields.com_Tab:setBtnRedDot(2, 0 < shopNum2, shopNum2)
end
function RoaringFlame_ShopPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule15")
	;(nil).content = i18n("flames_dunes_second_rule16")
	uiManager:show("RuleView", nil)
end
return RoaringFlame_ShopPanel
