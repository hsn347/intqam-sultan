local ramadanAccuRechargeCtrl = SoraDGetCtrl("ramadanAccuRechargeCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanAccuRechargePanel = class("RamadanAccuRechargePanel", baseFguiPanel)
function RamadanAccuRechargePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RamadanAccuRechargePanel:ctor", self.viewName)
end
function RamadanAccuRechargePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DecryptionNew"
	end
	return self._packageList
end
function RamadanAccuRechargePanel:onInit()
	print("=======RamadanAccuRechargePanel:onInit")
	self.fields.Button_detail:fixPos()
	self.functionCol = self:initFunc()
	ramadanAccuRechargeCtrl:sendDataMsg()
	self.fields.com_title:initData(i18n("activity_name_9001400"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self:setActivityTime()
	self.fields.text_tip:setString(i18n("accumulated_text02"))
	self.fields.Button_detail:addClickEventListener(handler(self, self.onDetailClick))
	self.fields.btn_recharge:addClickEventListener(handler(self, self.onRechargelick))
	self.fields.btn_recharge:setTitle(i18n("common_text_623"))
end
function RamadanAccuRechargePanel:initData()
	self.fields.Com_reward:initData()
	_ENV = nil
	;(nil).num = ramadanAccuRechargeCtrl:getCurScore()
	self.fields.Text_curScore:setString(i18n("common_text_2557", nil))
end
function RamadanAccuRechargePanel:refreshData()
	self.fields.Com_reward:refreshData()
	_ENV = nil
	;(nil).num = ramadanAccuRechargeCtrl:getCurScore()
	self.fields.Text_curScore:setString(i18n("common_text_2557", nil))
end
function RamadanAccuRechargePanel:initFunc()
	_ENV = nil
	;(nil).init = function()
		self:initData()
	end
	;(nil).reward = function()
		self:showRewards()
		self:refreshData()
	end
	local (nil).notOpen, functionCol = function()
		SoraDShowMsgTip(i18n("common_text_2486"))
	end, nil
	return functionCol
end
function RamadanAccuRechargePanel:showRewards()
	if not self.rewards then
		return
	end
	local _ENV, t = self.rewards, self.rewards
	for i, v in pairs(self.rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
end
function RamadanAccuRechargePanel:refreshView(data)
	if not data then
		return
	end
	dump(data, "RamadanAccuRechargePanel:refreshView")
	self.rewards = data.reward
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function RamadanAccuRechargePanel:setActivityTime()
	self.fields.Label_time:setUbbOn()
	self.fields.Label_time:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", strTime)
		return str
	end)
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.RAMADAN_ACCUMULATE_RECHARGE)
	if eventTime then
		self.fields.Label_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function RamadanAccuRechargePanel:onRechargelick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
function RamadanAccuRechargePanel:onDetailClick()
	SoraDPlaySound()
	uiManager:show("RamadanAccuDetail"):setOwnerKey(self)
end
function RamadanAccuRechargePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("accumulated_text01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function RamadanAccuRechargePanel:onShow()
	print("=======RamadanAccuRechargePanel:onShow")
end
function RamadanAccuRechargePanel:onHide()
	print("=======RamadanAccuRechargePanel:onHide")
end
function RamadanAccuRechargePanel:onDispose()
	print("=======RamadanAccuRechargePanel:onDispose")
end
return RamadanAccuRechargePanel
