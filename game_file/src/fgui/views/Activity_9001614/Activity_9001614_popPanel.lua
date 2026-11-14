local activity_9001614_Ctrl = SoraDGetCtrl("activity_9001614_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001614_popPanel = class("Activity_9001614_popPanel", baseFguiPanel)
function Activity_9001614_popPanel:ctor(...)
	Activity_9001614_popPanel.super.ctor(self, ...)
	print("Activity_9001614_popPanel:ctor", self.viewName)
end
function Activity_9001614_popPanel:onInit()
	print("=======Activity_9001614_popPanel:onInit")
	self.reward, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("hero_title_02"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_ok:addClickListener(handler(self, self.btnClick))
end
function Activity_9001614_popPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Activity_9001614_popPanel:onShow()
	print("=======Activity_9001614_popPanel:onShow")
	self.status = self.param.status
	self.data = self.param.data
	self:initData()
end
function Activity_9001614_popPanel:initData()
	self.fields.Button_ok:setString(self.status == gBtnTargetStatusDef.GOT and i18n("common_text_1892") or i18n("common_text_1146"))
	self.fields.Button_ok:setEnabled(self.status == gBtnTargetStatusDef.GET)
	_UPVALUE2_ = self.status == gBtnTargetStatusDef.GET
	;(self.status == gBtnTargetStatusDef.GET)[1] = "id"
	;(self.status == gBtnTargetStatusDef.GET)[2] = "count"
	self.reward = serviceFunctions.tableFormat(self.data.reward, self.status == gBtnTargetStatusDef.GET)
	self.fields.List:setNumItems(#self.reward)
end
function Activity_9001614_popPanel:btnClick()
	SoraDPlaySound()
	activity_9001614_Ctrl:sendReceiveMsg(self.data.index)
	self:close()
end
return Activity_9001614_popPanel
