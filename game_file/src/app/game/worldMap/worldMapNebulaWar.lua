local gametop = gModuleMgr.getObject("gametop")
local nebulaWarRead = include("nebulaWarRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local teamDef = include("teamDef")
local worldMapInstance = include("worldMapInstance")
local worldMapNebulaWar = class("worldMapNebulaWar", function()
	local panel = SoraDCreateBasePanel("worldMapNebulaWar")
	local target = worldMapInstance.new(panel)
	include("worldMapBuildProtectTips").new(target)
	return target
end)
function worldMapNebulaWar:ctor()
	self:initData()
	self:initWidget()
end
function worldMapNebulaWar:initData(...)
	self.siteClassID = nil
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.fromCamp = 0
	self.isSelfIn = false
	self.protectEndTime = 0
	self.selfCamp = nebulaActivityCtrl:getSelfCamp()
	self.selfTeamId = nebulaActivityCtrl:getSelfTeamId()
end
function worldMapNebulaWar:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
	self.image_Protect:addTo(self, 1)
	if self.Sprite_camp then
		self.Sprite_camp:setVisible(false)
	end
end
function worldMapNebulaWar:setBatchNodeGroupID(groupID)
	self.Sprite_build:setGroupID(groupID)
end
function worldMapNebulaWar:getSiteClassID()
	return self.siteClassID
end
function worldMapNebulaWar:getSubType()
	return self.subType
end
function worldMapNebulaWar:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapNebulaWar:initInstanceData(siteClassID, siteData, objId)
	print("==worldMapNebulaWar==", siteClassID, objId)
	self.siteClassID = siteClassID
	self.objId = objId
	local serverConfig = nebulaWarRead.getServerBuildConfig(self.siteClassID)
	self.subType = serverConfig.buildtype
	self.size = serverConfig.size
	self.image_Protect:setScale(self.size * 0.7)
	local buildImage = nebulaWarRead.getBuildImage(self.subType)
	self.Sprite_build:setSpriteFrame(buildImage)
	local pos = nebulaWarUtil.getMapBuildPosition(self.subType)
	self.Sprite_build:setPosition(pos)
	self.Text_build:setString(self:getFavoriteName())
	self:updateData(siteData)
end
function worldMapNebulaWar:updateData(data)
	if not data then
		return
	end
	dump(data, "==worldMapNebulaWar:updateData==")
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.fromKid then
		self.fromKid = data.fromKid
	end
	if data.camp then
		self.fromCamp = data.camp
	end
	if data.teamId then
		self.fromTeamId = data.teamId
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.isSelfIn ~= nil then
		self.isSelfIn = data.isSelfIn
	end
	if data.status then
		self.buildState = data.status
	end
	if data.protectEndTime then
		self.protectEndTime = data.protectEndTime
	end
	if data.connect then
		self.connect = data.connect
	end
	self:updateDataProtectime(data)
	self:updateEmojiByData(data)
	self:updatePlayerInfo(data)
	self:updateSafeState()
	self:updateFireEffect(self.buildState)
	_ENV = self
	self.msg = "MESSAGE_ATLANTISWAR_BUILD_UPDATE"
	self.siteClassID = self:getSiteClassID()
	SoraDSendMessage(self)
end
function worldMapNebulaWar:updatePlayerInfo(data)
	if self.fromCamp and self.fromCamp > 0 then
		self.Node_player:setVisible(true)
		local relationType = nebulaWarUtil.getRelationType(self.fromCamp, self.selfCamp, self.fromTeamId, self.selfTeamId)
		local nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
		self.Text_build:setColor(nameColor)
		self.Text_player:setColor(nameColor)
		self.rolygonColor = nameColor
		if data.teamAbbr then
			self.teamAbbr = data.teamAbbr
		end
		nebulaWarUtil = nameColor
		nameColor.abbr = self.teamAbbr
		nameColor.name = data.playerName
		local teamStr = i18n("common_text_186", nameColor)
		self.Text_player:setString(teamStr)
	else
		self.Node_player:setVisible(false)
		local nameColor = worldMapDefine.getLeagueManorLineColor(nil, gMapAllianceRelationType.NORMAL)
		self.Text_build:setColor(nameColor)
		self.rolygonColor = nameColor
	end
end
function worldMapNebulaWar:checkInProtectTime(...)
	if not self:checkInWarStatus() then
		return true
	end
	if self.protectEndTime ~= 0 and self.protectEndTime > serviceFunctions.systemTime() then
		return true
	end
	return false
end
function worldMapNebulaWar:updateSafeState()
	if self:checkInProtectTime() then
		self.image_Protect:setVisible(true)
		self:setProtectimeShow(true)
	else
		self.image_Protect:setVisible(false)
		self:setProtectimeShow(false)
	end
end
function worldMapNebulaWar:getFavoriteName()
	return nebulaWarRead.getBuildName(self.subType)
end
function worldMapNebulaWar:getConnect(...)
	return self.connect
end
function worldMapNebulaWar:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapNebulaWar:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if self.subType == gWorldTypeServerDef.subTypeNebulaWarBigMine or self.subType == gWorldTypeServerDef.subTypeNebulaWarSmallMine then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
		table.insert(buttonTypeArray, nil)
		return buttonTypeArray
	end
	if self:checkInWarStatus() then
		local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
		local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
		local enable = nebulaWarUtil.checkBuildCanAttack2(self.subType)
		if not self.fromCamp or self.fromCamp == 0 then
			if not self:checkInProtectTime() then
				if haveHall then
					_ENV = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					;(nil).isButtonEnabled = enable
					table.insert(buttonTypeArray, nil)
				end
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				;(nil).isButtonEnabled = enable
				table.insert(buttonTypeArray, nil)
			end
		elseif self.fromCamp == self.selfCamp and self.fromTeamId == self.selfTeamId then
			local hasArmy, queueId = self:checkHasArmy()
			if hasArmy and queueId and (not _G._returnQueueIdList or not _G._returnQueueIdList[queueId]) then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fanHui
				table.insert(buttonTypeArray, nil)
			end
			if haveHall then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
				table.insert(buttonTypeArray, nil)
			end
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
			table.insert(buttonTypeArray, nil)
			if self:canHasEmojiOperator() then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				table.insert(buttonTypeArray, nil)
			end
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
			table.insert(buttonTypeArray, nil)
		elseif not self:checkInProtectTime() then
			if haveHall then
				_ENV = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
				table.insert.isButtonEnabled = enable
				table.insert(buttonTypeArray, table.insert)
			end
			_ENV = table.insert
			table.insert.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
			table.insert.isButtonEnabled = enable
			table.insert(buttonTypeArray, table.insert)
			if 1 < towerLv then
				_ENV = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
				table.insert.isButtonEnabled = enable
				table.insert(buttonTypeArray, table.insert)
			end
		end
	end
	_ENV = nebulaWarUtil.checkBuildCanAttack2(self.subType)
	nebulaWarUtil.checkBuildCanAttack2(self.subType).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, (nebulaWarUtil.checkBuildCanAttack2(self.subType)))
	return buttonTypeArray
end
function worldMapNebulaWar:getAllianceAbbr(...)
	return self.teamAbbr
end
return worldMapNebulaWar
