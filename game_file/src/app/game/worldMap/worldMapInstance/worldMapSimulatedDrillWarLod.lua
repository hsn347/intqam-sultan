local simulatedDrillUtil = include("simulatedDrillUtil")
local simulatedDrillRead = include("simulatedDrillRead")
local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local worldMapSimulatedDrillWarLod = class("worldMapSimulatedDrillWarLod", include("worldMapInstanceLod"))
function worldMapSimulatedDrillWarLod:ctor()
	worldMapSimulatedDrillWarLod.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapSimulatedDrillWarLod:_initData(...)
	self.siteClassID = nil
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.fromCamp = 0
	self.selfCamp = simulatedDrillCtrl:getSelfCamp()
end
function worldMapSimulatedDrillWarLod:_initUI()
	local obj = fgui.UIPackage:createObject("SimulatedDrill", "worldMapSimulatedDrillWar")
	obj:addTo(self)
	self.fields = fguiHelper.get_fields(obj)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
	self.image_Protect:addTo(self, 1)
end
function worldMapSimulatedDrillWarLod:initInstanceData(objData, worldInstanceData, instanceData)
	self.objId = objData.objId
	self.subType = simulatedDrillRead.getBuildSubType(self.objId)
	local buildName = simulatedDrillRead.getBuildName(self.objId)
	self.fields.Text_build:setString(buildName)
	local buildImage = simulatedDrillRead.getBuildImage(self.objId)
	self.fields.Image_build:setURL(buildImage)
	simulatedDrillRead = self.fields.Image_build.setURL
	self.fields.Image_build.setURL[1] = cc.p(0, -40)
	self.fields.Image_build.setURL[2] = cc.p(-50, -30)
	local self.fields.Image_build.setURL[3], config = cc.p(-50, -30), self.fields.Image_build.setURL
	local offset = config[self.objId] or cc.p(0, 0)
	self.fields.Image_build:setPosition(offset)
	self:updateData(objData)
end
function worldMapSimulatedDrillWarLod:updateData(data)
	if not data then
		return
	end
	dump(data, "==worldMapSimulatedDrillWarLod:updateData==")
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
end
function worldMapSimulatedDrillWarLod:updatePlayerInfo(data)
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
function worldMapSimulatedDrillWarLod:updateSafeState()
	if not self:checkInWarStatus() then
		self.image_Protect:setVisible(true)
	else
		self.image_Protect:setVisible(false)
	end
end
function worldMapSimulatedDrillWarLod:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapSimulatedDrillWarLod:updateScaleChange(revertScale, scale)
	return
end
return worldMapSimulatedDrillWarLod
