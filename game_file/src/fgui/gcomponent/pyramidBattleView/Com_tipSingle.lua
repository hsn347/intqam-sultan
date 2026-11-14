local baseComponent = require("fgui.base.baseComponent")
local Com_tipSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://pyramidBattleView/Com_tipSingle", Com_tipSingle)
function Com_tipSingle:onInit()
	self:fixChildrenPos()
end
function Com_tipSingle:onShow()
end
function Com_tipSingle:initData(data)
	if data.targetType == gPyramidwarShopPointAddType.OCCUPY_BUILDING then
		self.fields.Text_name:setString(i18n("allianceWar_shopPoint_details_occupied"))
	elseif data.targetType == gPyramidwarShopPointAddType.KILL_SOLDIER then
		self.fields.Text_name:setString(i18n("allianceWar_shopPoint_details_kill"))
	elseif data.targetType == gPyramidwarShopPointAddType.SOLDIER_DIE then
		self.fields.Text_name:setString(i18n("allianceWar_shopPoint_details_die"))
	end
	_ENV = i18n("allianceWar_shopPoint_details_die")
	i18n("allianceWar_shopPoint_details_die").var = data.targetScore
	self.fields.Text_score:setString(i18n("allianceWar_shopPoint_01", i18n("allianceWar_shopPoint_details_die")))
end
return Com_tipSingle
