local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
local teamCtrl = SoraDGetCtrl("teamCtrl")
local buildLogic = include("buildLogic")
local gametop = gModuleMgr.getObject("gametop")
local baseComponent = require("fgui.base.baseComponent")
local Com_playerSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWarTeam/Com_playerSingle", Com_playerSingle)
fgui.register_extension("ui://NebulaEmperorTeam/Com_playerSingle", Com_playerSingle)
fgui.register_extension("ui://NebulaAllStarTeam/Com_playerSingle", Com_playerSingle)
_ENV = fgui.register_extension
fgui.register_extension.TYPE_APPLY = 1
fgui.register_extension.TYPE_INVITE = 2
fgui.register_extension.TYPE_MEMBER = 3
local fgui.register_extension.SET_COMMANDER, VIEW_TYPE = 4, fgui.register_extension
function Com_playerSingle:onInit()
	self.myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	self.fields.Text_powerLab:setString(i18n("common_text_090"))
	self.fields.Button_agree:addClickListener(handler(self, self.onClickBtnAgree))
	if self.fields.Button_reject then
		self.fields.Button_reject:setVisible(false)
		self.fields.Button_reject:setString(i18n("common_text_091"))
		self.fields.Button_reject:addClickListener(handler(self, self.onClickBtnReject))
	end
	if self.fields.Image_bust then
		self.fields.Image_bust:addClickListener(handler(self, self.onClickImageBust))
	end
	if self.fields.Load_click then
		self.fields.Load_click:addClickListener(handler(self, self.onClickImageBust))
	end
	self.fields.Sprite_leader:setVisible(false)
	if self.fields.Sprite_assembler then
		self.fields.Sprite_assembler:setVisible(false)
	end
	self.fields.Button_agree:setVisible(false)
	self:fixChildrenPos()
	self.fields.Com_castleLv:fixChildrenPos()
end
function Com_playerSingle:onShow()
end
function Com_playerSingle:initData(data, viewType)
	self.data = data
	self.viewType = viewType
	if self.teamType then
		self.myTeamInfo = teamCtrl:getTeamData(self.teamType or teamAreaEnum.NEBULA_WAR)
	end
	self:initNormalData(data)
	self.fields.Button_agree:setEnabled(true)
	if self.viewType == VIEW_TYPE.TYPE_APPLY then
		self.fields.Button_agree:setVisible(true)
		if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
			self.fields.Button_agree:setString(i18n("common_text_140"))
			self.fields.Button_reject:setVisible(true)
		else
			self.fields.Button_agree:setString(i18n("remains_btn_18"))
		end
	elseif self.viewType == VIEW_TYPE.TYPE_INVITE then
		self.fields.Button_agree:setVisible(true)
		if self.data.hasInvite then
			self.fields.Button_agree:setEnabled(false)
			self.fields.Button_agree:setString(i18n("remains_btn_15"))
		else
			self.fields.Button_agree:setString(i18n("common_text_189"))
		end
		if self.btnEnabled ~= nil then
			self.fields.Button_agree:setEnabled(self.btnEnabled)
		end
		if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
			self.controllers.c1:setSelectedIndex(1)
		end
	elseif self.viewType == VIEW_TYPE.TYPE_MEMBER then
		self:updateOnline()
		self.fields.Sprite_leader:setVisible(self.myTeamInfo:isTeamLeader(self.data.uid))
		if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
			self.fields.Sprite_assembler:setVisible(self.myTeamInfo:isTeamAssembler(self.data.uid))
			self.fields.Sprite_commander:setVisible(self.myTeamInfo:isTeamCommander(self.data.uid))
		elseif self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
			self.fields.Sprite_leader:setVisible(self.data.isLeader or self.myTeamInfo:isTeamLeader(self.data.uid))
			self.fields.Sprite_commander:setVisible(self.data.isCommander or self.myTeamInfo:isTeamCommander(self.data.uid))
			if self.data.uid == gametop.playertop_:getPlayerID() then
				self.controllers.c_self:setSelectedIndex(1)
			else
				self.controllers.c_self:setSelectedIndex(0)
			end
		end
	elseif self.viewType == VIEW_TYPE.SET_COMMANDER then
		self.fields.Button_agree:setVisible(true)
		self.fields.Button_agree:setString(i18n("nebula_war_text_0315"))
	end
