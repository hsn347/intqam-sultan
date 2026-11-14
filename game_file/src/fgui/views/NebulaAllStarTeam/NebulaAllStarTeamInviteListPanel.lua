local teamCtrl = SoraDGetCtrl("teamCtrl")
local teamAreaEnum = include("teamDef").teamAreaEnum
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarTeamInviteListPanel = class("NebulaAllStarTeamInviteListPanel", baseFguiPanel)
function NebulaAllStarTeamInviteListPanel:ctor(...)
	NebulaAllStarTeamInviteListPanel.super.ctor(self, ...)
	print("NebulaAllStarTeamInviteListPanel:ctor", self.viewName)
end
function NebulaAllStarTeamInviteListPanel:onInit()
	print("=======NebulaAllStarTeamInviteListPanel:onInit")
	self.fields.Panel_bg:setString(i18n("NebulaAllstar_84"))
	self.fields.List_info:setItemRenderer(handler(self, self.onNormalItemRederer))
	self.fields.List_info:setVirtual()
	self.fields.Text_notice:setString(i18n("common_text_927"))
end
function NebulaAllStarTeamInviteListPanel:onShow()
	print("=======NebulaAllStarTeamInviteListPanel:onShow")
	local myTeamInfo = teamCtrl:getTeamData(teamAreaEnum.NEBULA_ALL_STAR)
	myTeamInfo:reqTeamInvitedUsersInfo(true)
	SoraDShowLoading(self:displayObject())
end
function NebulaAllStarTeamInviteListPanel:onNormalItemRederer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local data = self.inviteList[index + 1]
	_fields.Com_head:setHeadSprite(data.headid, data.avatar)
	_fields.Com_head:setAvatarFrame(data.avatarFrameId)
	_fields.Text_name:setString(data.nickName)
	local power = string.formatnumberthousands(data.totalFc)
	_ENV = nil
	;(nil).power = power
	_fields.Text_power:setString(i18n("common_text_128", nil))
end
function NebulaAllStarTeamInviteListPanel:onMsgUpdateInvitedUsers(target, event)
	if not event.needInfo then
		return
	end
	SoraDCloseLoading(self:displayObject())
	if not event.invitedUsers then
		local _ENV, invitedUsers = event.invitedUsers, event.invitedUsers
	end
	local _ENV, ret = self:displayObject()
	for k, v in pairs(invitedUsers) do
		v.uid = tonumber(k)
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		if a.totalFc ~= b.totalFc then
			return a.totalFc > b.totalFc
		end
		return a.uid < b.uid
	end)
	self.inviteList = ret
	self.fields.List_info:setNumItems(#self.inviteList)
	self.fields.Text_notice:setVisible(#self.inviteList == 0)
end
return NebulaAllStarTeamInviteListPanel
