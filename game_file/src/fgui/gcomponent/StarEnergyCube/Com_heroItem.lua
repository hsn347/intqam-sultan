local equipDesRead = include("equipDesRead")
local heroltCtrl = include("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_heroItem", Com_heroItem)
function Com_heroItem:onInit()
end
function Com_heroItem:initData(index, v)
	if index == 1 and v.armsID then
		self.fields.Load_cellImage:setURL(equipDesRead.getArtifactIcon(v.armsID))
		equipDesRead = equipDesRead.getArtifactIcon(v.armsID)
		equipDesRead.getArtifactIcon(v.armsID).lv = v.level
		self.fields.cellLvTxt:setString(i18n("common_text_100", equipDesRead.getArtifactIcon(v.armsID)))
		self.controllers.c1:setSelectedIndex(1)
	else
		local heroInfo = heroltCtrl.getHeroInfo(v.heroID)
		self.fields.Load_cellImage:setSpriteFrame(heroInfo.herIcon)
		self.fields.Text_cellLvTxt:setString(v.level)
		self.fields.Load_cellBg:setSpriteFrame(heroltCtrl.getBg(v.quality))
	end
end
function Com_heroItem:onShow()
end
return Com_heroItem
