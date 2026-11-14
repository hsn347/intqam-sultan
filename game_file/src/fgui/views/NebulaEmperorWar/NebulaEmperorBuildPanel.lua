local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local kingdomMapUtil = include("kingdomMapUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorBuildPanel = class("NebulaEmperorBuildPanel", baseFguiPanel)
function NebulaEmperorBuildPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorBuildPanel:ctor", self.viewName)
	self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime))
	self.isHideCurrentSceneView = true
end
function NebulaEmperorBuildPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaEmperor"
	end
	return self._packageList
end
function NebulaEmperorBuildPanel:onInit()
	print("=======NebulaEmperorBuildPanel:onInit")
	local param = self.proxy.param
	self.buildID = param.buildID
	self.subType = nebulaEmperorRead.getBuildType(self.buildID)
	self:updateTipButtonData(param.tipButtonData)
	self.startPalaceWar = nebulaEmperorCtrl:getStartPalaceWar()
	self.selfCamp = nebulaEmperorCtrl:getSelfCamp()
	self.mapInstance = param.mapInstance
	local buildName = nebulaEmperorRead.getBuildName(self.buildID)
	local handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	self.fields.Com_title:initData(buildName, handler(self, self.onClickClose), handlerHelp)
	local build1 = nebulaEmperorRead.getBuildNameByType(gWorldTypeServerDef.subTypeNebulaEmperorWarPalace)
	local build2 = nebulaEmperorRead.getBuildNameByType(gWorldTypeServerDef.subTypeNebulaEmperorWarTower)
	_ENV = handlerHelp
	handlerHelp.build1 = build1
	handlerHelp.build2 = build2
	local tip = i18n("nebulaemperor_text_139", handlerHelp)
	self.fields.Text_tip:setString(tip)
	_ENV = tip
	tip.build1 = build1
	local tip2 = i18n("nebulaemperor_text_141", tip)
	self.fields.Text_tip2:setString(tip2)
	self.controllers.c1:setSelectedIndex(self.subType - 1)
	self.fields.Com_buildImage:getController("c1"):setSelectedIndex(self.subType - 1)
	self.fields.Com_buildImage:getChild("mv_xqsg"):setAllFrameName("dh_xingyunxqsg_%02d.png", 1)
	self.controllers.c_war:setSelectedIndex(self.startPalaceWar and 1 or 0)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarPalace then
		self.fields.List_build:setItemRenderer(handler(self, self.onItemRenderer))
		self:initComBuildRank()
	elseif self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarTower then
		self.fields.Button_energy:setString(i18n("nebulaemperor_text_22"))
		self.fields.Button_energy:addClickListener(handler(self, self.onClickBtnEnergy))
	elseif self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		self.fields.List_build2:setItemRenderer(handler(self, self.onItemRenderer))
		self:initComBuildRank()
		local regionId = nebulaEmperorRead.getBuildCamp(self.buildID)
		local teamName = nebulaEmperorUtil.getTeamNameRaw(regionId)
		local areaIcon = nebulaEmperorUtil.getAreaIcon(regionId)
		self.fields.Text_team:setString(teamName)
		self.fields.Load_flag:setURL(areaIcon)
	end
	if not SoraDFIsRA() then
		self.fields.Load_flag:fixPos()
		self.fields.Text_team:fixPos()
	end
end
function NebulaEmperorBuildPanel:onShow()
	print("=======NebulaEmperorBuildPanel:onShow")
	_ENV = print
	print[gWorldTypeServerDef.subTypeNebulaEmperorWarPalace] = true
	local print[gWorldTypeServerDef.subTypeNebulaEmperorWarTower], cfg = true, print
	if cfg[self.subType] then
		self:showOcuppyInfo(self.mapInstance:getBuildData())
	end
	_ENV = self.showOcuppyInfo
	self.showOcuppyInfo[gWorldTypeServerDef.subTypeNebulaEmperorWarPalace] = true
	local self.showOcuppyInfo[gWorldTypeServerDef.subTypeNebulaEmperorWarCamp], cfg = true, self.showOcuppyInfo
	if cfg[self.subType] then
		if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarPalace then
			if self.startPalaceWar then
				self.fields.Com_energy:setStartPalaceWar()
			end
			self:updateBuildList()
		elseif self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
			if self.startPalaceWar then
				self.fields.List_build2:setVisible(false)
			else
				self:updateBuildList()
			end
		end
		if self.startPalaceWar then
			nebulaEmperorCtrl:reqRankData(1)
		else
			nebulaEmperorCtrl:reqEnergyData()
		end
	end
