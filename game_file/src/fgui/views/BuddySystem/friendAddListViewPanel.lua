local contactCtrl = SoraDGetCtrl("contactCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local friendAddListViewPanel = class("friendAddListViewPanel", baseFguiPanel)
function friendAddListViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("friendAddListViewPanel:ctor", self.viewName)
end
function friendAddListViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function friendAddListViewPanel:onInit()
	print("=======friendAddListViewPanel:onInit")
	self.list, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("friend_btn_08"))
	self.fields.Text_none:setString(i18n("friend_text_36"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Button_reject:setString(i18n("friend_text_35"))
	self.fields.Button_reject:addClickListener(handler(self, self.onRejectClick))
end
function friendAddListViewPanel:onListRenderer(index, obj)
	obj:initData(self.list[index + 1], 0)
end
function friendAddListViewPanel:onShow()
	print("=======friendAddListViewPanel:onShow")
	self:initData()
end
function friendAddListViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.list, _ENV = SoraDCloseLoading, SoraDCloseLoading
	local mapList = contactCtrl:getSendInviteMap()
	for k, v in pairs(mapList) do
		v.uid = tonumber(k)
		table.insert(self.list, v)
	end
	table.sort(self.list, function(a, b)
		return a.t < b.t
	end)
	self.fields.Text_none:setVisible(#self.list < 1)
	self.fields.Button_reject:setEnabled(#self.list > 0)
	self.fields.List:setNumItems(#self.list)
end
function friendAddListViewPanel:onRejectClick()
	SoraDPlaySound()
	SoraDShowLoading(self)
	contactCtrl:reqCancelAllSendFriendInvite()
	contactCtrl:clearRecvInviteMap()
end
return friendAddListViewPanel
