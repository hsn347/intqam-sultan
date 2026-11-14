local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001606_invitesPanel = class("Activity_9001606_invitesPanel", baseFguiPanel)
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
function Activity_9001606_invitesPanel:ctor(...)
	Activity_9001606_invitesPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001606_invitesPanel:ctor", self.viewName)
end
function Activity_9001606_invitesPanel:onInit()
	self.fields.btn_rules:fixPos()
	print("=======Activity_9001606_invitesPanel:onInit")
	self.fields.Com_title:initData(i18n("CombineServers_1"), handler(self, self.onClickClose))
	self.fields.btn_rules:addClickEventListener(function()
		SoraDPlaySound()
		uiManager:show("Activity_9001606_rule")
	end)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001605)
	if eventTime then
		_ENV = handler(self, self.onClickClose)
		handler(self, self.onClickClose).time = ""
		self.fields.Com_title:initSpecialActivityTime(eventTime.timerNode.timer:getRemainTime(), i18n("CombineServers_7", handler(self, self.onClickClose)))
	end
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_title:setString(i18n("CombineServers_19"))
	self.fields.text_empty:setString(i18n("CombineServers_37"))
	local canInviteKingdomInfo = self.param.canInviteKingdomInfo
	self.kingdomMaps, _ENV = self.fields.text_empty, self.fields.text_empty
	for k, v in pairs(canInviteKingdomInfo) do
		for i, v2 in ipairs(v) do
			self.kingdomMaps[v2.kid] = v2
		end
	end
	self:initData()
end
function Activity_9001606_invitesPanel:onShow()
	print("=======Activity_9001606_invitesPanel:onShow")
end
function Activity_9001606_invitesPanel:initData()
	local invitedList = activity_9001606_Ctrl:getInvitedList()
	self.invitedList, activity_9001606_Ctrl = activity_9001606_Ctrl, activity_9001606_Ctrl
	for i, v in pairs(invitedList) do
		if v.state == gMergeServerInvitState.INVITED then
			table.insert(self.invitedList, v)
		end
	end
	self.fields.text_empty:setVisible(#self.invitedList == 0)
	self.fields.list:setNumItems(#self.invitedList)
end
function Activity_9001606_invitesPanel:onItemRenderer(index, obj)
	local kid = self.invitedList[index + 1].kid
	local data = self.kingdomMaps[kid]
	obj:initData(data)
end
return Activity_9001606_invitesPanel
