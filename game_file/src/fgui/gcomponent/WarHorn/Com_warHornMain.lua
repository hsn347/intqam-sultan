local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local warHornCtrl = SoraDGetCtrl("warHornCtrl")
local warOrderRead = include("warOrderRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_warHornMain = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarHorn/Com_warHornMain", Com_warHornMain)
function Com_warHornMain:onInit()
	self.lvRewardList, _ENV, self.activityID = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581, gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581, gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581
	self.fields.Text_advance:setString(i18n("Braque_text_05"))
	self.fields.Text_middle:setString(i18n("Braque_text_04"))
	self.fields.Text_normal:setString(i18n("Braque_text_03"))
	self.fields.Text_level:setString(i18n("common_text_748"))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.List_Award:setItemRenderer(handler(self, self.onItemAwardRederer))
	self.fields.Button_extraMid:setString(i18n("activity_9001581_text_02"))
	self.fields.Button_extraMid:addClickListener(handler(self, self.onClickMid))
	self.fields.Button_extraAdv:setString(i18n("activity_9001581_text_03"))
	self.fields.Button_extraAdv:addClickListener(handler(self, self.onClickAdv))
	self.fields.nbg:fix()
	self.fields.Text_advance:fixPos()
	self.fields.Text_middle:fixPos()
	self.fields.Text_normal:fixPos()
	self.fields.Text_level:fixPos()
	if not SoraDFIsRA() then
		self.fields.n1:setPositionX(161)
		self.fields.n2:setPositionX(302)
		self.fields.n3:setPositionX(445)
	end
	self.fields.Touch_lock_mid:fixPos()
	self.fields.Touch_lock_adv:fixPos()
	self.fields.Button_extraMid:fixPos()
	self.fields.Button_extraAdv:fixPos()
end
function Com_warHornMain:onItemAwardRederer(index, obj)
	obj:initData(self.lvRewardList[index + 1], index, self.curLv)
end
function Com_warHornMain:onShow()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function Com_warHornMain:initData()
	self.curLv = warHornCtrl:getLevel()
	self.lvRewardList = warOrderRead.getLvAwardList(self.activityID, warHornCtrl:getGroupIndex())
	self.fields.List_Award:setNumItems(#self.lvRewardList)
	self.fields.List_Award:scrollToView(math.min(#self.lvRewardList - 1, math.max(0, self.curLv - 1)))
	local isUnlockMid = warHornCtrl:isRewardUnlock(2)
	self.fields.Button_extraMid:setVisible(not isUnlockMid)
	self.fields.Touch_lock_mid:setVisible(not isUnlockMid)
	local isUnlockAdv = warHornCtrl:isRewardUnlock(3)
	self.fields.Button_extraAdv:setVisible(not isUnlockAdv)
	self.fields.Touch_lock_adv:setVisible(not isUnlockAdv)
end
function Com_warHornMain:onClickMid()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).type = 1
	uiManager:show("WarHornBuyGift", nil)
end
function Com_warHornMain:onClickAdv()
	SoraDPlaySound()
	local isUnlockMid = warHornCtrl:isRewardUnlock(2)
	if isUnlockMid then
		_ENV = nil
		;(nil).activityID = self.activityID
		;(nil).type = 2
		uiManager:show("WarHornBuyGift", nil)
	else
		_ENV = nil
		;(nil).name = i18n("common_text_4798")
		SoraDShowMsgTip(i18n("star_treasury_6", nil))
	end
end
return Com_warHornMain
