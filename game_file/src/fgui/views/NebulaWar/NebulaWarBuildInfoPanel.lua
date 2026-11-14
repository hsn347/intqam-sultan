local gametop = gModuleMgr.getObject("gametop")
local nebulaWarRead = include("nebulaWarRead")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local kingdomMapUtil = include("kingdomMapUtil")
local allianceDesRead = include("allianceDesRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local teamDef = include("teamDef")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarBuildInfoPanel = class("NebulaWarBuildInfoPanel", baseFguiPanel)
function NebulaWarBuildInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarBuildInfoPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaWarBuildInfoPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaCompetition"
	end
	return self._packageList
end
function NebulaWarBuildInfoPanel:onInit()
	print("=======NebulaWarBuildInfoPanel:onInit")
	local param = self.proxy.param
	self.subType = param.subType
	self.siteClassID = param.siteClassID
	self.tipButtonData = param.tipButtonData
	self.mapInstance = param.mapInstance
	self.selfCamp = nebulaActivityCtrl:getSelfCamp()
	self.selfTeamId = nebulaActivityCtrl:getSelfTeamId()
	self.fieldsVs = fguiHelper.get_fields(self.fields.Com_vsInfo)
	local buildImage = nebulaWarRead.getBuildImage(self.subType)
	self.fields.Load_build:setURL(buildImage)
	if self.subType ~= gWorldTypeServerDef.subTypeNebulaWarPalace then
		local pos = nebulaWarUtil.getMapBuildPosition(self.subType)
		local build = self.fields.Load_build
		build:setPosition(cc.p(build:getPositionX() + pos.x, build:getPositionY() + pos.y))
	end
	self.controllers.c_state:setSelectedIndex(0)
	if not SoraDFIsRA() then
		self.fields.Text_team:fixPos()
		self.fields.Load_flag:fixPos()
		self.fields.Com_vsInfo:fixChildrenPos()
	end
end
function NebulaWarBuildInfoPanel:onShow()
	print("=======NebulaWarBuildInfoPanel:onShow")
	local buildName = nebulaWarRead.getBuildName(self.subType)
	if self.subType == gWorldTypeServerDef.subTypeNebulaWarPalace or self.subType == gWorldTypeServerDef.subTypeNebulaWarFort then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_title:initData(buildName, handler(self, self.onClickClose), handler(self, self.onClickHelp))
		self.fields.Text_occupyTime = SoraDCreateTimerLabel(self, self.fields.Text_occupyTime)
		self.fields.Button_record:setString(i18n("common_text_836"))
		self.fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
		self.fields.Button_rank:setString(i18n("nebula_war_text_0188"))
		self.fields.Button_rank:addClickListener(handler(self, self.onClickBtnRank))
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_title:initData(buildName, handler(self, self.onClickClose))
		local build2 = nebulaWarRead.getMineTargetBuildName(self.siteClassID)
		local score = nebulaWarRead.getBuildIntegral(self.siteClassID)
		_ENV = handler(self, self.onClickClose)
		handler(self, self.onClickClose).build1 = buildName
		handler(self, self.onClickClose).build2 = build2
		handler(self, self.onClickClose).num = score
		self.fields.Text_tip:setString(i18n("nebula_war_text_0562", handler(self, self.onClickClose)))
		local buildList = nebulaWarRead.getMineTargetBuildList(self.siteClassID)
		if buildList[2] then
			self:initBuildSingle(self.fields.Com_build1, buildList[2])
			self:initBuildSingle(self.fields.Com_build2, buildList[1])
		else
			self:initBuildSingle(self.fields.Com_build1, buildList[1])
			self.fields.Com_build1:setPositionX(self:getWidth() / 2 - 78)
			self.fields.Node_pos2:setPositionX(self:getWidth() / 2)
			self.fields.Com_build2:setVisible(false)
		end
		self:initMineScoreQueue()
		self.fields.Text_collectTime = SoraDCreateTimerLabel(self, self.fields.Text_collectTime)
		self:updateCollectTime()
		self.fields.Text_collectTime:setTimeEndListener(function()
			self:initMineScoreQueue()
			self:updateCollectTime()
		end)
	end
	self:reqInfo()
	SoraDShowLoading(self:displayObject())
	if self.subType == gWorldTypeServerDef.subTypeNebulaWarPalace or self.subType == gWorldTypeServerDef.subTypeNebulaWarFort then
		self:initCampScore()
		nebulaActivityCtrl:reqCampScore()
	end
end
function NebulaWarBuildInfoPanel:onClickHelp(...)
	SoraDPlaySound()
	local buildDes = ""
	local time = nebulaWarRead.getBuildTime(self.siteClassID)
	local score1 = nebulaWarRead.getBuildIntegral(self.siteClassID)
	local score2 = nebulaWarRead.getTargetBuildScore(self.siteClassID)
	if self.subType == gWorldTypeServerDef.subTypeNebulaWarPalace then
		_ENV = nil
		;(nil).time = time
		;(nil).num1 = score1
		buildDes = i18n("nebula_war_text_0540", nil)
	elseif self.subType == gWorldTypeServerDef.subTypeNebulaWarFort then
		_ENV = nil
		;(nil).time = time
		;(nil).num1 = score1
		;(nil).num2 = score2
		buildDes = i18n("nebula_war_text_0541", nil)
	end
	local buildName = nebulaWarRead.getBuildName(self.subType)
	_ENV = nil
	;(nil).title = buildName
	;(nil).content = buildDes
	uiManager:show("RuleView", nil)
end
function NebulaWarBuildInfoPanel:onClickBtnRecord(EventContext)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("batteryStateViewLogRecord")
	local buildName = nebulaWarRead.getBuildName(self.subType)
	_ENV = nil
	;(nil).place = buildName
	;(nil).buildId = self.siteClassID
	;(nil).warType = gKingdomClassType.nebula
	panel:initData(nil)
	panel:show()
end
function NebulaWarBuildInfoPanel:onClickBtnRank(EventContext)
	SoraDPlaySound()
	uiManager:show("NebulaWarRank")
end
function NebulaWarBuildInfoPanel:reqInfo(...)
	local mapInKid = worldMapDefine.currentMapKindomID
	kingdomMapCtrl:reqPlaceOwnerInfo(mapInKid, self.siteClassID)
end
function NebulaWarBuildInfoPanel:showOcuppyInfo(ocuppyInfo)
	dump(ocuppyInfo, "==NebulaWarBuildInfoPanel:showOcuppyInfo==")
	self.ocuppyInfo = ocuppyInfo
	if ocuppyInfo and ocuppyInfo.uid and ocuppyInfo.uid > 0 then
		self.fields.Com_head:setHeadSprite(ocuppyInfo.iconID, ocuppyInfo.avatar)
		self.fields.Com_head:setPlayerID(ocuppyInfo.uid)
		self.fields.Text_player:setString(ocuppyInfo.name)
		local groupId = nebulaWarUtil.getGroupIdByCamp(ocuppyInfo.camp)
		self.fields.Load_flag:setURL(nebulaWarRead.getWarGroupIcon(groupId))
		local teamStr = string.format("(%s)%s", ocuppyInfo.teamAbbr or "", ocuppyInfo.teamName or "")
		self.fields.Text_team:setString(teamStr)
		if self.subType == gWorldTypeServerDef.subTypeNebulaWarPalace or self.subType == gWorldTypeServerDef.subTypeNebulaWarFort then
			local beginTime = ocuppyInfo.beginOccupyTime
			local occupyTime = math.max(0, serviceFunctions.systemTime() - beginTime)
			self.fields.Text_occupyTime:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("nebulaemperor_text_222", nil)
			end)
			if beginTime > serviceFunctions.systemTime() + 1 then
				self.fields.Text_occupyTime:setVisible(false)
			else
				self.fields.Text_occupyTime:setVisible(true)
				self.fields.Text_occupyTime:beginTime(occupyTime - 1, true)
			end
		end
		if ocuppyInfo.camp == self.selfCamp then
			if self.selfTeamId == ocuppyInfo.teamId then
				self.controllers.c_state:setSelectedIndex(3)
				local curNum = kingdomMapUtil.getArmyCount(self.tipButtonData.army)
				local maxNum = ocuppyInfo.maxNum
				self.fields.Text_troop:setString(string.format("%s/%s", string.formatnumberthousands(curNum), string.formatnumberthousands(maxNum)))
			else
				self.controllers.c_state:setSelectedIndex(2)
			end
		else
			self.controllers.c_state:setSelectedIndex(1)
		end
	else
		self.controllers.c_state:setSelectedIndex(0)
	end
