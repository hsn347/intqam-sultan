local limitTimeDiscountShopAPI = include("limitTimeDiscountShopAPI")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local discountShopViewPanel = class("discountShopViewPanel", baseFguiPanel)
function discountShopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("discountShopViewPanel:ctor", self.viewName)
end
function discountShopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function discountShopViewPanel:onInit()
	print("=======discountShopViewPanel:onInit")
	self.tableData, _ENV = print, print
	self.fields.Com_title:initData(i18n("common_text_3172"), handler(self, self.onClickClose))
	self.fields.Text_activityTime:setString(i18n("common_text_3173"))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:setTimeUpdateListener(function(time)
		local status = limitTimeDiscountShopAPI:getActivityInfo()
		if status and not allianceDesRead.getPlayerConquestWarMigration(false) and not allianceDesRead.getPlayerBattleGroundMigration(false) then
		else
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	_ENV = i18n("common_text_3173")
	i18n("common_text_3173").h = 0
	self.fields.Text_notice:setString(i18n("common_text_3171", i18n("common_text_3173")))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.n7:fixPos()
	self.fields.n7:fix()
	self.fields.Text_activityTime:fixPos()
	self.fields.n9:fixPos()
	self.fields.Text_notice:fixPos()
	self.fields.img:fix()
	self.fields.Text_time:fixPos()
end
function discountShopViewPanel:onShow()
	print("=======discountShopViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
	self:openTimeUp()
end
function discountShopViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableData[index + 1], true)
end
function discountShopViewPanel:openTimeUp()
	local status, remainTime = limitTimeDiscountShopAPI:getActivityInfo()
	if status then
		self.fields.Text_time:beginTime(remainTime)
	end
end
function discountShopViewPanel:updateScroll()
	local tableItems = limitTimeDiscountShopAPI:getShopItemList()
	table.sort(tableItems, function(a, b)
		if a.cur > 0 and b.cur > 0 or a.cur <= 0 and b.cur <= 0 then
			return a.shopItemID < b.shopItemID
		else
			return a.cur > 0
		end
	end)
	local index = 1
	for i = 1, #tableItems, 2 do
		limitTimeDiscountShopAPI = nil
		;(nil)[1] = tableItems[i]
		self.tableData[index], (nil)[2] = nil, tableItems[i + 1]
		index = index + 1
	end
	self.fields.scroll:setNumItems(#self.tableData)
end
function discountShopViewPanel:initData()
	self:updateScroll()
	self.fields.scroll:jumpToTop()
end
return discountShopViewPanel
