local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_HeroChoose = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001571/Com_HeroChoose", Com_HeroChoose)
function Com_HeroChoose:onInit()
	self:addClickListener(handler(self, self.onClickItem))
end
function Com_HeroChoose:onShow()
end
function Com_HeroChoose:initData(data, index)
	if data.heroID then
		self.heroID = tonumber(data.heroID)
		self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
		self.index = index
		self:initCommon()
	else
		self:setVisible(false)
		self.isEmpty = true
	end
end
function Com_HeroChoose:initCommon()
	self.fields.bg:setSpriteFrame(heroltCtrl.getHeroCardBg(self.heroID))
	self.fields.Sprite_head:setSpriteFrame(self.heroDesInfo.heroCard)
	self.fields.Sprite_quality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	self.fields.Sprite_heroname:setSpriteFrame(heroltCtrl.getHeroNamePng(self.heroID))
	if self.heroDesInfo.rarity >= gHeroQuality.PURPLE then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Panel_head:initData(self.heroID, heroltCtrl:getHeroDress(self.heroID)[1])
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self:showEffect()
end
function Com_HeroChoose:showEffect()
	local img, rarity = heroltCtrl:getCardRareImg(self.heroID)
	local isRarity = rarity > gHeroRarity.BLUE
	if isRarity then
		local cardBg = heroltCtrl.getHeroCardBg(self.heroID)
		self.fields.Panel_head:showEffect(cardBg == "frame_YX_xiaobeijing20.png")
	end
end
function Com_HeroChoose:isEmptyCom()
	return self.isEmpty
end
function Com_HeroChoose:setMyHandle(handle)
	self.handle = handle
end
function Com_HeroChoose:onClickItem()
	if self.index and self.handle then
		self.handle(self.index)
	end
end
function Com_HeroChoose:setChooseIndex(chooseIndex)
	if chooseIndex == self.index then
		self.controllers.c_black:setSelectedIndex(0)
	else
		self.controllers.c_black:setSelectedIndex(1)
	end
end
return Com_HeroChoose
