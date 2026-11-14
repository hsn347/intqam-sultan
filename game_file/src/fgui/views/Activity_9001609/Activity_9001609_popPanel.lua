local activity_9001609_Ctrl = SoraDGetCtrl("activity_9001609_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001609_popPanel = class("Activity_9001609_popPanel", baseFguiPanel)
function Activity_9001609_popPanel:ctor(...)
	Activity_9001609_popPanel.super.ctor(self, ...)
	print("Activity_9001609_popPanel:ctor", self.viewName)
end
function Activity_9001609_popPanel:onInit()
	print("=======Activity_9001609_popPanel:onInit")
	self.reward, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("pray_text_11"))
	self.fields.Text_reward:setString(i18n("common_text_2078"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_comfirm:addClickListener(handler(self, self.btnClick))
end
function Activity_9001609_popPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Activity_9001609_popPanel:onShow()
	print("=======Activity_9001609_popPanel:onShow")
	self.status = self.param.status
	self.data = self.param.data
	self:initData()
end
function Activity_9001609_popPanel:initData()
	self.fields.Button_comfirm:setString(self.status == 2 and i18n("common_text_1892") or i18n("common_text_1146"))
	self.fields.Button_comfirm:setEnabled(self.status == 1)
	_UPVALUE2_ = self.status == 1
	;(self.status == 1)[1] = "id"
	;(self.status == 1)[2] = "count"
	self.reward = serviceFunctions.tableFormat(self.data.taskReward, self.status == 1)
	self.fields.List:setNumItems(#self.reward)
end
function Activity_9001609_popPanel:btnClick()
	SoraDPlaySound()
	activity_9001609_Ctrl:sendTaskRewardMsg(self.data.taskID)
	self:close()
end
return Activity_9001609_popPanel
