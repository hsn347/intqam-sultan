local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_heroSelect = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001643/Btn_heroSelect", Btn_heroSelect)
function Btn_heroSelect:onInit()
end
function Btn_heroSelect:onShow()
end
function Btn_heroSelect:initData(heroID)
	self.heroID = tonumber(heroID)
	self.fields.hero:initData(self.heroID)
	self.fields.Sprite_class:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.fields.Text_lv:setString(heroInfo.level)
	local fileName, rarity, color = heroltCtrl:getCardRareImg(self.heroID)
	self.fields.Sprite_quality:setSpriteFrame(fileName)
end
return Btn_heroSelect
