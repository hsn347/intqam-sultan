local djRead = include("djRead")
local baseComponent = require("fgui.base.baseComponent")
local Lab_lvShow = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://DjView/Lab_lvShow", Lab_lvShow)
function Lab_lvShow:onInit()
	self:fixChildrenPos()
end
function Lab_lvShow:onShow()
end
function Lab_lvShow:initData(lv)
	local cfg = djRead.getMonthLvCfg(lv)
	self.fields.title:setString(i18n(cfg.nameMonth))
	self.fields.title:setColor(djRead.getColorByLv(lv, 1))
	self.fields.icon:setURL(cfg.picMonth)
end
return Lab_lvShow
