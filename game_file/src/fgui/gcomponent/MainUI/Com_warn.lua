local baseComponent = require("fgui.base.baseComponent")
local Com_warn = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_warn", Com_warn)
function Com_warn:onInit()
	self.warningList, _UPVALUE0_ = nil, nil
end
function Com_warn:onShow()
end
function Com_warn:setShowType(sType)
	self.controllers.c1:setSelectedIndex(sType)
end
function Com_warn:updateWarning(data)
	local sortIdx = data.sortIdx or 1
	if data.isVisible then
		self.warningList[sortIdx] = data.sType
		self:updateShowType()
	else
		self.warningList[sortIdx] = nil
		self:updateShowType()
	end
end
function Com_warn:updateShowType(...)
	if next(self.warningList) then
		local keys = table.keys(self.warningList)
		table.sort(keys)
		local cur_sortIdx = keys[#keys]
		local cur_sType = self.warningList[cur_sortIdx]
		self:setShowType(cur_sType)
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end
return Com_warn
