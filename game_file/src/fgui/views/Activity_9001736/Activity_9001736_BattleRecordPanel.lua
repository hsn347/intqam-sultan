local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_BattleRecordPanel = class("Activity_9001736_BattleRecordPanel", baseFguiPanel)
function Activity_9001736_BattleRecordPanel:ctor(...)
	self.isLRU = true
	Activity_9001736_BattleRecordPanel.super.ctor(self, ...)
	print("Activity_9001736_BattleRecordPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
end
function Activity_9001736_BattleRecordPanel:onInit()
	print("=======Activity_9001736_BattleRecordPanel:onInit")
	self.fields.Panel_bg:setString(i18n("football_match_text_018"))
	self.fields.Text_info:setString(i18n("football_match_text_019"))
	self.fields.Text_score:setString(i18n("football_match_text_020"))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Text_noData:setString(i18n("football_match_text_079"))
	if not SoraDFIsRA() then
		self.fields.Text_info:fixPos()
		self.fields.Text_score:fixPos()
	end
end
function Activity_9001736_BattleRecordPanel:endShow()
	print("=======Activity_9001736_BattleRecordPanel:endShow")
	activity_9001736_Ctrl:reqRecord()
end
function Activity_9001736_BattleRecordPanel:itemRenderer_List(index, obj)
	local data = self.recordList[index + 1]
	obj:initData(data, function()
		for i, v in ipairs(self.fields.List:getChildren()) do
			v:hideDetail()
		end
	end)
end
function Activity_9001736_BattleRecordPanel:onMsgUpdateBattleRecord(target, event)
	local recordList = event.recordList
	self.recordList = recordList
	self.fields.List:setNumItems(#self.recordList)
	self.fields.Text_noData:setVisible(#self.recordList == 0)
end
return Activity_9001736_BattleRecordPanel
