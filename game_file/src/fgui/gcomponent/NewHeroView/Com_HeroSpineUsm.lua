local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_HeroSpineUsm = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_HeroSpineUsm", Com_HeroSpineUsm)
function Com_HeroSpineUsm:onInit()
	self.fields.Usm:setPrepareCallback(function()
		self.effect = self.fields.Usm:getCriSprite()
		self.effect:start()
		self:updateStage()
	end)
end
function Com_HeroSpineUsm:onShow()
end
function Com_HeroSpineUsm:setNoAct()
	if not self.effect then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = cca.callFunc(function()
		self.effect:setAnimation(0, "animation", false)
	end)
	;(nil)[2] = cca.delay(0.016666666666666666)
	;(nil)[3] = cca.callFunc(function()
		self.effect:clearTracks()
	end)
	;(nil)[4] = cca.callFunc(function()
		self.effect:clearTracks()
	end)
	self.effect:runAction(cca.seq(nil))
end
function Com_HeroSpineUsm:setActiveModel()
	if not self.effect then
		return
	end
	self.effect:setColor(cc.c3b(255, 255, 255))
	if self.isUsm then
		self.effect:start()
	else
		self.effect:clearTracks()
		self.effect:setAnimation(0, "animation", true)
	end
end
function Com_HeroSpineUsm:setNotActiveModel()
	if not self.effect then
		return
	end
	self.effect:setColor(cc.c3b(255, 255, 255))
	if self.isUsm then
		self.effect:pause()
	else
		self.effect:clearTracks()
		self:setNoAct()
	end
end
function Com_HeroSpineUsm:setNotOwnModel()
	if not self.effect then
		return
	end
	self.effect:setColor(cc.c3b(100, 100, 100))
	if self.isUsm then
		self.effect:pause()
	else
		self.effect:clearTracks()
		self:setNoAct()
	end
end
function Com_HeroSpineUsm:updateStage(status)
	if status then
		self.status = status
	end
	if self.status == gHeroStoryUnLockType.ACTIVED then
		self:setActiveModel()
	elseif self.status == gHeroStoryUnLockType.UNLOCK then
		self:setNotActiveModel()
	elseif heroCtrl:getHeroInfoByID(self.heroID) then
		self:setNotActiveModel()
	else
		self:setNotOwnModel()
	end
end
function Com_HeroSpineUsm:initData(heroID, status, parent)
	self.parent = parent
	self.status = status
	self.heroID = heroID
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(heroID)
	if cfg then
		self.isUsm = cfg.isUsm or false
		if self.heroID == 1710 or self.heroID == 1747 or self.heroID == 1748 then
			self.isUsm = false
			spineCfg = string.format("spine/herosV/heroModle_%d01.skel", self.heroID)
		end
		self.fields.Spine:setVisible(not self.isUsm)
		self.fields.Usm:setVisible(self.isUsm)
		if self.isUsm then
			if cfg.maxChunkSize then
				self.fields.Usm:setMaxChunkSize(cfg.maxChunkSize)
			end
			self.fields.Usm:setUsmAP(cc.p(0.5, 0))
			self.fields.Usm:setUsmPos(cc.p(cfg.binaryNew[2], cfg.binaryNew[3]))
			self.fields.Usm:setUsmScale(cfg.binaryNew[1])
			self.fields.Usm:setEffectPath(spineCfg)
			self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		else
			self.fields.Spine:setEffectPath(spineCfg)
			self.fields.Spine:setScale(cfg.binaryNew[1])
			self.fields.Spine:setSpinePos(cc.p(cfg.binaryNew[2], cfg.binaryNew[3]))
			self.effect = self.fields.Spine:getSpine()
			self:updateStage()
		end
	end
end
return Com_HeroSpineUsm
