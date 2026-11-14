local storesCtrl = SoraDGetCtrl("storesCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local merchanteViewPanel = class("merchanteViewPanel", baseFguiPanel)
function merchanteViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("merchanteViewPanel:ctor", self.viewName)
end
function merchanteViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function merchanteViewPanel:onInit()
	print("=======merchanteViewPanel:onInit")
	self:bindBtnClose()
	self.isHideCurrentSceneView = true
	self.refreshAble = false
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Button_refresh:addClickListener(handler(self, self.btnRefreshClick))
	self.Text_leftTime = SoraDCreateTimerLabel(self, self.fields.Text_leftTime)
	self.Text_leftTime:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#00BE1E", strTime)
		return i18n("common_text_439", nil)
	end)
	self.Text_leftTime:setAlign(2)
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:setScrollEnable(false)
	self.fields.List:setScrollItemToViewOnClick(false)
	self.fields.resourceMenu:hideStone(true)
end
function merchanteViewPanel:onItemRender(index, obj)
	obj:initData(self.shopItemArray[index + 1], self)
end
function merchanteViewPanel:onShow()
	print("=======merchanteViewPanel:onShow")
	self:updateView()
end
function merchanteViewPanel:initData()
	self.shopItemArray = storesCtrl:getShopItemArray()
	self.fields.List:setNumItems(#self.shopItemArray)
end
function merchanteViewPanel:setTime()
	local leftRefreshTime = storesCtrl:getRefreshRemainTime()
	self.Text_leftTime:beginTime(leftRefreshTime)
end
function merchanteViewPanel:updateResource()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.3)
	;(nil)[2] = ffa.callFunc(function()
		self:refreshAll()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:refreshAll()
	end)
	local action = ffa.seq(nil)
	self:runAction(action)
end
function merchanteViewPanel:refreshAll(useAction)
	self.shopItemArray = storesCtrl:getShopItemArray()
	self.fields.resourceMenu:updateResource()
	self:initRecommendItem()
	for i, v in ipairs(self.shopItemArray) do
		if useAction then
			_ENV = nil
			;(nil)[1] = ffa.delay(0.2 * (i - 1))
			;(nil)[2] = ffa.callFunc(function()
				if i > self.fields.List:getChildrenCount() then
					return
				end
				self.fields.List:getChildAt(i - 1):refreshMyData(v, useAction)
			end)
			;(nil)[3] = ffa.callFunc(function()
				if i > self.fields.List:getChildrenCount() then
					return
				end
				self.fields.List:getChildAt(i - 1):refreshMyData(v, useAction)
			end)
			self:runAction(ffa.seq(nil))
		else
			if i > self.fields.List:getChildrenCount() then
				return
			end
			self.fields.List:getChildAt(i - 1):refreshMyData(v, useAction)
		end
	end
	if useAction then
		_ENV = ipairs(self.shopItemArray)
		ipairs(self.shopItemArray)[1] = ffa.delay(1)
		ipairs(self.shopItemArray)[2] = ffa.callFunc(function()
			self:lockFun(false)
		end)
		ipairs(self.shopItemArray)[3] = ffa.callFunc(function()
			self:lockFun(false)
		end)
		ipairs(self.shopItemArray)[4] = ffa.callFunc(function()
			self:lockFun(false)
		end)
		ipairs(self.shopItemArray)[5] = ffa.callFunc(function()
			self:lockFun(false)
		end)
		ipairs(self.shopItemArray)[6] = ffa.callFunc(function()
			self:lockFun(false)
		end)
		ipairs(self.shopItemArray)[7] = ffa.callFunc(function()
			self:lockFun(false)
		end)
		ipairs(self.shopItemArray)[8] = ffa.callFunc(function()
			self:lockFun(false)
		end)
		ipairs(self.shopItemArray)[9] = ffa.callFunc(function()
			self:lockFun(false)
		end)
		ipairs(self.shopItemArray)[10] = ffa.callFunc(function()
			self:lockFun(false)
		end)
		local action = ffa.seq(ipairs(self.shopItemArray))
		self:runAction(action)
	else
		self:lockFun(false)
	end
