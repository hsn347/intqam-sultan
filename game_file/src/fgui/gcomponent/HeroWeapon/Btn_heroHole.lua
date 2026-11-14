local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_heroHole = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_heroHole", Btn_heroHole)
function Btn_heroHole:onInit()
	self.fields.touch:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_remove:addClickListener(handler(self, self.btnRemoveClick))
end
function Btn_heroHole:onShow()
end
function Btn_heroHole:initData(weaponUid, heroID)
	self.weaponUid = weaponUid
	self.heroID = heroID or heroWeaponCtrl:getWearHeroId(self.weaponUid)
	if self.heroID then
		self.controllers.c1:setSelectedIndex(1)
		local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
		self.fields.Image_quality:setSpriteFrame(heroltCtrl.getBg(heroInfo.quality))
		local heroCfg = heroltCtrl.getHeroInfo(self.heroID)
		self.fields.icon:setSpriteFrame(heroCfg.herIcon)
		self.fields.icon_name:setSpriteFrame(heroltCtrl.getHeroNamePng(self.heroID, true))
		if self.fields.icon_name:getWidth() * 0.3 > 170 then
			self.fields.icon_name:setScale(170 / self.fields.icon_name:getWidth())
		else
			self.fields.icon_name:setScale(0.3)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Btn_heroHole:getTouch()
	return self.fields.touch
end
function Btn_heroHole:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).weaponUid = self.weaponUid
	;(nil).heroID = self.heroID
	uiManager:show("HeroWeaponHeroSelect", nil)
end
function Btn_heroHole:btnRemoveClick()
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(0)
	heroCtrl:weaponTakeOff(self.heroID)
end
return Btn_heroHole
