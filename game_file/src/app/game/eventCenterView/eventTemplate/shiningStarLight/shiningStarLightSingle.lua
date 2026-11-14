local shiningStarLightRead = include("shiningStarLightRead")
local shiningStarLightCtrl = SoraDGetCtrl("shiningStarLightCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shiningStarLightSingle = class("shiningStarLightSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("shiningStarLightSingle")
end)
_UPVALUE5_, shiningStarLightSingle.ctor = function(self, properties)
	self.status = gBtnTargetStatusDef.GO
	self.spLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.btnTouch:setTouchEnabled(true)
	self.btnTouch:addTouchEventListener(handler(self, self.btnTouchClick))
	self.textNeedNum = SoraDGetChildByName(self, "Text_NeedNum")
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_fgxd01")
	self.etColor = SoraDGetChildByName(self, "et_Par_xhdg")
	self.nodeNotEffect = SoraDGetChildByName(self, "Node_NotEffect")
	local dhTexture = SoraDGetChildByName(self.nodeNotEffect, "dh_Tex_ghxd_003")
	dhTexture:setOpacity(51.0)
	_UPVALUE1_ = handler(self, self.btnTouchClick)
	handler(self, self.btnTouchClick)[1] = cca.fadeTo(0.8333333333333334, 0.6)
	handler(self, self.btnTouchClick)[2] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[3] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[4] = cca.fadeTo(0.8333333333333334, 0.2)
	dhTexture:runAction(cca.repeatForever(cca.seq(handler(self, self.btnTouchClick))))
end, function(self, properties)
	self.status = gBtnTargetStatusDef.GO
	self.spLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.btnTouch:setTouchEnabled(true)
	self.btnTouch:addTouchEventListener(handler(self, self.btnTouchClick))
	self.textNeedNum = SoraDGetChildByName(self, "Text_NeedNum")
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_fgxd01")
	self.etColor = SoraDGetChildByName(self, "et_Par_xhdg")
	self.nodeNotEffect = SoraDGetChildByName(self, "Node_NotEffect")
	local dhTexture = SoraDGetChildByName(self.nodeNotEffect, "dh_Tex_ghxd_003")
	dhTexture:setOpacity(51.0)
	_UPVALUE1_ = handler(self, self.btnTouchClick)
	handler(self, self.btnTouchClick)[1] = cca.fadeTo(0.8333333333333334, 0.6)
	handler(self, self.btnTouchClick)[2] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[3] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[4] = cca.fadeTo(0.8333333333333334, 0.2)
	dhTexture:runAction(cca.repeatForever(cca.seq(handler(self, self.btnTouchClick))))
