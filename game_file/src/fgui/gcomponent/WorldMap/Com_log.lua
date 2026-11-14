local baseComponent = require("fgui.base.baseComponent")
local Com_log = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/Com_log", Com_log)
function Com_log:onInit()
	self.nowExplore = i18n("common_text_462")
	self.fields.Text_going:setString(self.nowExplore)
end
function Com_log:onShow()
	self:beginTime()
end
function Com_log:initData(logText)
	self.fields.Text_log:setString(logText)
end
function Com_log:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function Com_log:updateTime(time)
	local nowTxt = self.fields.Text_going:getText()
	self.fields.Text_going:setString(string.len(nowTxt) < string.len(self.nowExplore) + 5 and nowTxt .. "." or string.sub(nowTxt, 1, string.len(self.nowExplore)))
end
return Com_log
