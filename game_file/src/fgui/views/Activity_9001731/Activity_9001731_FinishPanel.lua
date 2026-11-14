local activity_9001731_Read = include("activity_9001731_Read")
local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001731_FinishPanel = class("Activity_9001731_FinishPanel", baseFguiPanel)
function Activity_9001731_FinishPanel:ctor(...)
	self.isLRU = true
	Activity_9001731_FinishPanel.super.ctor(self, ...)
	print("Activity_9001731_FinishPanel:ctor", self.viewName)
	self.isCantCloseByReturn = true
end
function Activity_9001731_FinishPanel:onInit()
	print("=======Activity_9001731_FinishPanel:onInit")
	self.fields.title:setString(i18n("surprise_box_035"))
	self.fields.title:enableGradient(cc.c3b(230, 219, 197), cc.c3b(178, 140, 68))
	self.fields.title:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_ok:setTitle(i18n("Ludo_test_018"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClick_Button_ok))
	self.fields.Label_score:setTitle(i18n("common_text_2078"))
end
function Activity_9001731_FinishPanel:endShow()
	print("=======Activity_9001731_FinishPanel:endShow")
	self.isWin = self.param.isWin
	self.rewards = self.param.rewards
	self.fields.Text_tip:setString(self.isWin and i18n("Ludo_test_019") or i18n("Ludo_test_020"))
	self.fields.List:setNumItems(#self.rewards)
	self.fields.List:setScrollEnable(#self.rewards > 5)
end
function Activity_9001731_FinishPanel:itemRenderer_List(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001731_FinishPanel:onClick_Button_ok(context)
	SoraDPlaySound()
	uiManager:close("Activity_9001731_Game")
	self:close()
end
return Activity_9001731_FinishPanel
