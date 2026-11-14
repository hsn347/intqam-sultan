local allianceMsg = SoraDGetCtrl("allianceMsg")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceUnlockMessagesViewPanel = class("allianceUnlockMessagesViewPanel", baseFguiPanel)
function allianceUnlockMessagesViewPanel:ctor(...)
	allianceUnlockMessagesViewPanel.super.ctor(self, ...)
	print("allianceUnlockMessagesViewPanel:ctor", self.viewName)
end
function allianceUnlockMessagesViewPanel:onInit()
	print("=======allianceUnlockMessagesViewPanel:onInit")
	self.tableListData, _ENV, self.tag = print, print, 1
	self.fields.Com_title:initData(i18n("common_text_077"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function allianceUnlockMessagesViewPanel:onShow()
	print("=======allianceUnlockMessagesViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	allianceMsg:reqAllianceMessageShieldList()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("common_text_080")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("common_text_081")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
end
function allianceUnlockMessagesViewPanel:onListRenderer(index, obj)
	obj:initData(self.tableListData[index + 1], self.tag)
end
function allianceUnlockMessagesViewPanel:onClickTab(tag)
	self.tag = tag
	self:updateScrollWithData()
	self.fields.List:jumpToTop()
end
function allianceUnlockMessagesViewPanel:updateScrollWithData()
	if (self.tag ~= 1 or not allianceMsg.aMsgList.shieldlord) and not allianceMsg.aMsgList.shieldalliance then
		allianceMsg = allianceMsg.aMsgList.shieldalliance
	end
	self.tableListData = allianceMsg.aMsgList.shieldalliance
	self.fields.List:setNumItems(#self.tableListData)
end
return allianceUnlockMessagesViewPanel
