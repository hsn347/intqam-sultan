local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_StoryHeroInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_StoryHeroInfo", Com_StoryHeroInfo)
function Com_StoryHeroInfo:onInit()
end
function Com_StoryHeroInfo:onShow()
end
function Com_StoryHeroInfo:initData(heroID)
	self.heroID = heroID
	local bg, _ = heroltCtrl.getHeroViewBg(self.heroID)
	self.fields.icon:setURL(bg)
end
return Com_StoryHeroInfo