end
function Com_playerSingle:updateOnline(...)
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR and not self.showOnline then
		self.fields.Text_online:setVisible(false)
		return
	end
	local online = self.data.online
	if online == 0 then
		self.fields.Text_online:setString(i18n("common_text_224"))
		if self.teamType == teamAreaEnum.NEBULA_EMPEROR or self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
			self.fields.Text_online:setColor(cc.c3b(0, 255, 66))
		else
			self.fields.Text_online:setColor(cc.c3b(112, 199, 35))
		end
	else
		local time = math.max(60, serviceFunctions.systemTime() - online)
		self.fields.Text_online:setString(SoraDConverSecondToDate(time, false, true))
		if self.teamType == teamAreaEnum.NEBULA_EMPEROR or self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
			self.fields.Text_online:setColor(cc.c3b(247, 0, 0))
		else
			self.fields.Text_online:setColor(cc.c3b(134, 127, 111))
		end
	end
end
function Com_playerSingle:initNormalData(data)
	self.fields.Text_name:setString(data.nickName)
	self.fields.Text_power:setString(string.formatnumberthousands(data.totalFc))
	_ENV = string.formatnumberthousands(data.totalFc)
	string.formatnumberthousands(data.totalFc).kid = data.kid
	self.fields.Text_kid:setString(i18n("common_text_342", string.formatnumberthousands(data.totalFc)))
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.Com_head:setAvatarFrame(data.avatarFrameId)
		local warLv = buildLogic.transformBuildLvToWarLv(data.cityLevel)
		warLv = math.max(0, warLv)
		self.fields.Com_castleLv:setString(warLv .. "-" .. data.starLv)
	else
		self.fields.Com_castleLv:initData(data.cityLevel, data.starLv)
		local lordLocalData = include("lordLocalData")
		self.fields.Image_bust:setURL(lordLocalData.getBust(data.headid))
	end
end
function Com_playerSingle:onClickBtnAgree(...)
	SoraDPlaySound()
	if self.viewType == VIEW_TYPE.TYPE_APPLY then
		if self.teamType == teamAreaEnum.NEBULA_WAR then
			local nebulaWarUtil = include("nebulaWarUtil")
			if not nebulaWarUtil.checkJoinTeamState() then
				SoraDShowMsgTip(i18n("nebula_war_text_0512"))
				return
			end
		end
		self.myTeamInfo:reqTeamAgreeApply(self.data.uid)
	elseif self.viewType == VIEW_TYPE.TYPE_INVITE then
		self.myTeamInfo:reqTeamInviteJoin(self.data.uid, self.data.kid)
	elseif self.viewType == VIEW_TYPE.SET_COMMANDER then
	end
end
function Com_playerSingle:onClickBtnReject(...)
	SoraDPlaySound()
	if self.viewType == VIEW_TYPE.TYPE_APPLY then
		self.myTeamInfo:reqTeamRejectApply(self.data.uid)
	end
end
function Com_playerSingle:onClickImageBust(...)
	SoraDPlaySound()
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		if self.viewType == VIEW_TYPE.TYPE_MEMBER then
			_ENV = nil
			;(nil).memberData = self.data
			;(nil).teamType = self.teamType
			;(nil).isInSameTeam = self.isInSameTeam
			uiManager:show("NebulaAllStarTeamMember", nil)
		elseif self.viewType == VIEW_TYPE.TYPE_APPLY or self.viewType == VIEW_TYPE.TYPE_INVITE then
			_ENV = nil
			;(nil).memberData = self.data
			;(nil).teamType = self.teamType
			;(nil).isInSameTeam = false
			uiManager:show("NebulaAllStarTeamMember", nil)
		end
		return
	end
	if self.viewType == VIEW_TYPE.TYPE_MEMBER then
		_ENV = nil
		;(nil).memberData = self.data
		;(nil).teamType = self.teamType
		uiManager:show("NebulaWarTeamMember", nil)
	end
end
function Com_playerSingle:initApplyData(data, otherData)
	self.teamType = otherData and otherData.teamType
	self:initData(data, VIEW_TYPE.TYPE_APPLY)
end
function Com_playerSingle:initInviteData(data, otherData)
	self.teamType = otherData and otherData.teamType
	self.btnEnabled = otherData and otherData.btnEnabled
	self:initData(data, VIEW_TYPE.TYPE_INVITE)
end
function Com_playerSingle:initMemberData(data, otherData)
	self.teamType = otherData and otherData.teamType
	self.showOnline = otherData and otherData.showOnline
	self.isInSameTeam = otherData and otherData.isInSameTeam
	self:initData(data, VIEW_TYPE.TYPE_MEMBER)
	local isSuperTeam = otherData and otherData.isSuperTeam
	if isSuperTeam and not self.isInitSuperTeam then
		self.isInitSuperTeam = true
		self.fields.Image_flg:setURL("frame_shmc_flag_03.png")
	end
end
function Com_playerSingle:initSetCommanderData(data)
	self:initData(data, VIEW_TYPE.SET_COMMANDER)
end
return Com_playerSingle
