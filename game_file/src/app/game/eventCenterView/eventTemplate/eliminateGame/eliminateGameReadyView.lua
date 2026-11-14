local publicRead = include("publicRead")
local eliminateGameCommon = include("eliminateGameCommon")
local EliminateGameReadyView = class("eliminateGameReadyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eliminateGameReadyView")
	end
	return target
end)
function EliminateGameReadyView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eliminate")
	self.ccs_bg:setTitle(i18n("activityname_15"))
	self.ccs_bg:setBtnHelpClickCallBack(handler(self, self.btnRuleClick))
	self.txtTime = SoraDGetChildByName(self, "Text_eventTime")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.btnStart = SoraDGetChildByName(self, "Button_start")
	self.txtDes = SoraDGetChildByName(self, "Text_des")
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.Text_4 = SoraDGetChildByName(self, "Text_4")
	self.Node_rewards = SoraDGetChildByName(self, "Node_rewards")
	self.Text_4:setString(i18n("common_text_609"))
	self.btnStart:setTitleText(i18n("common_text_2849"))
	self.txtDes:setString(i18n("common_text_2853"))
	_ENV = i18n("common_text_2853")
	i18n("common_text_2853").num = string.formatnumberthousands(50000)
	self.txtTip:setString(i18n("common_text_2854", i18n("common_text_2853")))
	self.btnStart:addTouchEventListener(handler(self, self.btnStartClick))
	self:fitDevice()
	self:initData()
end
function EliminateGameReadyView:fitDevice(...)
	self.Top_Image_1 = SoraDGetChildByName(self, "Top_Image_1")
	local iSize = self.Top_Image_1:getContentSize()
	if display.height > iSize.height then
		self.Top_Image_1:setContentSize(cc.size(iSize.width, display.height))
	end
end
function EliminateGameReadyView:initData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.SIEGE_COMBAT)
	self.leftTime = timer and timer.timerNode.timer:getRemainTime() or 0
	self:initView()
end
function EliminateGameReadyView:initView(...)
	local price = eliminateGameCommon.getRewardPrice()[1].Items
	local itemList = SoraDIntArr2FormatTable(price)
	local maxCount = 5
	local iSize = cc.size(100, 100)
	for i, v in ipairs(itemList) do
		local item = SoraDCreatePanel("commonItemAward")
		item:addTo(self.Node_rewards)
		local row = (i - 1) % maxCount + 1
		local col = math.ceil(i / maxCount)
		item:setPosition(iSize.width * SoraDFSign(3 - row), 20 - iSize.height * col)
		item:setScale(0.88)
		item:setOwnView(self)
		item:initData(v.id, v.num)
	end
	self.txtTime:beginTime(self.leftTime)
end
function EliminateGameReadyView:btnStartClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		include("eliminateGameCommon").enterGame()
	end
end
function EliminateGameReadyView:btnRuleClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "activityname_15"
		;("activityname_15")[1] = i18n("common_text_2852")
		;("activityname_15")[2] = i18n("common_text_2852")
		SoraDShowFixWindow(i18n("activityname_15"), "activityname_15")
	end
end
return EliminateGameReadyView
