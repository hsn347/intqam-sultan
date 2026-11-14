local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001676_SharePanel = class("Activity_9001676_SharePanel", baseFguiPanel)
local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
local chatCtrl = SoraDGetCtrl("chatCtrl")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
function Activity_9001676_SharePanel:ctor(...)
	self.isLRU = true
	Activity_9001676_SharePanel.super.ctor(self, ...)
	print("Activity_9001676_SharePanel:ctor", self.viewName)
end
function Activity_9001676_SharePanel:onInit()
	print("=======Activity_9001676_SharePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_533"))
	self.fields.Button_share:setString(i18n("common_text_204"))
	self.fields.Button_share:addClickListener(handler(self, self.btnShareBack))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function Activity_9001676_SharePanel:onItemRender(index, obj)
	obj:initData(self.totalData[index + 1], index + 1, self.confirmTags[index + 1])
	obj:setItemClickCallback(handler(self, self.onItemClick))
end
function Activity_9001676_SharePanel:onItemClick(clickIndex, isSelected)
	self.confirmTags[clickIndex] = isSelected
	local isHaveSelected = false
	for k, v in pairs(self.confirmTags) do
		if v then
			isHaveSelected = true
			break
		end
	end
	dump(self.confirmTags, "self.confirmTags")
	self.fields.Button_share:setEnabled(isHaveSelected)
end
function Activity_9001676_SharePanel:endShow()
	print("=======Activity_9001676_SharePanel:endShow")
	self.confirmTags, _ENV, self.totalData, _ENV = print, print, print, print
	self.fields.Button_share:setEnabled(false)
	_ENV = false
	;(false).channel = gChatChannel.KINGDOM
	table.insert(self.totalData, false)
	if allianceMgr:hasJoinAlliance() then
		_ENV = false
		;(false).channel = gChatChannel.ALLIANCE
		table.insert(self.totalData, false)
	end
	contactCtrl:reqGetData(true, false, false)
end
function Activity_9001676_SharePanel:friendDataBack(target, data)
	local _ENV, list
	local friendList = clone(contactCtrl:getContactList())
	for k, v in pairs(friendList) do
		v.uid = tonumber(k)
		if not chatCtrl:isShield(v.uid) then
			v.channel = gChatChannel.MAIL
			table.insert(list, v)
		end
	end
	table.sort(list, function(l, r)
		return l.totalFc > r.totalFc
	end)
	for k, v in ipairs(list) do
		table.insert(self.totalData, v)
	end
	self.fields.List:SelectNone()
	self.fields.List:setNumItems(#self.totalData)
	self.fields.List:jumpToTop()
end
function Activity_9001676_SharePanel:btnShareBack()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.toAlliance = false
	SoraDPlaySound.toUids, _ENV, SoraDPlaySound.toKingdom = nil, nil, false
	local sendData = SoraDPlaySound
	for k, v in pairs(self.confirmTags) do
		local selectData = self.totalData[k]
		if selectData.channel == gChatChannel.KINGDOM then
			sendData.toKingdom = true
		elseif selectData.channel == gChatChannel.ALLIANCE then
			sendData.toAlliance = true
		else
			table.insert(sendData.toUids, selectData.uid)
		end
	end
	dump(sendData, "Activity_9001676_SharePanel:btnShareBack")
	activity_9001676_Ctrl:reqKoreanChessRoomMode(sendData)
	self:close()
end
return Activity_9001676_SharePanel
