local baseComponent = require("fgui.base.baseComponent")
local Com_indicator = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_indicator", Com_indicator)
function Com_indicator:onInit()
	self.curIndex = 1
	self.fields.List_indicator:setAlignCenter(true)
end
function Com_indicator:initData(data)
	self.data = data
	self:updateView()
end
function Com_indicator:updateView()
	self.fields.List_indicator:setNumItems(self.data.count)
	self:setCurLight(self.data.begin)
end
function Com_indicator:reserLastIndex()
	self.curIndex = 1
	if SoraDFIsRA() and self.data then
		self.curIndex = self.data.count - self.curIndex + 1
	end
end
function Com_indicator:setCurLight(index)
	if table.nums(self.data) <= 1 then
		return
	end
	self.curIndex = index or 1
	if SoraDFIsRA() then
		self.curIndex = self.data.count - self.curIndex + 1
	end
	self.fields.List_indicator:setSelectedIndex(self.curIndex - 1)
end
function Com_indicator:onShow()
end
return Com_indicator
