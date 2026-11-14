local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local checknumber = _G.checknumber
local RW_CAMP = _G.RW_CAMP
local teamInfoScore = class("teamInfoScore", function(target, isAnchor)
	if target == nil then
		return SoraDCreateBasePanel("teamInfoScore")
	end
	return target
end)
function teamInfoScore:ctor(target, isAnchor)
	self.isAnchor = isAnchor
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	self.aid = allianceMgr:getOwnTeamID()
	self.maxPoints = 20000
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.checkIsInRemainsXianXia() then
		self.maxPoints = 5000
	end
	self.Node_progress_south = SoraDGetChildByName(self, "Node_progress_south")
	self.lab_self_south = SoraDGetChildByName(self.Node_progress_south, "Text_Self")
	self.lab_self_south_name = SoraDGetChildByName(self.Node_progress_south, "Text_Self_Name")
	self.Node_progress_north = SoraDGetChildByName(self, "Node_progress_north")
	self.lab_self_north = SoraDGetChildByName(self.Node_progress_north, "Text_Self")
	self.lab_self_north_name = SoraDGetChildByName(self.Node_progress_north, "Text_Self_Name")
	self.progress_south = SoraDGetChildByName(self.Node_progress_south, "LoadingBar_point")
	self.lab_points_south = SoraDGetChildByName(self.Node_progress_south, "Text_point")
	self.progress_north = SoraDGetChildByName(self.Node_progress_north, "LoadingBar_point")
	self.lab_points_north = SoraDGetChildByName(self.Node_progress_north, "Text_point")
	self.northPoint = 0
	self.data, gametop, self.southPoint = SoraDGetChildByName(self.Node_progress_north, "Text_point"), SoraDGetChildByName(self.Node_progress_north, "Text_point"), 0
	self:initEffect()
end
function teamInfoScore:initEffect()
	local nodeVS = SoraDGetChildByName(self, "Node_VS")
	if nodeVS then
		local remainsWarUtil = include("remainsWarUtil")
		remainsWarUtil.addVSEffect(nodeVS)
		local spVSBG = SoraDGetChildByName(self, "Sprite_VS_BG")
		remainsWarUtil.addVSAnimation(self, spVSBG)
	end
end
function teamInfoScore:onMessageListener()
	if not self.isAnchor then
		SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_CAMP_DATA", handler(self, self.updateWarData))
		SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_STATECHANGED", handler(self, self.updateWarData))
		SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_POINT_DATA", handler(self, self.updatePointData))
	end
end
function teamInfoScore:initViewWar()
	self.isAnchor = false
	self:updateWarData()
end
function teamInfoScore:initViewAnchor(data)
	self.isAnchor = true
	self:updateData(data)
end
function teamInfoScore:updateWarData()
	local data = remainsWarCtrl:getRemainsWarData()
	self:updateData(data)
end
function teamInfoScore:updateData(data)
	dump(data, "data", 10)
	self.data = data
	if not data.warCampData then
		local _ENV, warData = data.warCampData, data.warCampData
	end
	if not data.pointsData then
		local _ENV, pointData = data.pointsData, data.pointsData
	end
	if not warData[RW_CAMP.SOUTH_KEY] then
		_ENV = warData[RW_CAMP.SOUTH_KEY]
	end
	self.southData = warData[RW_CAMP.SOUTH_KEY]
	if not warData[RW_CAMP.NORTH_KEY] then
		_ENV = warData[RW_CAMP.NORTH_KEY]
	end
	self.northData = warData[RW_CAMP.NORTH_KEY]
	self.southPoint = checknumber(pointData[RW_CAMP.SOUTH_KEY])
	self.northPoint = checknumber(pointData[RW_CAMP.NORTH_KEY])
	self:updatePoints()
	self:updateTeamStatus()
end
function teamInfoScore:updatePointData()
	local data = remainsWarCtrl:getRemainsWarPointData()
	self.southPoint = checknumber(data[RW_CAMP.SOUTH_KEY])
	self.northPoint = checknumber(data[RW_CAMP.NORTH_KEY])
	self:updatePoints()
end
function teamInfoScore:updateTeamStatus()
	self:updateTeamName(self.lab_self_south_name, self.southData)
	self:updateTeamName(self.lab_self_north_name, self.northData)
	self:updateTeamSelf(self.lab_self_south, self.southData.teamId == self.aid)
	self:updateTeamSelf(self.lab_self_north, self.northData.teamId == self.aid)
end
function teamInfoScore:updatePoints()
	local point_south = self.southPoint
	local point_north = self.northPoint
	self.progress_south:setPercent(point_south * 100 / self.maxPoints)
	_ENV = nil
	;(nil).num = point_south
	self.lab_points_south:setString(i18n("common_text_2556", nil))
	self.progress_north:setPercent(point_north * 100 / self.maxPoints)
	_ENV = i18n("common_text_2556", nil)
	i18n("common_text_2556", nil).num = point_north
	self.lab_points_north:setString(i18n("common_text_2556", i18n("common_text_2556", nil)))
end
function teamInfoScore:updateTeamName(text, data)
	if not text then
		return
	end
	local leader = data.leader
	if leader and next(leader) then
		local name = leader.nickName or ""
		local allianceAbbr = leader.allianceAbb
		if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
			_ENV = nil
			;(nil).abbr = allianceAbbr
			;(nil).name = name
			name = i18n("common_text_186", nil)
		end
		if leader.fromKid then
			name = name .. "#" .. tostring(leader.fromKid)
		end
		text:setString(name)
	else
		text:setVisible(false)
	end
end
function teamInfoScore:updateTeamSelf(text, isSelf)
	if text then
		if isSelf then
			text:setString(i18n("common_text_3033"))
		else
			text:setString(i18n("common_text_3034"))
		end
	end
end
function teamInfoScore:updateTeamFlag(node, flag)
	if flag then
		if flag <= 0 then
			flag = 1
		end
		node:removeAllChildren()
		SoraDGetAllianceFlagByFid(flag):addTo(node)
	end
end
function teamInfoScore:hideName()
	if self.lab_self_north then
		self.lab_self_north:setVisible(false)
		self.lab_self_south:setVisible(false)
	end
end
return teamInfoScore
