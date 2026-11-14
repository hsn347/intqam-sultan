local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001729_GoldDicePanel = class("Activity_9001729_GoldDicePanel", baseFguiPanel)
function Activity_9001729_GoldDicePanel:ctor(...)
	self.isLRU = true
	Activity_9001729_GoldDicePanel.super.ctor(self, ...)
	print("Activity_9001729_GoldDicePanel:ctor", self.viewName)
end
function Activity_9001729_GoldDicePanel:onInit()
	print("=======Activity_9001729_GoldDicePanel:onInit")
	self.fields.listPoint:setItemRenderer(handler(self, self.itemRenderer_listPoint))
	self.fields.listPoint:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listPoint))
	self.fields.btnConfirm:setTitle(i18n("common_text_204"))
	self.fields.btnConfirm:addClickListener(handler(self, self.onClick_btnConfirm))
	self.fields.txtDesc:setString(i18n("Ramadan_treasure_hunt_text_09"))
	self.fields.Panel_bg1:setString(i18n("Ramadan_treasure_hunt_text_08"))
end
function Activity_9001729_GoldDicePanel:endShow()
	print("=======Activity_9001729_GoldDicePanel:endShow")
	self:initData()
end
function Activity_9001729_GoldDicePanel:itemRenderer_listPoint(index, obj)
	obj:initData(index + 1)
end
function Activity_9001729_GoldDicePanel:onClickItem_listPoint(context)
	self.step = self.fields.listPoint:getSelectedIndex() + 1
	self.fields.btnConfirm:setEnabled(true)
end
function Activity_9001729_GoldDicePanel:onClick_btnConfirm(context)
	SoraDPlaySound()
	activity_9001729_Ctrl:reqThrowDiceMsg(self.step)
	self:close()
end
function Activity_9001729_GoldDicePanel:initData()
	self.step = nil
	self.fields.listPoint:setNumItems(6)
	self.fields.listPoint:ClearSelection()
	self.fields.btnConfirm:setEnabled(false)
end
return Activity_9001729_GoldDicePanel
