local luckyFalconCtrl = SoraDGetCtrl("luckyFalconCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local luckyFalconRead = include("luckyFalconRead")
local MAX_AWARD_NUM = 20
local luckyFalconRewardDetailView = class("luckyFalconRewardDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("luckyFalconRewardDetailView")
	end
	return target
end)
function luckyFalconRewardDetailView:ctor()
	self:initControls()
	self:initData()
end
function luckyFalconRewardDetailView:initControls(...)
	SoraDGetAllChildFromWidget(self, self)
	self.awardArray, _ENV = SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget
	self.Text_detail:setString(i18n("pray_text_11"))
	self.Text_get:setString(i18n("luckyFalcon_text16"))
end
function luckyFalconRewardDetailView:initData()
	local classType = luckyFalconCtrl:getClassType()
	local poolRewardList = luckyFalconRead.getAllPoolRewardInfo(classType)
	self:initScroll(poolRewardList)
end
function luckyFalconRewardDetailView:initScroll(poolRewardList)
	if not poolRewardList then
		return
	end
	self.ScrollView_1:removeAllChildren()
	local sSize = self.ScrollView_1:getContentSize()
	local sH = math.max(sSize.height, #poolRewardList * 30)
	self.ScrollView_1:setInnerContainerSize(cc.size(sSize.width, sH))
	for k, v in ipairs(poolRewardList) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setOwnView(self)
			if k < 5 then
				self.awardArray[k]:setPosition(60 + (k - 1) * 120, sH - 60)
			elseif k < 9 then
				self.awardArray[k]:setPosition(60 + (k - 5) * 120, sH - 180)
			elseif k < 13 then
				self.awardArray[k]:setPosition(60 + (k - 9) * 120, sH - 300)
			elseif k < 17 then
				self.awardArray[k]:setPosition(60 + (k - 13) * 120, sH - 420)
			else
				self.awardArray[k]:setPosition(60 + (k - 17) * 120, sH - 540)
			end
			self.awardArray[k]:addTo(self.ScrollView_1)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #poolRewardList then
		for k = #self.awardArray, #poolRewardList + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
end
return luckyFalconRewardDetailView
