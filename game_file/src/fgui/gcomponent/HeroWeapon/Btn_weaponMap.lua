local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_weaponMap = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_weaponMap", Btn_weaponMap)
function Btn_weaponMap:onInit()
	self.fields.Label_reddot:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_weaponMap:onShow()
end
function Btn_weaponMap:initData(data)
	self.data = data
	self.fields.Image_quality:setSpriteFrame(heroWeaponRead.getWeaponBasePng(self.data.quality))
	self.fields.icon:setSpriteFrame(heroWeaponRead.getWeaponIcon(self.data.weaponId))
	self.fields.title:setString(heroWeaponRead.getWeaponName(self.data.weaponId))
	self.isHave = heroWeaponCtrl:getWeaponByID(self.data.weaponId) and true or false
	self.fields.Image_quality:setGrayed(not self.isHave)
	self.fields.icon:setGrayed(not self.isHave)
	local ret, map = heroWeaponCtrl:isHaveMergeEnable()
	if ret and map[tostring(self.data.weaponId)] then
		self.fields.Label_reddot:setVisible(true)
	else
		self.fields.Label_reddot:setVisible(false)
	end
end
function Btn_weaponMap:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("HeroWeaponDescribe", nil)
end
return Btn_weaponMap
