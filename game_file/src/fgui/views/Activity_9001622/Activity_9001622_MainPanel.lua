local activity_9001622_Ctrl = SoraDGetCtrl("activity_9001622_Ctrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001622_MainPanel = class("Activity_9001622_MainPanel", baseFguiPanel)
function Activity_9001622_MainPanel:ctor(...)
	Activity_9001622_MainPanel.super.ctor(self, ...)
	print("Activity_9001622_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.END_OF_RAMADAN_ADVANCE
end
function Activity_9001622_MainPanel:onInit()
	print("=======Activity_9001622_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.Text_des:setString(i18n("ramadan_commemoration_text2"))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_receive0:setString(i18n("server_text_04"))
	self.fields.Button_receive:setString(i18n("common_text_1146"))
	self.fields.Button_receive:addClickListener(handler(self, self.onClickBtnReceive))
	self.fields.Text_receive2:setString(i18n("common_text_1892"))
end
function Activity_9001622_MainPanel:onShow()
	print("=======Activity_9001622_MainPanel:onShow")
	self.itemList = activity_9001622_Ctrl:getRewardItemList()
	self.fields.List:setNumItems(#self.itemList)
	self:updateDoStage()
end
function Activity_9001622_MainPanel:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item.id, item.count)
end
function Activity_9001622_MainPanel:onClickBtnReceive(...)
	SoraDPlaySound()
	activity_9001622_Ctrl:reqReward()
	SoraDShowLoading(self)
end
function Activity_9001622_MainPanel:updateDoStage(...)
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if self.doStage == doStage then
		return
	end
	activityShowCtrl, self.doStage = self.doStage, doStage
	self.doStage[1] = i18n("ramadan_commemoration_text1")
	local self.doStage[2], config = i18n("ramadan_commemoration_text3"), self.doStage
	self.fields.Text_time1:setString(config[self.doStage + 1] or "")
	local remainTime = activityShowCtrl:getRemainTime(self.activityID)
	self.fields.Text_time:beginTime(remainTime)
	self:updateViewState()
end
function Activity_9001622_MainPanel:updateViewState(...)
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if doStage == 0 then
		self.controllers.c1:setSelectedIndex(0)
	elseif not activity_9001622_Ctrl:getIsGet() then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(2)
	end
end
function Activity_9001622_MainPanel:onMsgUpdateData(...)
	SoraDCloseLoading(self)
	self:updateViewState()
end
function Activity_9001622_MainPanel:onMsgCommonRefresh(...)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	self:updateDoStage()
end
return Activity_9001622_MainPanel
