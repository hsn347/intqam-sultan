local nebulaWarUtil = include("nebulaWarUtil")
local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local teamCtrl = SoraDGetCtrl("teamCtrl")
local nebulaEmperorRead = include("nebulaEmperorRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_beInviteSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWarTeam/Com_beInviteSingle", Com_beInviteSingle)
function Com_beInviteSingle:onInit()
	self.fields.Button_yes:addClickListener(handler(self, self.onClickBtnYes))
	self.fields.Button_no:addClickListener(handler(self, self.onClickBtnNo))
	self:fixChildrenPos()
end
function Com_beInviteSingle:onShow()
end
function Com_beInviteSingle:initData(data, otherData)
	self.data = data
	self.teamType = otherData and otherData.teamType or teamAreaEnum.NEBULA_WAR
	self.fields.Com_head:setHeadSprite(self.data.iconID, self.data.avatar)
	local name = data.nickname
	local teamAbbr = data.teamAbbr
	if teamAbbr ~= nil and string.len(teamAbbr) > 0 then
		teamAreaEnum = nil
		;(nil).abbr = teamAbbr
		;(nil).name = name
		name = i18n("common_text_186", nil)
	end
	if data.kid then
		name = name .. "#" .. tostring(data.kid)
	end
	self.fields.Text_name:setString(name)
	local strScoreNum = string.formatnumberthousands(data.totalFc or 0)
	teamAreaEnum = nil
	;(nil).power = strScoreNum
	self.fields.Text_power:setString(i18n("common_text_1418", nil))
	local memberMax = 0
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		memberMax = nebulaEmperorRead.getTeamNumMax()
		self.fields.bg_superTeam:setVisible(false)
	else
		memberMax = nebulaWarUtil.getTeamMerberMax(data.isSuperTeam)
		self.fields.bg_superTeam:setVisible(data.isSuperTeam or false)
	end
	teamAreaEnum = i18n("common_text_1418", nil)
	i18n("common_text_1418", nil).member = data.memberCount or 1
	i18n("common_text_1418", nil).total = memberMax
	self.fields.Text_num:setString(i18n("common_text_155", i18n("common_text_1418", nil)))
	local tiemTab = os.date("!*t", self.data.time)
	local str_date = string.format("%.4d-%.2d-%.2d", tiemTab.year, tiemTab.month, tiemTab.day)
	self.fields.Text_time:setString(str_date)
end
function Com_beInviteSingle:onClickBtnYes(...)
	SoraDPlaySound()
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		local myTeamInfo = teamCtrl:getTeamData(self.teamType)
		myTeamInfo:reqTeamAgreeInvite(self.data.tid)
		return
	end
	if not nebulaWarUtil.checkJoinTeamState() then
		SoraDShowMsgTip(i18n("nebula_war_text_0512"))
		return
	end
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	myTeamInfo:reqTeamAgreeInvite(self.data.tid)
end
function Com_beInviteSingle:onClickBtnNo(...)
	SoraDPlaySound()
	local myTeamInfo = teamCtrl:getTeamData(self.teamType)
	myTeamInfo:reqTeamRejectInvite(self.data.tid)
end
return Com_beInviteSingle
