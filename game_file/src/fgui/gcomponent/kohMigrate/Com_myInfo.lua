local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local kohMigrateRead = include("kohMigrateRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_myInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/Com_myInfo", Com_myInfo)
function Com_myInfo:onInit()
end
function Com_myInfo:onShow()
end
function Com_myInfo:initData()
	self.playerType = kohMigrateCtrl:getMyPlayerType()
	kohMigrateCtrl = nil
	;(nil).playertype = kohMigrateRead.getPlayerTypeName(self.playerType)
	self.fields.Text_type:setString(i18n("migrant_move_text19", nil))
	local beginStrength = kohMigrateCtrl:getBeginStrength()
	kohMigrateCtrl = i18n("migrant_move_text19", nil)
	i18n("migrant_move_text19", nil).power = string.formatnumberthousands(beginStrength)
	self.fields.Text_power:setString(i18n("migrant_move_text20", i18n("migrant_move_text19", nil)))
	local legend = kohMigrateCtrl:getMyLegend()
	local legendStr = legend and string.formatnumberthousands(legend) or i18n("rides_btn_01")
	kohMigrateCtrl = i18n("migrant_move_text20", i18n("migrant_move_text19", nil))
	i18n("migrant_move_text20", i18n("migrant_move_text19", nil)).legend = legendStr
	self.fields.Text_legend:setString(i18n("migrant_move_text21", i18n("migrant_move_text20", i18n("migrant_move_text19", nil))))
end
return Com_myInfo
