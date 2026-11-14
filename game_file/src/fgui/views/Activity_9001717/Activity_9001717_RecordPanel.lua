local activity_9001717_Read = include("activity_9001717_Read")
local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001717_RecordPanel = class("Activity_9001717_RecordPanel", baseFguiPanel)
function Activity_9001717_RecordPanel:ctor(...)
	self.isLRU = true
	Activity_9001717_RecordPanel.super.ctor(self, ...)
	print("Activity_9001717_RecordPanel:ctor", self.viewName)
end
function Activity_9001717_RecordPanel:onInit()
	print("=======Activity_9001717_RecordPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Bubble_island_rebuild_text_25"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_noData:setString(i18n("Bubble_island_rebuild_text_53"))
end
function Activity_9001717_RecordPanel:endShow()
	print("=======Activity_9001717_RecordPanel:endShow")
	activity_9001717_Ctrl:reqGiftRecord()
end
function Activity_9001717_RecordPanel:onItemRenderer(index, obj)
	obj:fixChildrenPos()
	local record = self.recordList[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_ENV = obj
	local obj.item, params = activity_9001717_Read.getGiftName(record.giftType), obj
	if record.nickName then
		params.name = record.nickName
		_fields.flag:setVisible(false)
		_fields.Com_head:setVisible(true)
		_fields.Com_head:setHeadSprite(record.headid, record.avatar)
		_fields.Com_head:setPlayerID(record.uid)
	else
		params.name = i18n("common_text_069")
		_fields.Com_head:setVisible(false)
		_fields.flag:setVisible(true)
		_fields.flag:clearContent()
		local flagNode = allianceDesRead.getFlagNode(allianceMgr:getAllianceProperty("flag"))
		flagNode:setScale(0.42)
		_fields.flag:setContent(flagNode)
	end
	local recordStr = i18n("Bubble_island_rebuild_text_24", params)
	_fields.Text_des:setString(recordStr)
	_fields.Text_date:setString(os.date("!%m-%d %H:%M:%S", record.time))
end
function Activity_9001717_RecordPanel:onMsgUpdateData(target, event)
	SoraDCloseLoading()
	local subMsg = event.subMsg
	if subMsg == "giftRecord" then
		if not event.rspdata then
			_ENV = event.rspdata
		end
		self.recordList = event.rspdata
		self.fields.List:setNumItems(#self.recordList)
		self.fields.Text_noData:setVisible(#self.recordList <= 0)
	end
end
return Activity_9001717_RecordPanel
