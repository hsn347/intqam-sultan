local activity_9001706_Ctrl = SoraDGetCtrl("activity_9001706_Ctrl")
local constantRead = include("constantRead")
local activity_9001706_Read = include("activity_9001706_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_pay = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001706/Com_pay", Com_pay)
function Com_pay:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_go:setString(i18n("Sultan_present_text_18"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Text_got:setString(i18n("common_text_1892"))
	self.fields.lock:setVisible(false)
	self.fields.done:setVisible(false)
	self.fields.Label_time:setTimeEndListener(function()
		self:setStatus()
	end)
	self:fixChildrenPos()
end
function Com_pay:onItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
	obj:setStatus(self.isClaimed and 3 or 2)
end
function Com_pay:onShow()
end
function Com_pay:setStatus()
	local doStage = activity_9001706_Ctrl:getDoStage()
	local peopleNum = activity_9001706_Ctrl:getPeopleNumber()
	if doStage == 0 then
		self.fields.title:setString(i18n("Sultan_present_text_16"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.lock:setVisible(false)
		self.fields.done:setVisible(false)
	else
		self.fields.title:setString(i18n("Sultan_present_text_12"))
		local day, isInPay = activity_9001706_Ctrl:getCurDay()
		local month = activity_9001706_Ctrl:getCurMonth()
		local isUnlock = activity_9001706_Ctrl:isPaySerUnlock(month)
		self.isClaimed = activity_9001706_Ctrl:isClaimedSerPayReward(month)
		local beginTime = activity_9001706_Ctrl:getActivityStageTime()
		local isBeginMonth = activity_9001706_Ctrl:isBeginMonth()
		local realIndex = activity_9001706_Read.getServerIndex(peopleNum, true)
		if isBeginMonth or realIndex <= 0 then
			self.controllers.c1:setSelectedIndex(1)
			self.fields.lock:setVisible(false)
			self.fields.done:setVisible(false)
		elseif isInPay then
			self.controllers.c1:setSelectedIndex(0)
			self.fields.lock:setVisible(not isUnlock)
			self.fields.done:setVisible(isUnlock)
			self.fields.Label_time:setVisible(not isUnlock)
			if not isUnlock then
				activity_9001706_Read = not isUnlock
				;(not isUnlock)[1] = 1
				;(not isUnlock)[2] = 7
				local cfgDays = constantRead.getConstValueArray("SULTAN_PRESENT_REWARD_TIME", not isUnlock)
				local leftTime = serviceFunctions.getNextMonthDayTime(beginTime, month - 1, cfgDays[2] + 1)
				if 0 < leftTime then
					self.fields.Label_time:beginTime(leftTime)
				end
			end
			self.fields.Button_go:setVisible(true)
		else
			self.controllers.c1:setSelectedIndex(self.isClaimed and 2 or 0)
			self.fields.lock:setVisible(not isUnlock)
			self.fields.done:setVisible(isUnlock)
			self.fields.Label_time:setVisible(false)
			self.fields.Button_go:setVisible(false)
		end
	end
end
function Com_pay:initData(cfg)
	self.cfg = cfg
	self.isClaimed = false
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(cfg.paidReward, nil)
	self:setStatus()
	self.fields.List:setNumItems(#self.rewardList)
end
function Com_pay:btnGoClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
return Com_pay
