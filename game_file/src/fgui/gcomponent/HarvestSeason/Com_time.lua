local baseComponent = require("fgui.base.baseComponent")
local Com_time = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HarvestSeason/Com_time", Com_time)
fgui.register_extension("ui://CommonBoxSingle/Com_time", Com_time)
fgui.register_extension("ui://Activity2112/Label_itemGetTime", Com_time)
fgui.register_extension("ui://Ramadanstarlights/Label_itemGetTime", Com_time)
function Com_time:onInit()
	self:fixChildrenPos()
	if self.fields.Text_time then
		self.fields.Text_time:setString(i18n("common_text_2669"))
	end
	self.fields.title = SoraDCreateTimerLabel(self, self.fields.title)
end
function Com_time:initData(remainTime)
	self:setTime(remainTime)
end
function Com_time:setTitle(str)
	self.fields.Text_time:setString(str)
end
function Com_time:setState(index)
	self.controllers.state:setSelectedIndex(index)
end
function Com_time:setTime(time)
	self.fields.title:beginTime(time)
end
function Com_time:setToCenter()
	self:setPositionX(display.width / 2 - self.fields.title:getPositionX() - 25)
end
function Com_time:onShow()
end
return Com_time
