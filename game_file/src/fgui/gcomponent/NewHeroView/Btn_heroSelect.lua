local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_heroSelect = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Btn_heroSelect", Btn_heroSelect)
function Btn_heroSelect:onInit()
	self.fields.Text_appointed:setString(i18n("nebulaemperor_text_239"))
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_heroSelect:onShow()
end
function Btn_heroSelect:initData(data, selectHeroID)
	self.heroID = data and tonumber(data.heroID)
	if self.heroID then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.select:setVisible(selectHeroID and self.heroID == selectHeroID or false)
		self.fields.hero:initData(self.heroID)
		self.fields.Sprite_class:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
		local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
		self.fields.Text_lv:setString(heroInfo.level)
		local fileName, rarity, color = heroltCtrl:getCardRareImg(self.heroID)
		self.fields.Sprite_quality:setSpriteFrame(fileName)
		self.controllers.c2:setSelectedIndex(data.isBeAppoint)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.select:setVisible(false)
	end
end
function Btn_heroSelect:btnClick()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_HERO_APPOINT_SELECT"
	;(nil).heroID = self.heroID
	SoraDSendMessage(nil)
end
return Btn_heroSelect
