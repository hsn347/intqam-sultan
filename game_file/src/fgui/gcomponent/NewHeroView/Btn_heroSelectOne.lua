local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_heroSelectOne = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Btn_heroSelectOne", Btn_heroSelectOne)
function Btn_heroSelectOne:onInit()
end
function Btn_heroSelectOne:onShow()
end
function Btn_heroSelectOne:initData(heroID)
	self.fields.hero:initData(heroID)
	self.fields.Sprite_class:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(heroID).icon)
	local heroInfo = heroCtrl:getHeroInfoByID(heroID)
	self.fields.Text_lv:setString(heroInfo.level)
	local fileName, rarity, color = heroltCtrl:getCardRareImg(heroID)
	self.fields.Sprite_quality:setSpriteFrame(fileName)
end
return Btn_heroSelectOne
