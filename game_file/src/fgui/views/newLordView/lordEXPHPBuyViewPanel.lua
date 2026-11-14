local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local lordEXPHPBuyViewPanel = class("lordEXPHPBuyViewPanel", baseFguiPanel)
function lordEXPHPBuyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("lordEXPHPBuyViewPanel:ctor", self.viewName)
end
function lordEXPHPBuyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function lordEXPHPBuyViewPanel:onInit()
	print("=======lordEXPHPBuyViewPanel:onInit")
	self.itemList, _ENV, self.enum = print, print, 1
	self.fields.Com_title:initData(i18n("common_text_029"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.bar_hp:fixPos()
	self.fields.bar_hp:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.bar_exp:fixPos()
	self.fields.bar_exp:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.n9:fixPos()
	self.fields.n10:fixPos()
	self.fields.n14:fixPos()
	self.fields.Text_bar:fixPos()
end
function lordEXPHPBuyViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], self.enum)
end
function lordEXPHPBuyViewPanel:onShow()
	print("=======lordEXPHPBuyViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.enum = self.param and self.param.enum or 1
	self.fields.Com_title:updateTitle(self.enum == 1 and i18n("common_text_029") or i18n("common_text_028"))
	self.controllers.c1:setSelectedIndex(self.enum - 1)
	self:initData()
end
function lordEXPHPBuyViewPanel:initData()
	self.itemList, lordInfoCtrl = nil, nil
	self.tableLordInfo = lordInfoCtrl:getBaseInfo()
	if self.enum == 1 then
		self.fields.bar_exp:setMax(self.tableLordInfo.expUpper)
		if self.tableLordInfo.isReachFullExp then
			self.fields.bar_exp:setValue(self.tableLordInfo.expUpper)
			self.fields.Text_bar:setString("MAX")
		else
			self.fields.bar_exp:setValue(self.tableLordInfo.exp)
			lordInfoCtrl = nil
			;(nil).var1 = self.tableLordInfo.exp
			;(nil).var2 = self.tableLordInfo.expUpper
			self.fields.Text_bar:setString(i18n("%{var1}/%{var2}", nil))
		end
		local expCfgList = backpackltCtrl:getItemArray(gItemType.LORD_EXP)
		for k, v in ipairs(expCfgList) do
			if backpackCtrl:getItemCount(v) > 0 then
				table.insert(self.itemList, v)
			end
		end
	else
		self.fields.bar_hp:setMax(self.tableLordInfo.physicalUpper)
		self.fields.bar_hp:setValue(math.min(self.tableLordInfo.physical, self.tableLordInfo.physicalUpper))
		lordInfoCtrl = math.min(self.tableLordInfo.physical, self.tableLordInfo.physicalUpper)
		math.min(self.tableLordInfo.physical, self.tableLordInfo.physicalUpper).var1 = self.tableLordInfo.physical
		math.min(self.tableLordInfo.physical, self.tableLordInfo.physicalUpper).var2 = self.tableLordInfo.physicalUpper
		self.fields.Text_bar:setString(i18n("%{var1}/%{var2}", math.min(self.tableLordInfo.physical, self.tableLordInfo.physicalUpper)))
		local hpCfgList = backpackltCtrl:getItemArray(gItemType.STAMINA)
		for k, v in ipairs(hpCfgList) do
			if backpackCtrl:getItemCount(v) > 0 then
				table.insert(self.itemList, v)
			elseif shopltCtrl:getShopItemByItemID(v) then
				table.insert(self.itemList, v)
			end
		end
	end
	self.fields.List:setNumItems(#self.itemList)
end
return lordEXPHPBuyViewPanel
