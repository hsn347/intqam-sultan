local equipmentltCtrl = include("equipmentltCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local acquisitionPanel = class("acquisitionPanel", basePanel)
function acquisitionPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function acquisitionPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Increasematerial"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function acquisitionPanel:onInit()
	self.param = self.proxy.param
	self.fields.Panel_bg:setTitle(i18n("common_text_1356"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRederer))
end
function acquisitionPanel:onShow()
	self.sourceList = equipmentltCtrl.getOutput(self.param.itemID)
	dump(self.sourceList, "self.sourceList")
	self:updateScroll()
end
function acquisitionPanel:updateScroll()
	self.fields.scroll:setNumItems(#self.sourceList)
end
function acquisitionPanel:onItemRederer(index, target)
	target:initData(self.sourceList[index + 1])
end
return acquisitionPanel
