local heroBiographyRead = include("heroBiographyRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_biographyItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_biographyItem", Com_biographyItem)
function Com_biographyItem:onInit()
	self.fields.Button_detail:setString("查看加成")
	self.fields.Button_detail:addClickListener(handler(self, self.btnDetailClick))
	self.fields.Check_tick:addClickListener(handler(self, self.btnClick))
end
function Com_biographyItem:onShow()
end
function Com_biographyItem:initData(index, editData)
	self.index = index
	self.fields.bg:setVisible(index % 2 == 1)
	self.fields.title:setString("列传" .. index .. "--" .. i18n(heroBiographyRead.getBiographyName(index)))
	self.fields.Check_tick:setSelected(not not editData.biographyIndex[self.index])
end
function Com_biographyItem:btnDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	uiManager:show("CheatHeroBiographyPop", nil)
end
function Com_biographyItem:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_BIOGRAPHY"
	;(nil).index = self.index
	;(nil).isSelect = self.fields.Check_tick:isSelected()
	SoraDSendMessage(nil)
end
return Com_biographyItem
