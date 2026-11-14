local gametop = gModuleMgr.getObject("gametop")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local legendTeamUtil = include("legendTeamUtil")
local legendTeamDef = include("legendTeamDef")
local allianceDesRead = include("allianceDesRead")
local legendTeamInfo = class("legendTeamInfo", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendTeamInfo")
	end
	return target
end)
function legendTeamInfo:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("free_team_text_41"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.txtTeamName = SoraDGetChildByName(self, "Text_team_name")
	self.txtTeamCount = SoraDGetChildByName(self, "Text_teamCount")
	self.txtTeamTitle = SoraDGetChildByName(self, "Text_teamTitle")
	self.txtTeamTitle:setString(i18n("remains_text_125"))
	self.txtTeamTota = SoraDGetChildByName(self, "Text_teamTota")
	self.txtTeamTota:setString("/" .. legendTeamDef.TEAM_MEMBER_MAX .. ")")
	self.frameLaceL = SoraDGetChildByName(self, "frame_title_lace_L")
	self.frameLaceR = SoraDGetChildByName(self, "frame_title_lace_R")
	self.spTeamFlag = SoraDGetChildByName(self, "Sprite_team_flag")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("legendTeamMember")
	self.memberList, _ENV, self.myTeamInfo, _ENV = self.scroll.setSingleCCS, self.scroll.setSingleCCS, self.scroll.setSingleCCS, self.scroll.setSingleCCS
	self:addFireEffect()
end
function legendTeamInfo:initData(teamId)
	legendTeamCtrl:reqGetTeamInfo(teamId)
	SoraDShowLoading(self)
end
function legendTeamInfo:addFireEffect()
	self.fireLeft = SoraDGetChildByName(self, "Sprite_fire_left")
	self.fireRight = SoraDGetChildByName(self, "Sprite_fire_right")
	local nodeFireL = _G.SoraDGetCommonJetFireNode(true)
	nodeFireL:setPosition(10, 55)
	nodeFireL:addTo(self.fireLeft)
	local nodeFireR = _G.SoraDGetCommonJetFireNode(true)
	nodeFireR:setPosition(10, 55)
	nodeFireR:addTo(self.fireRight)
	for i = 7, 9 do
		local particle = SoraDGetChildByName(self, "Particle_" .. i)
		if particle then
			particle:setAutoCull(false)
		end
	end
end
function legendTeamInfo:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_INFO", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function legendTeamInfo:updateTeamInfo(target, data)
	SoraDCloseLoading(self)
	local teamInfo = data.teamInfo
	if teamInfo and next(teamInfo) then
		self:initView(teamInfo)
	else
		self:removeFromParent()
	end
end
function legendTeamInfo:initView(teamInfo)