end
function merchanteViewPanel:updateView()
	self.fields.resourceMenu:updateResource()
	self:initRecommendItem()
	self:initData()
end
function merchanteViewPanel:initRecommendItem()
	self:setTime()
	self:setRefreshBtn()
	self.fields.Super:initData(storesCtrl:getBestShopItem())
end
function merchanteViewPanel:setRefreshBtn()
	self.refreshGold = tonumber(storesCtrl:updateRefreshGold())
	self.fields.Button_refresh:initData(self.refreshGold)
end
function merchanteViewPanel:setCurClickItem(itemID)
	self.curClickSingleItemID = itemID
end
function merchanteViewPanel:getData(target, redata)
	if redata and redata.Err then
		print("buy err = " .. redata.Err)
		if gErrDef.Err_CUR_DAY_RES_MAX == redata.Err and self.curClickSingleItemID then
			print("Err_CUR_DAY_RES_MAX")
			local name = publicRead.getName(self.curClickSingleItemID)
			local limitCount = cityCtrl:getDailyResLimit(self.curClickSingleItemID, gResSourceEnum.DISCOUNT)
			_ENV = nil
			;(nil).resourceID = name
			;(nil).count = SoraDConvertNumberWithUnit(limitCount)
			SoraDShowMsgTip(i18n("common_text_2901", nil))
		elseif gErrDef.Err_RES_TOTAL_MAX == redata.Err and self.curClickSingleItemID then
			print("Err_RES_TOTAL_MAX")
			local resName = publicRead.getName(self.curClickSingleItemID)
			_ENV = i18n("common_text_2901", nil)
			i18n("common_text_2901", nil).resourceID = resName
			i18n("common_text_2901", nil).count = SoraDConvertNumberWithUnit(cityCtrl:getResMaxTotal())
			SoraDShowMsgTip(i18n("notice_0124", i18n("common_text_2901", nil)))
		end
	elseif redata and redata.newData then
		local oldShopID = redata.oldShopID
		local newSingleData = redata.newData
		for i = 1, self.fields.List:getNumItems() do
			local data = self.fields.List:getChildAt(i - 1):getData()
			if data.shopItemID == oldShopID then
				if data.pricetype ~= gIDDef.GOLD then
					SoraDPopGainItem(data.itemId, data.itemNum)
				end
				self.fields.List:getChildAt(i - 1):refreshMyData(newSingleData, true)
			end
		end
	end
	self:lockFun(false)
end
function merchanteViewPanel:lockFun(bool)
	if bool then
		SoraDShowLoading(self)
		self.refreshAble = true
	else
		SoraDCloseLoading(self)
		self.refreshAble = false
	end
end
function merchanteViewPanel:checkRecommend()
	local isHaveSpuer = false
	for _, v in pairs(self.shopItemArray) do
		if v.quality >= MAX_QUALITY then
			isHaveSpuer = true
			break
		end
	end
	return isHaveSpuer
end
function merchanteViewPanel:btnHelpClick()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_443"))
end
function merchanteViewPanel:btnRefreshClick()
	SoraDPlaySound()
	local confirmRefresh = function()
		if SoraDEnoughGold(self.refreshGold) then
			storesCtrl:refresh()
			self:lockFun(true)
		end
	end
	if self.refreshAble then
		return
	end
	if self:checkRecommend() then
		SoraDShowBuyBox(i18n("common_text_435"), self.refreshGold, i18n("common_text_911"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				confirmRefresh()
			end
		end)
	elseif self.refreshGold == MERCHANTE_REFRESH_MIN_GOLD then
		SoraDShowBuyBox(i18n("common_text_564"), self.refreshGold, i18n("common_text_911"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				confirmRefresh()
			end
		end)
	else
		confirmRefresh()
	end
end
return merchanteViewPanel
