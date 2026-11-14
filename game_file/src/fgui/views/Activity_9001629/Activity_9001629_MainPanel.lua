local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001629_MainPanel = class("Activity_9001629_MainPanel", baseFguiPanel)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001629_Ctrl = SoraDGetCtrl("activity_9001629_Ctrl")
local activity_9001629_Read = include("activity_9001629_Read")
local publicRead = include("publicRead")
local dailyRemindManager = include("dailyRemindManager")
local constantRead = include("constantRead")
local starsWishingGameCtrl = SoraDGetCtrl("starsWishingGameCtrl")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
function Activity_9001629_MainPanel:ctor(...)
	Activity_9001629_MainPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001629_MainPanel:ctor", self.viewName)
end
function Activity_9001629_MainPanel:onInit()
	print("=======Activity_9001629_MainPanel:onInit")
	self.itemData = activity_9001629_Read:getItemData()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001629
	self.changeCDTime = activity_9001629_Ctrl:getChangeCDTime()
	self.callNeedNum = self.itemData[2]
	self.callItemID = self.itemData[1]
	self.fields.Text_title:setTitle(i18n("atlantiswar_text_0019"))
	self.fields.Com_title:initData(i18n("activity_name_9001629"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Text_tip:setString(i18n("nebula_stars_wishing_text6"))
	self.fields.Text_wish_tip:setString(i18n("nebula_stars_wishing_text3"))
	self.fields.btn_wish:setString(i18n("nebula_stars_wishing_text7"))
	self.fields.btn_wish:addClickListener(handler(self, self.onWishClick))
	self.fields.btn_change:setString(i18n("nebula_stars_wishing_text8"))
	self.fields.btn_change:addClickListener(handler(self, self.onChangeClick))
	self.fields.btn_game:setString(i18n("nebula_stars_wishing_text1"))
	self.fields.btn_game:addClickListener(handler(self, self.onGameClick))
	self.fields.btn_shop:setString(i18n("activity_name_9001635"))
	self.fields.btn_shop:addClickListener(handler(self, self.onShopClick))
	self.fields.btn_task:setString(i18n("nebula_stars_wishing_text2"))
	self.fields.btn_task:addClickListener(handler(self, self.onTaskClick))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.rewardList = activity_9001629_Read:getReward()
	self.fields.List_reward:setNumItems(#self.rewardList)
	self.fields.btn_lamp_1:setWishClickHandler(handler(self, self.onWishClick))
	self.fields.Lab_wish:initData(self.callItemID)
	activity_9001629_Ctrl:sendReqInitDataMsg()
	self.view:fixChildrenPos()
	self.fields.bg1:fix()
	self.fields.bg2:fix()
end
function Activity_9001629_MainPanel:onShow()
	print("=======Activity_9001629_MainPanel:onShow")
	self:updateView()
end
function Activity_9001629_MainPanel:updateView()
	self:updateItem()
	self.wishes = activity_9001629_Ctrl:getWishes()
	dump(self.wishes, "self.wishes")
	self.isHaveMyLamp = activity_9001629_Ctrl:getIsHaveWish()
	for i = 1, 5 do
		local wishData = self.wishes[i]
		self.fields["btn_lamp_" .. i]:initData(wishData, i)
	end
	dump(self.isHaveMyLamp, "self.isHaveMyLamp")
	self.fields.bg1:setVisible(not self.isHaveMyLamp)
	self.fields.bg2:setVisible(not self.isHaveMyLamp)
	self.fields.Text_wish_tip:setVisible(not self.isHaveMyLamp)
	local recvWishes = activity_9001629_Ctrl:getRecvWishes()
	if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.activity_9001629) and table.nums(recvWishes) > 0 then
		activity_9001629_Ctrl = self.wishes[i]
		self.wishes[i].dataList = recvWishes
		uiManager:show("Activity_9001629_RecvWish", self.wishes[i])
	elseif 0 < #recvWishes then
		activity_9001629_Ctrl:reqRead()
	end
	self:updateRedDot()
	self:updateChangeCD()
end
function Activity_9001629_MainPanel:playShowAni()
	self.fields.btn_lamp_1:playWishAni()
end
function Activity_9001629_MainPanel:updateItem()
	self.itemHave = self.fields.Lab_wish:updateNum()
	self:updateItemReddot()
end
function Activity_9001629_MainPanel:updateRedDot()
	local isTaskRedDot = activity_9001629_Ctrl:getTaskRedDot()
	self.fields.btn_task:setReddot(isTaskRedDot, 0)
	local isHaveLikeReddot = activity_9001629_Ctrl:getIsHaveLikeReddot()
	self.fields.btn_lamp_1:setReddot(isHaveLikeReddot, 0)
	local latsSteps = starsWishingGameCtrl:getMySteps()
	self.fields.btn_game:setReddot(not starsWishingGameCtrl:getIsMaxLevel() and (0 < latsSteps or starsWishingGameCtrl:getIsHaveFreePlusTimes()), 0)
	self:updateItemReddot()
end
function Activity_9001629_MainPanel:updateItemReddot()
	local ret, num = newExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001635)
	self.fields.btn_shop:setReddot(ret, 0)
	self.fields.btn_wish:setReddot(self.itemHave >= self.callNeedNum, 0)
end
function Activity_9001629_MainPanel:onItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function Activity_9001629_MainPanel:onGameClick()
	SoraDPlaySound()
	include("starsWishingGameCommon").enterGame()
end
function Activity_9001629_MainPanel:onShopClick()
	SoraDPlaySound()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001635)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		SoraDShowMsgTip(i18n("common_text_2486"))
	else
		_ENV = i18n("common_text_2486")
		i18n("common_text_2486").id = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001635
		uiManager:show("ExchangeEventPage", i18n("common_text_2486")):setOwnerKey(self)
	end
end
function Activity_9001629_MainPanel:onTaskClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001629_Task")
end
function Activity_9001629_MainPanel:onWishClick()
	SoraDPlaySound()
	if self.itemHave < self.callNeedNum then
		_ENV = nil
		;(nil).item = publicRead.getName(self.callItemID)
		SoraDShowMsgTip(i18n("common_text_1806", nil))
		return
	end
	uiManager:show("Activity_9001629_Wish")
end
function Activity_9001629_MainPanel:onChangeClick()
	SoraDPlaySound()
	if self.changeCDTime > 0 then
		SoraDShowMsgTip(i18n("nebula_stars_wishing_text4"))
		return
	end
	self:updateChangeCD()
	activity_9001629_Ctrl:reqRefresh()
end
function Activity_9001629_MainPanel:updateChangeCD()
	self.changeCDTime = activity_9001629_Ctrl:getChangeCDTime()
	self.fields.btn_change:setBright(self.changeCDTime <= 0)
	self.fields.btn_change:stopActionByTag(995)
	local titlestr = i18n("nebula_stars_wishing_text8")
	if self.changeCDTime > 0 then
		local cdAction = ffa.seq(ffa.delay(1), ffa.callFunc(handler(self, self.updateChangeCD)))
		cdAction:setTag(995)
		self.fields.btn_change:runAction(cdAction)
		titlestr = string.format("%s(%d)", titlestr, self.changeCDTime)
	end
	self.fields.btn_change:setTitle(titlestr)
end
function Activity_9001629_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_stars_wishing_text32")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return Activity_9001629_MainPanel
