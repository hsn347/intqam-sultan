local publicRead = include("publicRead")
local rechargeRead = include("rechargeRead")
local rechargeGiftRead = gModuleMgr.sharedMgr("rechargeGiftRead")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local rechargeGiftRewardPopView = class("rechargeGiftRewardPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("rechargeGiftRewardPopView")
end)
local baseHeight = 330
_ENV, _ENV = nil, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("rechargeGiftRewardPopView")
end
_ENV, (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("rechargeGiftRewardPopView")
end)[7210278], (nil).des = nil, nil, "rechargeGift_text_04"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("rechargeGiftRewardPopView")
end)[7210279], (nil).des = nil, "rechargeGift_text_05"
local function giftDescribe(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("rechargeGiftRewardPopView")
end
function rechargeGiftRewardPopView:ctor(properties)
	self.activityID = gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY
	self.imgBgLeft = SoraDGetChildByName(self, "Image_Bg_Left")
	self.imgBgRight = SoraDGetChildByName(self, "Image_Bg_Right")
	self.nodeHead = SoraDGetChildByName(self, "Node_Head")
	self.nodeTitle = SoraDGetChildByName(self, "Node_Title")
	self.textTips = SoraDGetChildByName(self.nodeTitle, "Text_Tips")
	self.textTips:setString(i18n("rechargeGift_text_02"))
	self.textActivityName = SoraDGetChildByName(self.nodeTitle, "Text_ActivityName")
	self.textActivityName:setString(i18n("activity_name_9001266"))
	self.imageRenwu = SoraDGetChildByName(self, "Image_Renwu")
	self.imageZS11 = SoraDGetChildByName(self, "frame_czzl_ZS11")
	self.itemOneNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_OnlyOne")
	self.itemOneNum = SoraDGetChildByName(self.itemOneNode, "Text_OneItemNum")
	self.nodeTime = SoraDGetChildByName(self, "Node_Time")
	self.textActivityTime = SoraDGetChildByName(self.nodeTime, "text_time")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.scrollBg = SoraDGetChildByName(self, "Image_ScrollBg")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initActivityTime()
end
function rechargeGiftRewardPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function rechargeGiftRewardPopView:initData(rechargeIDList)
	local nums = math.min(table.nums(rechargeIDList), 3)
	self.showDes = 1 < nums
	local singleHeight = self.showDes and 125 or 100
	self.height = baseHeight + (nums - 1) * singleHeight
	self.imgBgLeft:setContentSize(cc.size(320.0, self.height))
	self.imgBgRight:setContentSize(cc.size(320.0, self.height))
	self.nodeHead:setPositionY(self.height / 2 - 60)
	self.nodeTitle:setPositionY(self.height / 2 - 60)
	self.imageZS11:setPositionY(self.height / 2 - 130)
	self.nodeTime:setPositionY(-self.height / 2 - 40)
	dump(rechargeIDList, "rechargeIDList", 10)
	if self.showDes then
		self:showMoreReward(rechargeIDList)
	else
		self:showOneReward(rechargeIDList)
	end
end
function rechargeGiftRewardPopView:showOneReward(data)
	self.imageRenwu:setPositionY(-100)
	self.imageZS11:setPositionY(-80)
	self.scroll:setVisible(false)
	self.scrollBg:setVisible(false)
	self.itemOneNode:setVisible(true)
	local rewardList = rechargeActivityCtrl:getRechargeGift(data[1].rechargeID)
	if next(rewardList) then
		self.itemOneNode:setOwnView(self)
		self.itemOneNode:initData(rewardList[1].id)
	else
		self.itemOneNode:setVisible(false)
	end
	self.itemOneNum:setString("x" .. string.formatnumberthousands(rewardList[1].count))
	self.nodeTime:setPositionX(SoraDFPosX(-140, 0))
end
function rechargeGiftRewardPopView:showMoreReward(data)
	self.imageRenwu:setPositionY(0)
	self.scroll:setVisible(true)
	self.scrollBg:setVisible(true)
	self.itemOneNode:setVisible(false)
	self.nodeTime:setPositionX(0)
	self.scroll:setPositionY(self.height / 2 - 220)
	self.scrollBg:setPositionY(self.height / 2 - 220)
	self.scrollBg:setContentSize(cc.size(640, self.height - 205))
	self.scroll:setContentSize(cc.size(640, self.height - 205))
	_ENV = cc.size(640, self.height - 205)
	cc.size(640, self.height - 205).scroll = self.scroll
	cc.size(640, self.height - 205).view = self
	self.scroll:updateScrollView(cc.size(640, 125), data, 1, cc.size(640, self.height - 205))
	self.scroll:setEnabledFollowHeight()
end
function rechargeGiftRewardPopView:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textActivityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.textActivityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTime, 2, SoraDFIsRA())
end
function rechargeGiftRewardPopView:refreshScrollSingle(parent, data)
	local textTitle = SoraDGetChildByName(parent, "Text_Title")
	local nodeReward = SoraDGetChildByName(parent, "Node_Reward")
	local itemNode = SoraDGetExtendChildFromCCSByName(nodeReward, "CCS_commonItemAward")
	local itemName = SoraDGetChildByName(nodeReward, "Text_ItemName")
	local itemNum = SoraDGetChildByName(nodeReward, "Text_ItemNum")
	local rewardList = rechargeActivityCtrl:getRechargeGift(data.rechargeID)
	itemNode:setRealScale(0.7)
	itemNode:setOwnView(self.scroll)
	itemNode:initData(rewardList[1].id)
	itemNum:setString("x" .. string.formatnumberthousands(rewardList[1].count))
	itemName:setString(i18n(publicRead.getName(rewardList[1].id)))
	if giftDescribe[data.rechargeID] then
		textTitle:setString(i18n(giftDescribe[data.rechargeID].des))
	elseif data.price then
		_ENV = i18n(giftDescribe[data.rechargeID].des)
		i18n(giftDescribe[data.rechargeID].des).price = data.price
		textTitle:setString(i18n("rechargeGift_text_06", i18n(giftDescribe[data.rechargeID].des)))
	else
		local rechargeInfo = rechargeRead.getPageViewData(data.rechargeID)
		_ENV = i18n("rechargeGift_text_06", i18n(giftDescribe[data.rechargeID].des))
		i18n("rechargeGift_text_06", i18n(giftDescribe[data.rechargeID].des)).giftName = i18n(rechargeInfo.activeName)
		textTitle:setString(i18n("rechargeGift_text_03", i18n("rechargeGift_text_06", i18n(giftDescribe[data.rechargeID].des))))
	end
end
function rechargeGiftRewardPopView:createScrollSingle(parent, data)
	local single = self.nodeSingle:clone()
	return single
end
function rechargeGiftRewardPopView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
return rechargeGiftRewardPopView
