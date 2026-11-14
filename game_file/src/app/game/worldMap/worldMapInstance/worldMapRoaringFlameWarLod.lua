local gametop = gModuleMgr.getObject("gametop")
local worldLodDef = worldMapDefine.worldLodDef
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local worldMapRoaringFlameWarLod = class("worldMapRoaringFlameWarLod", include("worldMapInstanceLod"))
function worldMapRoaringFlameWarLod:ctor()
	worldMapRoaringFlameWarLod.super.ctor(self)
	include("worldMapBuildOccupyTime").new(self)
	self:_initData()
	self:_initUI()
end
function worldMapRoaringFlameWarLod:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.connect, _ENV, self.fromKid = gKingdomWarStatusType.close, gKingdomWarStatusType.close, 0
	self.protectScale = 2.0999999999999996
	self:_initOccupyTimeData()
end
function worldMapRoaringFlameWarLod:_initUI()
	local obj = fgui.UIPackage:createObject("RoaringFlameWorldMap", "worldMapRoaringFlameWarLod")
	obj:addTo(self)
	self.fields = fguiHelper.get_fields(obj)
	self.image_Protect = self.fields.image_Protect
	self.image_Protect:setColor(cc.c3b(255, 255, 80))
end
function worldMapRoaringFlameWarLod:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapRoaringFlameWarLod:initInstanceData(objData, worldInstanceData, instanceData)
	self.objId = objData.objId
	self.subType = roaringFlameWarRead.getBuildSubType(self.objId)
	local buildImage = roaringFlameWarRead.getBuildImage(self.subType)
	self.fields.Com_build:setIcon(buildImage)
	local buildName = roaringFlameWarRead.getBuildName(self.subType)
	self.fields.Text_build:setString(buildName)
	local level = roaringFlameWarRead.getBuildLevel(self.objId)
	self.fields.Text_lv:setString(level)
	local scale = roaringFlameWarUtil.getProtectScale(self.subType)
	self.image_Protect:setScale(self.protectScale * scale)
	roaringFlameWarUtil.initBuild(self)
	self:updateData(objData)
end
function worldMapRoaringFlameWarLod:updateData(data, delayTime)
	dump(data, "==worldMapRoaringFlameWarLod:updateData==")
	self.data = data
	if data.fromKid then
		self.fromKid = data.fromKid
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.connect then
		self.connect = data.connect
	end
	if data.camp then
		self.camp = data.camp
	end
	self:updatePlayerInfo(data)
	self:updateSafeState()
	self:updateDataOccupyTime(data)
	if self.camp and self.camp > 0 then
		self:setOccupyTimeShow(true)
	else
		self:setOccupyTimeShow(false)
	end
	_ENV = self
	self.msg = "MESSAGE_ROARINGFLAMEWAR_BUILD_UPDATE"
	self.objId = self.objId
	self.camp = data.finishOccupy and self.camp or 0
	self.connect = self.connect
	SoraDSendMessage(self)
end
function worldMapRoaringFlameWarLod:updatePlayerInfo(data)
	local buildLvImage = roaringFlameWarRead.getCampBuildLvImage(self.camp or 0)
	self.fields.Load_lv:setURL(buildLvImage)
end
function worldMapRoaringFlameWarLod:updateSafeState()
	if not self:checkOpenTime() then
		self.image_Protect:setVisible(true)
		return
	end
	if not roaringFlameWarUtil.checkShowProtect(self.subType) or self:checkInWarStatus() then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapRoaringFlameWarLod:checkOpenTime(...)
	local openTime = self.data.openTime
	if openTime and openTime > serviceFunctions.systemTime() then
		return false
	else
		return true
	end
end
function worldMapRoaringFlameWarLod:updateScaleChange(revertScale, scale)
end
function worldMapRoaringFlameWarLod:updateLodChange(...)
end
return worldMapRoaringFlameWarLod
