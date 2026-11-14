local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Cover = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_Cover", Com_Cover)
function Com_Cover:onInit()
	self.fields.Button_Open:setString(i18n("hero_text_121"))
	self.fields.Button_Open:addClickListener(handler(self, self.btnOpenClick))
end
function Com_Cover:onShow()
end
function Com_Cover:initData(heroID, handle)
	self.handle = handle
	self.fields.Spine:initData(heroID, nil, nil, true)
	self.fields.Sprite_heroname:setURL(heroltCtrl.getHeroNamePng(heroID, true))
end
function Com_Cover:btnOpenClick()
	SoraDPlaySound()
	self.handle()
end
return Com_Cover
