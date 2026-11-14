local gametop = gModuleMgr.getObject("gametop")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local HeroShowHeroView = class("heroShowHeroView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroShowHeroView")
	end
	return target
end)
function HeroShowHeroView:ctor()
	self.needCallBack2SDK = true
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
	self.spQuality = SoraDGetChildByName(self, "Sprite_quality")
	self.txtAddMarch = SoraDGetChildByName(self, "Text_addMarch")
	self.nodeHero = SoraDGetChildByName(self, "Node_hero")
	self.nodeSkill = SoraDGetChildByName(self, "Node_skill")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	SoraDGetChildByName(self, "Text_skillTitle"):setString(i18n("hero_title_09"))
end
function HeroShowHeroView:initData(heroInfo)
	self.heroID = tonumber(heroInfo.heroID)
	self.quality = heroInfo.quality
	self.heroLv = heroInfo.level
	self.dressID = heroInfo.dressID
	heroltCtrl:playHeroSound(self.heroID)
	self.heroExInfo = heroltCtrl.getHeroInfo(self.heroID)
	self.heroLevelInfo = heroltCtrl:getHeroLevelInfo(self.heroID, self.heroLv)
	self:initView()
end
function HeroShowHeroView:initView(...)
	_ENV = nil
	;(nil).name = self.heroExInfo and i18n(self.heroExInfo.herName) or ""
	;(nil).lv = self.heroLv
	self.txtName:setString(i18n("common_text_134", nil))
	local heroClassInfo = heroltCtrl.getHeroClassTypeInfo(self.heroID)
	self.spClass:setSpriteFrame(heroClassInfo and heroClassInfo.icon or "bg_transparent.png")
	self.spQuality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	_ENV = heroltCtrl:getCardRareImg(self.heroID)
	heroltCtrl:getCardRareImg(self.heroID).num = self.heroLevelInfo and string.formatnumberthousands(self.heroLevelInfo.march_add) or ""
	self.txtAddMarch:setString(i18n("hero_text_12", heroltCtrl:getCardRareImg(self.heroID)))
	self:initHeadSpine()
	self:initSkillBoard()
	self:showGreenFlag()
end
function HeroShowHeroView:showGreenFlag(...)
	local filePath = "3d/heroFlag/hero_flag.c3b"
	if SoraDIsFileExistByFileName(filePath) then
		local card = cc.Sprite3D:create(filePath)
		_ENV = nil
		;(nil).x = 0
		;(nil).y = -440
		;(nil).z = 0
		card:setPosition3D(nil)
		card:setScale(0.8)
		card:addTo(self.nodeFlag)
		local animation = cc.Animation3D:create(filePath)
		if nil ~= animation then
			local animate1 = cc.Animate3D:create(animation)
			local animate2 = cc.Animate3D:createWithFrames(animation, 165, 359)
			_UPVALUE8_ = animation
			animation[1] = animate1
			animation[2] = animate2
			animation[3] = animate2
			animation[4] = animate2
			animation[5] = animate2
			animation[6] = animate2
			animation[7] = animate2
			animation[8] = animate2
			local mySeq = cca.seq(animation)
			card:runAction(mySeq)
		end
	end
end
function HeroShowHeroView:initHeadSpine(...)
	local dressID = self.dressID or heroCtrl:getHeroDressSeting(self.heroID)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	if isUsm then
		local criSp = cc.criSprite.createCriSprite(spineCfg, false, true)
		criSp:setAnchorPoint(cc.p(0.5, 0))
		criSp:setScale(cfg.share[1])
		criSp:setPosition(cfg.share[2], cfg.share[3])
		criSp:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		criSp:addTo(self.nodeHero)
		heroltCtrl = gl.ONE_MINUS_SRC_ALPHA
		gl.ONE_MINUS_SRC_ALPHA[1] = cca.scaleTo(0.3, 0.75)
		gl.ONE_MINUS_SRC_ALPHA[2] = cca.fadeIn(0.2)
		gl.ONE_MINUS_SRC_ALPHA[3] = cca.fadeIn(0.2)
		gl.ONE_MINUS_SRC_ALPHA[4] = cca.fadeIn(0.2)
		heroCtrl = gl.ONE_MINUS_SRC_ALPHA
		gl.ONE_MINUS_SRC_ALPHA.easing = "backOut"
		transition.execute(criSp, cca.spawn(gl.ONE_MINUS_SRC_ALPHA), gl.ONE_MINUS_SRC_ALPHA)
	else
		local atlas = string.gsub(spineCfg, "%.%w+$", ".atlas")
		local spine = sp.SkeletonAnimation:create(spineCfg, atlas, 1)
		spine:setScale(cfg.share[1])
		spine:setPosition(cfg.share[2], cfg.share[3])
		spine:setAnimation(0, "animation", true)
		spine:addTo(self.nodeHero)
		heroltCtrl = "animation"
		;("animation")[1] = cca.scaleTo(0.3, 0.75)
		;("animation")[2] = cca.fadeIn(0.2)
		;("animation")[3] = cca.fadeIn(0.2)
		heroCtrl = "animation"
		;("animation").easing = "backOut"
		transition.execute(spine, cca.spawn("animation"), "animation")
	end
end
function HeroShowHeroView:initSkillBoard(...)
	local skillList = heroltCtrl:getSkillInfoByHeroID(self.heroID, self.heroLv, self.quality)
	dump(skillList, "skillList")
	if next(skillList) then
		for i, v in ipairs(skillList) do
			local newSkillItem = SoraDCreatePanel("heroSkillItem")
			heroltCtrl = nil
			;(nil).isActive = not v.isLock
			;(nil).skillLv = v.limitLv
			newSkillItem:initData(v.sid, self.quality, nil)
			newSkillItem:addTo(self.nodeSkill)
			newSkillItem:setPosition(SoraDFSign(#skillList * 115 / 2 - (i - 1) * 115 - 57.5), 0)
		end
	end
end
return HeroShowHeroView
