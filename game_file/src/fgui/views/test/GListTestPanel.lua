local baseFguiPanel = require("fgui.base.baseFguiPanel")
local GListTestPanel = class("GListTestPanel", baseFguiPanel)
function GListTestPanel:ctor(...)
	self.isLRU = true
	GListTestPanel.super.ctor(self, ...)
	print("GListTestPanel:ctor", self.viewName)
end
function GListTestPanel:onInit()
	print("=======GListTestPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_4498"), handler(self, self.onClickClose))
	_ENV = handler(self, self.onClickClose)
	handler(self, self.onClickClose).time = "00:15:46"
	self.fields.Label_title:setString(i18n("common_text_607", handler(self, self.onClickClose)))
	self.fields.List:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScroll))
	self.basePosY1 = self.fields.Com_info:getPositionY()
	self.basePosY2 = self.fields.Label_title:getPositionY()
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setNumItems(10)
end
function GListTestPanel:endShow()
	print("=======GListTestPanel:endShow")
end
function GListTestPanel:onScroll(...)
	local offsetY = self.fields.List:getScrollPane():getPositionY()
	print("==GListTestPanel:onScroll==", offsetY)
	local newPosY = self.basePosY2 - offsetY
	newPosY = math.max(80, newPosY)
	self.fields.Label_title:setPositionY(newPosY)
	self.fields.Com_info:setPositionY(self.basePosY1 - offsetY * 0.5)
	self.fields.Com_info:setOpacity(255 - offsetY * 2)
end
function GListTestPanel:onItemProvider(index)
	if index == 0 then
		return "ui://CommonNew/Com_empty"
	else
		return "ui://CommonNew/Com_taskSingle"
	end
end
function GListTestPanel:onItemRenderer(index, obj)
	if index == 0 then
		obj:setHeight(150)
	end
end
return GListTestPanel
