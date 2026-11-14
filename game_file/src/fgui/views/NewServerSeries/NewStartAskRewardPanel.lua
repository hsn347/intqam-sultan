local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewStartAskRewardPanel = class("NewStartAskRewardPanel", baseFguiPanel)
function NewStartAskRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NewStartAskRewardPanel:ctor", self.viewName)
	self.isCanCloseSelf = false
	self.isCantCloseByReturn = true
	self.isAddToPopManager = true
end
function NewStartAskRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NewStartAskRewardPanel:onInit()
	print("=======NewStartAskRewardPanel:onInit")
	self.fields.Text_title:setString(i18n("activity_name_9001404"))
	self.fields.Text_des1:setString(i18n("newstart_opt_tips_0001"))
	self.fields.Text_title2:setString(i18n("common_text_2078"))
	self.fields.Text_des2:setString(i18n("newstart_opt_tips_0002"))
	self.fields.Button_yes:setString(i18n("common_text_4518"))
	self.fields.Button_yes:addClickListener(handler(self, self.onClickBtnYes))
	self.fields.Button_no:setString(i18n("common_text_4519"))
	self.fields.Button_no:addClickListener(handler(self, self.onClickBtnNo))
	local constantRead = include("constantRead")
	local gold = constantRead.getConstValue("NewStart_Ask_Reward")
	self.gold = gold
	self.fields.Text_gold:setString(self.gold)
end
function NewStartAskRewardPanel:onShow()
	print("=======NewStartAskRewardPanel:onShow")
end
function NewStartAskRewardPanel:onClickBtnYes(...)
	SoraDPlaySound()
	newStartMainCtrl:reqGetAskReward(self.gold)
	self:closePanel()
	clientEventMgr.singleClickEvent(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY)
end
function NewStartAskRewardPanel:onClickBtnNo(...)
	SoraDPlaySound()
	newStartMainCtrl:reqGetAskReward(self.gold)
	self:closePanel()
end
return NewStartAskRewardPanel
