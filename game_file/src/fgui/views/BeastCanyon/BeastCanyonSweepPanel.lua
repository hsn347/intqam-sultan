local beastCanyonRead = include("beastCanyonRead")
local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BeastCanyonSweepPanel = class("BeastCanyonSweepPanel", baseFguiPanel)
function BeastCanyonSweepPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BeastCanyonSweepPanel:ctor", self.viewName)
end
function BeastCanyonSweepPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BeastCanyonSweepPanel:onInit()
	print("=======BeastCanyonSweepPanel:onInit")
	self.sweepNum = 1
	self.bossType = self.proxy.param.bossType
	self.activityID = self.proxy.param.activityID or gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
	beastCanyonCtrl = self.activityID
	self.activityID[1] = "id"
	self.activityID[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(beastCanyonRead.getBossConfigByBossType(self.activityID, self.bossType).sweepingShow, self.activityID)
	self.fields.Panel_bg:setString(i18n("epicbattle_btn_01"))
	self.fields.Text_Reward:setString(i18n("soldier_rush_text_11"))
	self.fields.Button_Sweep:addClickEventListener(handler(self, self.onClickSweep))
	self.fields.Text_Tip1:setString(i18n("Divinebeastcanyon_text_21"))
	self.maxDamage = beastCanyonCtrl:getTodayMaxLoseLife(self.activityID, self.bossType)
	self.fields.Text_Damage:setString(string.formatnumberthousands(self.maxDamage))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	_ENV = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).maxValue = beastCanyonCtrl:getChallengeTimes(self.activityID)
	handler(self, self.onItemRederer).minValue = 1
	handler(self, self.onItemRederer).curValue = 1
	self.fields.Com_Slider:initData(handler(self, self.onItemRederer))
	self.fields.Com_Slider:setSliderCallBack(handler(self, self.changeHandle))
end
function BeastCanyonSweepPanel:onShow()
	print("=======BeastCanyonSweepPanel:onShow")
	self:updateView()
end
function BeastCanyonSweepPanel:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count * self.sweepNum)
end
function BeastCanyonSweepPanel:updateView()
	local num, _ = beastCanyonRead.getBoxNumAndNextNum(self.activityID, self.bossType, self.maxDamage)
	beastCanyonRead = nil
	;(nil).num = num * self.sweepNum
	self.fields.Text_Tip2:setString(i18n("Divinebeastcanyon_text_22", nil))
	self.fields.List:setNumItems(#self.rewardList)
	beastCanyonRead = i18n("Divinebeastcanyon_text_22", nil)
	i18n("Divinebeastcanyon_text_22", nil).num = self.sweepNum
	self.fields.Button_Sweep:setString(i18n("Divinebeastcanyon_text_44", i18n("Divinebeastcanyon_text_22", nil)))
end
function BeastCanyonSweepPanel:onClickSweep()
	SoraDPlaySound()
	if beastCanyonCtrl:getChallengeTimes(self.activityID) >= self.sweepNum then
		beastCanyonCtrl:reqDivineBeastCanyonSweep(self.activityID, self.bossType, self.sweepNum)
		self:close()
	end
end
function BeastCanyonSweepPanel:changeHandle(count)
	self.sweepNum = count
	self:updateView()
end
return BeastCanyonSweepPanel
