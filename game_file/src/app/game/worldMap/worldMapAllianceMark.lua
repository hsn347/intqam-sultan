local worldLodDef = worldMapDefine.worldLodDef
local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
local AMM = require_data("alliancemapmark", true).data
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local activity_9001573_Read = include("activity_9001573_Read")
local worldMapAllianceMark = class("worldMapAllianceMark", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapAllianceMark")
	end
	return target
end)
_ENV = "worldMapAllianceMark"
;("worldMapAllianceMark")[1] = cc.c3b(255, 45, 45)
;("worldMapAllianceMark")[2] = cc.c3b(63, 106, 255)
;("worldMapAllianceMark")[3] = cc.c3b(255, 152, 59)
;("worldMapAllianceMark")[4] = cc.c3b(53, 199, 255)
;("worldMapAllianceMark")[5] = cc.c3b(255, 60, 239)
;("worldMapAllianceMark")[6] = cc.c3b(111, 219, 40)
;("worldMapAllianceMark")[7] = cc.c3b(42, 229, 121)
;("worldMapAllianceMark")[8] = cc.c3b(230, 223, 48)
;("worldMapAllianceMark")[9] = cc.c3b(0, 114, 255)
local ("worldMapAllianceMark")[10], colorConfig = cc.c3b(0, 175, 255), "worldMapAllianceMark"
function worldMapAllianceMark:ctor()
	self:initWidget()
end
function worldMapAllianceMark:onMessageListener()
end
function worldMapAllianceMark:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	SoraDCreatAnimation(self.__cname, self._ccsView, true)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.moveBy(0.3, 0, 3)
	;(nil)[2] = cca.moveBy(0.6, 0, -6)
	;(nil)[3] = cca.moveBy(0.3, 0, 3)
	;(nil)[4] = cca.moveBy(0.3, 0, 3)
	;(nil)[5] = cca.moveBy(0.3, 0, 3)
	;(nil)[6] = cca.moveBy(0.3, 0, 3)
	self.Sprite_icon:runAction(cca.repeatForever(cca.seq(nil)))
	if worldMapDefine.isInRoaringFlame() then
		self.Text_name:setAnchorPoint(0.5, 0)
		self.Text_name:setPositionY(103)
	end
	self.oldSize = self.Text_name:getContentSize()
end
function worldMapAllianceMark:toggle3D(...)
end
function worldMapAllianceMark:initData(data)
	self.data = data
	self:updateTextName(self.data.name)
	local collectType = data.collectType
	local markType = data.markType
	if collectType and collectType == gCollectType.nebulaDefence then
		self.Sprite_icon:setSpriteFrame(activity_9001573_Read.getCampMarkIcon(markType))
	elseif markType then
		local color = colorConfig[markType]
		if color then
			self.G_dh_Tex_XL_lmbj01:setColor(color)
			self.G_dh_Tex_XL_lmbj02:setColor(color)
		end
		local icon = AMM[markType] and AMM[markType].icon
		if icon then
			self.Sprite_icon:setSpriteFrame(icon)
		end
	end
end
function worldMapAllianceMark:updateTextName(nameStr)
	self.Text_name:ignoreContentAdaptWithSize(true)
	self.Text_name:setString(nameStr)
	local newSize = self.Text_name:getContentSize()
	_ENV = self.Text_name
	self.Text_name.max = 410
	local self.Text_name.min, wRange = 100, self.Text_name
	local height = self.oldSize.height
	if newSize.width > wRange.max then
		if worldMapDefine.isInRoaringFlame() then
			SoraDSetTextWidthHeight(self.Text_name, cc.size(wRange.max, 100))
			height = SoraDGetAutoHeightLabelNew(self.Text_name, wRange.max)
		else
			SoraDSetTextWidthHeight(self.Text_name, cc.size(wRange.max, height))
		end
		newSize.width = wRange.max
	end
	local bgW = newSize.width + 20
	bgW = math.max(wRange.min, bgW)
	self.Image_bg:setContentSize(cc.size(bgW, height + 11))
end
function worldMapAllianceMark:updateSpriteIcon(iconName)
	self.Sprite_icon:setSpriteFrame(iconName)
end
function worldMapAllianceMark:updateSpriteColor(iconColor)
	self.Sprite_icon:setColor(iconColor)
	self.G_dh_Tex_XL_lmbj01:setColor(iconColor)
	self.G_dh_Tex_XL_lmbj02:setColor(iconColor)
end
function worldMapAllianceMark:updateScaleZoom(scale)
	local _scale = math.max(1.0, scale * 0.65)
	self.Node_mark:setScale(_scale)
	local _scale = math.max(1.0, scale * 0.25)
	self.Node_line:setScale(_scale)
end
function worldMapAllianceMark:updateLodLevel(lodLevel)
	self.lodLevel = lodLevel
	if lodLevel >= worldLodDef.LOD4 then
		self.Node_bg2:setVisible(false)
	else
		self.Node_bg2:setVisible(true)
	end
	if self.data and worldMapDefine.isInRoaringFlame() then
		local nameStr = self.data.name
		if lodLevel >= worldLodDef.LOD2 then
			nameStr = SoraDConvertOmissionText(250, nameStr, 20)
		end
		self:updateTextName(nameStr)
	end
end
return worldMapAllianceMark
