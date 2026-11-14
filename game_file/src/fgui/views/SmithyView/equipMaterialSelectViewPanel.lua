local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipMaterialSelectViewPanel = class("equipMaterialSelectViewPanel", baseFguiPanel)
function equipMaterialSelectViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipMaterialSelectViewPanel:ctor", self.viewName)
end
function equipMaterialSelectViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipMaterialSelectViewPanel:onInit()
	print("=======equipMaterialSelectViewPanel:onInit")
	self.selectIndex = nil
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function equipMaterialSelectViewPanel:onShow()
	print("=======equipMaterialSelectViewPanel:onShow")
	self.title = self.param.title
	self.items = self.param.items
	self.mode = self.param.mode
	self.tag = self.param.tag
	self.fields.title:setString(self.title)
	self.fields.List:setNumItems(#self.items)
end
function equipMaterialSelectViewPanel:onItemRenderer(index, obj)
	obj:initData(self.items[index + 1], self.mode, self.tag, index + 1, self.selectIndex)
end
function equipMaterialSelectViewPanel:selectBack(target, data)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.08333333333333333)
	;(nil)[2] = ffa.callFunc(function()
		self:close()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:close()
	end)
	self:runAction(ffa.seq(nil))
end
return equipMaterialSelectViewPanel
