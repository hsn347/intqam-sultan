local gametop = gModuleMgr.getObject("gametop")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local HeroPreviewView = class("heroPreviewView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroPreviewView")
	end
	return target
end)
function HeroPreviewView:ctor()
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
	self.spQuality = SoraDGetChildByName(self, "Sprite_quality")
	self.txtAddMarch = SoraDGetChildByName(self, "Text_addMarch")
	self.nodeHero = SoraDGetChildByName(self, "Node_hero")
	self.nodeSkill = SoraDGetChildByName(self, "Node_skill")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.btnRecruit = SoraDGetChildByName(self, "Button_recruit")
	self.btnRecruit:setTitleText(i18n("hero_text_62"))
	self.btnRecruit:addTouchEventListener(handler(self, self.btnRecruitClick))
	self.nodeChip = SoraDGetChildByName(self, "Node_chip")
	self.btnChip = SoraDGetChildByName(self, "Button_chip")
	self.txtChip = SoraDGetChildByName(self, "Text_chip")
	self.imgChip = SoraDGetChildByName(self, "Image_chip")
	self.imgChipBg = SoraDGetChildByName(self, "Image_chipBg")
	self.imgChipBg:setTouchEnabled(true)
	self.imgChipBg:addTouchEventListener(handler(self, self.btnChipClick))
	self.btnChip:addTouchEventListener(handler(self, self.btnChipClick))
	SoraDGetChildByName(self, "Text_skillTitle"):setString(i18n("hero_title_09"))
	SoraDGetChildByName(self, "Text_yellowTip"):setString(i18n("hero_text_29"))
end
function HeroPreviewView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.recevieItemChangeMsg))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_RECRUITSUCCESS", handler(self, self.recruitSuccess))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS", handler(self, self.fileDownloadByFile))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_ERRCLOSELOADING", handler(self, self.errBack))
end
function HeroPreviewView:errBack(target, redata)
	SoraDCloseLoading(self)
end
function HeroPreviewView:recruitSuccess(target, redata)
	self:removeFromParent()
end
function HeroPreviewView:recevieItemChangeMsg(target, redata)
	if redata and redata.itemType and gItemType.HERO_CHIP == redata.itemType then
		self:initBtns()
	end
end
function HeroPreviewView:initData(heroID)
	self.heroID = tonumber(heroID)
	heroltCtrl:playHeroSound(self.heroID)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroExInfo = heroltCtrl.getHeroInfo(self.heroID)
	self.heroLevelInfo = heroltCtrl:getHeroLevelInfo(self.heroID, 1)
	self:initView()
end
function HeroPreviewView:initView(...)
	self.txtName:setString(i18n(self.heroExInfo.herName))
	_ENV = i18n(self.heroExInfo.herName)
	i18n(self.heroExInfo.herName).num = string.formatnumberthousands(self.heroLevelInfo.march_add)
	self.txtAddMarch:setString(i18n("hero_text_12", i18n(self.heroExInfo.herName)))
	self.spClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.spQuality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	self:initHeadSpine()
	self:initSkillBoard()
	if self.heroInfo then
		self.btnRecruit:setVisible(false)
		self.nodeChip:setVisible(false)
	else
		self:initBtns()
	end
	self:showGreenFlag()
end
function HeroPreviewView:showGreenFlag(...)
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
function HeroPreviewView:initBtns(...)
	local itemNum, needNum, itemID = heroltCtrl:judgeUpgradeItem(self.heroID)
	if needNum <= itemNum then
		self.btnRecruit:setVisible(true)
		self.nodeChip:setVisible(false)
	else
		self.btnRecruit:setVisible(false)
		self.nodeChip:setVisible(true)
		local itemIcon = publicRead.getIcon(itemID)
		local itemName = publicRead.getName(itemID)
		self.imgChip:loadTexture(itemIcon, ccui.TextureResType.plistType)
		local itemNum = backpackCtrl:getItemCount(itemID)
		self.txtChip:setString(itemNum .. "/" .. needNum)
	end
end
function HeroPreviewView:fileDownloadByFile(target, data)
	if string.find(data.file, self.heroExInfo.herImage) then
		self:initHeadSpine()
	end
end
function HeroPreviewView:initHeadSpine(...)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(self.heroID)
	local isUsm = cfg.isUsm or false
	if isUsm then
		local criSp = cc.criSprite.createCriSprite(spineCfg, false, true)
		criSp:setAnchorPoint(cc.p(0.5, 0))
		criSp:setScale(cfg.share[1])
		criSp:setPosition(cfg.share[2], cfg.share[3] - 340)
		criSp:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		criSp:addTo(self.nodeHero)
		_ENV = gl.ONE_MINUS_SRC_ALPHA
		gl.ONE_MINUS_SRC_ALPHA[1] = cca.scaleTo(0.3, 0.75)
		gl.ONE_MINUS_SRC_ALPHA[2] = cca.fadeIn(0.2)
		gl.ONE_MINUS_SRC_ALPHA[3] = cca.fadeIn(0.2)
		gl.ONE_MINUS_SRC_ALPHA[4] = cca.fadeIn(0.2)
		heroltCtrl = gl.ONE_MINUS_SRC_ALPHA
		gl.ONE_MINUS_SRC_ALPHA.easing = "backOut"
		transition.execute(criSp, cca.spawn(gl.ONE_MINUS_SRC_ALPHA), gl.ONE_MINUS_SRC_ALPHA)
	else
		local atlas = string.gsub(spineCfg, "%.%w+$", ".atlas")
		local spine = sp.SkeletonAnimation:create(spineCfg, atlas, 1)
		spine:setScale(cfg.share[1])
		spine:setPosition(cfg.share[2], cfg.share[3] - 340)
		spine:setAnimation(0, "animation", true)
		spine:addTo(self.nodeHero)
		_ENV = "animation"
		;("animation")[1] = cca.scaleTo(0.3, 0.75)
		;("animation")[2] = cca.fadeIn(0.2)
		;("animation")[3] = cca.fadeIn(0.2)
		heroltCtrl = "animation"
		;("animation").easing = "backOut"
		transition.execute(spine, cca.spawn("animation"), "animation")
	end
end
function HeroPreviewView:initSkillBoard(...)
	local skillList = heroltCtrl:getMaxQualitySkillInfoByHeroID(self.heroID)
	local skillIDs = table.keys(skillList)
	table.sort(skillIDs)
	for i, v in ipairs(skillIDs) do
		local newSkillItem = SoraDCreatePanel("heroSkillItem")
		newSkillItem:initData(v, gHeroQuality.MAXRANK)
		newSkillItem:addTo(self.nodeSkill)
		newSkillItem:setPosition(SoraDFSign(#skillIDs * 115 / 2 - (i - 1) * 115 - 57.5), 0)
	end
end
function HeroPreviewView:btnChipClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _, needNum, itemID = heroltCtrl:judgeUpgradeItem(self.heroID)
		_ENV = nil
		;(nil).itemID = itemID
		;(nil).needCount = needNum
		uiManager:show("newHeroGainChipMethodView", nil)
	end
end
function HeroPreviewView:btnRecruitClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		heroCtrl:recruitReq(self.heroID)
	end
end
return HeroPreviewView
