local luckyFlopRead = include("luckyFlopRead")
local luckyFlopMainView = class("luckyFlopMainView", function(target)
	return target or SoraDCreateBasePanel("luckyFlopMainView")
end)
function luckyFlopMainView:ctor()
	self.luckyFlopView = SoraDGetExtendChildFromCCSByName(self, "CCS_luckyFlopView")
	self.luckyFlopView:setParentView(self)
	self.luckyFlopRankView = SoraDGetExtendChildFromCCSByName(self, "CCS_luckyFlopRankView")
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnClickHelp))
	self.btnTab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.ccs_title:setTitle(i18n("activity_name_9001203"))
	_ENV = self.ccs_title.setTitle
	self.ccs_title.setTitle.tabNum = 3
	_ENV, _ENV, self.ccs_title.setTitle.defaultClick = i18n("activity_name_9001203")
	i18n("activity_name_9001203").title = i18n("activity_name_9001203")
	i18n("activity_name_9001203").handle = handler(self, self.btnClickTab)
	i18n("activity_name_9001203").fontSize = 22
	_ENV, self.ccs_title[1], i18n("activity_name_9001203").tag = i18n("activity_name_9001203")
	i18n("activity_name_9001203").title = i18n("luckyFlip_title_02")
	i18n("activity_name_9001203").handle = handler(self, self.btnClickTab)
	i18n("activity_name_9001203").fontSize = 22
	_ENV, self.ccs_title[2], i18n("activity_name_9001203").tag = i18n("activity_name_9001203")
	i18n("activity_name_9001203").title = i18n("luckyFlip_title_03")
	i18n("activity_name_9001203").handle = handler(self, self.btnClickTab)
	i18n("activity_name_9001203").fontSize = 22
	self.ccs_title.setTitle.tabsetArray, self.ccs_title[3], i18n("activity_name_9001203").tag = self.ccs_title, i18n("activity_name_9001203")
	local param = self.ccs_title.setTitle
	self.btnTab:initView(param)
end
function luckyFlopMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function luckyFlopMainView:btnClickTab(tag, name)
	self.luckyFlopView:setVisible(tag == 1)
	self.luckyFlopRankView:setVisible(tag ~= 1)
	if 1 < tag then
		self.luckyFlopRankView:initData(tag - 1, self)
	end
end
function luckyFlopMainView:btnClickHelp(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).num = string.formatnumberthousands(luckyFlopRead.getCharmNum())
		SoraDShowHelpMsgTip(i18n("luckyFlip_text_01", nil))
	end
end
function luckyFlopMainView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LUCKY_FLIP_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return luckyFlopMainView
