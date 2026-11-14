local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local kingdomMapUtil = include("kingdomMapUtil")
local nebulaWarRead = include("nebulaWarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarBuildPanel = class("NebulaAllStarBuildPanel", baseFguiPanel)
function NebulaAllStarBuildPanel:ctor(...)
	NebulaAllStarBuildPanel.super.ctor(self, ...)
	print("NebulaAllStarBuildPanel:ctor", self.viewName)
	self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime))
	self.isHideCurrentSceneView = true
	self.startPalaceWar = nebulaAllStarCtrl:getStartPalaceWar()
	self.selfCamp = nebulaAllStarCtrl:getSelfCamp()
	self.activityID = gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY
end
function NebulaAllStarBuildPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaEmperor"
		self._packageList, self._packageList[2] = self._packageList, "NebulaEmperorWar"
	end
	return self._packageList
end
function NebulaAllStarBuildPanel:onInit()
	print("=======NebulaAllStarBuildPanel:onInit")
	local param = self.proxy.param
	self.buildID = param.buildID
	self.subType = nebulaAllStarRead.getBuildType(self.buildID)
	self:updateTipButtonData(param.tipButtonData)
	self.mapInstance = param.mapInstance
	local buildName = nebulaAllStarRead.getBuildName(self.buildID)
	local handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("NebulaAllStarBuild")
	self.fields.Com_title:initData(buildName, handler(self, self.onClickClose), handlerHelp)
	self.fields.Text_tip:setString(i18n("NebulaAllstar_129"))
	local obj = self.fields.Com_buildImage:getChild("icon")
	local buildImage = nebulaAllStarRead.getBuildImage(self.buildID)
	obj:setURL(buildImage)
	if self.subType ~= gWorldTypeServerDef.subTypeNebulaAllStarWarPalace then
		local scale = nebulaAllStarRead.getMapBuildScale(self.subType)
		obj:setScale(scale)
	end
	local pos = nebulaAllStarRead.getMapBuildPosition(self.subType)
	obj:setPosition(pos)
	self:initBuildCriSprite()
	self.fields.Com_noOcuppy:setHeadSprite("frame_qmx_jianying.png")
	self.fields.Text_noOcuppy:setString(i18n("NebulaAllstar_133"))
	self:initTextBuff()
	self.controllers.c_war:setSelectedIndex(self.startPalaceWar and 1 or 0)
	if self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarPalace then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.List_build:setItemRenderer(handler(self, self.onItemRenderer))
		self.fields.Group_noOcuppy:setVisible(self.startPalaceWar)
	elseif self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarTower then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Button_energy:setString(i18n("nebulaemperor_text_22"))
		self.fields.Button_energy:addClickListener(handler(self, self.onClickBtnEnergy))
	else
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Button_build:setString(i18n("NebulaAllstar_136"))
		self.fields.Button_build:addClickListener(handler(self, self.onClickBtnBuild))
	end
end
function NebulaAllStarBuildPanel:initBuildCriSprite(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_buildImage)
	if self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarPalace then
		_fields.Usm_1:setVisible(true)
		_fields.Usm_1:setPosition(cc.p(20, 100))
		return
	else
		_fields.Usm_1:setVisible(false)
	end
	local pos = nebulaAllStarRead.getMapBuildPosition(self.subType)
	_ENV = false
	;(false).subType = self.subType
	;(false).parent = self.fields.Com_buildImage
	;(false).pos = cc.p(320 + pos.x, 75 + pos.y + 25)
	;(false).scale = nebulaAllStarRead.getMapBuildScale(self.subType)
	;(false).Sprite_build = _fields.icon
	nebulaAllStarUtil.getBuildSpriteEffect(false)
end
function NebulaAllStarBuildPanel:onShow()
	print("=======NebulaAllStarBuildPanel:onShow")
	self.fields.Com_buildOcuppy:setActivityID(self.activityID)
	self.fields.Com_energy:setActivityID(self.activityID)
	self:showOcuppyInfo(self.mapInstance:getBuildData())
	if self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarPalace then
		if self.startPalaceWar then
			self.fields.Com_energy:setStartPalaceWar()
		else
			nebulaAllStarCtrl:reqEnergyData()
		end
		self:updateBuildList()
	elseif self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarTower then
		nebulaAllStarCtrl:reqEnergyData()
	end
