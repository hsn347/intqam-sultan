local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceDinnerCtrl = SoraDGetCtrl("allianceDinnerCtrl")
local AllianceDinnerMainPanel = class("AllianceDinnerMainPanel", baseFguiPanel)
function AllianceDinnerMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AllianceDinnerMainPanel:ctor", self.viewName)
end
function AllianceDinnerMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceDinnerMainPanel:onInit()
	print("=======AllianceDinnerMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.ALLIANCE_DINNER_ACTIVITY
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.button_get:setTitle(i18n("Alliance_dinner_03"))
	self.fields.button_get:addClickEventListener(handler(self, self.onGetClick))
	self.fields.button_quest:setTitle(i18n("Alliance_dinner_02"))
	self.fields.button_quest:addClickEventListener(handler(self, self.onQuestClick))
	self.fields.btn_rank:setTitle(i18n("common_text_851"))
	self.fields.btn_rank:addClickEventListener(handler(self, self.onRankClick))
	for i = 1, 5 do
		self.fields["Button_food_" .. i]:addClickEventListener(handler(self, self.onFoodClick), i)
	end
	local dinnerShowCfgs = allianceDinnerCtrl:getDinnerShowCfg()
	self.fields.Com_item1:initData(dinnerShowCfgs[1].reward[1].id, dinnerShowCfgs[1].reward[1].count)
	self.fields.Com_item2:initData(dinnerShowCfgs[1].reward[2].id, dinnerShowCfgs[1].reward[2].count)
	allianceDinnerCtrl:sendReqInitDataMsg()
end
function AllianceDinnerMainPanel:onShow()
	print("=======AllianceDinnerMainPanel:onShow")
	self:updateView()
end
function AllianceDinnerMainPanel:updateTaskRedDot()
	local show, num = false, 0
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	self.fields.button_quest:setReddot(show, num)
end
function AllianceDinnerMainPanel:updateView()
	local score = allianceDinnerCtrl:getMySocre()
	allianceDinnerCtrl = nil
	;(nil).num = score
	self.fields.curPoint:setTitle(i18n("pet_flip_text_03", nil))
	self.dinnerCfgs = allianceDinnerCtrl:getDinnerCfgs()
	for i, v in ipairs(self.dinnerCfgs) do
		local dinnerData = allianceDinnerCtrl:getDinnerData(v.index)
		self.fields["Button_food_" .. i]:setTitle(dinnerData.mergeCount)
	end
	self:updateTaskRedDot()
end
function AllianceDinnerMainPanel:onGetClick()
	SoraDPlaySound()
	uiManager:show("AllianceDinnerGetWay")
end
function AllianceDinnerMainPanel:onQuestClick()
	SoraDPlaySound()
	uiManager:show("AllianceDinnerTask"):setOwnerKey(self)
end
function AllianceDinnerMainPanel:onRankClick()
	SoraDPlaySound()
	uiManager:show("AllianceDinnerRank"):setOwnerKey(self)
end
function AllianceDinnerMainPanel:onFoodClick(sender, param)
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = param
	uiManager:show("AllianceDinnerDonate", nil):setOwnerKey(self)
end
function AllianceDinnerMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Alliance_dinner_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return AllianceDinnerMainPanel
