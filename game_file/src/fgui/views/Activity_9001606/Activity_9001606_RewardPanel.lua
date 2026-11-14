local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001606_RewardPanel = class("Activity_9001606_RewardPanel", baseFguiPanel)
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activity_9001606_Read = include("activity_9001606_Read")
function Activity_9001606_RewardPanel:ctor(...)
	Activity_9001606_RewardPanel.super.ctor(self, ...)
	print("Activity_9001606_RewardPanel:ctor", self.viewName)
end
function Activity_9001606_RewardPanel:onInit()
	self.isAddToPopManager = true
	print("=======Activity_9001606_RewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("CombineServers_1"))
	self.myKingdomID = gametop.playertop_:getKingdomID()
	local kingdomName = ""
	local isK, kingdomInfo = kingdomCtrl:isFoundKingdomID(self.myKingdomID)
	if isK and kingdomInfo.kname then
		kingdomName = kingdomInfo.kname
	else
		kingdomName = i18n("common_text_479") .. "#" .. self.myKingdomID
	end
	_ENV = i18n("CombineServers_1")
	i18n("CombineServers_1").color = "#F0E6D2"
	local showStr = i18n("CombineServers_58") .. SoraDWrapHtmlTagByStyle(kingdomName, i18n("CombineServers_1"))
	self.fields.Text_name:setString(showStr)
	self.fields.Text_progress:setString(i18n("CombineServers_59"))
	self.fields.Button_get:addClickEventListener(handler(self, self.onSureClick))
	self.fields.Button_get:setTitle(i18n("common_text_1146"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.rewardList = activity_9001606_Read.getOnceRewards(self.param)
	self.fields.List_reward:setNumItems(#self.rewardList)
	self.fields.List_reward:scrollToView(0)
end
function Activity_9001606_RewardPanel:onShow()
	print("=======Activity_9001606_RewardPanel:onShow")
end
function Activity_9001606_RewardPanel:onHide()
	print("=======Activity_9001606_RewardPanel:onShow")
	lordInfoCtrl:reqCompleteMerge()
	if self.rewardList then
		SoraDMailGainItems(self.rewardList, true)
	end
end
function Activity_9001606_RewardPanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001606_RewardPanel:onSureClick()
	SoraDPlaySound()
	self:close()
end
return Activity_9001606_RewardPanel
