local gametop = gModuleMgr.getObject("gametop")
local AMB = require_data("atlantiswar_map_build", true).data
local AMBC = require_data("atlantiswar_map_build_config").data
local allianceMgr = SoraDGetCtrl("allianceMgr")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisWarUtil = include("atlantisWarUtil")
local worldMapInstance = include("worldMapInstance")
local worldMapAtlantisWar = class("worldMapAtlantisWar", function()
	local panel = SoraDCreateBasePanel("worldMapAtlantisWar")
	local target = worldMapInstance.new(panel)
	return target
end)
function worldMapAtlantisWar:ctor()
	self:initData()
	self:initWidget()
end
function worldMapAtlantisWar:initData(...)
	self.siteClassID = nil
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.isSelfIn = false
end
function worldMapAtlantisWar:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.Text_title:setString(i18n("common_text_1446"))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Node_state:setVisible(false)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
	self.image_Protect:addTo(self, 1)
end
function worldMapAtlantisWar:setBatchNodeGroupID(groupID)
	self.Sprite_build:setGroupID(groupID)
end
function worldMapAtlantisWar:getSiteClassID()
	return self.siteClassID
end
function worldMapAtlantisWar:getSubType()
	return self.subType
end
function worldMapAtlantisWar:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapAtlantisWar:initInstanceData(siteClassID, siteData, objId)
	print("==worldMapAtlantisWar==", siteClassID, objId)
	self.siteClassID = siteClassID
	self.objId = objId
	self.subType = AMB[self.siteClassID].type
	local imgName = AMBC[self.siteClassID].image
	self.Sprite_build:setSpriteFrame(imgName)
	if self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarPalace then
		self.Node_state:setPositionY(250)
		self.Sprite_build:setPosition(-100, 120)
		self.Sprite_build:setScale(1.3)
	elseif self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarFort then
		self.Node_state:setPositionY(150)
		self.Sprite_build:setPosition(-50, 50)
	elseif self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarBattery then
		self.Sprite_build:setPosition(-50, 50)
	end
	local size = AMB[self.siteClassID].size
	self.image_Protect:setScale(size * 0.7)
	self:updateData(siteData)
end
function worldMapAtlantisWar:updateData(data)
	if not data then
		return
	end
	dump(data, "==worldMapAtlantisWar:updateData==")
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.fromKid then
		self.fromKid = data.fromKid
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
	self:updateEmojiByData(data)
	self:updatePlayerInfo(data)
	self:updateSafeState()
	self:updateFireEffect(self.buildState)
	_ENV = self
	self.msg = "MESSAGE_ATLANTISWAR_BUILD_UPDATE"
	self.siteClassID = self:getSiteClassID()
	SoraDSendMessage(self)
end
function worldMapAtlantisWar:updatePlayerInfo(data)
	if self:checkInWarStatus() and self.fromKid and self.fromKid > 0 then
		self.Node_kingdom:setVisible(true)
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
function worldMapAtlantisWar:updateSafeState()
	if self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarPalace or self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarFort then
		if self:checkInWarStatus() then
			self.Node_state:setVisible(true)
			local time = atlantisWarCtrl:getWarStageRemainTime(gAtlantisWarStageType.warAreaIng)
			self.Text_time:beginTime(time)
		else
			self.Node_state:setVisible(false)
		end
	else
		self.Node_state:setVisible(false)
	end
	if self:checkInWarStatus() then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapAtlantisWar:getFavoriteName()
	local favoriteName = i18n(AMBC[self.siteClassID].name)
	return favoriteName
end
function worldMapAtlantisWar:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapAtlantisWar:getInstanceOp(isSelfKindom)
	local gametop, buttonTypeArray
	local selfKid = gametop.playertop_:getKingdomID()
	local ret = atlantisWarUtil.checkBuildState(self.siteClassID)
	local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
	local insertToArray = function(buttonType, isCheck)
		if isCheck then
			_ENV = nil
			;(nil).buttonType = buttonType
			;(nil).isButtonEnabled = ret.isCanZhanling
			;(nil).msgTipsKey = ret.clickTips
			return table.insert(buttonTypeArray, nil)
		else
			_ENV = nil
			;(nil).buttonType = buttonType
			return table.insert(buttonTypeArray, nil)
		end
	end
	if self:checkInWarStatus() then
		if self.fromKid == 0 then
			insertToArray(worldMapDefine.worldMapTipButtonType_gongJi, true)
			if haveHall then
				insertToArray(worldMapDefine.worldMapTipButtonType_xuanZhan, true)
			end
		elseif selfKid == self.fromKid then
			if self:checkHasArmy() then
				insertToArray(worldMapDefine.worldMapTipButtonType_fanHui)
			end
			if self:canHasEmojiOperator() then
				insertToArray(worldMapDefine.worldMapTipButtonType_biaoqingyinzhang)
			end
			insertToArray(worldMapDefine.worldMapTipButtonType_shibingYuabzhu, true)
			if haveHall then
				insertToArray(worldMapDefine.worldMapTipButtonType_zuduiYuanzhu, true)
			end
			insertToArray(worldMapDefine.worldMapTipButtonType_buDuiXiangqing)
		else
			insertToArray(worldMapDefine.worldMapTipButtonType_gongJi, true)
			if haveHall then
				insertToArray(worldMapDefine.worldMapTipButtonType_xuanZhan, true)
			end
			local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
			if 1 < towerLv then
				if self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarBattery then
					gametop = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
					;(nil).isButtonEnabled = ret.isCanZhanling
					;(nil).msgTipsKey = ret.zhenchaTips
					table.insert(buttonTypeArray, nil)
				else
					insertToArray(worldMapDefine.worldMapTipButtonType_zhenCha)
				end
			end
		end
	end
	insertToArray(worldMapDefine.worldMapTipButtonType_zhuangTai)
	return buttonTypeArray
end
function worldMapAtlantisWar:onShowWorldMapTip(...)
	if not self:checkInWarStatus() then
		local stage = atlantisWarCtrl:getWarStage()
		local name = self:getFavoriteName()
		if self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarPalace or self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarFort then
			if stage <= gAtlantisWarStageType.warAreaReady then
				return nil, false
			end
		elseif self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarBattery then
			local tSubType = atlantisWarUtil.getTargetSubType(self.siteClassID)
			if tSubType == gBossType.atlantisWarWlyn then
				if stage <= gAtlantisWarStageType.wlynReady then
					return worldMapInstance.onShowWorldMapTip(self, ...)
				end
				name = i18n("atlantiswar_text_0064")
			elseif tSubType == gBossType.atlantisWarSd then
				if stage <= gAtlantisWarStageType.sdReady then
					return worldMapInstance.onShowWorldMapTip(self, ...)
				end
				name = i18n("atlantiswar_text_0080")
			end
		end
		atlantisWarCtrl = ...
		....var = name
		SoraDShowMsgTip(i18n("atlantiswar_text_0231", ...))
		return nil, false
	end
	return worldMapInstance.onShowWorldMapTip(self, ...)
end
return worldMapAtlantisWar