end
function NebulaAllStarBuildPanel:updateBuildList(...)
	self.buildList, nebulaAllStarRead = nil, nil
	local buildIDList = nebulaAllStarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaAllStarWarTower)
	for __, buildID in ipairs(buildIDList) do
		nebulaAllStarRead = nil
		;(nil).buildID = buildID
		table.insert(self.buildList, nil)
	end
	if self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarPalace then
		self.fields.List_build:setNumItems(#self.buildList)
	end
end
function NebulaAllStarBuildPanel:onItemRenderer(index, obj)
	local data = self.buildList[index + 1]
	local buildID = data.buildID
	local _fields = obj._fields
	if not _fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj.c_war = obj:getController("c_war")
		_fields = obj._fields
		_fields.Button_go:setString(i18n("common_text_477"))
		_fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
		_ENV = _fields.Button_go
		_fields.Button_go.subType = gWorldTypeServerDef.subTypeNebulaAllStarWarTower
		_fields.Button_go.parent = obj
		_fields.Button_go.pos = cc.p(90, 180)
		_fields.Button_go.scale = 0.54
		nebulaAllStarUtil.getBuildSpriteEffect(_fields.Button_go)
	end
	local buildPos = nebulaAllStarRead.getBuildPos(buildID)
	_ENV = handler(self, self.onClickBtnGo)
	handler(self, self.onClickBtnGo).x = buildPos.x
	handler(self, self.onClickBtnGo).y = buildPos.y
	_fields.Text_pos:setString(i18n("common_text_2155", handler(self, self.onClickBtnGo)))
	_fields.Button_go:setTag(buildID)
	local buildImage = nebulaAllStarRead.getBuildImage(buildID)
	_fields.icon:setURL(buildImage)
	obj.c_war:setSelectedIndex(self.startPalaceWar and 1 or 0)
	if self.startPalaceWar then
		local buildName = nebulaAllStarRead.getBuildName(buildID)
		_fields.Text_name:setString(buildName)
	else
		local owner = nebulaAllStarCtrl:getBuildOwner(buildID)
		if owner then
			_fields.Load_region:setVisible(true)
			local regionIcon = nebulaWarRead.getAreaIcon(owner.camp)
			_fields.Load_region:setURL(regionIcon)
			_fields.Text_occupy:setString(owner.name)
		else
			_fields.Load_region:setVisible(false)
			_fields.Text_occupy:setString(i18n("devilvalley_text_21"))
		end
		fguiHelper.setTextWidthHeight(_fields.Text_occupy, cc.size(100, 30))
	end
end
function NebulaAllStarBuildPanel:onClickBtnGo(EventContext)
	SoraDPlaySound()
	if not worldMapDefine.isInNebulaAllStar() then
		return
	end
	local buildID = EventContext:getSender():getTag()
	local buildPos = nebulaAllStarRead.getBuildPos(buildID)
	SoraDGotoWorldMapPoint(buildPos, true)
	SoraDRemoveAllPanelFromManager()
end
function NebulaAllStarBuildPanel:showOcuppyInfo(data)
	dump(data, "==NebulaAllStarBuildPanel:showOcuppyInfo==")
	_ENV = dump
	dump.uid = data.playerID
	dump.iconID = data.headid
	dump.avatar = data.avatar
	dump.avatarFrameId = data.avatarFrameId
	dump.name = data.playerName
	dump.camp = data.camp
	local dump.beginOccupyTime, ocuppyInfo = data.beginOccupyTime, dump
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
function NebulaAllStarBuildPanel:onMsgEnergyDataBack(...)
	SoraDCloseLoading(self:displayObject())
	self.startPalaceWar = nebulaAllStarCtrl:getStartPalaceWar()
	self.controllers.c_war:setSelectedIndex(self.startPalaceWar and 1 or 0)
	if self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarPalace then
		self.fields.Com_energy:updateEnergy()
		self:updateBuildList()
		self.fields.Group_noOcuppy:setVisible(self.startPalaceWar)
	elseif self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarTower then
		self:initTextBuff()
	end
end
function NebulaAllStarBuildPanel:onClickBtnEnergy(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("NebulaEmperorEnergy", nil)
end
function NebulaAllStarBuildPanel:onClickBtnBuild(...)
	SoraDPlaySound()
	uiManager:show("NebulaAllStarBuildBuff")
end
function NebulaAllStarBuildPanel:onMsgUpdateBuild(target, event)
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
function NebulaAllStarBuildPanel:requestInstanceInfo()
	if self.mapInstance then
		local tilePoint = self.mapInstance:getTilePoint()
		local instanceID = self.mapInstance:getInstanceID()
		kingdomMapCtrl:reqMapObjInfo(tilePoint.x, tilePoint.y, instanceID)
	end
end
function NebulaAllStarBuildPanel:serverMessage_RequestMapInstaceInfo(target, event)
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
function NebulaAllStarBuildPanel:updateTipButtonData(tipButtonData)
