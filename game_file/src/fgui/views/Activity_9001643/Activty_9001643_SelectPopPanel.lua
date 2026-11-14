local heroCtrl = SoraDGetCtrl("heroCtrl")
local activity_9001643_Ctrl = SoraDGetCtrl("activity_9001643_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activty_9001643_SelectPopPanel = class("Activty_9001643_SelectPopPanel", baseFguiPanel)
function Activty_9001643_SelectPopPanel:ctor(...)
	Activty_9001643_SelectPopPanel.super.ctor(self, ...)
	print("Activty_9001643_SelectPopPanel:ctor", self.viewName)
end
function Activty_9001643_SelectPopPanel:onInit()
	print("=======Activty_9001643_SelectPopPanel:onInit")
	self.heros, _ENV = print, print
	self.heroID = nil
	self.fields.Panel_bg:setString(i18n("common_text_560"))
	self.fields.Lab_hero:setString(i18n("hero_title_07"))
	self.fields.Text_tip:setString(i18n("eidal_celebration_text25"))
	self.fields.List:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.Btn_ok:setEnabled(false)
end
function Activty_9001643_SelectPopPanel:onHeroRenderer(index, obj)
	obj:initData(self.heros[index + 1])
end
function Activty_9001643_SelectPopPanel:onClickItem()
	SoraDPlaySound()
	local index = self.fields.List:getSelectedIndex() + 1
	print("self.fields.List", index)
	self.heroID = tonumber(self.heros[index])
	self.fields.Btn_ok:setEnabled(true)
end
function Activty_9001643_SelectPopPanel:onShow()
	print("=======Activty_9001643_SelectPopPanel:onShow")
	self.taskID = self.param.taskID
	self.heros = heroCtrl:getHaveHerosList()
	self.fields.List:setNumItems(#self.heros)
end
function Activty_9001643_SelectPopPanel:btnOkClick()
	SoraDPlaySound()
	if self.taskID and self.heroID then
		activity_9001643_Ctrl:reqReceiveTask(self.taskID, self.heroID)
		SoraDRemoveAllPanelFromManager()
	end
end
return Activty_9001643_SelectPopPanel
