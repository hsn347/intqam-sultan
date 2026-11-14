local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroPowerSkillGiftCtrl = SoraDGetCtrl("heroPowerSkillGiftCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_advance = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_advance", Com_advance)
function Com_advance:onInit()
	self.fields.Button_talent:setVisible(false)
	self.fields.Button_uSkill:setString(i18n("hero_btn_06"))
	self.fields.Button_uSkill:addClickListener(handler(self, self.btnUSkillClick))
	self.fields.Button_weapon:setTitle(i18n("HeroWeapon_3"))
	self.fields.Button_weapon:addClickListener(handler(self, self.btnWeaponClick))
end
function Com_advance:onShow()
end
function Com_advance:initData(heroID)
	self.heroID = heroID
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.fields.Button_uSkill:setVisible(self.heroInfo and self.heroInfo.isAwake or false)
	if self.fields.Button_uSkill:isVisible() then
		local stageRewardNum = heroPowerSkillGiftCtrl:getCliamRewardNum(self.heroID)
		self.fields.Button_uSkill:getChildByName("Label_reddot"):initData(0 < stageRewardNum, stageRewardNum)
	end
	local rarity = heroltCtrl:getHeroRarity(self.heroID)
	self.isShowWeapon = rarity >= gHeroRarity.ORANGE and self.heroInfo.isAwake
	self:setBtnWeapon()
end
function Com_advance:setBtnWeapon()
	self.fields.Button_weapon:setVisible(self.isShowWeapon)
	if self.isShowWeapon then
		local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
		if heroInfo then
			if heroInfo.weaponUid and heroInfo.weaponUid > 0 then
				local weaponUid = heroInfo.weaponUid
				local heroWeaponRead = include("heroWeaponRead")
				local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
				local weapon = heroWeaponCtrl:getWeaponByUid(weaponUid)
				if weapon then
					self.fields.Button_weapon:getController("c1"):setSelectedIndex(1)
					self.fields.Button_weapon:setIcon(heroWeaponRead.getWeaponIcon(weapon.weaponID))
					self.fields.Button_weapon:getChildByName("icon_bg"):setSpriteFrame(heroWeaponRead.getWeaponComBg(weapon.weaponID))
				else
					self.fields.Button_weapon:getController("c1"):setSelectedIndex(0)
				end
			else
				self.fields.Button_weapon:getController("c1"):setSelectedIndex(0)
			end
		else
			self.fields.Button_weapon:setVisible(false)
		end
	end
end
function Com_advance:getChipItem()
	return self.fields.chipItem:getBtnChip()
end
function Com_advance:btnUSkillClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_HERODETAIL_SKILL_STUDY"
	;(nil).isShow = true
	SoraDSendMessage(nil)
end
function Com_advance:btnWeaponClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).heroID = self.heroID
	uiManager:show("HeroWeaponSelect", nil)
end
return Com_advance
