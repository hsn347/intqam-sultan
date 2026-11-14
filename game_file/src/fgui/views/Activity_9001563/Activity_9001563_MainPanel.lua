local newLotteryRead = include("newLotteryRead")
local activity_9001563_Ctrl = SoraDGetCtrl("activity_9001563_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001563_MainPanel = class("Activity_9001563_MainPanel", baseFguiPanel)
function Activity_9001563_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001563_MainPanel:ctor", self.viewName)
	self.state = "normal"
end
function Activity_9001563_MainPanel:onInit()
	print("=======Activity_9001563_MainPanel:onInit")
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001563
	self.itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	local _fields = fguiHelper.get_fields(self.fields.Com_reward)
	self.fields.Text_title = _fields.Text_title
	self.fields.List = _fields.List
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Com_have:initData(self.itemID)
	_ENV = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).num = 1
	self.fields.Button_one:setString(i18n("Pyramid_treasure_btn_01", handler(self, self.onItemRenderer)))
	self.fields.Button_one:addClickListener(handler(self, self.onClickBtnOne))
	self.fields.Text_noData:setString(i18n("soldier_rush_text_29"))
end
function Activity_9001563_MainPanel:onShow()
	print("=======Activity_9001563_MainPanel:onShow")
	self:updateItemCount()
	self:updateView()
end
function Activity_9001563_MainPanel:onClickHelp(...)
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("rendezvous_planet_01"))
end
function Activity_9001563_MainPanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001563_MainPanel:onClickBtnOne(...)
	SoraDPlaySound()
	if self.haveNum >= self.costNum then
		activity_9001563_Ctrl:reqLottery()
		SoraDShowLoading(self:displayObject())
		self.state = "clickBtnOne"
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function Activity_9001563_MainPanel:onMsgUpdateView(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rewards then
		self:updateView()
		return
	end
	SoraDShowLoading(self:displayObject(), nil, nil, true)
	self.transitions.t_reward:play()
	self.fields.Usm_reward:play()
	local criSprite = self.fields.Usm_reward:getCriSprite()
	_ENV = nil
	;(nil).frame = 124
	criSprite:addFrameEventData(nil)
	criSprite:setFrameEventCallback(function(_event)
		self.state = "showEffect"
		SoraDCloseLoading(self:displayObject())
		self:updateItemCount()
		self:updateView()
		self = self:displayObject()
		self:displayObject().reward = event.rewards
		self:displayObject().showAction = true
		uiManager:show("DesertMiningGetReward", self:displayObject())
	end)
end
function Activity_9001563_MainPanel:onIntoPanel(...)
	if self.state == "showEffect" then
		self.state = "normal"
		self.fields.Usm_reward:clearEffectOnly()
		self.fields.Usm_reward:setVisible(false)
		self.fields.content:setAlpha(1)
	end
end
function Activity_9001563_MainPanel:updateView(...)
	self.cfgList = newLotteryRead.getConfig(self.activityID)
	local newLotteryRead, ret = newLotteryRead.getConfig(self.activityID), newLotteryRead.getConfig(self.activityID)
	for i, v in ipairs(self.cfgList) do
		if not activity_9001563_Ctrl:getIsLottery(v.ItemOrder) then
			table.insertto(ret, v.reward)
		end
	end
	self.rewardList = ret
	if #self.rewardList <= 0 then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
		local lotteryCount = activity_9001563_Ctrl:getLotteryCount()
		local maxCount = #self.cfgList
		local remain = math.max(0, maxCount - lotteryCount)
		newLotteryRead = v.reward
		v.reward.num = remain
		self.fields.Text_title:setString(i18n("treasure_beach_03", v.reward))
		self.fields.List:setNumItems(#self.rewardList)
	end
end
function Activity_9001563_MainPanel:updateItemCount(...)
	if self.state == "clickBtnOne" then
		return
	end
	self.haveNum = self.fields.Com_have:updateNum()
	local lotteryCount = activity_9001563_Ctrl:getLotteryCount()
	local cost = newLotteryRead.getCostNum(self.activityID, lotteryCount)
	self.costNum = cost
	self.fields.Button_one:setCost(self.itemID, self.costNum)
end
return Activity_9001563_MainPanel
