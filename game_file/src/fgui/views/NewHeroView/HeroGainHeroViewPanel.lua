local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroGainHeroViewPanel = class("HeroGainHeroViewPanel", baseFguiPanel)
function HeroGainHeroViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroGainHeroViewPanel:ctor", self.viewName)
end
function HeroGainHeroViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroGainHeroViewPanel:onInit()
	print("=======HeroGainHeroViewPanel:onInit")
	self.fields.Com_new:getChild("MovieClip_new"):setAllFrameName("dh_huodeyx_%02d.png", 1)
	self.txtName = self.fields.Text_name
	self.spClass = self.fields.Com_heroInfo:getChild("Sprite_class")
	self.spQuality = self.fields.Com_heroInfo:getChild("Sprite_quality")
	self.Com_march = self.fields.Com_march
	self.txtAddMarch = self.Com_march:getChild("Lab_limit")
	self.spriteName = self.fields.Com_heroInfo:getChild("sprite_name")
	self.bg = self.fields.bg
	self.fields.List_skill:setScrollEnable(false)
end
function HeroGainHeroViewPanel:onShow()
	print("=======HeroGainHeroViewPanel:onShow")
	self:initData(self.proxy.param.heroID)
	self.fields.Button_Story:initData(gHeroBtnStyleType.story, self.proxy.param.heroID)
	self.bg:runAction(ffa.scaleTo(0.2, 1.02))
	self.fields.Spine:setScale(1.5)
	self.fields.Spine:runAction(ffa.scaleTo(0.2, 1))
	self.fields.List_skill:setScale(1.6)
	self.fields.List_skill:runAction(ffa.scaleTo(0.2, 1))
	self.spClass:setAlpha(0)
	_UPVALUE1_ = ffa.scaleTo(0.2, 1)
	ffa.scaleTo(0.2, 1)[1] = ffa.delay(0.5)
	ffa.scaleTo(0.2, 1)[2] = ffa.fadeIn(1.0)
	ffa.scaleTo(0.2, 1)[3] = ffa.fadeIn(1.0)
	ffa.scaleTo(0.2, 1)[4] = ffa.fadeIn(1.0)
	ffa.scaleTo(0.2, 1)[5] = ffa.fadeIn(1.0)
	ffa.scaleTo(0.2, 1)[6] = ffa.fadeIn(1.0)
	self.spClass:runAction(ffa.seq(ffa.scaleTo(0.2, 1)))
	self.spriteName:setAlpha(0)
	_UPVALUE1_ = ffa.seq(ffa.scaleTo(0.2, 1))
	ffa.seq(ffa.scaleTo(0.2, 1))[1] = ffa.delay(0.5)
	ffa.seq(ffa.scaleTo(0.2, 1))[2] = ffa.fadeIn(1.0)
	ffa.seq(ffa.scaleTo(0.2, 1))[3] = ffa.fadeIn(1.0)
	ffa.seq(ffa.scaleTo(0.2, 1))[4] = ffa.fadeIn(1.0)
	ffa.seq(ffa.scaleTo(0.2, 1))[5] = ffa.fadeIn(1.0)
	ffa.seq(ffa.scaleTo(0.2, 1))[6] = ffa.fadeIn(1.0)
	self.spriteName:runAction(ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1))))
	self.spQuality:setScale(2.0)
	self.spQuality:setAlpha(0)
	_UPVALUE1_ = ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))
	_UPVALUE1_ = ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))
	ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))[1] = ffa.scaleTo(0.2, 1)
	ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))[2] = ffa.fadeIn(0.2)
	ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))[3] = ffa.fadeIn(0.2)
	ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))[1] = ffa.delay(0.8)
	ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))[2] = ffa.spawn(ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1))))
	ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))[3] = ffa.spawn(ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1))))
	ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))[4] = ffa.spawn(ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1))))
	ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))[5] = ffa.spawn(ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1))))
	ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))[6] = ffa.spawn(ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1))))
	self.spQuality:runAction(ffa.seq(ffa.seq(ffa.seq(ffa.scaleTo(0.2, 1)))))
	self.Com_march:setAlpha(0)
	self.Com_march:runAction(ffa.fadeIn(1.0))
	self.fields.List_skill:setAlpha(0)
	self.fields.List_skill:runAction(ffa.fadeIn(0.5))
end
function HeroGainHeroViewPanel:onHide()
	if self.proxy.param and self.proxy.param.closeCallback then
		self.proxy.param.closeCallback()
	end
end
function HeroGainHeroViewPanel:updateStoryRedStatus()
	local isStoryAwardGot = heroBiographyCtrl:isStoryAwardGot(self.heroID)
	local isStoryAwardGot = heroBiographyCtrl:isStoryAwardGot(self.heroID)
	if not isStoryAwardGot then
		self.fields.Button_Story:setReddot(true, 1)
	else
		self.fields.Button_Story:setReddot(false, 0)
	end
end
function HeroGainHeroViewPanel:initData(heroID)
	self.heroID = tonumber(heroID)
	AudioEngine.pauseMusic()
	SoraDPlaySound("uicontrol", 22)
	heroltCtrl:playHeroSound(self.heroID)
	heroltCtrl = nil
	;(nil)[1] = ffa.delay(4.5)
	;(nil)[2] = ffa.callFunc(function()
		AudioEngine.resumeMusic()
	end)
	;(nil)[3] = ffa.callFunc(function()
		AudioEngine.resumeMusic()
	end)
	self:runAction(ffa.seq(nil))
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroLevelInfo = heroltCtrl:getHeroLevelInfo(self.heroID, 1)
	local imageName = heroltCtrl.getHeroViewBg(self.heroID)
	self.bg:setURL(imageName)
	self:initView()
