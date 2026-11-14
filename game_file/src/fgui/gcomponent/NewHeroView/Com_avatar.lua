local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_avatar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_avatar", Com_avatar)
function Com_avatar:onInit()
end
function Com_avatar:onShow()
end
function Com_avatar:initData(heroID)
	self.heroID = tonumber(heroID)
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	local heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self.fields.icon:setSpriteFrame(heroDesInfo.herIcon)
	self.fields.bg:setSpriteFrame(heroltCtrl.getBg(heroInfo.quality))
end
return Com_avatar