end
function NebulaWarBuildInfoPanel:updateBuild(target, data)
	if data and data.siteClassID == self.siteClassID then
		self:reqInfo()
	end
end
function NebulaWarBuildInfoPanel:initCampScore(...)
	local selfGroupId = nebulaActivityCtrl:getSelfGroupId()
	self:initGroupItem(selfGroupId, 1)
	local groupId = nebulaWarUtil.getFightGroupId()
	self:initGroupItem(groupId, 2)
	self.fieldsVs.bar:initData(0.5)
end
function NebulaWarBuildInfoPanel:initGroupItem(groupId, index)
	local Com_group = self.fieldsVs["Com_group" .. index]
	local abbr = nebulaWarRead.getWarGroupAbbr(groupId)
	local name = nebulaWarRead.getWarGroupName(groupId)
	nebulaWarRead = nil
	;(nil).abbr = abbr
	;(nil).name = name
	Com_group:setString(i18n("common_text_186", nil))
	Com_group:setIcon(nebulaWarRead.getWarGroupIcon(groupId))
end
function NebulaWarBuildInfoPanel:updateCampScore(campScoreInfo)
	self.campScoreInfo = campScoreInfo
	local selfGroupId = nebulaActivityCtrl:getSelfGroupId()
	self:updateGroupItem(selfGroupId, 1)
	local groupId = nebulaWarUtil.getFightGroupId()
	self:updateGroupItem(groupId, 2)
	local camp1 = nebulaWarUtil.getCampByGroupId(selfGroupId)
	local score1 = nebulaActivityCtrl:getPlayerScore(self.campScoreInfo[camp1])
	local camp2 = nebulaWarUtil.getCampByGroupId(groupId)
	local score2 = nebulaActivityCtrl:getPlayerScore(self.campScoreInfo[camp2])
	local percent = 50
	if score1 + score2 ~= 0 then
		percent = score1 / (score1 + score2) * 100
	end
	self.fieldsVs.bar:initData(percent / 100)
