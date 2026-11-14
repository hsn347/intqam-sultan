local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001687_RecordPanel = class("Activity_9001687_RecordPanel", baseFguiPanel)
local chatFunctions = include("chatFunctions")
function Activity_9001687_RecordPanel:ctor(...)
	self.isLRU = true
	Activity_9001687_RecordPanel.super.ctor(self, ...)
	print("Activity_9001687_RecordPanel:ctor", self.viewName)
end
function Activity_9001687_RecordPanel:onInit()
	print("=======Activity_9001687_RecordPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("rebag_title_01"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001687_RecordPanel:endShow()
	print("=======Activity_9001687_RecordPanel:endShow")
	self:initWithData(self.param.redPacketInfo)
end
function Activity_9001687_RecordPanel:initWithData(data)
	self.itemData = data
	local iconID = self.itemData.iconid
	self.fields.Com_head:setHeadSprite(iconID, self.itemData.avatar)
	local mailFunctions = include("mailFunctions")
	local name = self.itemData.nickname
	if self.itemData.type == 2 then
		name = mailFunctions:getWrappedName(self.itemData.allianceAbbr, self.itemData.nickname)
	end
	if self.itemData.npcId and self.itemData.npcId ~= 0 then
		name = chatFunctions:getNpcName(self.itemData.npcId)
	end
	self.redEnvelopesType = self.itemData.redEnvelopesType or gRedEnvelopesType.GOLD_GIFT
	_ENV = nil
	;(nil).name = name
	self.fields.text_name:setString(i18n("common_text_1847", nil))
	_ENV = i18n("common_text_1847", nil)
	i18n("common_text_1847", nil).num1 = self.itemData.num - self.itemData.left
	i18n("common_text_1847", nil).num2 = self.itemData.num
	self.fields.text_count:setString(i18n("snow_competition_text_22", i18n("common_text_1847", nil)))
	self.fields.list:setNumItems(#self.itemData.log)
end
function Activity_9001687_RecordPanel:onItemRenderer(index, obj)
	local data = self.itemData.log[index + 1]
	obj:initData(data)
end
return Activity_9001687_RecordPanel
