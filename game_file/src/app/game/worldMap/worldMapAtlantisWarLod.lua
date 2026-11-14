local gametop = gModuleMgr.getObject("gametop")
local AMB = require_data("atlantiswar_map_build", true).data
local AMBC = require_data("atlantiswar_map_build_config").data
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local worldLodDef = worldMapDefine.worldLodDef
local atlantisWarUtil = include("atlantisWarUtil")
local worldMapAtlantisWarLod = class("worldMapAtlantisWarLod", include("worldMapInstanceLod"))
function worldMapAtlantisWarLod:ctor()
	worldMapAtlantisWarLod.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapAtlantisWarLod:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.protectScale = 1
	self.hasInitBuildTime = false
end
function worldMapAtlantisWarLod:_initUI()
	local node = SoraDCreateCSBNode("worldMapAtlantisWarLod")
	node:addTo(self, 1)
	SoraDGetAllChildFromWidget(node, self)
	self.Text_buildTime = SoraDCreateTimerLabel(self, self.Text_buildTime)
end
function worldMapAtlantisWarLod:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_WARDATA", handler(self, self.onMsgRefreshWarData))
end
function worldMapAtlantisWarLod:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapAtlantisWarLod:onMsgRefreshWarData(...)
	if not self.hasInitBuildTime then
		self:initBuildTime()
	end
end
function worldMapAtlantisWarLod:initInstanceData(objData, worldInstanceData, instanceData)
	self.siteClassID = objData.objId
	self.subType = AMB[self.siteClassID].type
	local imgName = AMBC[self.siteClassID].image
	self.Sprite_build:setSpriteFrame(imgName)
	if self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarPalace then
		self.Sprite_build:setPosition(-100, 120)
		self.Sprite_build:setScale(1.3)
		self.Node_buildTime:setPositionY(250)
	elseif self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarFort then
		self.Sprite_build:setPosition(-50, 50)
		self.Sprite_build:setScale(1)
		self.Node_buildTime:setPositionY(150)
	elseif self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarBattery then
		self.Sprite_build:setPosition(-50, 50)
		self.Sprite_build:setScale(1)
	end
	local size = AMB[self.siteClassID].size
	self.protectScale = size * 0.7
	self.Node_protect:setScale(self.protectScale)
	self:initBuildTime()
	self:updateData(objData)
end
function worldMapAtlantisWarLod:updateData(data, delayTime)
	if data.fromKid then
		self.fromKid = data.fromKid
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	self:updatePlayerInfo(data)
	self:updateSafeState()
end
function worldMapAtlantisWarLod:updatePlayerInfo(data)
	if self:checkInWarStatus() and self.fromKid and self.fromKid > 0 then
		if self.lod ~= worldLodDef.LOD3 then
			self.Node_kingdom:setVisible(true)
		else
			self.Node_kingdom:setVisible(false)
		end
		self.Node_player:setVisible(true)
		if data.kingdomName then
			self.kingdomName = data.kingdomName
		end
		if data.playerName then
			self.playerName = data.playerName
		end
		local selfKid = gametop.playertop_:getKingdomID()
		local relationType = gMapAllianceRelationType.ENEMY
		if self.fromKid == selfKid then
			relationType = gMapAllianceRelationType.SELF
		end
		local nameColor = worldMapDefine.getLeagueManorLineColor(false, relationType)
		self.Text_kingdom:setColor(nameColor)
		self.Text_player:setColor(nameColor)
		self.Text_kingdom:setString(serviceFunctions.getKingdomFormatName(self.kingdomName, self.fromKid))
		self.Text_player:setString(self.playerName)
	else
		self.Node_kingdom:setVisible(false)
		self.Node_player:setVisible(false)
	end
end
function worldMapAtlantisWarLod:updateSafeState()
	if self:checkInWarStatus() then
		self.Node_protect:setVisible(false)
	else
		self.Node_protect:setVisible(true)
	end
end
function worldMapAtlantisWarLod:updateScaleChange(revertScale, scale)
	local realScale = revertScale * 0.65
	self.Node_player:setScale(realScale)
	self.Node_kingdom:setScale(realScale)
	self.Node_buildTime:setScale(realScale * 2)
end
function worldMapAtlantisWarLod:updateLodChange(...)
	if self.lod == worldLodDef.LOD3 then
		self.Node_kingdom:setVisible(false)
	elseif self:checkInWarStatus() and self.fromKid and self.fromKid > 0 then
		self.Node_kingdom:setVisible(true)
	end
end
function worldMapAtlantisWarLod:initBuildTime(...)
	local build = AMB[self.siteClassID]
	self:refreshTextBuildTime(self.Text_buildTime, build)
end
function worldMapAtlantisWarLod:refreshTextBuildTime(widget, build)
	local warData = atlantisWarCtrl:getWarData()
	if not warData.bossWlynStartTime then
		return
	end
	atlantisWarCtrl, atlantisWarCtrl = nil, warData.bossWlynStartTime
	;(nil).startTime = warData.bossWlynStartTime
	atlantisWarCtrl, warData.bossWlynStartTime[1], (nil).endTime = nil, nil, warData.bossWlynEndTime
	;(nil).startTime = warData.bossSdStartTime
	atlantisWarCtrl, warData.bossWlynStartTime[2], (nil).endTime = nil, nil, warData.bossSdEndTime
	;(nil).startTime = warData.warAreaStartTime
	warData.bossWlynStartTime[3], (nil).endTime = nil, warData.warAreaEndTime
	local timeConfig = warData.bossWlynStartTime
	local timeData
	if build.mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
		if build.type ~= gWorldTypeServerDef.subMapTypeAtlantisWarBattery then
			timeData = timeConfig[3]
		else
			local tSubType = atlantisWarUtil.getTargetSubType(self.siteClassID)
			if tSubType == gBossType.atlantisWarWlyn then
				timeData = timeConfig[1]
			elseif tSubType == gBossType.atlantisWarSd then
				timeData = timeConfig[2]
			end
		end
	elseif build.mapType == gMapObjTypeDef.mapTypeAtlantisWarBoss then
		if build.type == gBossType.atlantisWarWlyn then
			timeData = timeConfig[1]
		elseif build.type == gBossType.atlantisWarSd then
			timeData = timeConfig[2]
		end
	end
	local refreshTime = function(timeData)
		local startTime = timeData.startTime
		local endTime = timeData.endTime
		local curTime = serviceFunctions.systemTime()
		if startTime > curTime then
			widget:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("common_text_606", nil)
			end)
			widget:beginTime(startTime - curTime)
		elseif endTime < curTime then
			_ENV = nil
			;(nil).var = ""
			widget:setString(i18n("atlantiswar_text_0231", nil))
		elseif startTime <= curTime and endTime >= curTime then
			widget:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("common_text_607", nil)
			end)
			widget:beginTime(endTime - curTime)
		end
	end
	if timeData then
		widget:setTimeEndListener(function()
			refreshTime(timeData)
		end)
		refreshTime(timeData)
		self.hasInitBuildTime = true
	end
end
return worldMapAtlantisWarLod
