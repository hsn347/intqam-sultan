local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local itemActivationViewPanel = class("itemActivationViewPanel", baseFguiPanel)
function itemActivationViewPanel:ctor(...)
	itemActivationViewPanel.super.ctor(self, ...)
	print("itemActivationViewPanel:ctor", self.viewName)
end
function itemActivationViewPanel:onInit()
	print("=======itemActivationViewPanel:onInit")
	self.tableNeedBuy, _ENV = print, print
	self.tableMaterial, _ENV, self.canMerge = print, print, 0
	self.fields.Panel_bg:setString(i18n("common_text_2099"))
	self.fields.Text_condition:setString(i18n("common_text_2100"))
	self.fields.Button_compound:setString(i18n("common_text_246_ros"))
	self.fields.Button_compound:addClickListener(handler(self, self.btnCompoundClick))
	self.fields.Button_all:setString(i18n("common_text_2098"))
	self.fields.Button_all:addClickListener(handler(self, self.btnCompoundAllClick))
	self.fields.List_condition:setItemRenderer(handler(self, self.onItemRenderer))
	self.view:fixChildrenPos()
end
function itemActivationViewPanel:onShow()
	print("=======itemActivationViewPanel:onShow")
	self.itemID = self.param.itemID
	self.fields.item:initData(self.itemID)
	self.fields.Text_name:setString(itemDesRead.getName(self.itemID))
	self.fields.Text_des:setString(itemDesRead.getDes(self.itemID))
	self.tableMaterial = backpackltCtrl:getUseCondition(self.itemID, gItemUseCondType.ITEM)
	self:initData()
end
function itemActivationViewPanel:onItemRenderer(index, obj)
	local data = self.tableMaterial[index + 1]
	obj:getChild("item"):initData(data.id)
	_ENV = nil
	;(nil).count = fguiHelper.getColorString(data.num < data.count and "#BE2828" or "#FFFBD5", data.num)
	;(nil).need = data.count
	obj:getChild("Text_need"):setString(i18n("%{count}/%{need}", nil))
end
function itemActivationViewPanel:initData()
	for k, v in ipairs(self.tableMaterial) do
		v.num = backpackCtrl:getItemCount(v.id)
	end
	self.fields.List_condition:setNumItems(#self.tableMaterial)
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	if self.itemCount > 0 then
		self:updateView()
	else
		self:close()
	end
end
function itemActivationViewPanel:updateView()
	self.tableNeedBuy, _ENV = nil, nil
	local maxCanMerge = math.min(self.itemCount, backpackltCtrl:getUseMax(self.itemID))
	_UPVALUE5_ = self.itemCount
	self.itemCount[1] = 827601
	self.itemCount[2] = 827701
	self.itemCount[3] = 808501
	self.itemCount[4] = 808502
	local self.itemCount[5], quickBuyList = 808503, self.itemCount
	for k, v in ipairs(self.tableMaterial) do
		local mergeCount = math.floor(v.num / v.count)
		self.canMerge = math.min(maxCanMerge, mergeCount)
		if mergeCount <= 0 then
			local ret = shopCtrl:getShopItemByItemID(v.id)
			if SoraDisInList(v.id, quickBuyList) then
				ret = gModuleMgr.sharedMgr("shopltCtrl"):getQuickShopItemArrayByItemID(v.id)[1]
			end
			if ret then
				table.insert(self.tableNeedBuy, ret)
			end
		end
	end
	self.fields.Button_all:setString(#self.tableNeedBuy > 0 and i18n("common_text_282") or i18n("common_text_2098"))
end
function itemActivationViewPanel:btnCompoundClick()
	SoraDPlaySound()
	if self.canMerge < 1 then
		SoraDShowMsgTip(i18n("common_text_2101"), itemDesRead.getIcon(self.itemID))
	else
		backpackCtrl:reqUseItem(self.itemID, 1)
	end
end
function itemActivationViewPanel:btnCompoundAllClick()
	SoraDPlaySound()
	if self.canMerge < 1 then
		if #self.tableNeedBuy > 0 then
			local needCount = backpackCtrl:getItemCount(self.itemID)
			_ENV = nil
			_ENV, (nil).itemData = self.tableNeedBuy[1], self.tableNeedBuy[1]
			self.tableNeedBuy[1].curValue = needCount
			;(nil).otherData, self.tableNeedBuy[1].maxCount = self.tableNeedBuy[1], needCount
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("common_text_2101"), itemDesRead.getIcon(self.itemID))
		end
	else
		backpackCtrl:reqUseItem(self.itemID, self.canMerge)
	end
end
return itemActivationViewPanel
