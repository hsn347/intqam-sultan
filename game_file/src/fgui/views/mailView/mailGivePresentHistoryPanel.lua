local mailCtrl = SoraDGetCtrl("mailCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local mailGivePresentHistoryPanel = class("mailGivePresentHistoryPanel", baseFguiPanel)
function mailGivePresentHistoryPanel:ctor(...)
	mailGivePresentHistoryPanel.super.ctor(self, ...)
	print("mailGivePresentHistoryPanel:ctor", self.viewName)
end
function mailGivePresentHistoryPanel:onInit()
	print("=======mailGivePresentHistoryPanel:onInit")
	self.recordList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("alliance_war_text_03"))
	self.fields.Text_none:setString(i18n("god_beast_text_16"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function mailGivePresentHistoryPanel:onShow()
	print("=======mailGivePresentHistoryPanel:onShow")
	SoraDShowLoading(self)
	_ENV = nil
	;(nil).idx = 1
	;(nil).count = 50
	mailCtrl:getGiveHistory(nil)
end
function mailGivePresentHistoryPanel:onItemRenderer(index, obj)
	obj:initData(self.recordList[index + 1])
end
function mailGivePresentHistoryPanel:updateData(target, data)
	SoraDCloseLoading(self)
	self.recordList = data.data
	dump(self.recordList, "self.recordList===")
	self.fields.List:setNumItems(#self.recordList)
	self.fields.Text_none:setVisible(#self.recordList == 0)
end
return mailGivePresentHistoryPanel
