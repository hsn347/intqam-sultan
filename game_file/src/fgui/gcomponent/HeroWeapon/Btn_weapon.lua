local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroWeaponRead = include("heroWeaponRead")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_weapon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_weapon", Btn_weapon)
function Btn_weapon:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self.fields.hero:setVisible(false)
	self.fields.hero:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.stars:fixPos()
end
function Btn_weapon:onShow()
end
function Btn_weapon:initData(data)
	self.controllers.c1:setSelectedIndex(0)
	self.data = data
	self.fields.Image_quality:setSpriteFrame(heroWeaponRead.getWeaponBasePng(self.data.quality))
	self.fields.icon:setSpriteFrame(heroWeaponRead.getWeaponIcon(self.data.weaponID))
	heroWeaponRead = heroWeaponRead.getWeaponIcon(self.data.weaponID)
	heroWeaponRead.getWeaponIcon(self.data.weaponID).lv = self.data.lv
	self.fields.Text_lv:setString(i18n("common_text_100", heroWeaponRead.getWeaponIcon(self.data.weaponID)))
	self.fields.stars:setStage(self.data.stage)
	local heroID = self.data.heroID or heroWeaponCtrl:getWearHeroId(self.data.id)
	if heroID then
		self.fields.hero:setVisible(true)
		local heroInfo = heroCtrl:getHeroInfoByID(heroID)
		local heroCfg = heroltCtrl.getHeroInfo(heroID)
		self.fields.hero:getChildByName("bg"):setSpriteFrame(heroltCtrl.getBg(heroInfo.quality))
		self.fields.hero:getChildByName("icon"):setSpriteFrame(heroCfg.herIcon)
	else
		self.fields.hero:setVisible(false)
	end
end
function Btn_weapon:initNone()
	self.controllers.c1:setSelectedIndex(1)
end
function Btn_weapon:btnClick()
	if self.data then
		SoraDPlaySound()
		_ENV = nil
		;(nil).data = self.data
		uiManager:show("HeroWeaponDetail", nil)
	end
end
return Btn_weapon