end
function NebulaWarBuildInfoPanel:updateGroupItem(groupId, index)
	local camp = nebulaWarUtil.getCampByGroupId(groupId)
	local score = nebulaActivityCtrl:getPlayerScore(self.campScoreInfo[camp])
	local Text_score = self.fieldsVs["Text_score" .. index]
	Text_score:setString(string.formatnumberthousands(score))
end
function NebulaWarBuildInfoPanel:updateCollectTime(...)
	local key, queue = next(self.mineScoreQueues)
	if not queue then
		self.fields.Text_collectTime:setTimeLast(function(time)
			return i18n("nebula_war_text_0542") .. "\n" .. time
		end)
		local remainTime = nebulaWarUtil.getMineScoreRemainTime(self.siteClassID)
		if remainTime then
			self.fields.Text_collectTime:beginTime(remainTime)
		else
			self.fields.Text_collectTime:endTime()
			self.fields.Text_collectTime:setVisible(false)
		end
	else
		self.fields.Text_collectTime:setTimeLast(function(time)
			return i18n("nebula_war_text_0543") .. "\n" .. time
		end)
		local remainTime = queue.statusEndTime - serviceFunctions.systemTime()
		if 0 < remainTime then
			self.fields.Text_collectTime:beginTime(remainTime)
		end
	end
end
function NebulaWarBuildInfoPanel:initBuildSingle(obj, buildId)
	local _fields = obj._fields
	if not _fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
		_fields.Button_go:setString(i18n("common_text_477"))
		_fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	end
	local buildIcon = nebulaWarRead.getBuildImageByBuildId(buildId)
	_fields.Load_build:setURL(buildIcon)
	local buildName = nebulaWarRead.getBuildNameByBuildId(buildId)
	_fields.Text_name:setString(buildName)
	local buildPos = nebulaWarRead.getBuildPoint(buildId)
	_ENV = handler(self, self.onClickBtnGo)
	handler(self, self.onClickBtnGo).x = buildPos.x
	handler(self, self.onClickBtnGo).y = buildPos.y
	_fields.Text_pos:setString(i18n("common_text_2155", handler(self, self.onClickBtnGo)))
	_fields.Button_go:setTag(buildId)
	local owner
	if owner then
		local relationType = nebulaWarUtil.getRelationType(owner.camp, self.selfCamp, owner.teamId, self.selfTeamId)
		local nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
		_fields.Text_name:setColor(nameColor)
	else
		_fields.Text_name:setColor(cc.c3b(240, 230, 210))
	end
