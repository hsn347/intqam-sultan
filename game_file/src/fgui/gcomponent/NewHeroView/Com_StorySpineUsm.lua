local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_StorySpineUsm = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_StorySpineUsm", Com_StorySpineUsm)
function Com_StorySpineUsm:onInit()
	self.fields.Usm:setPrepareCallback(function()
		self.effect = self.fields.Usm:getCriSprite()
		self.effect:start()
		if self.isPause then
			self.effect:pause()
		end
	end)
end
function Com_StorySpineUsm:onShow()
end
function Com_StorySpineUsm:initData(heroID, isNoPause, isUsmScale, isCover)
	self.isPause = not isNoPause
	local dressID = heroCtrl:getHeroDressSeting(heroID)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	if isCover and cfg.is3S then
		isUsm = false
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	self.fields.Spine:setVisible(not isUsm)
	self.fields.Usm:setVisible(isUsm)
	if isUsm then
		if cfg.maxChunkSize then
			self.fields.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.fields.Usm:setEffectPath(spineCfg)
		self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm:setScale(isUsmScale and 1.5 or cfg.story[1])
		self.fields.Usm:setUsmAP(cc.p(0.5, 0))
		self.fields.Usm:setUsmPos(cc.p(isUsmScale and 0 or cfg.story[2], isUsmScale and -660 or cfg.story[3]))
	else
		self.fields.Spine:setEffectPath(spineCfg)
		self.fields.Spine:setScale(cfg.story[1])
		self.fields.Spine:setSpinePos(cc.p(cfg.story[2], cfg.story[3] - 100))
		if self.isPause then
			self:setNoAct(self.fields.Spine:getSpine())
		end
	end
end
function Com_StorySpineUsm:setNoAct(spine)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.callFunc(function()
		spine:setAnimation(0, "animation", false)
	end)
	;(nil)[2] = cca.delay(0.016666666666666666)
	;(nil)[3] = cca.callFunc(function()
		spine:clearTracks()
	end)
	;(nil)[4] = cca.callFunc(function()
		spine:clearTracks()
	end)
	spine:runAction(cca.seq(nil))
end
return Com_StorySpineUsm
