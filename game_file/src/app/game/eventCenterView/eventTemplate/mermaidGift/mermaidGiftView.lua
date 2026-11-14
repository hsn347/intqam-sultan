local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local mermaidGiftCtrl = SoraDGetCtrl("mermaidGiftCtrl")
local mermaidGiftRead = include("mermaidGiftRead")
local mermaidGiftView = class("mermaidGiftView", function(target)
	return target or SoraDCreateBasePanel("mermaidGiftView")
end)
function mermaidGiftView:ctor()
	self:setContentSize(cc.size(640, 960))
	SoraDDeviceFitOffset(self)
	self.singleLight, _ENV = SoraDDeviceFitOffset, SoraDDeviceFitOffset
	self.activityID = gActivityTimeActivityID.MERMAID_GIFT_ACTIVITY
	self.scrollView = SoraDGetChildByName(self, "ScrollView")
	if 960 >= display.height then
		self.Image_2 = SoraDGetChildByName(self, "Image_2")
		local image3 = self.Image_2:clone()
		image3:clone():addTo(self.Image_2:getParent(), -1)
		image3:setOpacity(204.0)
	end
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.btnFlopOne = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_One")
	self.btnFlopTen = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_Ten")
	self.btnLog = SoraDGetChildByName(self, "Button_record")
	self.recordTitle = SoraDGetChildByName(self, "Text_recordTitle")
	self.rewardPvTitle = SoraDGetChildByName(self, "Text_rewardPvTitle")
	self.btnAward = SoraDGetChildByName(self, "Button_reward_pv")
	self.btnPointExlpain = SoraDGetChildByName(self.nodeBottom, "Button_PointExplain")
	self.nodePoint = SoraDGetChildByName(self, "Node_Num")
	self.btnAddPoint = SoraDGetChildByName(self.nodePoint, "Button_Add")
	self.textNum = SoraDGetChildByName(self.nodePoint, "Text_NumHave")
	self.textNum = SoraDChangeTextToHtml(self.textNum)
	self.textLogTip = SoraDGetChildByName(self.nodeBottom, "Text_Tip_Log")
	self.textGiftNum = SoraDGetChildByName(self, "Text_gift_num")
	self.textGiftNum:setColor(cc.c3b(255, 255, 255))
	self.textGiftNum:enableShadow(cc.c3b(0, 0, 0), cc.size(1, -1))
	self.textLoveTitle = SoraDGetChildByName(self, "Text_LoveTitle")
	self.textLoveTitle:setString(i18n("Mermaid_title_05"))
	self.textluckyNum = SoraDGetChildByName(self, "Text_lucky_num")
	self.textluckyNum:setColor(cc.c3b(255, 255, 255))
	self.textluckyNum:enableShadow(cc.c3b(0, 0, 0), cc.size(1, -1))
	self.textluckyTitle = SoraDGetChildByName(self, "Text_luckyTitle")
	self.textluckyTitle:setString(i18n("Mermaid_title_06"))
	self.activityTime = SoraDGetChildByName(self.nodeTop, "Text_LeftTime")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.textMainTip = SoraDGetChildByName(self, "Text_1")
	self.textMainTip:setString(i18n("Mermaid_text_24"))
	self.buttonLuckyNum = SoraDGetChildByName(self, "Button_lucky_num")
	self.buttonGiftNum = SoraDGetChildByName(self, "Button_gift_num")
	self.btnFlopOne:setTag(1)
	_ENV = 1
	_ENV = i18n("Mermaid_text_24")
	i18n("Mermaid_text_24").num = 1
	;(1).title = i18n("Mermaid_title_04", i18n("Mermaid_text_24"))
	;(1).gold = 1 * mermaidGiftCtrl:getFlipNum()
	;(1).icon = "icon_mermaid_changeNum.png"
	self.btnFlopOne:initData(1, 1)
	self.btnFlopOne:setTitleSize(cc.size(210, 21))
	self.btnFlopOne:addTouchEventListener(handler(self, self.btnClickFlop))
	self.btnFlopTen:setTag(10)
	self.btnFlopTen:setColor(gBtnColorDef.YELLOW)
	_ENV = gBtnColorDef.YELLOW
	_ENV = handler(self, self.btnClickFlop)
	handler(self, self.btnClickFlop).num = 10
	gBtnColorDef.YELLOW.title = i18n("Mermaid_title_04", handler(self, self.btnClickFlop))
	gBtnColorDef.YELLOW.gold = 10 * mermaidGiftCtrl:getFlipNum()
	gBtnColorDef.YELLOW.icon = "icon_mermaid_changeNum.png"
	self.btnFlopTen:initData(gBtnColorDef.YELLOW, 1)
	self.btnFlopTen:setTitleSize(cc.size(210, 21))
	self.btnFlopTen:addTouchEventListener(handler(self, self.btnClickFlop))
	self.btnPointExlpain:addTouchEventListener(handler(self, self.btnClickPointExlpain))
	self.btnAddPoint:addTouchEventListener(handler(self, self.btnClickAddPoint))
	self.btnLog:addTouchEventListener(handler(self, self.btnClickOpenLog))
	self.buttonLuckyNum:addTouchEventListener(handler(self, self.btnClickLucky))
	self.buttonGiftNum:addTouchEventListener(handler(self, self.btnClickGift))
	self.textLogTip:setString(i18n("Mermaid_text_12"))
	self.rewardPvTitle:setString(i18n("decrypt_text_03"))
	self.recordTitle:setString(i18n("Mermaid_title_16"))
	SoraDAutoSizeButtonText(self.btnLog, cc.size(115, 35))
	SoraDAutoSizeButtonText(self.btnAward, cc.size(115, 35))
	self.btnAward:addTouchEventListener(handler(self, self.btnClickOpenPreAward))
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.activityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	if activityData and activityData.param and activityData.param.kids then
		self.textArea = SoraDGetChildByName(self, "Text_area")
		local areaStr = ""
		local lastKid
		for k, v in pairs(activityData.param.kids) do
			if not lastKid or lastKid == v - 1 then
				lastKid = v
			end
			if areaStr == "" then
				areaStr = areaStr .. v
			end
			if lastKid ~= v then
				areaStr = areaStr .. "-" .. lastKid .. "," .. v
				lastKid = nil
			end
		end
		if lastKid ~= nil and #activityData.param.kids ~= 1 then
			areaStr = areaStr .. "-" .. lastKid
		end
		_ENV = self.eventTime.timerNode.timer:getRemainTime()
		self.eventTime.timerNode.timer:getRemainTime().num = areaStr
		self.textArea:setString(i18n("Mermaid_text_02", self.eventTime.timerNode.timer:getRemainTime()))
	end
	SoraDShowLoading(self)
	mermaidGiftCtrl:reqMermaidGiftInit()
	self.bgSp = cc.criSprite.createCriSprite("sp_rydkz_003.usm", false, true, true)
	self.bgSp:setPosition(display.width / 2, display.height / 2)
	self.bgSp:addTo(self, -1)
	self.bgSp:setPreviewImage("#dh_Tex_rydkz_001.png", cc.size(640, 1386), true, true)
	self.buttonLuckyNum:setCascadeOpacityEnabled(false)
	local effect_normal = SoraDCreatAnimation("Node_Effect_rydkz02", nil, true)
	effect_normal:setPosition(cc.p(self.buttonLuckyNum:getContentSize().width / 2, self.buttonLuckyNum:getContentSize().height / 2))
	effect_normal:addTo(self.buttonLuckyNum)
	effect_normal:setLocalZOrder(-1)
	self.buttonGiftNum:setCascadeOpacityEnabled(false)
	local effect_normal = SoraDCreatAnimation("Node_Effect_rydkz02", nil, true)
	effect_normal:setPosition(cc.p(self.buttonGiftNum:getContentSize().width / 2, self.buttonGiftNum:getContentSize().height / 2))
	effect_normal:addTo(self.buttonGiftNum)
	effect_normal:setLocalZOrder(-1)
