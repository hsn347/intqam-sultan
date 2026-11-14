local activityCommonMergeCtrl = SoraDGetCtrl("activityCommonMergeCtrl")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local chatCtrl = SoraDGetCtrl("chatCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001663_sharePanel = class("Activity_9001663_sharePanel", baseFguiPanel)
function Activity_9001663_sharePanel:ctor(...)
	Activity_9001663_sharePanel.super.ctor(self, ...)
	print("Activity_9001663_sharePanel:ctor", self.viewName)
end
function Activity_9001663_sharePanel:onInit()
	print("=======Activity_9001663_sharePanel:onInit")
	_ENV, self.listData, _ENV = print, print, print
	self.selectData, print.notifyUids, _ENV, print.isNotifyAlliance = print, "=======Activity_9001663_sharePanel:onInit", "=======Activity_9001663_sharePanel:onInit", false
	self.fields.Panel_bg:setString(i18n("bubble_party_text_13"))
	self.fields.Text_none:setString(i18n("bubble_party_text_39"))
	self.fields.Text_none:setVisible(false)
	self.fields.Button_share:setString(i18n("alliance_btn_01"))
	self.fields.Button_share:addClickListener(handler(self, self.btnShareClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function Activity_9001663_sharePanel:onItemRender(index, target)
	target:initData(self.listData[index + 1], handler(self, self.onChooseItem))
end
function Activity_9001663_sharePanel:onChooseItem(data, isSelect)
	SoraDPlaySound()
	if isSelect then
		if data.channel == gChatChannel.ALLIANCE then
			self.selectData.isNotifyAlliance = true
		else
			self.selectData.notifyUids[tostring(data.uid)] = true
		end
	elseif data.channel == gChatChannel.ALLIANCE then
		self.selectData.isNotifyAlliance = false
	else
		self.selectData.notifyUids[tostring(data.uid)] = nil
	end
end
function Activity_9001663_sharePanel:onShow()
	print("=======Activity_9001663_sharePanel:onShow")
	self.activityID = self.param.activityID
	self.post = self.param.post
	contactCtrl:reqGetData(true, false, false)
	SoraDShowLoading(self)
end
function Activity_9001663_sharePanel:initData(target, data)
	SoraDCloseLoading(self)
	self.listData, _ENV = SoraDCloseLoading, SoraDCloseLoading
	if allianceMgr:hasJoinAlliance() then
		_ENV = nil
		;(nil).channel = gChatChannel.ALLIANCE
		table.insert(self.listData, nil)
	end
	local _ENV, friendList = table.insert, table.insert
	local friendMap = clone(contactCtrl:getContactList())
	for k, v in pairs(friendMap) do
		v.uid = tonumber(k)
		if not chatCtrl:isShield(v.uid) and v.sourceKid == SoraDGetCtrl("lordInfoCtrl"):getMapSourceKid() then
			v.channel = gChatChannel.MAIL
			table.insert(friendList, v)
		end
	end
	table.sort(friendList, function(l, r)
		return l.totalFc > r.totalFc
	end)
	for k, v in ipairs(friendList) do
		table.insert(self.listData, v)
	end
	self.fields.List:setNumItems(#self.listData)
	self.fields.Text_none:setVisible(#self.listData == 0)
end
function Activity_9001663_sharePanel:btnShareClick()
	SoraDPlaySound()
	local _ENV, notifyUids = SoraDPlaySound, SoraDPlaySound
	for k, v in pairs(self.selectData.notifyUids) do
		table.insert(notifyUids, tonumber(k))
	end
	activityCommonMergeCtrl:reqExchangePost(self.activityID, self.post, self.selectData.isNotifyAlliance, notifyUids)
	self:close()
end
return Activity_9001663_sharePanel
