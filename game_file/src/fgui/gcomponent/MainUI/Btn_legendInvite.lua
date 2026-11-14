local teamAreaEnum = include("teamDef").teamAreaEnum
local teamCtrl = SoraDGetCtrl("teamCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_legendInvite = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_legendInvite", Btn_legendInvite)
fgui.register_extension("ui://MainUI/Btn_kingStarInvite", Btn_legendInvite)
function Btn_legendInvite:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_legendInvite:onShow()
end
function Btn_legendInvite:setTeamType(teamType)
	self.teamType = teamType
end
function Btn_legendInvite:setRed(num)
	self.fields.lab_red:setVisible(0 < num)
	if self.teamType ~= teamAreaEnum.NEBULA_ALL_STAR then
		self.fields.lab_red:setString(num)
	end
end
function Btn_legendInvite:onBtnClick()
	SoraDPlaySound()
	if self.teamType == teamAreaEnum.LEGEND_LORD then
		if not SoraDSearchPanelFromManagerByName("legendTeamInvitedView") then
			local panel = SoraDCreatePanel("legendTeamInvitedView")
			panel:show()
			panel:initData()
		end
	elseif self.teamType == teamAreaEnum.LEGEND_LORD_FOR_SEP then
		if not SoraDSearchPanelFromManagerByName("kingStarTeamInvitedView") then
			local panel = SoraDCreatePanel("kingStarTeamInvitedView")
			panel:show()
			panel:initData()
		end
	elseif self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		_ENV = nil
		;(nil).teamType = self.teamType
		uiManager:show("NebulaWarTeamBeInvite", nil)
	elseif self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		nebulaAllStarUtil.agreeOrRejectTeamInvite()
	end
end
function Btn_legendInvite:updateTeamInvitedInfo(...)
	local myTeamInfo = teamCtrl:getTeamData(self.teamType)
	local hasInvite = myTeamInfo:isHasInvitedInfo()
	self:setVisible(hasInvite)
	if hasInvite then
		if not myTeamInfo:getInvitedInfo() then
			local teamCtrl, inviteList = myTeamInfo:getInvitedInfo(), myTeamInfo:getInvitedInfo()
		end
		self:setRed(#inviteList)
	else
		self:setRed(0)
	end
end
return Btn_legendInvite
