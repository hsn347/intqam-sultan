local armyChangeRead = include("armyChangeRead")
local basePanel = require("fgui.base.baseFguiPanel")
local armyTransferOrignPanel = class("armyTransferOrignPanel", basePanel)
function armyTransferOrignPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function armyTransferOrignPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function armyTransferOrignPanel:onInit()
	self.param = self.proxy.param
	self.fields.Panel_bg:setTitle(i18n("armyExchange_text_008"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function armyTransferOrignPanel:onShow()
	self.costNum = armyChangeRead.getArmyTranferCost(self.param.armyType, self.param.level)[1].armyCostNum
	self.armyIdList = armyChangeRead.getOrignArmyIDList(self.param.armyType, self.param.level)
	dump(self.armyIdList, "self.armyIdList")
	self.fields.scroll:setNumItems(#self.armyIdList)
end
function armyTransferOrignPanel:onItemRenderer(index, object)
	object:initData(self.armyIdList[index + 1], self.costNum, handler(self, self.chooseBack))
end
function armyTransferOrignPanel:chooseBack(armyId)
	if self.param.handler then
		self.param.handler(armyId)
	end
	self:close()
end
return armyTransferOrignPanel
