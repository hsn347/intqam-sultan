local activity_9001622_Ctrl = SoraDGetCtrl("activity_9001622_Ctrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001622_PopPanel = class("Activity_9001622_PopPanel", baseFguiPanel)
function Activity_9001622_PopPanel:ctor(...)
	Activity_9001622_PopPanel.super.ctor(self, ...)
	print("Activity_9001622_PopPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.END_OF_RAMADAN_ADVANCE
end
function Activity_9001622_PopPanel:onInit()
	print("=======Activity_9001622_PopPanel:onInit")
	_ENV = print
	print[1] = "font_9001622_ayu.png"
	local print[2], config = "font_9001622_yingyu.png", print
	self.fields.Load_title:setURL(SoraDFIsRA() and config[1] or config[2])
	self.fields.Text_des:setString(i18n("ramadan_commemoration_text2"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
end
function Activity_9001622_PopPanel:onShow()
	print("=======Activity_9001622_PopPanel:onShow")
	self.itemList = activity_9001622_Ctrl:getRewardItemList()
	self.fields.List:setNumItems(#self.itemList)
	self:updateDoStage()
end
function Activity_9001622_PopPanel:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item.id, item.count)
end
function Activity_9001622_PopPanel:onClickBtnGo(...)
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(self.activityID)
	self:closePanel()
end
function Activity_9001622_PopPanel:updateDoStage(...)
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if self.doStage == doStage then
		return
	end
	self.doStage = doStage
	if self.doStage == 0 then
		self.fields.Label_time:initActivityTimeStyle(self.activityID, "ramadan_commemoration_text5")
		self.fields.Text_receive:setString(i18n("server_text_04"))
	else
		self.fields.Label_time:initActivityTimeStyle(self.activityID, "ramadan_commemoration_text6")
		self.fields.Text_receive:setString(i18n("Bright_night_activity_tips_0003"))
	end
end
function Activity_9001622_PopPanel:onMsgCommonRefresh(...)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	self:updateDoStage()
end
return Activity_9001622_PopPanel
