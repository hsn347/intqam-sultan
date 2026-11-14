local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local sinbadTreasureRead = include("sinbadTreasureRead")
local sinbadTreasureExtraView = class("sinbadTreasureExtraView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sinbadTreasureExtraView")
	end
	return target
end)
function sinbadTreasureExtraView:ctor()
	self:initWidget()
	self:fitDevice()
end
function sinbadTreasureExtraView:fitDevice()
end
function sinbadTreasureExtraView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_EXTRA_REWARD_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		SoraDShowMsgTip(i18n("Outstanding_text_07"))
		self:updateBtnState()
		self:closePanel()
	end)
end
function sinbadTreasureExtraView:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Text_name:setString(i18n("common_text_2078"))
	self.Button_receive:addTouchEventListener(handler(self, self.buttonGetCallBack))
end
function sinbadTreasureExtraView:initData()
	local rankData = sinbadTreasureRead.getRankData(1, sinbadTreasureCtrl:getClassType())
	local activityData = sinbadTreasureCtrl:getActivityData()
	_ENV = sinbadTreasureCtrl:getClassType()
	sinbadTreasureCtrl:getClassType()[1] = "id"
	sinbadTreasureCtrl:getClassType()[2] = "count"
	local rewardList = serviceFunctions.tableFormat(rankData[1].reward, sinbadTreasureCtrl:getClassType())
	sinbadTreasureRead = sinbadTreasureCtrl:getClassType()
	sinbadTreasureCtrl:getClassType().var = rankData[1].rank[1]
	self.Text_tips2:setString(i18n("Sinbad_text_17", sinbadTreasureCtrl:getClassType()))
	for i, v in ipairs(rewardList) do
		local rewardCell = include("commonItemAward").new()
		rewardCell:setScale(1.0)
		rewardCell:setBaseScale(1.0)
		rewardCell:setOwnView(self)
		rewardCell:initData(v.id, v.count)
		if SoraDFIsRA() then
			rewardCell:setPosition(450 - (i - 1) * 120, 200)
		else
			rewardCell:setPosition(90 + (i - 1) * 120, 200)
		end
		rewardCell:addTo(self.Panel_cut)
	end
	self:updateBtnState()
end
function sinbadTreasureExtraView:updateBtnState()
	local num, nextNum = sinbadTreasureCtrl:getNextBlessRewardNum()
	print("num, nextNum", num, nextNum)
	self.num = num
	if 0 < num then
		self.Button_receive:setTouchEnabled(true)
	else
		self.Button_receive:setTouchEnabled(false)
		self.Button_receive:setBright(false)
	end
	if self.num > 0 then
		sinbadTreasureCtrl = nil
		;(nil).num = self.num
		if i18n("Sinbad_text_31", nil) then
			goto lbl_41
		end
	end
	::lbl_41::
	self.Button_receive:setTitleText((i18n("common_text_4120")))
end
function sinbadTreasureExtraView:buttonGetCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.num > 0 then
			local activityData = sinbadTreasureCtrl:getActivityData()
			local level = activityData.activityStage + 1
			if 2 < level then
				SoraDShowMsgTip(i18n("Sinbad_text_18"))
				SoraDRemoveAllExceptPanelFromManager(SoraDSearchPanelFromManagerByName("EventCenterView"))
				clientEventMgr.singleClickEvent(gActivityTimeActivityID.SINBAD_TREASURE)
				return
			end
			SoraDShowLoading(self)
			sinbadTreasureCtrl:reqStageTwoExtraReward(self.num)
		end
	end
end
return sinbadTreasureExtraView
