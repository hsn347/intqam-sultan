local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local anniversaryTreasureHuntClickRewardView = class("anniversaryTreasureHuntClickRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("anniversaryTreasureHuntClickRewardView")
	end
	return target
end)
local MAX_AWARD_NUM = 12
function anniversaryTreasureHuntClickRewardView:ctor()
	self:initControls()
end
function anniversaryTreasureHuntClickRewardView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.awardArray, _ENV = SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget
	self.text_ins:setString(i18n("anniversary_text_09"))
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_TREASURE_HUNT
end
function anniversaryTreasureHuntClickRewardView:initData(rewardList, packageID)
	if not rewardList then
		return
	end
	if not packageID then
		return
	end
	self.rewardList = rewardList
	self.packageID = packageID
	if 1407318 == self.packageID then
		self.icon_znxb_hjbox_01_2:setSpriteFrame("icon_znxb_bybox_01.png")
	end
	self:initScroll()
end
function anniversaryTreasureHuntClickRewardView:initScroll()
	self.ScrollView_reward:removeAllChildren()
	local scrollH = math.max(self.ScrollView_reward:getContentSize().height, 320)
	self.ScrollView_reward:setInnerContainerSize(cc.size(self.ScrollView_reward:getContentSize().width, scrollH))
	for k, v in ipairs(self.rewardList) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(1.0)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self)
			if k <= 4 then
				self.awardArray[k]:setPosition(80 + (k - 1) * 130, scrollH - 50)
			elseif k <= 8 then
				self.awardArray[k]:setPosition(80 + (k - 5) * 130, scrollH - 160)
			else
				self.awardArray[k]:setPosition(80 + (k - 9) * 80, scrollH - 270)
			end
			self.awardArray[k]:addTo(self.ScrollView_reward)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #self.rewardList then
		for k = #self.awardArray, #self.rewardList + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
end
function anniversaryTreasureHuntClickRewardView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return anniversaryTreasureHuntClickRewardView
