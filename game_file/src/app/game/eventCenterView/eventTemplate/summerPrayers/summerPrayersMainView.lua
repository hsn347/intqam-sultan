local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local summerPrayCtrl = SoraDGetCtrl("summerPrayCtrl")
local summerPrayersMainView = class("summerPrayersMainView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("summerPrayersMainView")
end)
_ENV = "summerPrayersMainView"
;("summerPrayersMainView").EXCHANGE = 2
local ("summerPrayersMainView").PRAYERS, VIEW_TYPE = 1, "summerPrayersMainView"
function summerPrayersMainView:ctor(properties)
	SoraDGetChildByName(self, "Image_bg_Size_Tile"):setLocalZOrder(-1)
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("activity_name_9001255"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.nodeSummerPrayersNode = SoraDGetExtendChildFromCCSByName(self, "CCS_summerPrayersNode")
	self.nodeSummerPrayersExchangeNode = SoraDGetExtendChildFromCCSByName(self, "CCS_summerPrayersExchangeNode")
	_ENV, _ENV, self.nodeCommonTabBtn = self, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.title = i18n("lucky_btn_01")
	self.handle = handler(self, self.btnTabClick)
	self.tag = VIEW_TYPE.PRAYERS
	_ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[1], self.fontSize = self, self, 20
	self.title = i18n("common_text_1889")
	self.handle = handler(self, self.btnTabClick)
	self.tag = VIEW_TYPE.EXCHANGE
	self.tableData, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[2], self.fontSize = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), self, 20
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	_ENV = activityShowCtrl
	activityShowCtrl.tabNum = 2
	activityShowCtrl.defaultClick = (activityData.doStage or 0) + 1
	local activityShowCtrl.tabsetArray, param = self.tableData, activityShowCtrl
	self.nodeCommonTabBtn:initView(param)
	self:updataRedPoint()
end
function summerPrayersMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updataRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function summerPrayersMainView:initData(target, data)
end
function summerPrayersMainView:updataRedPoint()
	local retExchange = summerPrayCtrl:getExchangeRed()
	local retLuckyNum = summerPrayCtrl:getPrayRed()
	SoraDPrint(retExchange)
	self.nodeCommonTabBtn:setRedPointState(VIEW_TYPE.EXCHANGE, retExchange)
	self.nodeCommonTabBtn:setRedPointState(VIEW_TYPE.PRAYERS, retLuckyNum)
end
function summerPrayersMainView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = "pray_text_01"
		;("pray_text_01").title = i18n("common_text_1173")
		;("pray_text_01").closeBtn = true
		;("pray_text_01").align = SoraDFIsRA() and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
		SoraDShowHelpMsgTip(i18n("pray_text_01"), "pray_text_01")
	end
end
function summerPrayersMainView:btnTabClick(tag, name)
	self.nodeSummerPrayersNode:setVisible(tag == 1)
	self.nodeSummerPrayersExchangeNode:setVisible(tag == 2)
end
function summerPrayersMainView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return summerPrayersMainView
