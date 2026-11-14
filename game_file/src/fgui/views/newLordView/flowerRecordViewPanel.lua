local flowerSysCtrl = SoraDGetCtrl("flowerSysCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local flowerRecordViewPanel = class("flowerRecordViewPanel", baseFguiPanel)
function flowerRecordViewPanel:ctor(...)
	self.isLRU = true
	flowerRecordViewPanel.super.ctor(self, ...)
	print("flowerRecordViewPanel:ctor", self.viewName)
end
function flowerRecordViewPanel:onInit()
	print("=======flowerRecordViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_2305"))
	self.fields.Text_none:setString(i18n("common_text_1060"))
	self.fields.Text_none:setVisible(false)
	self.fields.Text_sent:setString(i18n("flowers_give_1"))
	self.fields.Text_got:setString(i18n("flowers_receive_1"))
	self.fields.Button_sent:addClickListener(handler(self, self.btnSentClick))
	self.fields.Button_got:addClickListener(handler(self, self.btnGotClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_sent:fixPos()
	self.fields.Text_got:fixPos()
	self.fields.Button_sent:fixPos()
	self.fields.Button_got:fixPos()
	self.fields.Image_sent:fixPos()
	self.fields.Image_got:fixPos()
end
function flowerRecordViewPanel:onItemRenderer(index, obj)
	obj:initData(self.history[index + 1], self.msgType)
end
function flowerRecordViewPanel:endShow()
	print("=======flowerRecordViewPanel:endShow")
	self.history, _ENV, self.msgType = print, print, 1
	self:sendHistory()
end
function flowerRecordViewPanel:initData()
	SoraDCloseLoading(self)
	self.history, _ENV = SoraDCloseLoading, SoraDCloseLoading
	local _ENV, historyMap = SoraDCloseLoading, SoraDCloseLoading
	if not flowerSysCtrl:getHistoryData() then
		local _ENV, historyData = flowerSysCtrl:getHistoryData(), flowerSysCtrl:getHistoryData()
	end
	self.fields.Text_none:setVisible(#historyData == 0)
	for k, v in ipairs(historyData) do
		local dateStr = os.date("!%Y-%m-%d", v.date)
		if not historyMap[dateStr] then
			historyMap[dateStr], _ENV = historyMap[dateStr], historyMap[dateStr]
		end
		v.dateStr = dateStr
		table.insert(historyMap[dateStr], v)
	end
	local index = 1
	for t, data in pairs(historyMap) do
		self.history[index], _ENV = historyMap[dateStr], historyMap[dateStr]
		self.history[index].dateStr = t
		self.history[index].list = data
		index = index + 1
	end
	table.sort(self.history, function(a, b)
		return a.dateStr > b.dateStr
	end)
	self.fields.List:setNumItems(#self.history)
	self.fields.List:jumpToTop()
end
function flowerRecordViewPanel:switchBtns()
	self.fields.Image_sent:setVisible(self.msgType == 2)
	self.fields.Image_got:setVisible(self.msgType == 1)
	self.fields.Text_sent:setColor(self.msgType == 2 and cc.c3b(93, 51, 13) or cc.c3b(118, 72, 31))
	self.fields.Text_got:setColor(self.msgType == 1 and cc.c3b(93, 51, 13) or cc.c3b(118, 72, 31))
end
function flowerRecordViewPanel:sendHistory()
	flowerSysCtrl:sendHistory(self.msgType)
	SoraDShowLoading(self)
	self:switchBtns()
end
function flowerRecordViewPanel:btnSentClick()
	SoraDPlaySound()
	self.msgType = 2
	self:sendHistory()
end
function flowerRecordViewPanel:btnGotClick()
	SoraDPlaySound()
	self.msgType = 1
	self:sendHistory()
end
return flowerRecordViewPanel
