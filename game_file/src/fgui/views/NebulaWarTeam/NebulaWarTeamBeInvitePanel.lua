local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
local teamCtrl = SoraDGetCtrl("teamCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamBeInvitePanel = class("NebulaWarTeamBeInvitePanel", baseFguiPanel)
function NebulaWarTeamBeInvitePanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamBeInvitePanel:ctor", self.viewName)
end
function NebulaWarTeamBeInvitePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarTeamBeInvitePanel:onInit()
	print("=======NebulaWarTeamBeInvitePanel:onInit")
	self.teamType = self.proxy.param and self.proxy.param.teamType or teamAreaEnum.NEBULA_WAR
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		self.fields.Panel_bg:setString(i18n("nebulaemperor_text_48"))
	else
		self.fields.Panel_bg:setString(i18n("nebula_war_text_0051"))
	end
	self.fields.List_info:setItemRenderer(handler(self, self.onNormalItemRederer))
	self.fields.List_info:setVirtual()
	self.fields.Text_notice:setString(i18n("nebula_war_text_0052"))
end
function NebulaWarTeamBeInvitePanel:onShow()
	print("=======NebulaWarTeamBeInvitePanel:onShow")
	self:initView()
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		local myTeamInfo = teamCtrl:getTeamData(self.teamType)
		myTeamInfo:reqTeamNebulaEmperorTeamInfo()
	end
end
function NebulaWarTeamBeInvitePanel:onNormalItemRederer(index, obj)
	local data = self.inviteList[index + 1]
	_UPVALUE0_ = nil
	;(nil).teamType = self.teamType
	obj:initData(data, nil)
end
function NebulaWarTeamBeInvitePanel:initView(...)
	local myTeamInfo = teamCtrl:getTeamData(self.teamType)
	self.inviteList = myTeamInfo:getInvitedInfo()
	self.fields.List_info:setNumItems(#self.inviteList)
	self.fields.Text_notice:setVisible(#self.inviteList == 0)
end
function NebulaWarTeamBeInvitePanel:refreshView(...)
	self:initView()
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR and #self.inviteList == 0 then
		self:closePanel()
	end
end
function NebulaWarTeamBeInvitePanel:onMsgReqTeamInfoBack(target, event)
	if self.teamType ~= teamAreaEnum.NEBULA_EMPEROR then
		return
	end
	self:initView()
end
return NebulaWarTeamBeInvitePanel
