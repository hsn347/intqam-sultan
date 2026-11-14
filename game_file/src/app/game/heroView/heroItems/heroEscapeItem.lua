local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local HeroEscapeItem = class("heroEscapeItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroEscapeItem")
	end
	return target
end)
function HeroEscapeItem:ctor()
	self.spHeadBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.spHead = SoraDGetChildByName(self, "Sprite_head")
	self.spState = SoraDGetChildByName(self, "Sprite_state")
	self.txtLv = SoraDGetChildByName(self, "Text_lv")
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
end
function HeroEscapeItem:initData(info)
	self.heroID = tonumber(info.heroID)
	self.heroLevel = info.level
	self.heroQuality = info.quality
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function HeroEscapeItem:initView(...)
	self.spHead:setSpriteFrame(self.heroDesInfo.herIcon)
	self.spClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	if self.heroLevel then
		self.spState:setVisible(true)
		self.txtLv:setString(self.heroLevel)
	else
		self.spState:setVisible(false)
	end
	if self.heroQuality then
		self.spHeadBg:setSpriteFrame(heroltCtrl.getBg(self.heroQuality))
	else
		self.spHeadBg:setSpriteFrame(heroltCtrl.getBg(gHeroQuality.WHITE))
	end
end
return HeroEscapeItem
