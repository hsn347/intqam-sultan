local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local simulatedDrillUtil = include("simulatedDrillUtil")
local simulatedDrillRead = include("simulatedDrillRead")
local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local worldMapInstance = include("worldMapInstance")
local worldMapSimulatedDrillWar = class("worldMapSimulatedDrillWar", function()
	local target = worldMapInstance.new("worldMapSimulatedDrillWar")
	return target
end)
function worldMapSimulatedDrillWar:ctor()
	self:_initData()
	self:_initUI()
end
function worldMapSimulatedDrillWar:_initData(...)
	self.siteClassID = nil
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.fromCamp = 0
	self.selfCamp = simulatedDrillCtrl:getSelfCamp()
end
function worldMapSimulatedDrillWar:_initUI(...)
	local obj = fguiHelper.createObject("SimulatedDrill", "worldMapSimulatedDrillWar")
	obj:addTo(self)
	self.fields = fguiHelper.get_fields(obj)
	self.fields.Node_player:setVisible(false)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
	self.image_Protect:addTo(self, 1)
end
function worldMapSimulatedDrillWar:initInstanceData(siteClassID, siteData, objId)
	print("==worldMapSimulatedDrillWar==", siteClassID, objId)
	self.siteClassID = siteClassID
	self.objId = objId
	self.subType = simulatedDrillRead.getBuildSubType(self.objId)
	local buildName = simulatedDrillRead.getBuildName(self.objId)
	self.fields.Text_build:setString(buildName)
	local buildImage = simulatedDrillRead.getBuildImage(self.objId)
	self.fields.Image_build:setURL(buildImage)
	_ENV = self.fields.Image_build.setURL
	self.fields.Image_build.setURL[1] = cc.p(0, -40)
	self.fields.Image_build.setURL[2] = cc.p(-50, -30)
	local self.fields.Image_build.setURL[3], config = cc.p(-50, -30), self.fields.Image_build.setURL
	local offset = config[self.objId] or cc.p(0, 0)
	self.fields.Image_build:setPosition(offset)
	self:updateData(siteData)
end
function worldMapSimulatedDrillWar:updateData(data)
	if not data then
		return
	end
	dump(data, "==worldMapSimulatedDrillWar:updateData==")
	self.data = data
	if data.playerID then
		self.playerID = data.playerID
	end
	self.fromKid = data.fromKid
	self.fromCamp = data.camp
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	self:updatePlayerInfo(data)
	self:updateSafeState()
	_ENV = self
	self.msg = "MESSAGE_SIMULATED_DRILL_BUILD_UPDATE"
	self.objId = self.objId
	self.data = self.data
	SoraDSendMessage(self)
end
function worldMapSimulatedDrillWar:updatePlayerInfo(data)
	if self.fromCamp and self.fromCamp > 0 then
		self.fields.Node_player:setVisible(true)
		local nameColor = simulatedDrillUtil.getPlayerNameColor(self.fromCamp, self.selfCamp)
		self.fields.Text_camp:setColor(nameColor)
		self.fields.Text_player:setColor(nameColor)
		local campName = simulatedDrillUtil.getCampName(self.fromCamp)
		self.fields.Text_camp:setString(campName)
		local playerName = textParser.formatPlayerName(nil, data.nickName, self.fromKid)
		self.fields.Text_player:setString(playerName)
	else
		self.fields.Node_player:setVisible(false)
	end
end
function worldMapSimulatedDrillWar:updateSafeState()
	if not self:checkInWarStatus() then
		self.image_Protect:setVisible(true)
	else
		self.image_Protect:setVisible(false)
	end
end
function worldMapSimulatedDrillWar:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapSimulatedDrillWar:getFavoriteName()
	return simulatedDrillRead.getBuildName(self.siteClassID)
end
function worldMapSimulatedDrillWar:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapSimulatedDrillWar:onClickInstance(onShowView)
	self:playClickSound()
	local selectShowPanel = self:onShowWorldMapTip(onShowView)
	return selectShowPanel, true
end
function worldMapSimulatedDrillWar:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if self.subType == gWorldTypeServerDef.subTypeSimulatedDrillWarCampBuild then
		return buttonTypeArray
	end
	if not self:checkInWarStatus() then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
		table.insert(buttonTypeArray, nil)
		return buttonTypeArray
	end
	local selfKid = gametop.playertop_:getKingdomID()
	local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
	local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
	local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
	if not self.fromCamp or self.fromCamp == 0 then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
		table.insert(buttonTypeArray, nil)
		if haveHall then
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
			table.insert(buttonTypeArray, nil)
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
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
		table.insert(buttonTypeArray, nil)
		if haveHall then
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
			table.insert(buttonTypeArray, nil)
		end
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
		table.insert(buttonTypeArray, nil)
	else
		_ENV = table.insert
		table.insert.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
		table.insert(buttonTypeArray, table.insert)
		if haveHall then
			_ENV = table.insert
			table.insert.buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
			table.insert(buttonTypeArray, table.insert)
		end
		if 1 < towerLv then
			_ENV = table.insert
			table.insert.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
			table.insert(buttonTypeArray, table.insert)
		end
	end
	_ENV = table.insert
	table.insert.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, table.insert)
	return buttonTypeArray
end
function worldMapSimulatedDrillWar:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	if tipButtonType == worldMapDefine.worldMapTipButtonType_zhuangTai then
		_ENV = nil
		;(nil).objId = self.objId
		;(nil).data = self.data
		uiManager:show("SimulatedDrillBuild", nil)
		return true
	end
end
return worldMapSimulatedDrillWar
