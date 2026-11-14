local paintedEggCrazyCtrl = SoraDGetCtrl("paintedEggCrazyCtrl")
local eggCarnivalMainView = class("eggCarnivalMainView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("eggCarnivalMainView")
end)
function eggCarnivalMainView:onEnterPanel()
	paintedEggCrazyCtrl:reqPaintedEggCrazyShareInit()
end
function eggCarnivalMainView:ctor(properties)
	self.activityID = gActivityTimeActivityID.PAINTED_EGG_CRAZY_ACTIVITY
	self.nodeEggCarnivalMakeNode = SoraDGetExtendChildFromCCSByName(self, "CCS_eggCarnivalMakeNode", true)
	self.nodeEggCarnivalShareNode = SoraDGetExtendChildFromCCSByName(self, "CCS_eggCarnivalShareNode", true)
	_ENV, self.nodeCommonTabBtn = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_madele"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_madele")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_madele").tabNum = 2
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_madele").defaultClick = "Top_CCS_commonTabBtn_madele", self, 1
	;("Top_CCS_commonTabBtn_madele").title = i18n("easterEgg_title_01")
	;("Top_CCS_commonTabBtn_madele").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn_madele").tag = 1
	_ENV, self[1], ("Top_CCS_commonTabBtn_madele").fontSize = "Top_CCS_commonTabBtn_madele", "Top_CCS_commonTabBtn_madele", 22
	;("Top_CCS_commonTabBtn_madele").title = i18n("easterEgg_title_02")
	;("Top_CCS_commonTabBtn_madele").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn_madele").tag = 2
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_madele").tabsetArray, self[2], ("Top_CCS_commonTabBtn_madele").fontSize = self, "Top_CCS_commonTabBtn_madele", 22
	local param = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_madele")
	self.nodeCommonTabBtn:initView(param)
	self.nodeEggCarnivalShareNode:setTabBtnView(self.nodeCommonTabBtn)
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_madele")
	self.nodeCommonFramTitle:setTitle(i18n("activity_name_9001337"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
end
function eggCarnivalMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_MADELE_GETPOINT", handler(self, self.getReward))
	SoraDAddMessage(self, "MESSAGE_SERVER_MADELE_UPDATE", handler(self, self.update))
end
function eggCarnivalMainView:update(target, data)
	dump(data, "eggCarnivalMainView")
	self:updateRedPoint()
	self.nodeEggCarnivalMakeNode:updateFood()
	self.nodeEggCarnivalShareNode:updataData()
end
function eggCarnivalMainView:getReward(target, data)
	dump(data, "updataData")
	self:updateRedPoint()
	self.nodeEggCarnivalShareNode:updataData()
	if data.reward then
		SoraDMailGainItems(data.reward, true)
	end
end
function eggCarnivalMainView:updateRedPoint()
	local _, mergeNum = paintedEggCrazyCtrl:getMergeNum()
	local _, rewardNum = paintedEggCrazyCtrl:getPointeRewardNum()
	self.nodeCommonTabBtn:setBigRedPointCount(2, rewardNum)
	self.nodeCommonTabBtn:setBigRedPointCount(1, mergeNum)
end
function eggCarnivalMainView:btnTabClick(tag, name)
	if tag == 1 then
		self.nodeEggCarnivalMakeNode:setVisible(true)
		self.nodeEggCarnivalShareNode:setVisible(false)
	elseif tag == 2 then
		self.nodeEggCarnivalMakeNode:setVisible(false)
		self.nodeEggCarnivalShareNode:setVisible(true)
	end
end
function eggCarnivalMainView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = "easterEgg_text_01"
		;("easterEgg_text_01").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("easterEgg_text_01"), "easterEgg_text_01")
	end
end
function eggCarnivalMainView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return eggCarnivalMainView
