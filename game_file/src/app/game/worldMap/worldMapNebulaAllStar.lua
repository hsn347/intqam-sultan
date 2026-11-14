local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarRead = include("nebulaAllStarRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local teamDef = include("teamDef")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local worldMapInstance = include("worldMapInstance")
local worldMapNebulaAllStar = class("worldMapNebulaAllStar", function()
	local panel = SoraDCreateBasePanel("worldMapNebulaEmperor")
	panel:setName("worldMapNebulaAllStar")
	local target = worldMapInstance.new(panel)
	return target
end)
function worldMapNebulaAllStar:ctor()
	self:initData()
	self:initWidget()
end
function worldMapNebulaAllStar:initData(...)
	self.siteClassID = nil
	self.warStatus = gKingdomWarStatusType.close
	self.fromCamp = 0
	self.protectEndTime = 0
	self.selfTeamId = nebulaAllStarCtrl:getSelfTeamId()
	self.selfCamp = nebulaAllStarCtrl:getSelfCamp()
end
function worldMapNebulaAllStar:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
	self.image_Protect:addTo(self, 1)
	self.Sprite_camp:setVisible(false)
end
function worldMapNebulaAllStar:setBatchNodeGroupID(groupID)
	self.Sprite_build:setGroupID(groupID)
end
function worldMapNebulaAllStar:getSiteClassID()
	return self.siteClassID
end
function worldMapNebulaAllStar:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapNebulaAllStar:initInstanceData(siteClassID, siteData, objId)
	print("==worldMapNebulaAllStar==", siteClassID, objId)
	self.siteClassID = siteClassID
	self.objId = objId
	local cfg = nebulaAllStarRead.getBuildConfig(self.siteClassID)
	self.subType = cfg.buildtype
	self.size = cfg.size
	self.image_Protect:setScale(self.size * 0.7)
	local buildImage = nebulaAllStarRead.getBuildImage(self.siteClassID)
	self.Sprite_build:setSpriteFrame(buildImage)
	local pos = nebulaAllStarRead.getMapBuildPosition(self.subType)
	self.Sprite_build:setPosition(pos)
	local scale = nebulaAllStarRead.getMapBuildScale(self.subType)
	self.Sprite_build:setScale(scale)
	self.Text_build:setString(self:getFavoriteName())
	self:initBuildCriSprite()
	self:updateData(siteData)
end
function worldMapNebulaAllStar:initBuildCriSprite(...)
	self.Sprite_build:setVisible(true)
	local pos = nebulaAllStarRead.getMapBuildPosition(self.subType)
	if self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarTower then
		pos = cc.p(24, 100)
	end
	nebulaAllStarRead = 24
	;(24).subType = self.subType
	;(24).parent = self
	;(24).pos = pos
	;(24).scale = nebulaAllStarRead.getMapBuildScale(self.subType)
	;(24).Sprite_build = self.Sprite_build
	nebulaAllStarUtil.getBuildSpriteEffect(24)
end
function worldMapNebulaAllStar:updateData(data)
	if not data then
		return
	end
	dump(data, "==worldMapNebulaAllStar:updateData==")
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
	if data.teamId then
		self.fromTeamId = data.teamId
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
function worldMapNebulaAllStar:updatePlayerInfo(data)
	local nameColor = nebulaAllStarRead.getCampColorRGB(self.fromCamp)
	self.Text_build:setColor(nameColor)
	if self.fromCamp and self.fromCamp > 0 then
		self.Node_player:setVisible(true)
		self.Text_player:setColor(nameColor)
		local teamAbbr = nebulaAllStarUtil.getTeamAbbr(self.fromCamp, self.fromTeamId)
		nebulaAllStarRead = nil
		;(nil).abbr = teamAbbr
		;(nil).name = data.playerName
		local teamStr = i18n("common_text_186", nil)
		self.Text_player:setString(teamStr)
	else
		self.Node_player:setVisible(false)
	end
end
function worldMapNebulaAllStar:checkInProtectTime(...)
	if self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarCamp then
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
function worldMapNebulaAllStar:updateSafeState()
	if self:checkInProtectTime() then
		self.image_Protect:setVisible(true)
	else
		self.image_Protect:setVisible(false)
	end
end
function worldMapNebulaAllStar:getFavoriteName()
	return nebulaAllStarRead.getBuildName(self.siteClassID)
end
function worldMapNebulaAllStar:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapNebulaAllStar:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarCamp then
		return buttonTypeArray
	end
	if not worldMapDefine.isInNebulaAllStar() then
		return buttonTypeArray
	end
	if self:checkInWarStatus() then
		local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
		local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
		local haveTower = 1 < towerLv
		local isEnable, msgTipsKey = true
		local ok, errTip = nebulaAllStarUtil.checkBuildCanAttack(self.subType)
		if not ok then
			isEnable = false
			msgTipsKey = errTip
		end
		local addToButtonTypeArray = function(buttonType)
			_ENV = nil
			;(nil).buttonType = buttonType
			;(nil).isButtonEnabled = isEnable
			;(nil).msgTipsKey = msgTipsKey
			table.insert(buttonTypeArray, nil)
		end
		if not self.fromCamp or self.fromCamp == 0 then
			addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_gongJi)
			if haveHall then
				addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_xuanZhan)
			end
		elseif self.fromCamp == self.selfCamp then
			local hasArmy, queueId = self:checkHasArmy()
			if hasArmy and queueId and (not _G._returnQueueIdList or not _G._returnQueueIdList[queueId]) then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fanHui
				table.insert(buttonTypeArray, nil)
			end
			if self:canHasEmojiOperator() then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				table.insert(buttonTypeArray, nil)
			end
			addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_shibingYuabzhu)
			if haveHall then
				addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_zuduiYuanzhu)
			end
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
			table.insert(buttonTypeArray, nil)
		else
			addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_gongJi)
			if haveHall then
				addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_xuanZhan)
			end
			if haveTower then
				addToButtonTypeArray(worldMapDefine.worldMapTipButtonType_zhenCha)
			end
		end
	end
	_ENV = true
	;(true).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, true)
	return buttonTypeArray
end
function worldMapNebulaAllStar:getBuildData(...)
	return self.buildData
end
return worldMapNebulaAllStar
