local baseComponent = require("fgui.base.baseComponent")
local Com_9001656_reward = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
local activity_9001656_Read = include("activity_9001656_Read")
fgui.register_extension("ui://Activity_9001656/Com_9001656_reward", Com_9001656_reward)
function Com_9001656_reward:onInit()
	self:fixChildrenPos()
	self.fields.Bg_single:fix()
	self.fields.Button_buyGift:addClickListener(handler(self, self.onClickBuyGift))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClickOneKey))
	self.fields.Text_lvTitle:setString(i18n("common_text_748"))
	self.fields.Text_rewardTitle:setString(i18n("warmongering_text_7"))
	self.fields.Text_rewardTitle1:setString(i18n("StarlitNight_text_07"))
	self.fields.Button_buyGift:setString(i18n("StarlitNight_text_02"))
	self.fields.Button_oneKey:setString(i18n("cavalryrise_text_07"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onListScroll))
end
function Com_9001656_reward:onListScroll()
	self:updateSpecialReward()
end
function Com_9001656_reward:getMaxShowReward()
	local firstChild = self.fields.List:getFirstChildInView()
	local singleHeight = 98
	local contentHeight = self.fields.List:getContentSize().height
	local index = firstChild + math.ceil(contentHeight / singleHeight) + (5 - firstChild % 5)
	return activity_9001656_Read.getShowRewad(index)
end
function Com_9001656_reward:updateSpecialReward()
	local cfg = self:getMaxShowReward()
	self.fields.Com_lastReward:initData(cfg)
end
function Com_9001656_reward:onItemRenderer(index, obj)
	local cfg = self.rewardList[index + 1]
	obj:initData(cfg)
end
function Com_9001656_reward:onClickBuyGift()
	SoraDPlaySound()
	if activity_9001656_Ctrl:isActiveGold() then
		return
	end
	uiManager:show("Activity_9001656_BuyGift")
end
function Com_9001656_reward:onClickOneKey()
	SoraDPlaySound()
	if not activity_9001656_Ctrl:hasAward() then
		print("Com_9001656_reward:onClickOneKey 没有可领取的")
		return
	end
	activity_9001656_Ctrl:reqStageReward()
end
function Com_9001656_reward:onShow()
end
function Com_9001656_reward:updateUI()
	local isActiveGold = activity_9001656_Ctrl:isActiveGold()
	self.controllers.c2:setSelectedIndex(isActiveGold and 1 or 0)
	local hasAward = activity_9001656_Ctrl:hasAward()
	local lvMax = activity_9001656_Read.getMaxLevel()
	local rewardLv = activity_9001656_Ctrl:getRewardLevel()
	local rewardLvGold = activity_9001656_Ctrl:getRewardLevelGold()
	local index = rewardLv + 1
	if isActiveGold then
		index = math.min(index, rewardLvGold + 1)
	end
	index = math.min(index, lvMax - 1)
	self.fields.Button_oneKey:setReddot(hasAward)
	self.fields.Button_oneKey:setTouchable(hasAward)
	self.fields.Button_oneKey:setGrayed(not hasAward)
	self.rewardList = activity_9001656_Read:getRewardList()
	self.fields.List:setNumItems(#self.rewardList - 1)
	self.fields.List:scrollToView(index - 1, false, false)
end
return Com_9001656_reward
