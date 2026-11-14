local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroAdd = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_heroAdd", Com_heroAdd)
function Com_heroAdd:onInit()
	self.fields.Button_touch:addClickListener(handler(self, self.btnChooseClick))
	self.fields.Button_remove:addClickListener(handler(self, self.btnRemoveClick))
end
function Com_heroAdd:onShow()
end
function Com_heroAdd:initData(style, index, editData, id)
	self.style = style
	self.index = index
	self.editData = editData
	self.id = id
	local index = id and style or 0
	self.controllers.c1:setSelectedIndex(index)
	if index == 1 or index == 3 then
		local dressCfg = heroltCtrl:getHeroDress(id)
		self.fields.hero:initMax(id, dressCfg[2] or dressCfg[1])
		self.fields.title:setString(i18n(heroltCtrl.getHeroName(id)))
	elseif index == 2 then
		self.fields.title:setString(heroWeaponRead.getWeaponName(id))
		self.fields.weapon:initData(id)
	else
		self.fields.title:setString("请选择")
	end
end
function Com_heroAdd:btnChooseClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).style = self.style
	;(nil).index = self.index
	;(nil).id = self.id
	;(nil).editData = self.editData
	uiManager:show("CheatHeroWeaponChoose", nil)
end
function Com_heroAdd:btnRemoveClick()
	SoraDPlaySound()
	if self.index == 2 then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_CHOOSE"
		;(nil).style = self.style
		;(nil).index = self.index
		;(nil).weaponID = nil
		SoraDSendMessage(nil)
	else
		_ENV = nil
		;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_CHOOSE"
		;(nil).style = self.style
		;(nil).index = self.index
		;(nil).heroID = nil
		SoraDSendMessage(nil)
	end
end
return Com_heroAdd
