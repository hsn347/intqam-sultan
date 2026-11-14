local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local coffeeCraftsmanCtrl = SoraDGetCtrl("coffeeCraftsmanCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DessertMasterPoolSavePanel = class("DessertMasterPoolSavePanel", baseFguiPanel)
function DessertMasterPoolSavePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function DessertMasterPoolSavePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CoffeeCraftsman"
	end
	return self._packageList
end
function DessertMasterPoolSavePanel:onInit()
	self.fields.Button_save:addClickListener(handler(self, self.onClickSave))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_title:setString(i18n("coffeeCraftsman_text_30"))
	self.fields.List_award:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function DessertMasterPoolSavePanel:onClickItem()
	self:updateBtnStatus()
end
function DessertMasterPoolSavePanel:onItemRenderer(index, obj)
	local item = self.reward[index + 1]
	obj:setCanSelected(true)
	obj:initData(item.id, item.count)
end
function DessertMasterPoolSavePanel:onClickSave()
	SoraDPlaySound()
	local index = self.fields.List_award:getSelectedIndex() + 1
	if index == 0 then
		SoraDShowMsgTip(i18n("coffeeCraftsman_text_34"))
		return
	end
	local itemId = self.reward[index].id
	coffeeCraftsmanCtrl:reqChoose(self.proxy.param.pool, itemId)
end
function DessertMasterPoolSavePanel:onShow()
	local pool = self.proxy.param.pool
	local itemId = coffeeCraftsmanCtrl:getPoolMapItemID(pool)
	self.reward = coffeeCraftsmanCtrl:getConfig(pool).reward
	self.fields.List_award:setNumItems(#self.reward)
	local bSelect = false
	for i, v in ipairs(self.reward) do
		if v.id == itemId then
			self.fields.List_award:setSelectedIndex(i - 1)
			bSelect = true
		end
	end
	self:updateBtnStatus()
end
function DessertMasterPoolSavePanel:updateBtnStatus()
	local index = self.fields.List_award:getSelectedIndex() + 1
	local itemId = coffeeCraftsmanCtrl:getPoolMapItemID(self.proxy.param.pool)
	self.fields.Button_save:setGrayed(index < 1)
	local newId = 1 <= index and self.reward[index].id or 0
	print("======", itemId, newId)
	if 0 < itemId then
		if itemId == newId then
			self.fields.Button_save:setString(i18n("common_btn_18"))
		else
			self.fields.Button_save:setString(i18n("coffeeCraftsman_text_33"))
		end
	else
		self.fields.Button_save:setString(i18n("coffeeCraftsman_text_32"))
	end
end
return DessertMasterPoolSavePanel
