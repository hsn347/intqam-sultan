local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_spineHero = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_spineHero", Com_spineHero)
fgui.register_extension("ui://Activity_9001571/Com_spineHero", Com_spineHero)
function Com_spineHero:onInit()
	if self.fields.Usm then
		self.fields.Usm:setVisible(false)
	end
end
function Com_spineHero:onShow()
end
function Com_spineHero:initData(heroID, dressID)
	local dressID = dressID or heroCtrl:getHeroDressSeting(heroID)
	local cfg, spineCfg = heroltCtrl:getHeroCardSpineCfg(dressID)
	if cfg and spineCfg then
		if cfg.isUsm and self.fields.Usm then
			self.fields.Usm:setVisible(true)
			self.fields.Spine:setVisible(false)
			self.fields.Usm:setEffectPath(spineCfg)
			self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
			self.fields.Usm:setScale(cfg.scale)
			self.fields.Usm:setUsmAP(cc.p(0.5, 0))
			self.fields.Usm:setUsmPos(cfg.offset)
		else
			if self.fields.Usm then
				self.fields.Usm:setVisible(false)
			end
			self.fields.Spine:setVisible(true)
			self.fields.Spine:setIsAsync(true)
			self.fields.Spine:setSpineScale(cfg.scale)
			self.fields.Spine:setSpinePos(cfg.offset)
			self.fields.Spine:setEffectPath(spineCfg)
		end
	end
end
function Com_spineHero:showEffect(isSpecial)
	self.fields.Effect_1:setVisible(isSpecial)
	self.fields.Effect_2:setVisible(not isSpecial)
end
return Com_spineHero
