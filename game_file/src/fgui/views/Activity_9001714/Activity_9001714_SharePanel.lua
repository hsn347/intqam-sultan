local chatCtrl = SoraDGetCtrl("chatCtrl")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001714_SharePanel = class("Activity_9001714_SharePanel", baseFguiPanel)
function Activity_9001714_SharePanel:ctor(...)
	self.isLRU = true
	Activity_9001714_SharePanel.super.ctor(self, ...)
	print("Activity_9001714_SharePanel:ctor", self.viewName)
end
function Activity_9001714_SharePanel:onInit()
	print("=======Activity_9001714_SharePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_533"))
	self.fields.Button_share:setString(i18n("common_text_204"))
	self.fields.Button_share:addClickListener(handler(self, self.btnShareBack))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onItemClick))
end
function Activity_9001714_SharePanel:onItemRender(index, obj)
	obj:initData(self.totalData[index + 1])
end
function Activity_9001714_SharePanel:onItemClick()
	SoraDPlaySound()
	local selectIndex = self.fields.List:getSelectedIndex() + 1
	local isSelect = self.fields.List:getChildAt(selectIndex - 1):isTickSelect()
	self.confirmTag = isSelect and selectIndex or 0
	print("selectIndex,isSelect,self.confirmTag====", selectIndex, isSelect, self.confirmTag)
	self.fields.Button_share:setEnabled(self.confirmTag ~= 0)
end
function Activity_9001714_SharePanel:endShow()
	print("=======Activity_9001714_SharePanel:endShow")
	self.totalData, _ENV, self.goodId = self.param.goodId, self.param.goodId, self.param.goodId
	self.confirmTag = 0
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
function Activity_9001714_SharePanel:friendDataBack(target, data)
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
function Activity_9001714_SharePanel:btnShareBack()
	SoraDPlaySound()
	local selectData = self.totalData[self.confirmTag]
	if selectData.channel == gChatChannel.KINGDOM then
		activity_9001678_Ctrl:sendShareMsg(self.goodId, nil, nil, true)
	elseif selectData.channel == gChatChannel.ALLIANCE then
		activity_9001678_Ctrl:sendShareMsg(self.goodId, nil, true)
	else
		activity_9001678_Ctrl:sendShareMsg(self.goodId, selectData.uid)
	end
	self:close()
end
return Activity_9001714_SharePanel
