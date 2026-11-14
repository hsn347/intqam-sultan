local baseComponent = require("fgui.base.baseComponent")
local Com_scoreSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://pyramidBattleView/Com_scoreSingle", Com_scoreSingle)
function Com_scoreSingle:onInit()
	self:fixChildrenPos()
end
function Com_scoreSingle:onShow()
end
function Com_scoreSingle:initData(data, index)
	self.fields.bg:setVisible(index % 2 == 1)
	if data.targetType == gPyramidwarShopPointAddType.OCCUPY_BUILDING then
		local buildName = i18n("buildDes_name_" .. data.event)
		_ENV = nil
		;(nil).var1 = data.getPoint[1] / 60
		;(nil).var2 = buildName
		self.fields.Text_name:setString(i18n(data.getPointDesc, nil))
	elseif data.targetType == gPyramidwarShopPointAddType.KILL_SOLDIER then
		_ENV = i18n(data.getPointDesc, nil)
		i18n(data.getPointDesc, nil).var1 = data.getPoint[1]
		i18n(data.getPointDesc, nil).var2 = data.event
		self.fields.Text_name:setString(i18n(data.getPointDesc, i18n(data.getPointDesc, nil)))
	elseif data.targetType == gPyramidwarShopPointAddType.SOLDIER_DIE then
		_ENV = i18n(data.getPointDesc, i18n(data.getPointDesc, nil))
		i18n(data.getPointDesc, i18n(data.getPointDesc, nil)).var1 = data.getPoint[1]
		i18n(data.getPointDesc, i18n(data.getPointDesc, nil)).var2 = data.event
		self.fields.Text_name:setString(i18n(data.getPointDesc, i18n(data.getPointDesc, i18n(data.getPointDesc, nil))))
	end
	self.fields.Text_score:setString(data.getPoint[2])
end
return Com_scoreSingle
