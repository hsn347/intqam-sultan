local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001606_kingdomsPanel = class("Activity_9001606_kingdomsPanel", baseFguiPanel)
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
function Activity_9001606_kingdomsPanel:ctor(...)
	Activity_9001606_kingdomsPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001606_kingdomsPanel:ctor", self.viewName)
end
function Activity_9001606_kingdomsPanel:onInit()
	self.view:fixChildrenPos()
	print("=======Activity_9001606_kingdomsPanel:onInit")
	self.fields.Com_title:initData(i18n("CombineServers_1"), handler(self, self.onClickClose))
	self.fields.btn_rules:addClickEventListener(function()
		SoraDPlaySound()
		uiManager:show("Activity_9001606_rule")
	end)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001605)
	if eventTime then
		_ENV = handler(self, self.onClickClose)
		handler(self, self.onClickClose).time = ""
		self.fields.Com_title:initSpecialActivityTime(eventTime.timerNode.timer:getRemainTime(), i18n("CombineServers_7", handler(self, self.onClickClose)))
	end
	self.fields.btn_invites:setTitle(i18n("CombineServers_19"))
	self.fields.btn_invites:addClickEventListener(handler(self, self.onInvitesClick))
	self.fields.Com_myTitle:setTitle(i18n("CombineServers_13"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	activity_9001606_Ctrl:reqCanInvite()
end
function Activity_9001606_kingdomsPanel:onShow()
	print("=======Activity_9001606_kingdomsPanel:onShow")
end
function Activity_9001606_kingdomsPanel:initData(data)
	self.data = data
	self.fields.Com_mianKingdom:initData(data.selfKindomInfo, true)
	self.inviteList = data.inviteList
	self.invitedList = data.invitedList
	local _ENV, tabsetArray = data.invitedList, data.invitedList
	for k, v in pairs(data.canInviteKingdomInfo) do
		_ENV = nil
		_ENV = nil
		;(nil).num = k
		;(nil).title = i18n("CombineServers_56", nil) .. k
		;(nil).tag = tonumber(k)
		table.insert(tabsetArray, nil)
	end
	table.sort(tabsetArray, function(a, b)
		return a.tag < b.tag
	end)
	_ENV = table.sort
	table.sort.defaultClick = tabsetArray[1].tag
	table.sort.tabsetArray = tabsetArray
	local table.sort.callback, param = handler(self, self.btn_onClick_btns), table.sort
	self.fields.com_Tab:initView(param)
	self.isKing = activity_9001606_Ctrl:getIsKing()
	self.fields.btn_invites:setVisible(self.isKing)
	if self.isKing then
		local redNum = activity_9001606_Ctrl:getRedPointNum()
		self.fields.btn_invites:setReddot(0 < redNum, redNum)
	end
end
function Activity_9001606_kingdomsPanel:updateInviteList(inviteList, invitedList)
	self.inviteList = inviteList
	self.invitedList = invitedList
	self.fields.list:setNumItems(#self.itemDatas)
	if self.isKing then
		local redNum = activity_9001606_Ctrl:getRedPointNum()
		self.fields.btn_invites:setReddot(0 < redNum, redNum)
	end
end
function Activity_9001606_kingdomsPanel:btn_onClick_btns(tag, name)
	print("==WatchTowerView:btn_onClick_btns==", tag, name)
	if self.curClassType == tag then
		return
	end
	self.curClassType = tag
	self.itemDatas = self.data.canInviteKingdomInfo[tostring(tag)]
	self.fields.list:setNumItems(#self.itemDatas)
end
function Activity_9001606_kingdomsPanel:onItemRenderer(index, obj)
	local data = self.itemDatas[index + 1]
	obj:initData(data, self.inviteList, self.invitedList)
end
function Activity_9001606_kingdomsPanel:onInvitesClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).canInviteKingdomInfo = self.data.canInviteKingdomInfo
	;(nil).inviteList = self.inviteList
	;(nil).invitedList = self.invitedList
	uiManager:show("Activity_9001606_invites", nil)
end
return Activity_9001606_kingdomsPanel
