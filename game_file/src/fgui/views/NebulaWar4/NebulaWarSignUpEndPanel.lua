local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local teamDef = include("teamDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarSignUpEndPanel = class("NebulaWarSignUpEndPanel", baseFguiPanel)
function NebulaWarSignUpEndPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarSignUpEndPanel:ctor", self.viewName)
	self.myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
end
function NebulaWarSignUpEndPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaWarTeam"
	end
	return self._packageList
end
function NebulaWarSignUpEndPanel:onInit()
	print("=======NebulaWarSignUpEndPanel:onInit")
	self.fields.Panel_bg:setString(i18n("nebula_war_text_0371"))
	self.fields.Text_des:setString(i18n("nebula_war_text_0516"))
	self.fields.Text_des2:setString(i18n("nebula_war_text_0517"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_noData:setString(i18n("nebula_war_text_0518"))
	self.fields.Text_noData:setVisible(false)
end
function NebulaWarSignUpEndPanel:onShow()
	print("=======NebulaWarSignUpEndPanel:onShow")
	self.myTeamInfo:reqTeamSuperTeamInfo()
	SoraDShowLoading(self:displayObject())
end
function NebulaWarSignUpEndPanel:onItemRenderer(index, obj)
	local teamData = self.teamList[index + 1]
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
	end
	local Com_team = obj.fields.Com_team
	_ENV = nil
	;(nil).isSuperTeam = true
	Com_team:initData(teamData, nil)
end
function NebulaWarSignUpEndPanel:updateSuperTeam(teamList)
