local contactCtrl = SoraDGetCtrl("contactCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local friendApplyListViewPanel = class("friendApplyListViewPanel", baseFguiPanel)
function friendApplyListViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("friendApplyListViewPanel:ctor", self.viewName)
end
function friendApplyListViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function friendApplyListViewPanel:onInit()
	print("=======friendApplyListViewPanel:onInit")
	self.list, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("friend_btn_03"))
	self.fields.Text_none:setString(i18n("friend_text_11"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Button_accept:setString(i18n("friend_btn_05"))
	self.fields.Button_accept:addClickListener(handler(self, self.onAcceptClick))
	self.fields.Button_reject:setString(i18n("friend_btn_04"))
	self.fields.Button_reject:addClickListener(handler(self, self.onRejectClick))
	self.fields.Button_accept:fixPos()
	self.fields.Button_reject:fixPos()
end
function friendApplyListViewPanel:onListRenderer(index, obj)
	obj:initData(self.list[index + 1], 1)
end
function friendApplyListViewPanel:onShow()
	print("=======friendApplyListViewPanel:onShow")
	self:initData()
end
function friendApplyListViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.list, _ENV = SoraDCloseLoading, SoraDCloseLoading
	local mapList = contactCtrl:getRecvInviteMap()
	for k, v in pairs(mapList) do
		v.uid = tonumber(k)
		table.insert(self.list, v)
	end
	table.sort(self.list, function(a, b)
		return a.t < b.t
	end)
	self.fields.Text_none:setVisible(#self.list < 1)
	self.fields.Button_accept:setEnabled(#self.list > 0)
	self.fields.Button_reject:setEnabled(#self.list > 0)
	self.fields.List:setNumItems(#self.list)
end
function friendApplyListViewPanel:onAcceptClick()
	SoraDPlaySound()
	if contactCtrl:isOwnFriendMaxLimit() then
		SoraDShowMsgTip(i18n("friend_text_06"))
	else
		local contactMax = contactCtrl:getContactFriendMax()
		if contactMax < #self.list + contactCtrl:getContactNum() then
			SoraDShowMsgBox(i18n("friend_text_10"), i18n("common_text_054"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					SoraDShowLoading(self)
					contactCtrl:reqAcceptAllFriendInvite()
				end
			end)
		else
			SoraDShowLoading(self)
			contactCtrl:reqAcceptAllFriendInvite()
		end
	end
end
function friendApplyListViewPanel:onRejectClick()
	SoraDPlaySound()
	contactCtrl:reqRejectAllFriendInvite()
	self:close()
end
return friendApplyListViewPanel
