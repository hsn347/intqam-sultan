local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local legendMDesRead = include("legendMDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LegendMPopEditKingDesPanel = class("LegendMPopEditKingDesPanel", baseFguiPanel)
function LegendMPopEditKingDesPanel:ctor(...)
	self.super.ctor(self, ...)
	print("LegendMPopEditKingDesPanel:ctor", self.viewName)
end
function LegendMPopEditKingDesPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LegendMPopEditKingDesPanel:onInit()
	print("=======LegendMPopEditKingDesPanel:onInit")
	self.pageType = self.proxy.param.pageType
	self.serverData = self.proxy.param.serverData
	self.fields.Button_Close:addTouchEventListener(handler(self, self.onClickClose))
	self.fields.btn_commit:addTouchEventListener(handler(self, self.onClick_btnCommit))
	self.fields.title:setString(i18n("history_title_05"))
	self.fields.btn_commit:setString(i18n("common_text_3628"))
end
function LegendMPopEditKingDesPanel:onShow()
	print("=======LegendMPopEditKingDesPanel:onShow")
	dump(data, "legendMPopEditKingDes:init")
	local strTip = legendMDesRead.getKingDes(self.serverData)
	self.fields.textField_Content:setString(strTip)
end
function LegendMPopEditKingDesPanel:onClick_btnCommit(sender, event)
	SoraDPlaySound()
	local strDes = self.fields.textField_Content:getText()
	if string.len(strDes) == 0 then
		SoraDShowMsgTip(i18n("common_text_1525"))
		return
	end
	local kid = self.serverData.kid
	local setType = self.serverData.setType
	local round = self.serverData.round
	SoraDShowMsgBox(i18n("history_text_11"), i18n("common_text_054"), i18n("common_text_185"), function(type)
		if type == MSGBOX_CALLBACK_YES then
			print("发起设置des")
			SoraDShowLoading()
			legendMCtrl:reqSetKingDes(strDes, setType, round, kid)
			self:closePanel()
		end
	end)
end
return LegendMPopEditKingDesPanel
