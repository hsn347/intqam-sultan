local worldMapDefine = include("worldMapDefine")
local ramadanAccuRechargeltCtrl = include("ramadanAccuRechargeltCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarryNightJourneyDetailPanel = class("StarryNightJourneyDetailPanel", baseFguiPanel)
function StarryNightJourneyDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarryNightJourneyDetailPanel:ctor", self.viewName)
end
function StarryNightJourneyDetailPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RamadanAccuRecharge"
	end
	return self._packageList
end
function StarryNightJourneyDetailPanel:onInit()
	print("=======RamadanAccuDetailPanel:onInit")
	self:fixChildrenPos()
	self.activityID = gActivityTimeActivityID.STARRY_NIGHT_JOURNEY
	self.fields.Text_point:fixPos()
	self.fields.Text_level:fixPos()
	self.fields.Panel_bg:setString(i18n("atlantiswar_text_0249"))
	self.fields.Text_level:setString(i18n("common_text_748"))
	self.fields.Text_point:setString(i18n("common_text_3156"))
	self.fields.Text_tip:setString(i18n("StarryNight_text_03"))
	self.fields.List_detail:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function StarryNightJourneyDetailPanel:initData()
	self.pointInfo = ramadanAccuRechargeltCtrl.getStarryNightJourneyScore()
	self.fields.List_detail:setNumItems(table.nums(self.pointInfo))
end
function StarryNightJourneyDetailPanel:onItemRenderer(index, obj)
	obj:initData(index + 1, self.pointInfo[index + 1].score, worldMapDefine.getMonsterLevel(self.pointInfo[index + 1].npcId))
end
function StarryNightJourneyDetailPanel:onShow()
	print("=======StarryNightJourneyDetailPanel:onShow")
end
return StarryNightJourneyDetailPanel
