local activity_9001702_Ctrl = SoraDGetCtrl("activity_9001702_Ctrl")
local activity_9001702_Read = include("activity_9001702_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001702_RecordPanel = class("Activity_9001702_RecordPanel", baseFguiPanel)
function Activity_9001702_RecordPanel:ctor(...)
	self.isLRU = true
	Activity_9001702_RecordPanel.super.ctor(self, ...)
	print("Activity_9001702_RecordPanel:ctor", self.viewName)
end
function Activity_9001702_RecordPanel:onInit()
	print("=======Activity_9001702_RecordPanel:onInit")
	self.bysendRecords, _ENV, self.giftItemID = activity_9001702_Read.getGiftItemID(), activity_9001702_Read.getGiftItemID(), activity_9001702_Read.getGiftItemID()
	self.fields.Panel_bg:setString(i18n("common_text_836"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_record:setItemRenderer(handler(self, self.onRecordItemRenderer))
	self.fields.Text_noData:setString(i18n("god_beast_text_16"))
end
function Activity_9001702_RecordPanel:endShow()
	print("=======Activity_9001702_RecordPanel:endShow")
	self.luckNumberMap, _ENV = print, print
	self.fields.Com_have:initItemID(self.giftItemID)
	_ENV = self.fields.Com_have.initItemID
	_ENV, _ENV, self.fields.Com_have.initItemID.defaultClick = self.giftItemID, self.fields.Com_have, 1
	_ENV, self.fields.Com_have[1], self.giftItemID.title = self.giftItemID, self.giftItemID, i18n("slot_machine_text_11")
	self.fields.Com_have.initItemID.tabsetArray, self.fields.Com_have[2], self.giftItemID.title = self.fields.Com_have, self.giftItemID, i18n("Eidal_celebration_text_22")
	local self.fields.Com_have.initItemID.callback, param = handler(self, self.onClickTab), self.fields.Com_have.initItemID
	self.fields.com_TabW:initView(param)
end
function Activity_9001702_RecordPanel:onClickTab(tag)
	self.curTag = tag
	self.controllers.viewType:setSelectedIndex(tag - 1)
	if tag == 1 then
		activity_9001702_Ctrl:reqWinnerRecord()
	else
		activity_9001702_Ctrl:reqBysendRecord()
	end
end
function Activity_9001702_RecordPanel:onRewardItemRenderer(index, obj)
	local day = self.dayList[index + 1]
	local drawRecord = self.drawRecords[tostring(day)]
	obj:initData(day, drawRecord, self.luckNumberMap)
end
function Activity_9001702_RecordPanel:onRecordItemRenderer(index, obj)
	local record = self.bysendRecords[#self.bysendRecords - index]
	obj:initData(record, true)
end
function Activity_9001702_RecordPanel:updateBysendRecord()
	self.fields.List_record:setNumItems(#self.bysendRecords)
	self.fields.Text_noData:setVisible(#self.bysendRecords <= 0)
end
function Activity_9001702_RecordPanel:updateRewardRecord()
	self.drawRecords = activity_9001702_Ctrl:getDrawRecords()
	dump(self.drawRecords, "==Activity_9001702_RecordPanel=drawRecords=", 10)
	local activity_9001702_Ctrl, temp = dump, dump
	for k, __ in pairs(self.drawRecords) do
		table.insert(temp, tonumber(k))
	end
	table.sort(temp, function(a, b)
		return b < a
	end)
	self.dayList = temp
	self.fields.List_reward:setNumItems(#self.dayList)
	self.fields.Text_noData:setVisible(#self.dayList <= 0)
end
function Activity_9001702_RecordPanel:onMsgUpdate(target, event)
	local subMsg = event.subMsg
	if subMsg == "bysendRecord" then
		if self.curTag == 2 then
			if not event.rspdata then
				_ENV = event.rspdata
			end
			self.bysendRecords = event.rspdata
			self:updateBysendRecord()
		end
	elseif subMsg == "winnerRecord" then
		if self.curTag == 1 then
			local _ENV, ret = self.curTag, self.curTag
			if not event.rspdata then
				local _ENV, winnerRecords = event.rspdata, event.rspdata
			end
			for i, v in ipairs(winnerRecords) do
				ret[v.luckNumber] = true
			end
			self.luckNumberMap = ret
			self:updateRewardRecord()
		end
	elseif subMsg == "itemCount" and event.itemID == self.giftItemID then
		self.fields.Com_have:updateNum()
		self:updateBysendRecord()
	end
end
return Activity_9001702_RecordPanel