end
function mermaidGiftView:setParentView(parent)
	self.parentView = parent
end
function mermaidGiftView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.updataInfoData))
	SoraDAddMessage(self, "MESSAGE_MERMAID_GIFT_SWAP", handler(self, self.onGiftSwap))
	SoraDAddMessage(self, "MESSAGE_MERMAID_GIFT_REFRESH_SUCCESS", handler(self, self.updataData))
	SoraDAddMessage(self, "MESSAGE_MERMAID_GIFT_REWARD_CLOSE", function()
		self.bgSp:pause(false)
	end)
end
function mermaidGiftView:updataInfoData(target, data)
	if data.activityID == self.activityID then
		SoraDCloseLoading(self)
		mermaidGiftCtrl:initClientData(data.initData)
		self:updataData()
	end
end
function mermaidGiftView:updataData()
	self.score = mermaidGiftCtrl:getScore() or 0
	mermaidGiftCtrl = nil
	mermaidGiftCtrl, mermaidGiftCtrl, (nil).num = self.score, string.formatnumberthousands(self.score), string.formatnumberthousands(self.score)
	string.formatnumberthousands(self.score).num, self.score.color = self.score, "#FFCC00"
	local str = i18n_html("Mermaid_text_13", nil, (string.formatnumberthousands(self.score)))
	self.textNum:setString(str)
	self.btnFlopOne:setTextGoldColor(mermaidGiftCtrl:isScoreEnough(self.score, 1) and COLOR3.YELLOW or display.COLOR_RED)
	self.btnFlopTen:setTextGoldColor(mermaidGiftCtrl:isScoreEnough(self.score, 10) and COLOR3.YELLOW or display.COLOR_RED)
	self.textGiftNum:setString(string.formatnumberthousands(mermaidGiftCtrl:getPresentVal()))
	self.textluckyNum:setString(mermaidGiftCtrl:getLuckyNum())
	SoraDToCenter(self.nodePoint, 0, SoraDFIsRA())
	self:setButtonTitleColor(self.btnFlopTen)
	self:setButtonTitleColor(self.btnFlopOne)
end
function mermaidGiftView:onGiftSwap(target, data)
	local result = data.result
	local view = SoraDCreatePanel("mermaidGiftRewardView")
	view:initData(result)
	view:show()
	self.bgSp:pause(true)
	self:updataData()
end
function mermaidGiftView:setButtonTitleColor(target)
	if mermaidGiftCtrl:isScoreEnough(self.score or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end
function mermaidGiftView:btnClickFlop(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local flopTimes = button:getTag()
		if mermaidGiftCtrl:isScoreEnough(self.score, flopTimes) then
			mermaidGiftCtrl:reqMermaidGiftSwap(tonumber(flopTimes) == 10)
		else
			SoraDShowMsgTip(i18n("Mermaid_text_14"))
		end
	end
end
function mermaidGiftView:btnClickAddPoint(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function mermaidGiftView:btnClickPointExlpain(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("mermaidGiftPointExplain"):show()
	end
end
function mermaidGiftView:btnClickOpenLog(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("mermaidGiftpLogView")
		panel:show()
	end
end
function mermaidGiftView:btnClickOpenPreAward(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("mermaidGiftPreAwardView")
		panel:show()
	end
end
function mermaidGiftView:btnClickLucky(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("Mermaid_text_11"))
	end
end
function mermaidGiftView:btnClickGift(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("Mermaid_text_23"))
	end
end
return mermaidGiftView
