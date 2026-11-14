local baseComponent = require("fgui.base.baseComponent")
local Com_logGroup = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMainView/Com_logGroup", Com_logGroup)
function Com_logGroup:onInit()
	self.logList, _ENV = nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function Com_logGroup:onShow()
end
function Com_logGroup:onListRenderer(index, obj)
	obj:initData(self.logList[index + 1])
end
function Com_logGroup:initData(log)
	self.logList = log.data
	self.fields.Text_dateTime:setString(log.key)
	self.fields.List:setNumItems(#self.logList)
	local height = 24
	for i = 1, self.fields.List:getNumItems() do
		local logSingle = self.fields.List:getChildAt(i - 1)
		height = height + logSingle:getHeight() + 10
	end
	self:setHeight(height)
end
return Com_logGroup
