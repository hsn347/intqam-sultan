local gametop = gModuleMgr.getObject("gametop")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroIntroductionPanel = class("HeroIntroductionPanel", baseFguiPanel)
function HeroIntroductionPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroIntroductionPanel:ctor", self.viewName)
end
function HeroIntroductionPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroIntroductionPanel:onInit()
	print("=======HeroIntroductionPanel:onInit")
	self.needCallBack2SDK = true
	self.fields.Text_skillTitle:setString(i18n("hero_title_09"))
	self.Spine = self.fields.bg:getChild("Spine")
	self.Usm = self.fields.bg:getChild("Usm")
	self.bg = self.fields.bg:getChild("bg")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function HeroIntroductionPanel:onShow()
	print("=======HeroIntroductionPanel:onShow")
	self:initData(self.proxy.param)
end
function HeroIntroductionPanel:initData(heroInfo)
	self.heroID = tonumber(heroInfo.heroID)
	self.quality = heroInfo.quality
	self.heroLv = heroInfo.level
	self.dressID = heroInfo.dressID
	heroltCtrl:playHeroSound(self.heroID)
	self.heroExInfo = heroltCtrl.getHeroInfo(self.heroID)
	self.heroLevelInfo = heroltCtrl:getHeroLevelInfo(self.heroID, self.heroLv)
	self:initView()
end
function HeroIntroductionPanel:initView(...)
	_ENV = nil
	;(nil).name = self.heroExInfo and i18n(self.heroExInfo.herName) or ""
	;(nil).lv = self.heroLv
	self.fields.Text_name:setString(i18n("common_text_134", nil))
	local heroClassInfo = heroltCtrl.getHeroClassTypeInfo(self.heroID)
	self.fields.Sprite_heroClass:setURL(heroClassInfo and heroClassInfo.icon or "bg_transparent.png")
	local qualityIcon = heroltCtrl:getCardRareImg(self.heroID)
	self.fields.Sprite_quality:setURL(qualityIcon)
	_ENV = i18n("common_text_134", nil)
	i18n("common_text_134", nil).num = self.heroLevelInfo and string.formatnumberthousands(self.heroLevelInfo.march_add) or ""
	self.fields.Text_addMarch:setString(i18n("hero_text_12", i18n("common_text_134", nil)))
	self:initHeadSpine()
	self:initSkillBoard()
end
function HeroIntroductionPanel:initHeadSpine(...)
	local dressID = self.dressID or heroCtrl:getHeroDressSeting(self.heroID)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	self.Spine:setVisible(not isUsm)
	self.Usm:setVisible(isUsm)
	if isUsm then
		if cfg.maxChunkSize then
			self.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.Usm:setEffectPath(spineCfg)
		self.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.Usm:setScale(cfg.share[1])
		self.Usm:setUsmAP(cc.p(0.5, 0))
		self.Usm:setUsmPos(cc.p(cfg.share[2], cfg.share[3]))
	else
		self.Spine:setEffectPath(spineCfg)
		self.Spine:setScale(cfg.share[1])
		self.Spine:setSpinePos(cc.p(cfg.share[2], cfg.share[3]))
	end
	local viewBg, isNewBg = heroltCtrl:getDressViewBg(dressID)
	self.bg:setURL(viewBg)
end
function HeroIntroductionPanel:initSkillBoard(...)
	self.skillList = heroltCtrl:getSkillInfoByHeroID(self.heroID, self.heroLv, self.quality)
	dump(self.skillList, "skillList")
	self.fields.List:setNumItems(#self.skillList)
end
function HeroIntroductionPanel:onItemRenderer(index, obj)
	local v = self.skillList[index + 1]
	obj:setClickHandBack(handler(self, self.onClickSkillItem))
	_ENV = handler(self, self.onClickSkillItem)
	handler(self, self.onClickSkillItem).index = index + 1
	handler(self, self.onClickSkillItem).skillID = v.sid
	_ENV, handler(self, self.onClickSkillItem).quality = self.quality, self.quality
	self.quality.isActive = not v.isLock
	handler(self, self.onClickSkillItem).otherData, self.quality.skillLv = self.quality, v.limitLv
	obj:initData(handler(self, self.onClickSkillItem))
end
function HeroIntroductionPanel:onClickSkillItem(skillID, otherData)
	_ENV = nil
	;(nil).heroID = self.heroID
	;(nil).skillID = skillID
	;(nil).quality = self.quality
	;(nil).otherData = otherData
	uiManager:show("heroSkillPopView", nil)
end
return HeroIntroductionPanel
