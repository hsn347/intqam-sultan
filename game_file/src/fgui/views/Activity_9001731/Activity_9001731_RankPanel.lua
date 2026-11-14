local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001731_RankPanel = class("Activity_9001731_RankPanel", baseFguiPanel)
function Activity_9001731_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001731_RankPanel.super.ctor(self, ...)
	print("Activity_9001731_RankPanel:ctor", self.viewName)
end
function Activity_9001731_RankPanel:onInit()
	print("=======Activity_9001731_RankPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("surprise_box_035"))
	self.fields.Button_ok:setTitle(i18n("Ludo_test_018"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClick_Button_ok))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
end
function Activity_9001731_RankPanel:endShow()
	print("=======Activity_9001731_RankPanel:endShow")
	self.winList = self.param.winList
	self.fields.List:setNumItems(#self.winList)
end
function Activity_9001731_RankPanel:itemRenderer_List(index, obj)
	obj:initData(self.winList[index + 1], index + 1)
end
function Activity_9001731_RankPanel:onClick_Button_ok(context)
	SoraDPlaySound()
	self:close()
end
function Activity_9001731_RankPanel:onHide()
	uiManager:close("Activity_9001731_Game")
end
return Activity_9001731_RankPanel
