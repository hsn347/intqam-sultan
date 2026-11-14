local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_imageBuild = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://RoaringFlameWorldMap/Com_imageBuild", Com_imageBuild)
function Com_imageBuild:setGroupID(...)
	self.fields.icon:setGroupID(...)
end
function Com_imageBuild:onInit()
end
function Com_imageBuild:onShow()
	self.centerPos = cc.p(self:getWidth() / 2, self:getHeight() / 2)
end
function Com_imageBuild:initObjId(objId)
	self.objId = objId
	self.subType = roaringFlameWarRead.getBuildSubType(self.objId)
	local buildImage = roaringFlameWarUtil.getDirBuildImage(self.objId)
	self.fields.icon:setURL(buildImage)
	self:updateBuildEffect()
end
function Com_imageBuild:updateBuildEffect(...)
	self:hideBuildEffect()
	if self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix then
		if not self.mv_bsnjz then
			local mv_bsnjz = roaringFlameWarUtil.createBuildEffect(self.subType, 3)
			mv_bsnjz:addTo(self)
			mv_bsnjz:setPosition(cc.p(self.centerPos.x + 43, self.centerPos.y + 67))
			self.mv_bsnjz = mv_bsnjz
		end
		self.mv_bsnjz:setVisible(true)
		if roaringFlameWarCtrl:checkInWarStatus() then
			if not self.mv_bsncx then
				local mv_bsncx = roaringFlameWarUtil.createBuildEffect(self.subType, 1)
				mv_bsncx:addTo(self)
				mv_bsncx:setPosition(self.centerPos.x + 48, self.centerPos.y)
				self.mv_bsncx = mv_bsncx
			end
			self.mv_bsncx:setVisible(true)
		else
			if not self.mv_fhgw then
				local mv_fhgw = roaringFlameWarUtil.createBuildEffect(self.subType, 2)
				mv_fhgw:addTo(self)
				mv_fhgw:setPosition(self.centerPos)
				self.mv_fhgw = mv_fhgw
			end
			self.mv_fhgw:setVisible(true)
		end
	elseif roaringFlameWarUtil.checkIsGatewayBuild(self.subType) then
		if not self.mv_fire then
			local mv_fire = roaringFlameWarUtil.createBuildEffect(self.subType)
			mv_fire:addTo(self)
			self.mv_fire = mv_fire
		end
		self.mv_fire:setVisible(true)
		if not roaringFlameWarUtil.checkBuildNeedFlipX(self.objId) then
			self.mv_fire:setScaleX(-1)
			self.mv_fire:setPosition(cc.p(self.centerPos.x + 55 - 96, self.centerPos.y - 128 + 20))
		else
			self.mv_fire:setScaleX(1)
			self.mv_fire:setPosition(cc.p(self.centerPos.x + 55, self.centerPos.y - 128))
		end
	elseif self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
		if not self.mv_build9 then
			local mv_build9 = roaringFlameWarUtil.createBuildEffect(self.subType)
			mv_build9:addTo(self)
			mv_build9:setPosition(self.centerPos)
			self.mv_build9 = mv_build9
		end
		self.mv_build9:setVisible(true)
	end
end
function Com_imageBuild:hideBuildEffect(...)
	if self.mv_bsnjz then
		self.mv_bsnjz:setVisible(false)
	end
	if self.mv_bsncx then
		self.mv_bsncx:setVisible(false)
	end
	if self.mv_fhgw then
		self.mv_fhgw:setVisible(false)
	end
	if self.mv_fire then
		self.mv_fire:setVisible(false)
	end
	if self.mv_build9 then
		self.mv_build9:setVisible(false)
	end
end
return Com_imageBuild
