local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_buildOcuppy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaEmperorWar/Com_buildOcuppy", Com_buildOcuppy)
fgui.register_extension("ui://NebulaAllStarWar/Com_buildOcuppy", Com_buildOcuppy)
function Com_buildOcuppy:onInit()
	self.activityID = gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
	self.fields.Text_occupyTime = SoraDCreateTimerLabel(self, self.fields.Text_occupyTime)
	self.fields.Text_occupyTime:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("nebulaemperor_text_222", nil)
	end)
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_buildOcuppy:onShow()
end
function Com_buildOcuppy:updateOcuppyInfo(ocuppyInfo)
	self.fields.Com_head:setHeadSprite(ocuppyInfo.iconID, ocuppyInfo.avatar)
	self.fields.Com_head:setAvatarFrame(ocuppyInfo.avatarFrameId)
	self.fields.Com_head:setPlayerID(ocuppyInfo.uid)
	local regionId = ocuppyInfo.camp
	local areaIcon = nebulaEmperorUtil.getAreaIcon(regionId)
	self.fields.Load_flag:setURL(areaIcon)
	local beginTime = ocuppyInfo.beginOccupyTime
	local occupyTime = math.max(0, serviceFunctions.systemTime() - beginTime)
	self.fields.Text_occupyTime:beginTime(occupyTime, true)
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		self.fields.Text_player:setString(ocuppyInfo.name)
		local teamName = nebulaEmperorUtil.getTeamName(regionId)
		self.fields.Text_team:setString(teamName)
		local relationType = nebulaEmperorUtil.getRelationType(regionId)
		local nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
		self.fields.Text_player:setColor(nameColor)
		self.fields.Text_team:setColor(nameColor)
		self.fields.Text_occupyTime:setColor(nameColor)
		self.isSelfCamp = relationType == gMapAllianceRelationType.SELF
	elseif self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		local teamAbbr = nebulaAllStarUtil.getTeamAbbr(regionId, ocuppyInfo.teamId)
		nebulaEmperorUtil = relationType == gMapAllianceRelationType.SELF
		;(relationType == gMapAllianceRelationType.SELF).abbr = teamAbbr
		;(relationType == gMapAllianceRelationType.SELF).name = ocuppyInfo.name
		local teamName = i18n("common_text_186", relationType == gMapAllianceRelationType.SELF)
		self.fields.Text_team:setString(teamName)
		local nameColor = nebulaAllStarRead.getCampColorRGB(regionId)
		self.fields.Text_team:setColor(nameColor)
		local selfCamp = nebulaAllStarCtrl:getSelfCamp()
		self.isSelfCamp = regionId == selfCamp
	end
	self:updateTextTroop(ocuppyInfo)
end
function Com_buildOcuppy:updateTextTroop(ocuppyInfo)
	if self.isSelfCamp then
		local curNum = ocuppyInfo.armyCount
		local maxNum = ocuppyInfo.maxNum
		self.fields.Text_troop:setString(string.format("%s/%s", string.formatnumberthousands(curNum), string.formatnumberthousands(maxNum)))
	end
	self.fields.Sprite_troop:setVisible(self.isSelfCamp)
	self.fields.Text_troop:setVisible(self.isSelfCamp)
end
function Com_buildOcuppy:setActivityID(activityID)
	self.activityID = activityID
end
return Com_buildOcuppy
