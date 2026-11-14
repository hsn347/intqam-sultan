local mermaidGiftCtrl = SoraDGetCtrl("mermaidGiftCtrl")
local constantRead = include("constantRead")
local mermaidGiftMainView = class("mermaidGiftMainView", function(target)
	return target or SoraDCreateBasePanel("mermaidGiftMainView")
end)
function mermaidGiftMainView:ctor()
	self.mermaidGiftView = SoraDGetExtendChildFromCCSByName(self, "CCS_mermaidGiftView")
	self.mermaidGiftView:setParentView(self)
	self.mermaidGiftRankView = SoraDGetExtendChildFromCCSByName(self, "CCS_mermaidGiftRankView")
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnClickHelp))
	self.btnTab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.ccs_title:setTitle(i18n("activity_name_9001357"))
	_ENV = self.ccs_title.setTitle
	self.ccs_title.setTitle.tabNum = 3
	_ENV, _ENV, self.ccs_title.setTitle.defaultClick = i18n("activity_name_9001357")
	i18n("activity_name_9001357").title = i18n("activity_name_9001357")
	i18n("activity_name_9001357").handle = handler(self, self.btnClickTab)
	i18n("activity_name_9001357").fontSize = 22
	_ENV, self.ccs_title[1], i18n("activity_name_9001357").tag = i18n("activity_name_9001357")
	i18n("activity_name_9001357").title = i18n("Mermaid_title_01")
	i18n("activity_name_9001357").handle = handler(self, self.btnClickTab)
	i18n("activity_name_9001357").fontSize = 22
	_ENV, self.ccs_title[2], i18n("activity_name_9001357").tag = i18n("activity_name_9001357")
	i18n("activity_name_9001357").title = i18n("Mermaid_title_02")
	i18n("activity_name_9001357").handle = handler(self, self.btnClickTab)
	i18n("activity_name_9001357").fontSize = 22
	self.ccs_title.setTitle.tabsetArray, self.ccs_title[3], i18n("activity_name_9001357").tag = self.ccs_title, i18n("activity_name_9001357")
	local param = self.ccs_title.setTitle
	self.btnTab:initView(param)
end
function mermaidGiftMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function mermaidGiftMainView:btnClickTab(tag, name)
	self.mermaidGiftView:setVisible(tag == 1)
	self.mermaidGiftRankView:setVisible(tag ~= 1)
	if 1 < tag then
		self.mermaidGiftRankView:initData(tag - 1, self)
	end
end
function mermaidGiftMainView:btnClickHelp(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local numberLimit = string.formatnumberthousands(constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000))
		_ENV = constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000)
		constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000).num1 = string.formatnumberthousands(mermaidGiftCtrl:getGiftCharNum())
		constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000).num2 = numberLimit
		SoraDShowHelpMsgTip(i18n("Mermaid_text_01", constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000)))
	end
end
function mermaidGiftMainView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MERMAID_GIFT_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return mermaidGiftMainView
