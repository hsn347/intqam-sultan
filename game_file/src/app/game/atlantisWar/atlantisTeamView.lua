local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local atlantisTeamView = class("atlantisTeamView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisTeamView")
	end
	return target
end)
function atlantisTeamView:ctor()
	self.isHideCurrentSceneView = true
	self:initWidget()
	self:initEffect()
	self:req4Data()
end
function atlantisTeamView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_CAMPPLAYERLIST", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_MEMBERCLASS", handler(self, self.updateMemberClass))
end
function atlantisTeamView:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("atlantiswar_text_0139"))
	self.Button_setting:addTouchEventListener(handler(self, self.btnSettingClick))
	self.Text_teamCount:enableShadow(cc.c3b(0, 0, 0), cc.size(2, -2), 2)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "kohMigrateKingdomListScroll")
	self.scroll:setSingleCCS("atlantisMemberGroupSingle")
	self.Button_war:setVisible(false)
	self.Button_privilege:setPositionX(0)
	self.Button_privilege:setTitleText(i18n("atlantiswar_text_0142"))
	SoraDAutoSizeButtonTextByContent(self.Button_privilege)
	self.Button_privilege:addTouchEventListener(handler(self, self.btnPrivilegeClick))
	local showSetting = commonCheck.ATLANTISWAR_ARM and atlantisWarCtrl:getSelfMemberClass() >= gAtlantisRankType.Manager
	self.Button_setting:setVisible(showSetting)
end
function atlantisTeamView:initEffect()
	include("atlantisWarUtil").playFireAnimation(self)
end
function atlantisTeamView:req4Data()
	atlantisWarCtrl:reqCampPlayerList()
end
function atlantisTeamView:btnSettingClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("atlantisSettingPopView"):show()
	end
end
function atlantisTeamView:btnPrivilegeClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("atlantisMemberRankInfoView"):show()
	end
end
function atlantisTeamView:updateTeamInfo(target, event)
	if not event.rspdata then
		local atlantisWarCtrl, rspdata = event.rspdata, event.rspdata
	end
	local players = atlantisWarCtrl:getCampPlayerList()
	if not rspdata.kingdomInfo then
		local atlantisWarCtrl, kingdomInfo = rspdata.kingdomInfo, rspdata.kingdomInfo
	end
	self.Text_team_name:setString(serviceFunctions.getKingdomFormatName(kingdomInfo.kingdomName, kingdomInfo.kid))
	local allianceDesRead = include("allianceDesRead")
	allianceDesRead.getFlagWithParticle(kingdomInfo.flag, self.Node_flag)
	self.Text_teamCount:setString(string.format("%s(%d/%d)", i18n("remains_text_125"), #players, 150))
	self:refreshScroll()
end
function atlantisTeamView:refreshScroll(...)
	local atlantisWarCtrl, playerList
	local players = atlantisWarCtrl:getCampPlayerList()
	for i, v in ipairs(players) do
		local memberClass = v.memberClass
		if not playerList[memberClass] then
			atlantisWarCtrl = playerList[memberClass]
		end
		playerList[memberClass] = playerList[memberClass]
		table.insert(playerList[memberClass], v)
	end
	local atlantisWarCtrl, groupList = (for generator), ipairs(players)
	for i = gAtlantisRankType.Manager, gAtlantisRankType.R0, -1 do
		atlantisWarCtrl = playerList[memberClass]
		playerList[memberClass].playerList = playerList[i]
		table.insert(groupList, playerList[memberClass])
	end
	atlantisWarCtrl = nil
	;(nil).itemSize = cc.size(320, 230)
	self.scroll:initScroll(groupList, nil)
end
function atlantisTeamView:updateMemberClass(target, event)
	self:refreshScroll()
end
function atlantisTeamView:initAtlantisWarView(...)
	self.ccs_title:setVisible(false)
end
return atlantisTeamView
