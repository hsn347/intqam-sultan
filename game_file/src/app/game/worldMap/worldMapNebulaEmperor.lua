local gametop = gModuleMgr.getObject("gametop")
local nebulaEmperorRead = include("nebulaEmperorRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local teamDef = include("teamDef")
local worldMapInstance = include("worldMapInstance")
local worldMapNebulaEmperor = class("worldMapNebulaEmperor", function()
	local panel = SoraDCreateBasePanel("worldMapNebulaEmperor")
	local target = worldMapInstance.new(panel)
	return target
end)
function worldMapNebulaEmperor:ctor()
	self:initData()
	self:initWidget()
end
function worldMapNebulaEmperor:initData(...)
	self.siteClassID = nil
	self.warStatus = gKingdomWarStatusType.close
	self.fromCamp = 0
	self.protectEndTime = 0
	self.selfTeamId = nebulaEmperorCtrl:getSelfTeamId()
	self.selfCamp = nebulaEmperorCtrl:getSelfCamp()
end
function worldMapNebulaEmperor:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
	self.image_Protect:addTo(self, 1)
	self.Sprite_camp:setVisible(false)
end
function worldMapNebulaEmperor:setBatchNodeGroupID(groupID)
	self.Sprite_build:setGroupID(groupID)
end
function worldMapNebulaEmperor:getSiteClassID()
	return self.siteClassID
end
function worldMapNebulaEmperor:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapNebulaEmperor:initInstanceData(siteClassID, siteData, objId)
	print("==worldMapNebulaEmperor==", siteClassID, objId)
	self.siteClassID = siteClassID
	self.objId = objId
	local cfg = nebulaEmperorRead.getBuildConfig(self.siteClassID)
	self.subType = cfg.buildtype
	self.size = cfg.size
	self.image_Protect:setScale(self.size * 0.7)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarTower then
		self.image_Protect:setPositionY(150)
	end
	local buildImage = nebulaEmperorRead.getBuildImage(self.siteClassID)
	self.Sprite_build:setSpriteFrame(buildImage)
	local pos = nebulaEmperorUtil.getMapBuildPosition(self.subType)
	self.Sprite_build:setPosition(pos)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		self.Sprite_build:setScale(0.77)
	end
	self:initBuildCriSprite()
	self.Text_build:setString(self:getFavoriteName())
	self:initCampBuildPlayerInfo()
	self:updateData(siteData)
end
function worldMapNebulaEmperor:updateData(data)
	if not data then
		return
	end
	dump(data, "==worldMapNebulaEmperor:updateData==")
	self.buildData = data
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.camp then
		self.fromCamp = data.camp
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.protectEndTime then
		self.protectEndTime = data.protectEndTime
	end
	self:updateEmojiByData(data)
	self:updatePlayerInfo(data)
	self:updateSafeState()
	_ENV = self
	self.msg = "MESSAGE_NEBULA_EMPEROR_BUILD_UPDATE"
	self.buildID = self:getSiteClassID()
	self.data = data
	SoraDSendMessage(self)
end
function worldMapNebulaEmperor:updatePlayerInfo(data)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		return
	end
	local relationType = nebulaEmperorUtil.getRelationType(self.fromCamp, self.selfCamp)
	local nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
	self.Text_build:setColor(nameColor)
	if self.fromCamp and self.fromCamp > 0 then
		self.Node_player:setVisible(true)
		self.Text_player:setColor(nameColor)
		_ENV = nameColor
		nameColor.abbr = data.teamAbbr
		nameColor.name = data.playerName
		local teamStr = i18n("common_text_186", nameColor)
		self.Text_player:setString(teamStr)
	else
		self.Node_player:setVisible(false)
	end
end
function worldMapNebulaEmperor:checkInProtectTime(...)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		return false
	end
	if not self:checkInWarStatus() then
		return true
	end
	if self.protectEndTime ~= 0 and self.protectEndTime > serviceFunctions.systemTime() then
		return true
	end
	return false
end
function worldMapNebulaEmperor:updateSafeState()
	if self:checkInProtectTime() then
		self.image_Protect:setVisible(true)
	else
		self.image_Protect:setVisible(false)
	end
end
function worldMapNebulaEmperor:getFavoriteName()
	return nebulaEmperorRead.getBuildName(self.siteClassID)
end
function worldMapNebulaEmperor:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapNebulaEmperor:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, nil)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		return buttonTypeArray
	end
	if self:checkInWarStatus() then
		local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
		local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
		local haveTower = 1 < towerLv
		local isEnable, msgTipsKey = true
		if nebulaEmperorUtil.isForbitWarByInBorn() then
			isEnable = false
			msgTipsKey = i18n("nebulaemperor_text_220")
		elseif nebulaEmperorUtil.isTileInBornArea(self:getTilePoint()) then
			isEnable = false
			msgTipsKey = i18n("nebulaemperor_text_219")
		end
		local addToButtonTypeArray = function(buttonType)
			_ENV = nil
			;(nil).buttonType = buttonType
			;(nil).isButtonEnabled = isEnable
			;(nil).msgTipsKey = msgTipsKey
			table.insert(buttonTypeArray, nil)
		end
		if not self.fromCamp or self.fromCamp == 0 then
			if haveHall then
				addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_xuanZhan)
			end
			addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_gongJi)
		elseif self.fromCamp == self.selfCamp then
			local hasArmy, queueId = self:checkHasArmy()
			if hasArmy and queueId and (not _G._returnQueueIdList or not _G._returnQueueIdList[queueId]) then
				_ENV = self:getTilePoint()
				self:getTilePoint().buttonType = worldMapDefine.worldMapTipButtonType_fanHui
				table.insert(buttonTypeArray, self:getTilePoint())
			end
			if self:canHasEmojiOperator() then
				_ENV = self:getTilePoint()
				self:getTilePoint().buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				table.insert(buttonTypeArray, self:getTilePoint())
			end
			addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_shibingYuabzhu)
			if haveHall then
				addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_zuduiYuanzhu)
			end
			_ENV = self:getTilePoint()
			self:getTilePoint().buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
			table.insert(buttonTypeArray, self:getTilePoint())
		else
			if haveHall then
				addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_xuanZhan)
			end
			if haveTower then
				addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_zhenCha)
			end
			addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_gongJi)
		end
	end
	return buttonTypeArray
