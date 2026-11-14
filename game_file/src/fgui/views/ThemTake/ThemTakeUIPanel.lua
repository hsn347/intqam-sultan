local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local loudlyDressedCtrl = SoraDGetCtrl("loudlyDressedCtrl")
local loudlyDressRead = include("loudlyDressRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ThemTakeUIPanel = class("ThemTakeUIPanel", baseFguiPanel)
function ThemTakeUIPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ThemTakeUIPanel:ctor", self.viewName)
end
function ThemTakeUIPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ThemTakeUIPanel:onInit()
	print("=======ThemTakeUIPanel:onInit")
	self.activityID = gActivityTimeActivityID.LOUDLY_DRESSED_ACTIVITY
	self.isFromMsg = false
	self.fields.Com_title:initData(i18n("activity_name_9001425"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_recharge:setString(i18n("activity_btn_9001075_ROS"))
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 1 or 0)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_dress:setItemRenderer(handler(self, self.onDressRenderer))
	self.fields.Button_recharge:addClickListener(handler(self, self.onBtnClick))
	self.fields.Button_box:addClickListener(handler(self, self.onBtnBoxClick))
	self.fields.Button_pre:addClickListener(handler(self, self.onBtnPreClick))
	self.fields.Button_pre:setString(i18n("decrypt_text_03"))
	self.fields.Usm_3:setVisible(false)
	self.fields.Text_des:setAlign(0)
end
function ThemTakeUIPanel:onItemRenderer(index, obj)
	local item = self.curDayCfg[index + 1]
	obj:initData(item.id, item.count)
end
function ThemTakeUIPanel:onDressRenderer(index, obj)
	obj:initData(index + 1, self.isFromMsg)
end
function ThemTakeUIPanel:onShow()
	print("=======ThemTakeUIPanel:onShow")
	self.curDay = loudlyDressedCtrl:getCurDay()
	self.cumuDay = loudlyDressRead.getCfgNum()
	_ENV = nil
	_ENV = nil
	;(nil).num = self.cumuDay
	;(nil).num = fguiHelper.getColorString("#0033B5", i18n("Loudlydressed_text_09", nil))
	self.fields.Text_des:setString(i18n("Loudlydressed_text_08", nil))
	local timeInfo = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timeInfo then
		local leftTime = timeInfo.timerNode.timer:getRemainTime()
		self.fields.Label_time:setTimeLast(function(timeStr)
			return fguiHelper.getColorString("#F7C974", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", timeStr)
		end)
		self.fields.Label_time:beginTime(leftTime)
	end
	self:initData()
end
function ThemTakeUIPanel:initData(isFromMsg)
	self.isFromMsg = isFromMsg
	self.curDay = loudlyDressedCtrl:getCurDay()
	self.rechargeCount = loudlyDressedCtrl:getRechargeRecordCount()
	loudlyDressedCtrl = nil
	;(nil).var1 = self.rechargeCount
	;(nil).var2 = self.cumuDay
	self.fields.Text_progress:setString(i18n("[%{var1}/%{var2}]", nil))
	local isReward = loudlyDressedCtrl:isRewarded(self.curDay)
	if self.rechargeCount >= self.cumuDay then
		self.fields.Text_tip:setString(i18n("Loudlydressed_text_11"))
		self.fields.Button_recharge:setVisible(false)
	else
		self.fields.Text_tip:setString(isReward and i18n("Loudlydressed_text_02") or i18n("Loudlydressed_text_01"))
		self.fields.Button_recharge:setVisible(not isReward)
	end
	self.curDayCfg = loudlyDressRead.getRewardByTimes(isReward and self.rechargeCount or self.rechargeCount + 1)
	self.fields.List_reward:setNumItems(#self.curDayCfg)
	self.isCumuReward = loudlyDressedCtrl:isCumuRewarded(self.cumuDay)
	if self.rechargeCount >= self.cumuDay and not self.isCumuReward and self.isFromMsg then
		self:playMergeAct()
	else
		self:setRewardBox()
	end
	self.fields.List_dress:setNumItems(self.cumuDay)
end
function ThemTakeUIPanel:setRewardBox()
	self.controllers.c2:setSelectedIndex(self.rechargeCount < self.cumuDay and 0 or 1)
	self.fields.icon_box:setSpriteFrame(self.isCumuReward and "icon_LoudlyDressed_bx02.png" or "icon_LoudlyDressed_bx.png")
	self.fields.Usm_2:setVisible(self.rechargeCount >= self.cumuDay and not self.isCumuReward)
	local ret, num = loudlyDressedCtrl:getReceiveStatusAndNum()
	self.fields.Label_reddot:initData(ret, num)
end
function ThemTakeUIPanel:playMergeAct()
	self.fields.Usm_3:setCompleteCallback(function()
		self:setRewardBox()
		self.fields.Usm_3:setVisible(false)
	end)
	self.fields.Usm_3:setVisible(true)
	self.fields.Usm_3:play(false)
	self.fields.List_dress:setVisible(false)
	self.fields.n11:setVisible(false)
	self.fields.Text_progress:setVisible(false)
end
function ThemTakeUIPanel:onBtnClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
function ThemTakeUIPanel:onBtnBoxClick()
	SoraDPlaySound()
	if not self.isCumuReward then
		local index, reward = loudlyDressRead.getCumuReward()
		loudlyDressedCtrl:sendClaim(index)
	end
end
function ThemTakeUIPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Loudlydressed_text_10")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ThemTakeUIPanel:onBtnPreClick()
	SoraDPlaySound()
	uiManager:show("Rewardpreview")
end
return ThemTakeUIPanel
