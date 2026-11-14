local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_itemHole = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_itemHole", Btn_itemHole)
function Btn_itemHole:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_itemHole:onShow()
end
function Btn_itemHole:initData(selfUid, quality, costID, costNum, weaponUidList)
	self.costID = costID
	self.costNum = costNum
	self.selfUid = selfUid
	self.weaponUidList = weaponUidList
	if #self.weaponUidList > 0 then
		self.controllers.c1:setSelectedIndex(1)
		_UPVALUE0_ = 1
		;(1).weaponID = self.costID
		;(1).lv = 0
		;(1).stage = 0
		;(1).quality = quality
		self.fields.weapon:initData(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Btn_itemHole:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).weaponID = self.costID
	;(nil).costNum = self.costNum
	;(nil).selfUid = self.selfUid
	;(nil).weaponUidList = self.weaponUidList
	uiManager:show("HeroWeaponChoose", nil)
end
return Btn_itemHole
