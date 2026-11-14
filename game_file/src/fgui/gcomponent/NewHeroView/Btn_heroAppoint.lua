local heroAppointCtrl = SoraDGetCtrl("heroAppointCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_heroAppoint = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Btn_heroAppoint", Btn_heroAppoint)
function Btn_heroAppoint:onInit()
	self.fields.touch:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_remove:addClickListener(handler(self, self.btnDismissClick))
end
function Btn_heroAppoint:onShow()
end
function Btn_heroAppoint:getBtnTouch()
	return self.fields.touch
end
function Btn_heroAppoint:initData(bid, heroID)
	self.bid = bid
	self.heroID = heroID
	if self.heroID then
		self.controllers.c1:setSelectedIndex(1)
		local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
		local heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
		self.fields.icon:setSpriteFrame(heroDesInfo.herIcon)
		self.fields.Sprite_class:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
		self.fields.Text_lv:setString(heroInfo.level)
		self.fields.bg:setSpriteFrame(heroltCtrl.getBg(heroInfo.quality))
		self.fields.Sprite_quality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Btn_heroAppoint:btnDismissClick()
	SoraDPlaySound()
	heroAppointCtrl:reqDismiss(self.bid)
end
function Btn_heroAppoint:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).bid = self.bid
	;(nil).heroID = self.heroID
	uiManager:show("HeroAppointPop", nil)
end
return Btn_heroAppoint