end
function NebulaWarBuildInfoPanel:onClickBtnGo(EventContext)
	SoraDPlaySound()
	local buildId = EventContext:getSender():getTag()
	local buildPos = nebulaWarRead.getBuildPoint(buildId)
	SoraDGotoWorldMapPoint(buildPos, true)
	SoraDRemoveAllPanelFromManager()
end
function NebulaWarBuildInfoPanel:initMineScoreQueue(...)
	if not self.queueObjs then
		_ENV = self.queueObjs
	end
	for __, v in ipairs(self.queueObjs) do
		v:removeFromParent()
	end
	self.queueObjs, _ENV = ipairs(self.queueObjs)
	local buildList = nebulaWarRead.getMineTargetBuildList(self.siteClassID)
	local queueMap = kingdomMapCtrl:getAllQueue()
	local _ENV, queues = kingdomMapCtrl, kingdomMapCtrl
	for k, v in pairs(queueMap) do
		if v.moveLineType == gMapMoveLineType.moveLineTypeNebulaWarMineScore and v.from.objId == self.siteClassID then
			if v.to.objId == buildList[1] then
				queues[1] = v
			end
			if v.to.objId == buildList[2] then
				queues[2] = v
			end
		end
	end
	dump(queues, "==NebulaWarBuildInfoPanel:initMineScoreQueue queues==")
	self.mineScoreQueues = queues
	local _ENV, pointConfig = dump, dump
	for i = 1, 3 do
		local Node_pos = self.fields["Node_pos" .. i]
		local pos = Node_pos:getPosition()
		table.insert(pointConfig, cc.p(pos.x, self:getHeight() - pos.y))
	end
	local beginPoint = pointConfig[1]
	for index, queue in pairs(queues) do
		local endPoint = pointConfig[index + 1]
		local moveLine = self:createMoveLine(beginPoint, endPoint)
		_ENV = cc.p(pos.x, self:getHeight() - pos.y)
		cc.p(pos.x, self:getHeight() - pos.y).moveLine = moveLine
		cc.p(pos.x, self:getHeight() - pos.y).moveTime = serviceFunctions.systemTime() - queue.statusStartTime
		cc.p(pos.x, self:getHeight() - pos.y).marchTime = queue.realTotalTime
		local solider = self:addEscortSolider(beginPoint, endPoint, cc.p(pos.x, self:getHeight() - pos.y))
		table.insert(self.queueObjs, moveLine)
		table.insert(self.queueObjs, solider)
	end
end
function NebulaWarBuildInfoPanel:createMoveLine(beginPoint, endPoint)
	local moveLine = include("worldMapMoveLine").new(beginPoint, endPoint)
	moveLine:setPosition(beginPoint)
	moveLine:addTo(self.fields.Node_moveLine:displayObject(), -1)
	moveLine:setVisible(true)
	moveLine:setMoveLineColor(gMapMoveLineColor.moveLineColorWhite)
	return moveLine
end
function NebulaWarBuildInfoPanel:addEscortSolider(beginPoint, endPoint, otherData)
	local solider = include("escortSolider").new()
	local currentMoveTime = otherData.moveTime
	local marchTime = otherData.marchTime
	solider:setScale(0.5)
	solider:setPosition(beginPoint)
	solider:initData(beginPoint, endPoint)
	_ENV = solider.initData
	_ENV, _ENV, solider.initData.currentMoveTime = beginPoint, solider, currentMoveTime
	beginPoint.distancePrecent = 1
	solider.initData.moveTimeSpan, solider[1], beginPoint.time = solider, beginPoint, marchTime
	local moveTimeData = solider.initData
	solider:setMoveTimeData(moveTimeData)
	solider:addTo(self.fields.Node_solider:displayObject(), -1)
	solider:setVisible(true)
	local moveLine = otherData and otherData.moveLine
	solider:setMoveLine(moveLine)
	local matrixState = otherData and otherData.matrixState or gMapMoveLineStatusType.moveLineStatusTypeMoving
	solider:setMatrixState(matrixState)
	return solider
end
return NebulaWarBuildInfoPanel
