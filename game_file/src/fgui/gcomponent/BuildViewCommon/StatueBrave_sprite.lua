local cityltCtrl = include("cityltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local StatueBrave_sprite = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://BuildViewCommon/StatueBrave_sprite", StatueBrave_sprite)
function StatueBrave_sprite:onInit()
end
function StatueBrave_sprite:onShow()
end
function StatueBrave_sprite:initQuality(quality)
	self:setScale(self:getParent():getHeight() / 1386)
	local imageName = cityltCtrl.getStatueBraveArmorImage(quality)
	self:setIcon(imageName)
	self:updateBraveStatueEffect(quality)
end
function StatueBrave_sprite:updateBraveStatueEffect(quality)
	if self.effectSp then
		self.effectSp:removeFromParent()
		self.effectSp = nil
	end
	if self.prefabTop then
		self.prefabTop:removeFromParent()
		self.prefabTop = nil
	end
	if self.prefabBtm then
		self.prefabBtm:removeFromParent()
		self.prefabBtm = nil
	end
	local effect = cityltCtrl.getStatueBraveArmorEffect(quality)
	if not effect then
		return
	end
	if effect.isPrefab then
		local obj = fgui.UIPackage:createObject("CommonNew", "Com_prefabEX")
		obj:addTo(self)
		obj:setEffectPath(effect.top)
		obj:setPosition(effect.pos)
		self.prefabTop = obj
		local obj = fgui.UIPackage:createObject("CommonNew", "Com_prefabEX")
		obj:addTo(self, -1)
		obj:setEffectPath(effect.btm)
		obj:setPosition(effect.pos)
		self.prefabBtm = obj
	else
		self.effectSp = cc.criSprite.createCriSprite(effect.name, false, true)
		self.effectSp:addTo(self)
		self.effectSp:setPosition(effect.pos)
		if effect.isAdd == nil or effect.isAdd then
			self.effectSp:setBlendFunc(gl.ONE, gl.ONE)
		else
			self.effectSp:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		end
	end
end
return StatueBrave_sprite
