local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RomanLevelRewardPanel = class("RomanLevelRewardPanel", baseFguiPanel)
function RomanLevelRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RomanLevelRewardPanel:ctor", self.viewName)
end
function RomanLevelRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RomanSoulNew"
	end
	return self._packageList
end
function RomanLevelRewardPanel:onInit()
	if display.width / display.height > 0.7 then
		self.view:setScale(0.9)
	end
	print("=======RomanLevelRewardPanel:onInit")
	_ENV = nil
	;(nil).num = romeActivityCtrl.score
	self.fields.Text_point:setString(i18n("common_text_1492", nil))
end
function RomanLevelRewardPanel:onShow()
	print("=======RomanLevelRewardPanel:onShow")
	self.data = self.proxy.param.itemData
	_ENV = nil
	;(nil).level = self.data.level
	self.fields.Text_title:setString(i18n("common_text_1229", nil))
	self.rewardIndex = self:setDiffEffect()
	self:setDiffEffect()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setNumItems(table.nums(self.data.itemList))
end
function RomanLevelRewardPanel:onItemRenderer(index, object, showIndex)
	object:initData(index + 1, self.data.itemList[index + 1], index + 1 == self.rewardIndex)
end
function RomanLevelRewardPanel:setDiffEffect()
	if gAllianceRomeActivityState.RUNNING ~= romeActivityCtrl.state and gAllianceRomeActivityState.FINISH ~= romeActivityCtrl.state then
		return -1
	end
	if romeActivityCtrl.level ~= self.data.level or romeActivityCtrl.score == 0 then
		return -1
	end
	for i, v in pairs(self.data.itemList) do
		if romeActivityCtrl.score < v.needPoint then
			if i ~= 1 then
				return i - 1
			end
			return -1
		end
	end
	return 5
end
function RomanLevelRewardPanel:checkNeedRemindOnce(activityID)
	local phase = romeActivityCtrl:getActNthPhase()
	romeActivityCtrl = nil
	;(nil).byUID = true
	local lastPhase = SoraDConfigGet("Game:romanChallengeSelectedView:effect~integer", nil) or -1
	if lastPhase == -1 or phase == lastPhase then
		return true
	else
		return false
	end
end
function RomanLevelRewardPanel:onHide()
	print("=======RomanLevelRewardPanel:onHide")
end
function RomanLevelRewardPanel:onDispose()
	print("=======RomanLevelRewardPanel:onDispose")
end
return RomanLevelRewardPanel