end
function HeroGainHeroViewPanel:initView(...)
	self:initHeroView()
	self:initSkillBoard()
	self:updateStoryRedStatus()
end
function HeroGainHeroViewPanel:initHeroView(...)
	self:initHeadSpine()
	self.spriteName:setURL(heroltCtrl.getHeroNamePng(self.heroID))
	self.spClass:setURL(heroltCtrl.getHeroClassTypeInfo(self.heroID).cardIcon)
	local fileName, rarity = heroltCtrl:getCardRareImg(self.heroID)
	heroltCtrl = self.heroID
	self.heroID[gHeroRarity.WHITE] = "Com_heroB"
	self.heroID[gHeroRarity.GREEN] = "Com_heroA"
	self.heroID[gHeroRarity.BLUE] = "Com_heroS"
	self.heroID[gHeroRarity.PURPLE] = "Com_heroSS"
	local self.heroID[gHeroRarity.ORANGE], comTbl = "Com_heroSSS", self.heroID
	self.spQuality:setURL("ui://NewHeroView/" .. comTbl[rarity])
	heroltCtrl = heroltCtrl.getHeroNamePng(self.heroID)
	heroltCtrl.getHeroNamePng(self.heroID).num = string.formatnumberthousands(self.heroLevelInfo.march_add)
	self.txtAddMarch:setString(i18n("hero_text_12", heroltCtrl.getHeroNamePng(self.heroID)))
end
function HeroGainHeroViewPanel:initHeadSpine(...)
	local dressID = heroCtrl:getHeroDressSeting(self.heroID)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	self.fields.Spine:setVisible(not isUsm)
	self.fields.Usm:setVisible(isUsm)
	if isUsm then
		if cfg.maxChunkSize then
			self.fields.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.fields.Usm:setEffectPath(spineCfg)
		self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm:setScale(cfg.detail[1])
		self.fields.Usm:setUsmAP(cc.p(0.5, 0))
		if display.height > 1200 then
			_UPVALUE3_ = display.height
			cfg.detail, display.height[1] = display.height, 1
			cfg.detail, display.height[2] = display.height, 0
			cfg.detail, display.height[3] = display.height, 0
		end
		self.fields.Usm:setUsmPos(cc.p(cfg.detail[2], cfg.detail[3]))
	else
		self.fields.Spine:setEffectPath(spineCfg)
		self.fields.Spine:setScale(cfg.detail[1])
		self.fields.Spine:setSpinePos(cc.p(cfg.detail[2], cfg.detail[3]))
	end
end
function HeroGainHeroViewPanel:initSkillBoard(...)
	if not self.heroInfo then
		return
	end
	local skillIDs = table.keys(self.heroInfo.skillList)
	table.sort(skillIDs)
	self.fields.List_skill:setItemRenderer(function(index, obj)
		local info = self.heroInfo.skillList[skillIDs[index + 1]]
		local skillData = heroltCtrl.getSkillDesInfo(info.skillType)
		if skillData then
			obj:getChild("Image_skillIcon"):setURL(skillData.herIcon)
			obj:addClickListener(function(EventContext)
				SoraDPlaySound()
				_ENV = nil
				;(nil).heroID = self.heroID
				;(nil).skillID = info.skillType
				_ENV, (nil).quality = self.heroInfo.quality, self.heroInfo.quality
				self.heroInfo.quality.isActive = info.isActive
				;(nil).otherData, self.heroInfo.quality.skillLv = self.heroInfo.quality, info.activeLevel
				uiManager:show("heroSkillPopView", nil)
			end)
		end
	end)
	self.fields.List_skill:setNumItems(#skillIDs)
end
function HeroGainHeroViewPanel:btnStoryClick(EventContext)
	SoraDPlaySound()
	dump(self.heroID, "HeroGainHeroViewPanel:btnStoryClick")
	_ENV = nil
	;(nil).heroID = self.heroID
	uiManager:show("HeroStory", nil)
end
function HeroGainHeroViewPanel:onClickClose()
	print("=======HeroGainHeroViewPanel:onClickClose")
	AudioEngine.resumeMusic()
	if self.heroID == 1710 then
		local ladderGiftCtrl = SoraDGetCtrl("ladderGiftCtrl")
		local ladderData = ladderGiftCtrl:getLadderData()
		if ladderData.warMadMan then
			local rid = ladderData.warMadMan.curGiftID
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).id = rid
				;(nil).fromCenter = gRechargeActiveFromEnum.ROAD21
				uiManager:show("rechargePopView", nil)
			else
				local panel = SoraDCreatePanel("rechargePopView")
				panel:initData(rid, gRechargeActiveFromEnum.ROAD21)
				panel:show()
			end
			self:close()
			return
		end
	end
	local rechargeltCtrl = include("rechargeltCtrl")
	local recruitInfo = rechargeltCtrl.getHeroRecruitInfo(self.heroID)
	dump(recruitInfo, "recruitInfo")
	if recruitInfo then
		local heroGiftCtrl = SoraDGetCtrl("heroGiftCtrl")
		if heroGiftCtrl:getHeroGiftInfo(recruitInfo.giftId) then
			heroGiftCtrl:recordGift(recruitInfo.giftId)
			_ENV = rid
			rid.giftID = recruitInfo.giftId
			uiManager:show("HeroGiftRecharge", rid)
			self:close()
			return
		end
	end
	self:close()
end
return HeroGainHeroViewPanel
