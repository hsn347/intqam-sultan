local manorFarmRead = include("manorFarmRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ComFilter = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComFilter", ComFilter)
function ComFilter:onInit()
	self.fields.listType:setItemRenderer(handler(self, self.itemRenderer_listType))
	self.fields.listType:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listType))
	self.fields.listQuality:setItemRenderer(handler(self, self.itemRenderer_listQuality))
	self.fields.listQuality:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listQuality))
	self.fields.title:setString(i18n("farmland_text_87"))
	self.fields.txtQuality:setString(i18n("farmland_text_91"))
	self.fields.txtType:setString(i18n("farmland_text_90"))
	self.fields.btnHide:addClickListener(handler(self, self.onClick_btnHide))
end
function ComFilter:onShow()
end
function ComFilter:onClick_btnHide(...)
	local proxy = uiManager:getProxy("FarmTrade")
	if proxy then
		proxy:hideFilter()
	end
end
function ComFilter:itemRenderer_listType(index, obj)
	local icon = manorFarmRead.getSeedTypeIcon(index + 1)
	obj:initType(index + 1, icon)
end
function ComFilter:itemRenderer_listQuality(index, obj)
	obj:initQuality(index + 1)
end
function ComFilter:onClickItem_listType(context)
	if self.fields.listType:getSelectedIndex() >= 0 and 0 <= self.fields.listQuality:getSelectedIndex() then
		self:reqFilter(self.fields.listType:getSelectedIndex(), self.fields.listQuality:getSelectedIndex())
	end
end
function ComFilter:onClickItem_listQuality(context)
	if self.fields.listType:getSelectedIndex() >= 0 and 0 <= self.fields.listQuality:getSelectedIndex() then
		self:reqFilter(self.fields.listType:getSelectedIndex(), self.fields.listQuality:getSelectedIndex())
	end
end
function ComFilter:reqFilter(listTypeIndex, listQualityIndex)
	if self.fields.listType:getSelectedIndex() < 0 or 0 > self.fields.listQuality:getSelectedIndex() then
		return
	end
	local type = self.fields.listType:getSelectedIndex() + 1
	local quality = self.fields.listQuality:getSelectedIndex() + 1
	manorCityCtrl:reqMarketSaleList(nil, type, quality)
	SoraDShowLoading(uiManager:getProxy("FarmTrade").view, nil, gCmd.REQ_GARDEN_FARMLAND_MARKET_SALE_LIST)
end
function ComFilter:initData()
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum() - 1)
	self.fields.listQuality:setNumItems(manorFarmRead.getMaxFruitQuality())
	for k, v in pairs(self.fields.listType:GetChildren()) do
		v:setSelected(false)
	end
	for k, v in pairs(self.fields.listQuality:GetChildren()) do
		v:setSelected(false)
	end
end
function ComFilter:getSelectedType()
	local _ENV, ret
	for k, v in pairs(self.fields.listType:GetChildren()) do
		if v:isSelected() then
			table.insert(ret, v.type)
		end
	end
	return ret
end
function ComFilter:getSelectedQuality()
	local _ENV, ret
	for k, v in pairs(self.fields.listQuality:GetChildren()) do
		if v:isSelected() then
			table.insert(ret, v.quality)
		end
	end
	return ret
end
return ComFilter
