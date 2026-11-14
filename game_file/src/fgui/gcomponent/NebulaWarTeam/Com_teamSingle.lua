local teamDef = include("teamDef")
local allianceDesRead = include("allianceDesRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_teamSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWarTeam/Com_teamSingle", Com_teamSingle)
function Com_teamSingle:onInit()
	self.fields.Button_apply:addClickListener(handler(self, self.onClickBtnApply))
	self.fields.Button_chat:addClickListener(handler(self, self.onClickBtnChat))
	self.fields.Button_detail:addClickListener(handler(self, self.onClickBtnDetail))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.bg_team:fix()
		self.fields.bg_superTeam:fix()
	end
end
function Com_teamSingle:onShow()
end
function Com_teamSingle:initData(data, otherData)
	self.data = data
	local isSuperTeam = teamDef.getIsSuperTeam(self.data) or false
	local memberMax = nebulaWarUtil.getTeamMerberMax(isSuperTeam)
	local nameStr = teamDef.getTeamName_Legend(self.data)
	self.fields.Text_name:setString(nameStr)
	self.fields.bg_superTeam:setVisible(isSuperTeam)
	local ret = nebulaWarUtil.checkJoinTeamState()
	self.fields.Button_apply:setVisible(ret)
	if otherData and otherData.justLook then
		self.fields.Button_apply:setVisible(false)
	end
	if not self.data or not next(self.data) then
		self.fields.Text_power:setString("0")
		self.fields.Text_leader:setString(i18n("nebula_war_text_0369") .. i18n("common_text_480"))
		teamDef = "common_text_480"
		;("common_text_480").member = 0
		;("common_text_480").total = memberMax
		self.fields.Text_num:setString(i18n("common_text_155", "common_text_480"))
		self.fields.Button_chat:setVisible(false)
		self.fields.Button_apply:setString(i18n("common_text_182"))
		self.fields.Button_detail:setVisible(false)
		return
	end
	local totalFc = self.data.totalFc or teamDef.getTeamTotalFc(self.data)
	if otherData and otherData.isLockFc then
		self.fields.Text_power:setString(i18n("nebula_war_text_0606") .. string.formatnumberthousands(totalFc))
	else
		self.fields.Text_power:setString(string.formatnumberthousands(totalFc))
	end
	local nameStr = teamDef.getTeamLeaderName(self.data)
	local kid = self.data.kid
	kid = kid or teamDef.getTeamLeaderKid(self.data)
	local leaderStr = string.format("%s#%d", nameStr, kid or 1)
	teamDef = string.formatnumberthousands(totalFc)
	string.formatnumberthousands(totalFc).name = leaderStr
	self.fields.Text_leader:setString(i18n("common_text_650", string.formatnumberthousands(totalFc)))
	local memberCount = self.data.memberCount or table.nums(self.data.memberList)
	teamDef = i18n("common_text_650", string.formatnumberthousands(totalFc))
	i18n("common_text_650", string.formatnumberthousands(totalFc)).member = memberCount
	i18n("common_text_650", string.formatnumberthousands(totalFc)).total = memberMax
	self.fields.Text_num:setString(i18n("common_text_155", i18n("common_text_650", string.formatnumberthousands(totalFc))))
	if memberMax <= memberCount then
		self.fields.Button_apply:setString(i18n("nebula_war_text_0213"))
		self.fields.Button_apply:setEnabled(false)
	else
		self.fields.Button_apply:setString(i18n("common_text_182"))
		self.fields.Button_apply:setEnabled(true)
	end
	self.fields.Load_flag:setURL(allianceDesRead.getFlagIcon(self.data.setting and self.data.setting.flag or 1))
	local isSelf = nebulaWarUtil.getSelfPlayerID() == self.data.leader
	self.fields.Button_chat:setVisible(not isSelf)
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if self.data.tid == myTeamInfo:getTeamID() then
		self.controllers.c_self:setSelectedIndex(1)
	else
		self.controllers.c_self:setSelectedIndex(0)
	end
end
function Com_teamSingle:onClickBtnApply(...)
	SoraDPlaySound()
	if not self.data or not next(self.data) then
		return
	else
		local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
		myTeamInfo:reqTeamApplyJoin(self.data.tid)
	end
end
function Com_teamSingle:onClickBtnChat(...)
	SoraDPlaySound()
	local leader = self.data.memberList[tostring(self.data.leader)]
	_ENV = tostring(self.data.leader)
	tostring(self.data.leader).targetType = gMailType.CHAT
	tostring(self.data.leader).target = self.data.leader
	tostring(self.data.leader).nickName = leader.nickName
	local tostring(self.data.leader).allianceAbbr, data = leader.allianceAbbr, tostring(self.data.leader)
	SoraDCreateChatView(data)
end
function Com_teamSingle:onClickBtnDetail(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).teamData = self.data
	uiManager:show("NebulaWarTeamDetail", nil)
end
return Com_teamSingle
