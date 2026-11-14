local baseComponent = require("fgui.base.baseComponent")
local Com_indicator = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_indicator", Com_indicator)
function Com_indicator:onInit()
	self.curIndex = 1
	self.lastIndex = -1
	self.fields.List_indicator:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_indicator:initData(data)
	self.data = data
	self:updateView()
end
function Com_indicator:updateView()
	self.fields.List_indicator:setNumItems(self.data.count)
	self:setCurLight(self.data.begin)
end
function Com_indicator:onItemRenderer(index, object)
	object:getChild("on"):setVisible(false)
end
function Com_indicator:reserLastIndex()
	self.lastIndex = -1
	self.curIndex = 1
	if SoraDFIsRA() and self.data then
		self.curIndex = self.data.count - self.curIndex + 1
	end
end
function Com_indicator:setCurLight(index)
	if self.data.count <= 1 then
		return
	end
	self.curIndex = index or 1
	if SoraDFIsRA() then
		self.curIndex = self.data.count - self.curIndex + 1
	end
	self.fields.List_indicator:getChildAt(self.curIndex - 1):getChild("on"):setVisible(true)
	if self.lastIndex > 0 then
		self.fields.List_indicator:getChildAt(self.lastIndex - 1):getChild("on"):setVisible(false)
	end
	self.lastIndex = self.curIndex
end
function Com_indicator:onShow()
end
return Com_indicator
