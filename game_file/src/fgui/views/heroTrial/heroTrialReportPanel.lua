local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroTrialReportPanel = class("heroTrialReportPanel", baseFguiPanel)
function heroTrialReportPanel:ctor(...)
	self.isLRU = true
	heroTrialReportPanel.super.ctor(self, ...)
	print("heroTrialReportPanel:ctor", self.viewName)
end
function heroTrialReportPanel:onInit()
	print("=======heroTrialReportPanel:onInit")
	self.fields.Com_title:initData(i18n("mail_text_13"), handler(self, self.onClickClose))
end
function heroTrialReportPanel:endShow()
	print("=======heroTrialReportPanel:endShow")
	self.logData = self.param.logData
	self.fields.Com_title:updateTitle(self.logData.isAttackWin and i18n("mail_text_13") or i18n("mail_text_14"))
	self.fields.Com_content:initData(self.logData)
end
return heroTrialReportPanel
