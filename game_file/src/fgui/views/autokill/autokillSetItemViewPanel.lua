local autokillCtrl = SoraDGetCtrl("autokillCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local autokillSetItemViewPanel = class("autokillSetItemViewPanel", baseFguiPanel)
function autokillSetItemViewPanel:ctor(...)
	autokillSetItemViewPanel.super.ctor(self, ...)
	print("autokillSetItemViewPanel:ctor", self.viewName)
end
function autokillSetItemViewPanel:onInit()
	print("=======autokillSetItemViewPanel:onInit")
	self.itemSetList, _ENV, self.itemList, _ENV = print, print, print, print
	self.fields.Panel_bg:setString(i18n("common_text_4809"))
	self.fields.Button_set:setString(i18n("common_text_054"))
	self.fields.Button_set:addClickListener(handler(self, self.onClickSet))
	self.fields.Button_set:setEnabled(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function autokillSetItemViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1])
end
function autokillSetItemViewPanel:onShow()
	print("=======autokillSetItemViewPanel:onShow")
	if not self.param.itemList then
		_ENV = self.param.itemList
	end
	self.itemData = self.param.itemList
	local itemIDArray = backpackltCtrl:getItemArray(gItemType.STAMINA)
	self.itemList, _ENV = backpackltCtrl, backpackltCtrl
	for k, v in ipairs(itemIDArray) do
		_ENV = nil
		;(nil).id = v
		;(nil).count = backpackCtrl:getItemCount(v)
		;(nil).num = self.itemData[tostring(v)] or 0
		table.insert(self.itemList, nil)
	end
	self.fields.List:setNumItems(#self.itemList)
end
function autokillSetItemViewPanel:itemChange(target, data)
	self.itemSetList[tostring(data.id)] = data.count
	self:updatePhs()
end
function autokillSetItemViewPanel:updatePhs()
	local phs = 0
	for k, v in pairs(self.itemSetList) do
		local result = backpackltCtrl:getResult(tonumber(k))
		local hp = result[1].count
		phs = phs + hp * v
	end
	_ENV = nil
	;(nil).num = phs
	self.fields.Text_tips:setString(i18n("automatic_text_23", nil))
	self.fields.Button_set:setEnabled(0 < phs)
end
function autokillSetItemViewPanel:onClickSet()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_AUTO_KILL_ITEM_SETFINAL"
	;(nil).itemSetList = self.itemSetList
	SoraDSendMessage(nil)
	self:close()
end
return autokillSetItemViewPanel
