local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local UI_Com_heroEffect = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_heroEffect", UI_Com_heroEffect)
function UI_Com_heroEffect:onInit()
end
function UI_Com_heroEffect:onShow()
end
function UI_Com_heroEffect:initData(heroID, dressID)
	local dressID = dressID or heroCtrl:getHeroDressSeting(heroID)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	self.fields.Spine:setVisible(not isUsm)
	self.fields.Usm:setVisible(isUsm)
	if isUsm then
		if cfg.maxChunkSize then
			self.fields.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.fields.Usm:clearEffect()
		self.fields.Usm:setEffectPath(spineCfg)
		self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm:setScale(cfg.detail[1])
		self.fields.Usm:setUsmAP(cc.p(0.5, 0))
		self.fields.Usm:setUsmPos(cc.p(cfg.detail[2], cfg.detail[3]))
	else
		self.fields.Spine:setEffectPath(spineCfg)
		self.fields.Spine:setScale(cfg.detail[1])
		self.fields.Spine:setSpinePos(cc.p(cfg.detail[2], cfg.detail[3]))
	end
	self.effectPos = cc.p(cfg.detail[2], cfg.detail[3])
end
function UI_Com_heroEffect:getEffect()
	local effect = self.fields.Spine.effect
	if self.fields.Usm:isVisible() then
		effect = self.fields.Usm.effect
	end
	return effect
end
function UI_Com_heroEffect:setEffectColor(color)
	self.fields.Spine:updateSpineColor(color)
	self.fields.Usm:updateUsmColor(color)
end
function UI_Com_heroEffect:playOpacityAct(time)
	local effect = self:getEffect()
	effect:setOpacity(0)
	effect:runAction(cca.fadeIn(time or 0.3))
end
function UI_Com_heroEffect:playOffsetXAct(time, isLeft)
	local effect = self:getEffect()
	local offsetX = 100
	if isLeft then
		offsetX = -100
	end
	effect:setPositionX(self.effectPos.x + offsetX)
	effect:runAction(cca.moveTo(time or 0.3, self.effectPos.x, self.effectPos.y))
end
return UI_Com_heroEffect
