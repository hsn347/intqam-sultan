local gametop = gModuleMgr.getObject("gametop")
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local worldMapRoaringFlameWarLod4 = class("worldMapRoaringFlameWarLod4", include("worldMapInstanceLod"))
function worldMapRoaringFlameWarLod4:ctor()
	worldMapRoaringFlameWarLod4.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapRoaringFlameWarLod4:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.connect, _ENV, self.camp = gKingdomWarStatusType.close, gKingdomWarStatusType.close, 0
end
function worldMapRoaringFlameWarLod4:_initUI()
	self.imgIcon = display.newSpriteNoChild("#frame_9001674_jianzhudian.png")
	self.imgIcon:addTo(self, -1)
	self.imgIcon:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	self.image_Protect = display.newSpriteNoChild("#dh_Texture_XL_sstshd_000.png")
	self.image_Protect:addTo(self, -1)
	self.image_Protect:setScale(4)
end
function worldMapRoaringFlameWarLod4:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapRoaringFlameWarLod4:updateCullRect(...)
	local offset = self.holdInstace * 256 * 0.25
	self.rect = cc.rect(-offset, -offset, display.width + 2 * offset, display.height + 2 * offset)
end
function worldMapRoaringFlameWarLod4:initInstanceData(objData, worldInstanceData, instanceData)
	self.objId = objData.objId
	self.subType = roaringFlameWarRead.getBuildSubType(self.objId)
	local buildIcon = roaringFlameWarRead.getBuildIcon(self.subType)
	self.imgIcon:setSpriteFrame(buildIcon)
	local isFlipX = roaringFlameWarUtil.checkBuildNeedFlipX(self.objId)
	self.imgIcon:setFlippedX(isFlipX)
	self:updateData(objData)
end
function worldMapRoaringFlameWarLod4:updateData(data, delayTime)
	dump(data, "==worldMapRoaringFlameWarLod4:updateData==")
	self.data = data
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.connect then
		self.connect = data.connect
	end
	if data.camp then
		self.camp = data.camp
	end
	if self.camp and self.camp > 0 then
		local nameColor = roaringFlameWarRead.getCampBuildLineColor(self.camp)
		self.imgIcon:setColor(nameColor)
	end
	self:updateSafeState()
	_ENV = self
	self.msg = "MESSAGE_ROARINGFLAMEWAR_BUILD_UPDATE"
	self.objId = self.objId
	self.camp = data.finishOccupy and self.camp or 0
	self.connect = self.connect
	SoraDSendMessage(self)
end
function worldMapRoaringFlameWarLod4:updateSafeState()
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
function worldMapRoaringFlameWarLod4:checkOpenTime(...)
	local openTime = self.data.openTime
	if openTime and openTime > serviceFunctions.systemTime() then
		return false
	else
		return true
	end
end
function worldMapRoaringFlameWarLod4:updateScaleChange(revertScale, scale)
	local buildScale = revertScale
	self.imgIcon:setScale(buildScale)
	self.image_Protect:setScale(buildScale * 0.6)
end
function worldMapRoaringFlameWarLod4:updateLodChange(...)
end
function worldMapRoaringFlameWarLod4:getSpriteBuild(...)
	return self.imgIcon
end
function worldMapRoaringFlameWarLod4:getBuildId(...)
	return self.objId
end
return worldMapRoaringFlameWarLod4