end
_ENV, _UPVALUE5_, (function(self, properties)
	self.status = gBtnTargetStatusDef.GO
	self.spLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.btnTouch:setTouchEnabled(true)
	self.btnTouch:addTouchEventListener(handler(self, self.btnTouchClick))
	self.textNeedNum = SoraDGetChildByName(self, "Text_NeedNum")
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_fgxd01")
	self.etColor = SoraDGetChildByName(self, "et_Par_xhdg")
	self.nodeNotEffect = SoraDGetChildByName(self, "Node_NotEffect")
	local dhTexture = SoraDGetChildByName(self.nodeNotEffect, "dh_Tex_ghxd_003")
	dhTexture:setOpacity(51.0)
	_UPVALUE1_ = handler(self, self.btnTouchClick)
	handler(self, self.btnTouchClick)[1] = cca.fadeTo(0.8333333333333334, 0.6)
	handler(self, self.btnTouchClick)[2] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[3] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[4] = cca.fadeTo(0.8333333333333334, 0.2)
	dhTexture:runAction(cca.repeatForever(cca.seq(handler(self, self.btnTouchClick))))
end)[1] = "icon_ghxd_lvd.png", "icon_ghxd_bd.png", "icon_ghxd_bd.png"
_ENV, _UPVALUE5_, (function(self, properties)
	self.status = gBtnTargetStatusDef.GO
	self.spLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.btnTouch:setTouchEnabled(true)
	self.btnTouch:addTouchEventListener(handler(self, self.btnTouchClick))
	self.textNeedNum = SoraDGetChildByName(self, "Text_NeedNum")
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_fgxd01")
	self.etColor = SoraDGetChildByName(self, "et_Par_xhdg")
	self.nodeNotEffect = SoraDGetChildByName(self, "Node_NotEffect")
	local dhTexture = SoraDGetChildByName(self.nodeNotEffect, "dh_Tex_ghxd_003")
	dhTexture:setOpacity(51.0)
	_UPVALUE1_ = handler(self, self.btnTouchClick)
	handler(self, self.btnTouchClick)[1] = cca.fadeTo(0.8333333333333334, 0.6)
	handler(self, self.btnTouchClick)[2] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[3] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[4] = cca.fadeTo(0.8333333333333334, 0.2)
	dhTexture:runAction(cca.repeatForever(cca.seq(handler(self, self.btnTouchClick))))
end)[2] = "icon_ghxd_lvd.png", "icon_ghxd_bd.png", "icon_ghxd_lvd.png"
_ENV, _UPVALUE5_, (function(self, properties)
	self.status = gBtnTargetStatusDef.GO
	self.spLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.btnTouch:setTouchEnabled(true)
	self.btnTouch:addTouchEventListener(handler(self, self.btnTouchClick))
	self.textNeedNum = SoraDGetChildByName(self, "Text_NeedNum")
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_fgxd01")
	self.etColor = SoraDGetChildByName(self, "et_Par_xhdg")
	self.nodeNotEffect = SoraDGetChildByName(self, "Node_NotEffect")
	local dhTexture = SoraDGetChildByName(self.nodeNotEffect, "dh_Tex_ghxd_003")
	dhTexture:setOpacity(51.0)
	_UPVALUE1_ = handler(self, self.btnTouchClick)
	handler(self, self.btnTouchClick)[1] = cca.fadeTo(0.8333333333333334, 0.6)
	handler(self, self.btnTouchClick)[2] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[3] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[4] = cca.fadeTo(0.8333333333333334, 0.2)
	dhTexture:runAction(cca.repeatForever(cca.seq(handler(self, self.btnTouchClick))))
end)[3] = "icon_ghxd_lvd.png", "icon_ghxd_bd.png", "icon_ghxd_land.png"
_ENV, _UPVALUE5_, (function(self, properties)
	self.status = gBtnTargetStatusDef.GO
	self.spLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.btnTouch:setTouchEnabled(true)
	self.btnTouch:addTouchEventListener(handler(self, self.btnTouchClick))
	self.textNeedNum = SoraDGetChildByName(self, "Text_NeedNum")
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_fgxd01")
	self.etColor = SoraDGetChildByName(self, "et_Par_xhdg")
	self.nodeNotEffect = SoraDGetChildByName(self, "Node_NotEffect")
	local dhTexture = SoraDGetChildByName(self.nodeNotEffect, "dh_Tex_ghxd_003")
	dhTexture:setOpacity(51.0)
	_UPVALUE1_ = handler(self, self.btnTouchClick)
	handler(self, self.btnTouchClick)[1] = cca.fadeTo(0.8333333333333334, 0.6)
	handler(self, self.btnTouchClick)[2] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[3] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[4] = cca.fadeTo(0.8333333333333334, 0.2)
	dhTexture:runAction(cca.repeatForever(cca.seq(handler(self, self.btnTouchClick))))
end)[4] = "icon_ghxd_lvd.png", "icon_ghxd_bd.png", "icon_ghxd_zd.png"
local _ENV, _UPVALUE5_, (function(self, properties)
	self.status = gBtnTargetStatusDef.GO
	self.spLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.btnTouch:setTouchEnabled(true)
	self.btnTouch:addTouchEventListener(handler(self, self.btnTouchClick))
	self.textNeedNum = SoraDGetChildByName(self, "Text_NeedNum")
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_fgxd01")
	self.etColor = SoraDGetChildByName(self, "et_Par_xhdg")
	self.nodeNotEffect = SoraDGetChildByName(self, "Node_NotEffect")
	local dhTexture = SoraDGetChildByName(self.nodeNotEffect, "dh_Tex_ghxd_003")
	dhTexture:setOpacity(51.0)
	_UPVALUE1_ = handler(self, self.btnTouchClick)
	handler(self, self.btnTouchClick)[1] = cca.fadeTo(0.8333333333333334, 0.6)
	handler(self, self.btnTouchClick)[2] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[3] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[4] = cca.fadeTo(0.8333333333333334, 0.2)
	dhTexture:runAction(cca.repeatForever(cca.seq(handler(self, self.btnTouchClick))))
end)[5], iconConfig = "icon_ghxd_lvd.png", "icon_ghxd_bd.png", "icon_ghxd_hd.png", function(self, properties)
	self.status = gBtnTargetStatusDef.GO
	self.spLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.btnTouch:setTouchEnabled(true)
	self.btnTouch:addTouchEventListener(handler(self, self.btnTouchClick))
	self.textNeedNum = SoraDGetChildByName(self, "Text_NeedNum")
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_fgxd01")
	self.etColor = SoraDGetChildByName(self, "et_Par_xhdg")
	self.nodeNotEffect = SoraDGetChildByName(self, "Node_NotEffect")
	local dhTexture = SoraDGetChildByName(self.nodeNotEffect, "dh_Tex_ghxd_003")
	dhTexture:setOpacity(51.0)
	_UPVALUE1_ = handler(self, self.btnTouchClick)
	handler(self, self.btnTouchClick)[1] = cca.fadeTo(0.8333333333333334, 0.6)
	handler(self, self.btnTouchClick)[2] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[3] = cca.fadeTo(0.8333333333333334, 0.2)
	handler(self, self.btnTouchClick)[4] = cca.fadeTo(0.8333333333333334, 0.2)
	dhTexture:runAction(cca.repeatForever(cca.seq(handler(self, self.btnTouchClick))))
