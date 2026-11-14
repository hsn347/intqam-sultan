local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local starTreasureltCtrl = include("starTreasureltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarTreasureRewardPanel = class("StarTreasureRewardPanel", baseFguiPanel)
function StarTreasureRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("StarTreasureRewardPanel:ctor", self.viewName)
end
function StarTreasureRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarTreasureRewardPanel:onInit()
	print("=======StarTreasureRewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("hero_title_02"))
	self.fields.Text_must:setString(i18n("ramadanTreasure_text07"))
	self.fields.Text_random:setString(i18n("ramadanTreasure_text08"))
	local classtype = activityShowCtrl:getParamByID(gActivityTimeActivityID.STAR_TREASURE_EXPLORE).classtype
	self.mustRewardList = starTreasureltCtrl.getMustRewardByClassType(classtype)
	self.randomRewardList = starTreasureltCtrl.getRandomRewardByClassType(classtype)
	self.fields.List_must:setItemRenderer(handler(self, self.onItemRendererMust))
	self.fields.List_random:setItemRenderer(handler(self, self.onItemRendererRandom))
	self.fields.List_must:setNumItems(table.nums(self.mustRewardList) / 2)
	self.fields.List_random:setNumItems(table.nums(self.randomRewardList) / 3)
end
function StarTreasureRewardPanel:onItemRendererMust(index, obj)
	obj:initData(self.mustRewardList[index * 2 + 1], self.mustRewardList[index * 2 + 2])
end
function StarTreasureRewardPanel:onItemRendererRandom(index, obj)
	obj:initData(self.randomRewardList[index * 3 + 1], self.randomRewardList[index * 3 + 2])
end
function StarTreasureRewardPanel:onShow()
	print("=======StarTreasureRewardPanel:onShow")
end
function StarTreasureRewardPanel:onHide()
	print("=======StarTreasureRewardPanel:onHide")
end
function StarTreasureRewardPanel:onDispose()
	print("=======StarTreasureRewardPanel:onDispose")
end
return StarTreasureRewardPanel
