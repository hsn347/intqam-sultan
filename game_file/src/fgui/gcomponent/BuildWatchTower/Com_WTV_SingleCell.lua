local baseComponent = require("fgui.base.baseComponent")
local Com_WTV_SingleCell = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_WTV_SingleCell", Com_WTV_SingleCell)
function Com_WTV_SingleCell:onInit()
end
function Com_WTV_SingleCell:onShow()
end
function Com_WTV_SingleCell:initData(isOnlyTitle, data, isFilter)
	if not isOnlyTitle then
		local isMass = self.fields.Com_WTV_single:initData(data, isFilter)
		self.controllers.c1:setSelectedIndex(isMass and 2 or 0)
	else
		self.fields.Com_WTV_filter:setTitle(i18n("commom_text_4300"))
		self.controllers.c1:setSelectedIndex(1)
	end
end
return Com_WTV_SingleCell
