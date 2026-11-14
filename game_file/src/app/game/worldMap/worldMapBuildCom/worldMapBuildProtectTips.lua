local worldMapBuildProtectTips = class("worldMapBuildProtectTips", function(target)
	return target
end)
function worldMapBuildProtectTips:ctor()
end
function worldMapBuildProtectTips:_initProtectData()
	self.protectEndTime = 0
end
function worldMapBuildProtectTips:_initProtectimeUI()
	local protectTips = SoraDCreatePanel("worldMapRadianceProtect")
	protectTips:setAnchorPoint(cc.p(0.5, 0.5))
	protectTips:addTo(self, 2)
	protectTips:setVisible(false)
	local offsetX = 0
	local offsetY = 70
	if self.instanceType == gMapObjTypeDef.nebulaWarBuilding then
		offsetY = 50
	end
	protectTips:setPosition(cc.p(self.centerPoint.x - offsetX, self.centerPoint.y + offsetY))
	self._protectTips = protectTips
end
function worldMapBuildProtectTips:beginProtectime(timeNumber, isProtect)
	if not self._protectTips then
		self:_initProtectimeUI()
	end
	if self._protectTips then
		self._protectTips:beginTime(timeNumber, isProtect)
	end
end
function worldMapBuildProtectTips:removeProtectimeHandle()
	if self._protectTips then
		self._protectTips:endTime()
	end
end
function worldMapBuildProtectTips:resetProtectime()
	self:removeProtectimeHandle()
end
function worldMapBuildProtectTips:updateDataProtectime(data)
	if data.openTime then
		self.protectEndTime = data.openTime
	end
	if data.protectEndTime then
		self.protectEndTime = data.protectEndTime
	end
end
function worldMapBuildProtectTips:updateProtectimePos()
	if self._protectTips then
		local radianceWarRead = include("radianceWarRead")
		local x, _ = radianceWarRead.getBuildPos(self.siteClassID)
		self._protectTips:setPosition(cc.p(self.centerPoint.x + x, self.centerPoint.y + 70))
	end
end
function worldMapBuildProtectTips:setProtectimeShow(show, isProtect)
	if show and self.protectEndTime > 0 then
		local sysTime = serviceFunctions.systemTime()
		local timeNumber = self.protectEndTime - sysTime
		if timeNumber <= 0 then
			self:removeProtectimeHandle()
		else
			self:beginProtectime(timeNumber, isProtect)
		end
	else
		self:removeProtectimeHandle()
	end
end
function worldMapBuildProtectTips:setProtectTipsScale(scale)
	if self._protectTips then
		self._protectTips:setScale(scale)
	end
end
return worldMapBuildProtectTips
