local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_BattlePassPanel = class("Activity_9001680_BattlePassPanel", baseFguiPanel)
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
local activity_9001680_Read = include("activity_9001680_Read")
function Activity_9001680_BattlePassPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_BattlePassPanel.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001680
	print("Activity_9001680_BattlePassPanel:ctor", self.viewName)
end
function Activity_9001680_BattlePassPanel:onInit()
	print("=======Activity_9001680_BattlePassPanel:onInit")
	self.view:fixChildrenPos()
	self.fields.n21:fix()
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.Button_buyGift:addClickListener(handler(self, self.onClickBuyGift))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClickOneKey))
	self.fields.Text_lvTitle:setString(i18n("snow_competition_text_08"))
	self.fields.Text_rewardTitle:setString(i18n("return_peak_04"))
	self.fields.Text_rewardTitle1:setString(i18n("StarlitNight_text_07"))
	self.fields.Button_buyGift:setString(i18n("StarlitNight_text_02"))
	self.fields.Button_oneKey:setString(i18n("cavalryrise_text_07"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_des:setString(i18n("snow_competition_text_07"))
end
function Activity_9001680_BattlePassPanel:endShow()
	print("=======Activity_9001680_BattlePassPanel:endShow")
	self:updateView()
end
function Activity_9001680_BattlePassPanel:onItemRenderer(index, obj)
	local cfg = self.rewardList[index + 1]
	obj:initData(cfg, index + 1)
end
function Activity_9001680_BattlePassPanel:onClickBuyGift()
	SoraDPlaySound()
	if activity_9001680_Ctrl:isActiveGold() then
		return
	end
	uiManager:show("Activity_9001680_BuyGift")
end
function Activity_9001680_BattlePassPanel:onClickOneKey()
	SoraDPlaySound()
	if not activity_9001680_Ctrl:hasAward() then
		print("Activity_9001680_BattlePassPanel:onClickOneKey 没有可领取的")
		return
	end
	activity_9001680_Ctrl:reqGoldMinerBattlePassAllReward()
end
function Activity_9001680_BattlePassPanel:updateView()
	local isActiveGold = activity_9001680_Ctrl:isActiveGold()
	self.controllers.c1:setSelectedIndex(isActiveGold and 1 or 0)
	local hasAward = activity_9001680_Ctrl:hasAward()
	self.fields.Button_oneKey:setTouchable(hasAward)
	self.fields.Button_oneKey:setGrayed(not hasAward)
	self.rewardList = activity_9001680_Read:getRewardList()
	self.fields.List:setNumItems(#self.rewardList)
end
function Activity_9001680_BattlePassPanel:updateRedDot()
	local hasAward = activity_9001680_Ctrl:hasAward()
	self.fields.Button_oneKey:setReddot(hasAward)
	return hasAward and 1 or 0
end
return Activity_9001680_BattlePassPanel
