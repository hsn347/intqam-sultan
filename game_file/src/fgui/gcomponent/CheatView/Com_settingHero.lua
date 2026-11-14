local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_settingHero = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_settingHero", Com_settingHero)
function Com_settingHero:onInit()
end
function Com_settingHero:onShow()
end
function Com_settingHero:initData(index, editData)
	self.fields.title:setString("位置" .. index)
	local mainHeroID = editData.heroList[index]
	self.fields.mainHero:initData(1, index, editData, mainHeroID)
	if mainHeroID then
		local rarity = heroltCtrl:getHeroRarity(mainHeroID)
		if rarity >= gHeroRarity.ORANGE then
			local weaponID = editData.heroWeapon[tostring(index)] and editData.heroWeapon[tostring(index)].weaponID or nil
			self.fields.weapon:initData(2, index, editData, weaponID)
			self.fields.weapon:setVisible(true)
		else
			self.fields.weapon:setVisible(false)
		end
	else
		self.fields.weapon:setVisible(false)
	end
	if mainHeroID and heroltCtrl:isOwnMoreDress(mainHeroID) then
		self.fields.viceHero:initData(3, index, editData, editData.viceHeroList[index])
		self.fields.viceHero:setVisible(true)
	else
		self.fields.viceHero:setVisible(false)
	end
end
return Com_settingHero
