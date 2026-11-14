local angrySnowWolfKingCtrl = SoraDGetCtrl("angrySnowWolfKingCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local angerRecordViewPanel = class("angerRecordViewPanel", baseFguiPanel)
function angerRecordViewPanel:ctor(...)
	angerRecordViewPanel.super.ctor(self, ...)
	print("angerRecordViewPanel:ctor", self.viewName)
end
function angerRecordViewPanel:onInit()
	print("=======angerRecordViewPanel:onInit")
	self.recordTbl, _ENV, self.battleType = gAngrySnowWolfKingBattletype.NORMAL_BATTLE, gAngrySnowWolfKingBattletype.NORMAL_BATTLE, gAngrySnowWolfKingBattletype.NORMAL_BATTLE
	self.fields.Text_noRecords:setString(i18n("common_text_1464"))
	self.fields.Text_noRecords:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onRecordRenderer))
	self.fields.Button_switch:addClickListener(handler(self, self.btnSwitchClick))
end
function angerRecordViewPanel:onShow()
	print("=======angerRecordViewPanel:onShow")
	self.battleType = self.param.battleType or gAngrySnowWolfKingBattletype.NORMAL_BATTLE
	self.logType = self.param.logType or 1
	self:initData(self.logType)
end
function angerRecordViewPanel:onRecordRenderer(index, obj)
	obj:initData(self.recordTbl[index + 1], index + 1)
end
function angerRecordViewPanel:initData(logType)
	self.logType = logType
	self.controllers.c1:setSelectedIndex(self.logType - 1)
	self.fields.Text_title:setString(self.logType == 1 and i18n("common_text_3287") or i18n("common_text_3288"))
	self.fields.Button_switch:setString(self.logType == 1 and i18n("common_text_3288") or i18n("common_text_3287"))
	self.recordTbl = self.logType == 1 and angrySnowWolfKingCtrl:getPersonalAwardInfo() or angrySnowWolfKingCtrl:getServerAwardInfo()
	table.sort(self.recordTbl, function(a, b)
		return a.t > b.t
	end)
	self.fields.List:setNumItems(#self.recordTbl)
	self.fields.List:jumpToTop()
	self.fields.Text_noRecords:setVisible(#self.recordTbl == 0)
end
function angerRecordViewPanel:btnSwitchClick()
	SoraDPlaySound()
	if self.logType == 1 then
		self:initData(2)
	elseif self.logType == 2 then
		self:initData(1)
	end
end
return angerRecordViewPanel
