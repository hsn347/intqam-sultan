local eidSignCtrl = SoraDGetCtrl("eidSignCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local signRewadRead = include("signRewadRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DashainGiftingPopPanel = class("DashainGiftingPopPanel", baseFguiPanel)
function DashainGiftingPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DashainGiftingPopPanel:ctor", self.viewName)
end
function DashainGiftingPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DashainGiftingPopPanel:onInit()
	print("=======DashainGiftingPopPanel:onInit")
	self.fields.Text_Title:setString(i18n("soldier_rush_text_11"))
	self.fields.List_Award:setItemRenderer(handler(self, self.onItemRederer))
	activityShowCtrl = signRewadRead
	signRewadRead[1] = "id"
	signRewadRead[2] = "count"
	self.awardConfig = serviceFunctions.tableFormat(signRewadRead:getEidaladhaExtra(activityShowCtrl:getParamClassType(gActivityTimeActivityID.EID_SIGN_ACTIVITY)), signRewadRead)
	self.fields.List_Award:setNumItems(#self.awardConfig)
	self.fields.Button_comfirm:addClickListener(handler(self, self.onClickComfirm))
end
function DashainGiftingPopPanel:onShow()
	print("=======DashainGiftingPopPanel:onShow")
	self:updateStatus()
end
function DashainGiftingPopPanel:updateStatus()
	self.status = eidSignCtrl:getExtraStatusByDay(7)
	if self.status == gIceCrazyNightStatus.RECEIVED then
		self.fields.Button_comfirm:setString(i18n("common_text_1892"))
	else
		self.fields.Button_comfirm:setString(i18n("common_text_1146"))
	end
	self.fields.Button_comfirm:setGrayed(self.status ~= gIceCrazyNightStatus.RECEIVE)
end
function DashainGiftingPopPanel:onItemRederer(index, target)
	target:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
function DashainGiftingPopPanel:onClickComfirm()
	SoraDPlaySound()
	if self.status == gIceCrazyNightStatus.RECEIVE then
		SoraDShowLoading()
		eidSignCtrl:reqEidSignGetExtra(7)
	elseif self.status == gIceCrazyNightStatus.UNREACH then
		SoraDShowMsgTip(i18n("eidaladha_sign_text_06"))
	end
end
return DashainGiftingPopPanel
