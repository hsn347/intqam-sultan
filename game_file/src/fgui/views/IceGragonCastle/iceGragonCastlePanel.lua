local iceWolfCastleCtrl = SoraDGetCtrl("iceWolfCastleCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local iceGragonCastlePanel = class("iceGragonCastlePanel", baseFguiPanel)
function iceGragonCastlePanel:ctor(...)
	self.super.ctor(self, ...)
	print("iceGragonCastlePanel:ctor", self.viewName)
end
function iceGragonCastlePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function iceGragonCastlePanel:onInit()
	print("=======iceGragonCastlePanel:onInit")
	self.activityID = gActivityTimeActivityID.RAMADAN_SHINING_CASTLE_5
	self.fields.Com_title:initData(i18n("activity_name_9001485"), handler(self, self.onClickClose))
	self.fields.textTips:setString(i18n("ice_dragon_01"))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.GetRank:initData(2)
	self.fields.GiveRank:initData(1)
	self.fields.GetRank:fixPos()
	self.fields.GiveRank:fixPos()
	self.fields.com_ItemNum:setString(i18n("common_text_3893"))
	self.fields.com_ItemNum:initData(860101)
end
function iceGragonCastlePanel:onShow()
	print("=======iceGragonCastlePanel:onShow")
	iceWolfCastleCtrl:reqRamadanShiningCastleActivityData4()
end
function iceGragonCastlePanel:updateRankInfo()
	self.fields.GetRank:updateRankInfo()
	self.fields.GiveRank:updateRankInfo()
end
return iceGragonCastlePanel
