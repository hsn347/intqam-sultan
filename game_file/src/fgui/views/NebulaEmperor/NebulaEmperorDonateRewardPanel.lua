local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorDonateRewardPanel = class("NebulaEmperorDonateRewardPanel", baseFguiPanel)
function NebulaEmperorDonateRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorDonateRewardPanel:ctor", self.viewName)
end
function NebulaEmperorDonateRewardPanel:onInit()
	print("=======NebulaEmperorDonateRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("nebulaemperor_text_86"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_receive:addClickListener(handler(self, self.onClickBtnReceive))
	if not SoraDFIsRA() then
		self.fields.Label_donate:fixChildrenPos()
	end
end
function NebulaEmperorDonateRewardPanel:onShow()
	print("=======NebulaEmperorDonateRewardPanel:onShow")
	self.grade = self.param.grade
	self.status = self.param.status
	self.activityID = self.param.activityID or gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
	local _ENV, donateInfo = self.param.activityID or gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY, self.param.activityID or gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		donateInfo = nebulaEmperorCtrl:getDonateInfo()
		self.itemList = nebulaEmperorRead.getDonateRewards(self.grade)
	else
		donateInfo = nebulaAllStarCtrl:getDonateInfo()
		self.itemList = nebulaAllStarRead.getDonateRewards(self.grade)
	end
	local totalGold = donateInfo.totalGold
	_ENV = nil
	;(nil).num = string.formatnumberthousands(totalGold)
	self.fields.Label_donate:setString(i18n("nebulaemperor_text_84", nil))
	self.fields.List:setNumItems(#self.itemList)
	if self.status == gBtnTargetStatusDef.GET then
		self.fields.Button_receive:setTitleText(i18n("common_text_1146"))
		self.fields.Button_receive:setEnabled(true)
	elseif self.status == gBtnTargetStatusDef.GOT then
		self.fields.Button_receive:setTitleText(i18n("common_text_1892"))
		self.fields.Button_receive:setEnabled(false)
	else
		self.fields.Button_receive:setTitleText(i18n("common_text_1146"))
		self.fields.Button_receive:setEnabled(false)
	end
end
function NebulaEmperorDonateRewardPanel:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item.id, item.count)
end
function NebulaEmperorDonateRewardPanel:onClickBtnReceive()
	SoraDPlaySound()
	if self.status == gBtnTargetStatusDef.GET then
		if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
			nebulaEmperorCtrl:reqDonateReward(self.grade)
		else
			nebulaAllStarCtrl:reqDonateReward(self.grade)
		end
	end
end
return NebulaEmperorDonateRewardPanel