end
;("icon_ghxd_lvd.png").etName = "et_Par_xhdg_006.plist"
_ENV, ("icon_ghxd_lvd.png").scale = "icon_ghxd_land.png", 3.1
;("icon_ghxd_land.png").etName = "et_Par_xhdg_009.plist"
_ENV, ("icon_ghxd_land.png").scale = "icon_ghxd_zd.png", 3.5
;("icon_ghxd_zd.png").etName = "et_Par_xhdg_010.plist"
_ENV, ("icon_ghxd_zd.png").scale = "icon_ghxd_hd.png", 3.5
;("icon_ghxd_hd.png").etName = "et_Par_xhdg_004.plist"
_ENV, ("icon_ghxd_hd.png").scale = nil, 3.5
;(nil).etName = "et_Par_xhdg_008.plist"
;(nil).scale = 3.5
;("icon_ghxd_bd.png")[1] = "icon_ghxd_lvd.png"
;("icon_ghxd_bd.png")[2] = "icon_ghxd_land.png"
;("icon_ghxd_bd.png")[3] = "icon_ghxd_zd.png"
;("icon_ghxd_bd.png")[4] = "icon_ghxd_hd.png"
local ("icon_ghxd_bd.png")[5], etConfig = nil, "icon_ghxd_bd.png"
function shiningStarLightSingle:initData(index, showNum)
	self.showNum = showNum
	self.btnTouch:setTouchEnabled(self.showNum)
	SoraDGetChildByName(self, "Image_1"):setVisible(showNum)
	self.textNeedNum:setVisible(showNum)
	self.index = index
	self.status = status
	self.lampIndex = shiningStarLightCtrl:getStarLampIndex()
	local config = shiningStarLightRead.getLightAward(shiningStarLightCtrl:getInitCastleLv(), index)
	local needNum = config.need[2]
	self.textNeedNum:setString(needNum)
	if self.lampIndex >= self.index then
		self.status = gLampLightStatusType.LIGHT
	elseif needNum <= backpackCtrl:getItemCount(config.need[1]) and self.lampIndex == self.index - 1 then
		self.status = gLampLightStatusType.CANLIGHT
	elseif self.lampIndex == self.index - 1 then
		self.status = gLampLightStatusType.GOTASK
	elseif self.lampIndex < self.index then
		self.status = gLampLightStatusType.CANNOT
	end
	if self.status ~= gLampLightStatusType.LIGHT and self.status ~= gLampLightStatusType.CANLIGHT then
		self.spLamp:setSpriteFrame("icon_ghxd_an.png")
	else
		self.spLamp:setSpriteFrame(iconConfig[index])
	end
	self.nodeNotEffect:setVisible(self.status == gLampLightStatusType.CANLIGHT)
	if self.nodeEffect then
		self.nodeEffect:setVisible(self.status == gLampLightStatusType.LIGHT)
		if not self.et then
			self.et = cc.ParticleSystemQuad:create("Particle/" .. etConfig[index].etName)
			self.et:addTo(self.nodeEffect)
			self.et:setPosition(0, 0)
			self.et:setScale(etConfig[index].scale)
		end
	end
end
function shiningStarLightSingle:setNodeScale(scale)
	self:setScale(scale or 1)
end
function shiningStarLightSingle:btnTouchClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.index then
			local panel = SoraDCreatePanel("shiningStarLightPopView")
			panel:initData(self.index, self.status)
			panel:show()
		end
	end
end
return shiningStarLightSingle