end
function NebulaEmperorBuildPanel:initComBuildRank(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_buildRank)
	_fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	_fields.Text_rank:setString(i18n("nebulaemperor_text_140"))
	_fields.Text_noData:setString(i18n("herobattle_text_05"))
end
function NebulaEmperorBuildPanel:updateBuildList(...)
	self.buildList, nebulaEmperorRead = nil, nil
	local buildIDList = nebulaEmperorRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaEmperorWarTower)
	for __, buildID in ipairs(buildIDList) do
		nebulaEmperorRead = nil
		;(nil).buildID = buildID
		table.insert(self.buildList, nil)
	end
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarPalace then
		self.fields.List_build:setNumItems(#self.buildList)
		local build = self.fields.List_build:getChildAt(0)
		build._fields.mv_xq1:setAllFrameName("dh_xingyunxq1_%02d.png", 1)
	elseif self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		self.fields.List_build2:setNumItems(#self.buildList)
		local build = self.fields.List_build2:getChildAt(0)
		build._fields.mv_xq1:setAllFrameName("dh_xingyunxq1_%02d.png", 1)
	end
end
function NebulaEmperorBuildPanel:onItemRenderer(index, obj)
	local data = self.buildList[index + 1]
	local buildID = data.buildID
	local _fields = obj._fields
	if not _fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
		_fields.Button_go:setString(i18n("common_text_477"))
		_fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	end
	local cfg = nebulaEmperorRead.getBuildConfig(buildID)
	_fields.Text_name:setString(i18n(cfg.name))
	_ENV = i18n(cfg.name)
	i18n(cfg.name).x = cfg.x
	i18n(cfg.name).y = cfg.y
	_fields.Text_pos:setString(i18n("common_text_2155", i18n(cfg.name)))
	_fields.Button_go:setTag(buildID)
	_fields.Button_go:setVisible(not self.startPalaceWar)
	local owner = nebulaEmperorCtrl:getBuildOwner(buildID)
	if owner then
		local regionId = owner.camp
		local relationType = nebulaEmperorUtil.getRelationType(regionId)
		local nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
		_fields.Text_name:setColor(nameColor)
	else
		_fields.Text_name:setColor(cc.c3b(240, 230, 210))
	end
end
function NebulaEmperorBuildPanel:onClickBtnGo(EventContext)
	SoraDPlaySound()
	if not worldMapDefine.isInNebulaEmperor() then
		SoraDShowMsgTip(i18n("nebulaemperor_text_218"))
		return
	end
	local buildID = EventContext:getSender():getTag()
	local buildPos = nebulaEmperorRead.getBuildPos(buildID)
	SoraDGotoWorldMapPoint(buildPos, true)
	SoraDRemoveAllPanelFromManager()
end
function NebulaEmperorBuildPanel:showOcuppyInfo(data)
	_UPVALUE0_ = nil
	;(nil).uid = data.playerID
	;(nil).iconID = data.headid
	;(nil).avatar = data.avatar
	;(nil).name = data.playerName
	;(nil).camp = data.camp
	local (nil).beginOccupyTime, ocuppyInfo = data.beginOccupyTime, nil
	self.ocuppyInfo = ocuppyInfo
	if ocuppyInfo and ocuppyInfo.uid and ocuppyInfo.uid > 0 then
		self.controllers.c_state:setSelectedIndex(1)
		ocuppyInfo.armyCount = self.armyCount
		ocuppyInfo.maxNum = self.tipButtonData.maxNum
		self.fields.Com_buildOcuppy:updateOcuppyInfo(ocuppyInfo)
	else
		self.controllers.c_state:setSelectedIndex(0)
	end
end
function NebulaEmperorBuildPanel:onMsgEnergyDataBack(...)
	SoraDCloseLoading(self:displayObject())
	self.startPalaceWar = nebulaEmperorCtrl:getStartPalaceWar()
	self.controllers.c_war:setSelectedIndex(self.startPalaceWar and 1 or 0)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarPalace then
		self.fields.Com_energy:updateEnergy()
		self:updateBuildList()
	elseif self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		if self.startPalaceWar then
			self.fields.List_build2:setVisible(false)
		else
			self:updateBuildList()
		end
	end
	if self.startPalaceWar then
		nebulaEmperorCtrl:reqRankData(1)
	end
end
function NebulaEmperorBuildPanel:onMsgGetPlayerRank(target, event)
	if event.rankType ~= 1 then
		return
	end
	if not event.rspdata.rankList then
		_ENV = event.rspdata.rankList
	end
	self.rankList = event.rspdata.rankList
	local _fields = fguiHelper.get_fields(self.fields.Com_buildRank)
	_fields.List_rank:setNumItems(#self.rankList)
	_fields.Text_noData:setVisible(#self.rankList == 0)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		local rankStr = i18n("herobattle_text_05")
		local occupyPalaceSecs = 0
		local regionId = nebulaEmperorRead.getBuildCamp(self.buildID)
		for rank, v in ipairs(self.rankList) do
			if v.camp == regionId then
				rankStr = tostring(rank)
				occupyPalaceSecs = v.occupyPalaceSecs
				break
			end
		end
		_ENV = nil
		;(nil).num = rankStr
		self.fields.Text_areaRank:setString(i18n("nebulaemperor_text_142", nil))
		local timeStr = SoraDConvertSecondToString(occupyPalaceSecs)
		_ENV = i18n("nebulaemperor_text_142", nil)
		i18n("nebulaemperor_text_142", nil).time = timeStr
		self.fields.Text_areaTime:setString(i18n("nebulaemperor_text_143", i18n("nebulaemperor_text_142", nil)))
	end
end
function NebulaEmperorBuildPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	local _fields = fguiHelper.get_fields(obj)
	_fields.Text_rank:setString(rank)
	local teamName = nebulaEmperorUtil.getTeamNameRaw(data.camp)
	local areaIcon = nebulaEmperorUtil.getAreaIcon(data.camp)
	_fields.Text_team:setString(teamName)
	_fields.Load_flag:setURL(areaIcon)
	_fields.Text_time:setString(SoraDConvertSecondToString(data.occupyPalaceSecs or 0))
end
function NebulaEmperorBuildPanel:onClickBtnEnergy(...)
	SoraDPlaySound()
	uiManager:show("NebulaEmperorEnergy")
end
function NebulaEmperorBuildPanel:onMsgUpdateBuild(target, event)
	if event and event.buildID == self.buildID then
		if not event.data then
			local _UPVALUE0_, data = event.data, event.data
		end
		self:showOcuppyInfo(data)
		if self:checkShowArmyCount() then
			self.needRefreshArmy = true
		end
	end
end
function NebulaEmperorBuildPanel:requestInstanceInfo()
	if self.mapInstance then
		local tilePoint = self.mapInstance:getTilePoint()
		local instanceID = self.mapInstance:getInstanceID()
		kingdomMapCtrl:reqMapObjInfo(tilePoint.x, tilePoint.y, instanceID)
	end
end
function NebulaEmperorBuildPanel:serverMessage_RequestMapInstaceInfo(target, event)
	if not (event and event.data) or not next(event.data) then
		return
	end
	if not self:checkShowArmyCount() then
		return
	end
	if not event.data.data then
		local _ENV, tipButtonData = event.data.data, event.data.data
	end
	self:updateTipButtonData(tipButtonData)
	_ENV = tipButtonData
	tipButtonData.armyCount = self.armyCount
	tipButtonData.maxNum = self.tipButtonData.maxNum
	self.fields.Com_buildOcuppy:updateTextTroop(tipButtonData)
end
function NebulaEmperorBuildPanel:updateTipButtonData(tipButtonData)
	self.tipButtonData = tipButtonData
	self.armyCount = kingdomMapUtil.getArmyCount(self.tipButtonData.army)
end
function NebulaEmperorBuildPanel:checkShowArmyCount(...)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeNebulaEmperorWarPalace] = true
	local (nil)[gWorldTypeServerDef.subTypeNebulaEmperorWarTower], cfg = true, nil
	if cfg[self.subType] then
		return self.ocuppyInfo.camp == self.selfCamp
	end
	return false
end
function NebulaEmperorBuildPanel:updateTime(...)
	if self.needRefreshArmy then
		self.needRefreshArmy = false
		if self:checkShowArmyCount() then
			self:requestInstanceInfo()
		end
	end
end
return NebulaEmperorBuildPanel
