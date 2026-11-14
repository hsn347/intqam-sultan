local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local Nodewdpm = class("Nodewdpm", function(target)
	if target == nil then
		return SoraDCreateBasePanel("Nodewdpm")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function Nodewdpm:ctor()
	self.head_icon = SoraDGetChildByName(self, "head_icon")
	self.labelName = SoraDGetChildByName(self, "text_alliance")
	self.labelNum = SoraDGetChildByName(self, "text_score")
	self.labelAlliance = SoraDGetChildByName(self, "text_leader")
	self.labelIndex = SoraDGetChildByName(self, "text_my_rank")
	self.tableSingleData, _ENV, self.spriteIndex = SoraDGetChildByName(self, "Sprite_index"), SoraDGetChildByName(self, "Sprite_index"), SoraDGetChildByName(self, "Sprite_index")
end
function Nodewdpm:initData(singleData)
	self.tableSingleData = singleData
	if self.tableSingleData.rank then
		self.labelIndex:setVisible(self.tableSingleData.rank > RANK_TOP_SPECIAL)
		self.spriteIndex:setVisible(self.tableSingleData.rank <= RANK_TOP_SPECIAL)
		self.labelIndex:setString(tostring(self.tableSingleData.rank))
		if self.tableSingleData.rank <= RANK_TOP_SPECIAL then
			self.spriteIndex:setSpriteFrame("icon_ranking_" .. self.tableSingleData.rank .. ".png")
		end
	else
		self.spriteIndex:setVisible(false)
		local strRank = i18n("common_text_480")
		self.labelIndex:setString(strRank)
	end
	local player = lordInfoCtrl:getBaseInfo()
	SoraDGetHeadFromManager(self.head_icon, player.imageId, player.avatar)
	if player.nickName then
		local name = player.nickName
		local leagueAbbrName, leagueName, allianceKey, alliance
		local teamCtrl = include("legendTeamUtil").getCurTeamCtrl(self.mapid)
		if teamCtrl:isHasTeam() then
			leagueAbbrName = teamCtrl:getTeamAbbr()
			leagueName = teamCtrl:getTeamNameRaw()
			allianceKey = "free_team_text_74"
			if leagueName then
				_ENV = tostring(self.tableSingleData.rank)
				tostring(self.tableSingleData.rank).content = leagueName
				alliance = i18n(allianceKey, tostring(self.tableSingleData.rank))
			else
				_ENV = tostring(self.tableSingleData.rank)
				tostring(self.tableSingleData.rank).content = i18n("common_text_826")
				alliance = i18n(allianceKey, tostring(self.tableSingleData.rank))
			end
		else
			leagueAbbrName = allianceMgr:getAllianceProperty("abbr")
			leagueName = allianceMgr:getAllianceProperty("name")
			allianceKey = "common_text_925"
			if leagueName then
				_ENV = "name"
				;("name").conten = leagueName
				alliance = i18n(allianceKey, "name")
			else
				_ENV = "name"
				;("name").conten = i18n("common_text_826")
				alliance = i18n(allianceKey, "name")
			end
		end
		if leagueAbbrName then
			_ENV = "name"
			;("name").abbr = leagueAbbrName
			;("name").name = player.nickName
			name = i18n("common_text_186", "name")
		end
		local sourceKid = gametop.playertop_:getKingdomID()
		if sourceKid then
			name = name .. "#" .. tostring(sourceKid)
		end
		self.labelName:setString(name)
		self.labelAlliance:setString(alliance)
	end
	if self.tableSingleData.occupySecs then
		local strTime = SoraDConvertSecondToString(self.tableSingleData.occupySecs)
		self.labelNum:setString(strTime)
	end
end
return Nodewdpm