end
function worldMapNebulaEmperor:initCampBuildPlayerInfo(...)
	if self.subType ~= gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		return
	end
	local buildCamp = nebulaEmperorRead.getBuildCamp(self.siteClassID)
	local relationType = nebulaEmperorUtil.getRelationType(buildCamp, self.selfCamp)
	local nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
	self.Text_build:setColor(nameColor)
	local teamStr = nebulaEmperorUtil.getAreaName(buildCamp)
	self.Text_player:setColor(nameColor)
	self.Text_player:setString(teamStr)
end
function worldMapNebulaEmperor:getBuildData(...)
	return self.buildData
end
function worldMapNebulaEmperor:initBuildCriSprite(...)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeNebulaEmperorWarPalace] = "xydw_diwangjz01.usm"
	local (nil)[gWorldTypeServerDef.subTypeNebulaEmperorWarTower], config = "xydw_diwangjz02.usm", nil
	local effectPath = config[self.subType]
	if not effectPath then
		self.Sprite_build:setVisible(true)
		return
	end
	self.Sprite_build:setVisible(false)
	local criSprite = cc.criSprite.createCriSprite(effectPath, false, true)
	criSprite:addTo(self)
	criSprite:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	_ENV = criSprite.setBlendFunc
	criSprite.setBlendFunc[gWorldTypeServerDef.subTypeNebulaEmperorWarPalace] = cc.p(31, 119)
	local criSprite.setBlendFunc[gWorldTypeServerDef.subTypeNebulaEmperorWarTower], config = cc.p(28, 145), criSprite.setBlendFunc
	local offset = config[self.subType]
	local pos = nebulaEmperorUtil.getMapBuildPosition(self.subType)
	criSprite:setPosition(pos.x + offset.x, pos.y + offset.y)
end
return worldMapNebulaEmperor
