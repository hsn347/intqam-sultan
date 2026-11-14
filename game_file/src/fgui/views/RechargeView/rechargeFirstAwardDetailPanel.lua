local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local rechargeltCtrl = include("rechargeltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeFirstAwardDetailPanel = class("rechargeFirstAwardDetailPanel", baseFguiPanel)
function rechargeFirstAwardDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargeFirstAwardDetailPanel:ctor", self.viewName)
end
function rechargeFirstAwardDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargeFirstAwardDetailPanel:onInit()
	print("=======rechargeFirstAwardDetailPanel:onInit")
	self.rewardData, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("common_text_4764"))
	_ENV = i18n("common_text_4764")
	i18n("common_text_4764").count = fguiHelper.getColorString("#FFD43E", RECHARGE_DAY_FIRST_GOLD)
	self.fields.text_title:setString(i18n("common_text_3768", i18n("common_text_4764")))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function rechargeFirstAwardDetailPanel:onItemRenderer(index, obj)
	obj:initData(index, self.rewardData[index + 1])
end
function rechargeFirstAwardDetailPanel:onShow()
	print("=======rechargeFirstAwardDetailPanel:onShow")
	self:initView()
end
function rechargeFirstAwardDetailPanel:initView()
	local rewards = rechargeltCtrl:getRechargeDayFirstReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewardData = serviceFunctions.tableFormat(rewards[1].award, nil)
	self.fields.list:setNumItems(#self.rewardData)
end
function rechargeFirstAwardDetailPanel:sMsgReceiveNormal()
	local isRechargeAccout = rechargeActivityCtrl:getIsAccountFirstRecharge()
	local isRecharge = rechargeActivityCtrl:getIsDayFirstRecharge()
	if not isRecharge then
		self:close()
		return
	end
	self:initView()
end
return rechargeFirstAwardDetailPanel
