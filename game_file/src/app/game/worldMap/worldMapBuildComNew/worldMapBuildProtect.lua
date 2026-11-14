local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildProtect = class("worldMapBuildProtect", worldMapBuildComNew)
function worldMapBuildProtect:ctor(...)
	worldMapBuildProtect.super.ctor(self, ...)
end
function worldMapBuildProtect:_initData(...)
	self.isSafe = false
end
function worldMapBuildProtect:_initUI(...)
	self.image_Protect = worldMapDefine.createWorldMapProtectNew()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 70))
	self.image_Protect:addTo(self.target_, 4)
end
function worldMapBuildProtect:addCacheBefore(...)
	self.image_Protect:setVisible(false)
	self:removePyramidProtectEffect()
end
function worldMapBuildProtect:updateData(data)
	self.data = data
	if data.isSafe ~= nil then
		self.isSafe = data.isSafe
	end
	local worldMapBuildEffect = self.target_:getBuildCom("worldMapBuildEffect")
	self.imgScale = worldMapBuildEffect:getImgScale()
	self.imgOffset = worldMapBuildEffect:getImgOffset()
	self:updateSafeState()
end
function worldMapBuildProtect:updateSafeState()
	if self.target_:isInAllianceWar() then
		self:setImgProtect()
		self:addPyramidProtectEffect()
	else
		self:removePyramidProtectEffect()
		if self.isSafe then
			self:setImgProtect()
		else
			self.image_Protect:setVisible(false)
		end
	end
end
function worldMapBuildProtect:setImgProtect()
	if self:isSysWarProtect() then
		self.image_Protect:setIsGray(true)
	else
		self.image_Protect:setIsGray(false)
	end
	self.image_Protect:setVisible(true)
	self.image_Protect:setScale(self.imgScale)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + self.imgOffset.x, self.centerPoint.y + self.imgOffset.y))
end
function worldMapBuildProtect:isSysWarProtect(...)
	local endTime = self.data.sysWarProtectStatusEndTime
	if endTime and endTime > serviceFunctions.systemTime() then
		return true
	else
		return false
	end
end
function worldMapBuildProtect:addPyramidProtectEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_cjztzc_protect_01.plist"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 140
	_ENV, (nil)[1], (nil).scale = nil, nil, 2
	_ENV, (nil).plist = nil, "et_cjztzc_protect_02.plist"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 140
	_ENV, (nil)[2], (nil).scale = nil, nil, 2
	_ENV, (nil).plist = nil, "et_cjztzc_protect_03.plist"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 140
	_ENV, (nil)[3], (nil).scale = nil, nil, 2
	_ENV, (nil).plist = nil, "et_cjztzc_protect_04.plist"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 140
	;(nil)[4], (nil).scale = nil, 2
	local param
	if self.pyramidProtectNode then
		SoraDResetEffectNode(self.pyramidProtectNode)
	else
		self.pyramidProtectNode = SoraDCreateEffectNode(param)
		self.target_:addChild(self.pyramidProtectNode, 5)
		self.pyramidProtectNode:setScale(self.imgScale)
		self.pyramidProtectNode:setPosition(self.imgOffset)
	end
end
function worldMapBuildProtect:removePyramidProtectEffect()
	if self.pyramidProtectNode then
		self.pyramidProtectNode:removeFromParent()
		self.pyramidProtectNode = nil
	end
end
return worldMapBuildProtect
