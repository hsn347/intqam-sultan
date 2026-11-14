local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewYearTopupPanel = class("NewYearTopupPanel", baseFguiPanel)
local cumulativeRecharge2021Read = include("cumulativeRecharge2021Read")
local cumulativeRecharge2021Ctrl = SoraDGetCtrl("cumulativeRecharge2021Ctrl")
function NewYearTopupPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NewYearTopupPanel:ctor", self.viewName)
end
function NewYearTopupPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function NewYearTopupPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======NewYearTopupPanel:onInit")
	self.fields.com_title:initData(i18n("activity_name_9001383"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.text_mail_tip:setString(i18n("newYearRecharge_002"))
	self.fields.btn_daily:addClickEventListener(handler(self, self.onDailyRewardClick))
	self.fields.btn_recharge:addClickEventListener(handler(self, self.onRechargelick))
	self.fields.btn_recharge:setTitle(i18n("activity_btn_9001075_ROS"))
end
function NewYearTopupPanel:onShow()
	print("=======NewYearTopupPanel:onShow")
	self.fields.label_timer:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4415", nil, nil)
	end)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CUMULATIVE_RECHARGE_2021)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.fields.label_timer:beginTime(leftTime)
		else
			self:close()
		end
	end
	self:updateView()
end
function NewYearTopupPanel:onHide()
	print("=======NewYearTopupPanel:onHide")
end
function NewYearTopupPanel:onDispose()
	print("=======NewYearTopupPanel:onDispose")
end
function NewYearTopupPanel:updateView()
	self.rechargeList = cumulativeRecharge2021Read.getRechargeList()
	local isCanGetReward = cumulativeRecharge2021Ctrl:getIsCanGetReward()
	self.fields.btn_daily:setIcon(isCanGetReward and "icon_xncz_libao1.png" or "icon_xncz_libao2.png")
	table.sort(self.rechargeList, function(a, b)
		local left = cumulativeRecharge2021Ctrl:getIsComplete(a.time) and 99 or 1
		local right = cumulativeRecharge2021Ctrl:getIsComplete(b.time) and 99 or 1
		if left == right then
			return a.time < b.time
		end
		return left < right
	end)
	self.fields.scroll:setNumItems(#self.rechargeList)
	self.fields.scroll:runAction(ffa.seq(ffa.delay(0.1), ffa.callFunc(function()
		self.fields.scroll:setNumItems(#self.rechargeList)
	end)))
	self.fields.btn_daily:setEnabled(isCanGetReward)
	self.fields.Label_reddot:setVisible(isCanGetReward)
end
function NewYearTopupPanel:onItemRenderer(index, obj)
	local rechargeCfg = self.rechargeList[index + 1]
	local isComplete = cumulativeRecharge2021Ctrl:getIsComplete(rechargeCfg.time)
	local isToday = index == 0 and not cumulativeRecharge2021Ctrl:getIsTodayComplete() and cumulativeRecharge2021Ctrl:getCompleteCount() ~= #self.rechargeList or cumulativeRecharge2021Ctrl:getIsTodayComplete(rechargeCfg.time) or index == #self.rechargeList - 1 and cumulativeRecharge2021Ctrl:getCompleteCount() == #self.rechargeList
	local price = not (not (index == 0 and isToday) or cumulativeRecharge2021Ctrl:getIsTodayComplete()) and cumulativeRecharge2021Ctrl:getPrice() or isComplete and rechargeCfg.quantity or 0
	obj:initData(rechargeCfg, isComplete, price, isToday)
end
function NewYearTopupPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("newYearRecharge_007")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function NewYearTopupPanel:onDailyRewardClick()
	SoraDPlaySound()
	cumulativeRecharge2021Ctrl:reqGetReward()
end
function NewYearTopupPanel:onRechargelick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
return NewYearTopupPanel
