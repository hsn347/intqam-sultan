local activity_9001660_Ctrl = SoraDGetCtrl("activity_9001660_Ctrl")
local activity_9001660_Read = include("activity_9001660_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001660_RecordViewPanel = class("Activity_9001660_RecordViewPanel", baseFguiPanel)
function Activity_9001660_RecordViewPanel:ctor(...)
	Activity_9001660_RecordViewPanel.super.ctor(self, ...)
	print("Activity_9001660_RecordViewPanel:ctor", self.viewName)
end
function Activity_9001660_RecordViewPanel:onInit()
	print("=======Activity_9001660_RecordViewPanel:onInit")
	self.recordTbl, _ENV, self.battleType = activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE, activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE, activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE
	self.fields.Text_noRecords:setString(i18n("common_text_1464"))
	self.fields.Text_noRecords:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onRecordRenderer))
	self.fields.Button_switch:addClickListener(handler(self, self.btnSwitchClick))
end
function Activity_9001660_RecordViewPanel:onShow()
	print("=======Activity_9001660_RecordViewPanel:onShow")
	self.battleType = self.param.battleType or activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE
	self.logType = self.param.logType or 1
	self:initData(self.logType)
end
function Activity_9001660_RecordViewPanel:onRecordRenderer(index, obj)
	obj:initData(self.recordTbl[index + 1], index + 1)
end
function Activity_9001660_RecordViewPanel:initData(logType)
	self.logType = logType
	self.controllers.c1:setSelectedIndex(self.logType - 1)
	self.fields.Text_title:setString(self.logType == 1 and i18n("common_text_3287") or i18n("common_text_3288"))
	self.fields.Button_switch:setString(self.logType == 1 and i18n("common_text_3288") or i18n("common_text_3287"))
	self.recordTbl = self.logType == 1 and activity_9001660_Ctrl:getPersonalAwardInfo() or activity_9001660_Ctrl:getServerAwardInfo()
	table.sort(self.recordTbl, function(a, b)
		return a.t > b.t
	end)
	self.fields.List:setNumItems(#self.recordTbl)
	self.fields.List:jumpToTop()
	self.fields.Text_noRecords:setVisible(#self.recordTbl == 0)
end
function Activity_9001660_RecordViewPanel:btnSwitchClick()
	SoraDPlaySound()
	if self.logType == 1 then
		self:initData(2)
	elseif self.logType == 2 then
		self:initData(1)
	end
end
return Activity_9001660_RecordViewPanel
