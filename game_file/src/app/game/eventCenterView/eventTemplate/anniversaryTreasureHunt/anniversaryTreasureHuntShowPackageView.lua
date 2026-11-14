local anniversaryTreasureHuntRead = include("anniversaryTreasureHuntRead")
local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local anniversaryTreasureHuntCtrl = SoraDGetCtrl("anniversaryTreasureHuntCtrl")
local rechargeRead = include("rechargeRead")
local anniversaryTreasureHuntShowPackageView = class("anniversaryTreasureHuntShowPackageView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("anniversaryTreasureHuntShowPackageView")
	end
	return target
end)
local MAX_AWARD_NUM = 8
_ENV, _ENV = nil, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("anniversaryTreasureHuntShowPackageView")
	end
	return target
end
_ENV, (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("anniversaryTreasureHuntShowPackageView")
	end
	return target
end)[1], (nil).price = nil, nil, 4.99
_ENV, (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("anniversaryTreasureHuntShowPackageView")
	end
	return target
end)[2], (nil).price = nil, nil, 9.99
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("anniversaryTreasureHuntShowPackageView")
	end
	return target
end)[3], (nil).price = nil, 19.99
local function priceList(target)
	if target == nil then
		return SoraDCreateTouchPanel("anniversaryTreasureHuntShowPackageView")
	end
	return target
end
function anniversaryTreasureHuntShowPackageView:ctor()
	self:initControls()
	self:initScroll()
end
function anniversaryTreasureHuntShowPackageView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_TREASURE_HUNT
end
function anniversaryTreasureHuntShowPackageView:initScroll()
	self.ScrollView_2:removeAllChildren()
	local totalHeight = 850
	local scrollH = math.max(self.ScrollView_2:getContentSize().height, totalHeight * #priceList)
	self.ScrollView_2:setInnerContainerSize(cc.size(self.ScrollView_2:getContentSize().width, scrollH))
	local starLv = anniversaryTreasureHuntCtrl:getStarLv()
	for i, v in ipairs(priceList) do
		local packageInfo = anniversaryTreasureHuntRead:getTreasureHuntPackageInfoByPrice(v.price)
		local titleNode = self.singleTitle:clone()
		titleNode:setPosition(300, scrollH - totalHeight * (i - 1))
		titleNode:addTo(self.ScrollView_2)
		local txtTitle = SoraDGetChildByName(titleNode, "txtPackageTitle")
		_ENV = cc.size(self.ScrollView_2:getContentSize().width, scrollH)
		cc.size(self.ScrollView_2:getContentSize().width, scrollH).price = v.price
		txtTitle:setString(i18n("anniversary_text_10", cc.size(self.ScrollView_2:getContentSize().width, scrollH)))
		local index = 1
		for j, m in ipairs(packageInfo) do
			local limitInfo = anniversaryTreasureHuntRead:getMerchantPackageInfoByID(m.index)
			local lvLimit = limitInfo.lvLimit
			local singleNode = SoraDGetChildByName(titleNode, "singleNode_" .. index)
			if starLv >= lvLimit[1] and starLv <= lvLimit[2] and singleNode then
				index = index + 1
				anniversaryTreasureHuntCtrl = index
				index[1] = "id"
				index[2] = "count"
				local rewardList = serviceFunctions.tableFormat(m.result, index)
				local txtLimit = SoraDGetChildByName(singleNode, "txtlimit")
				_ENV = i18n("anniversary_text_10", cc.size(self.ScrollView_2:getContentSize().width, scrollH))
				i18n("anniversary_text_10", cc.size(self.ScrollView_2:getContentSize().width, scrollH)).num = limitInfo.activityLimit
				txtLimit:setString(i18n("common_text_4505", i18n("anniversary_text_10", cc.size(self.ScrollView_2:getContentSize().width, scrollH))))
				for k = 1, #rewardList do
					self.awardArray, _ENV = i18n("common_text_4505", i18n("anniversary_text_10", cc.size(self.ScrollView_2:getContentSize().width, scrollH)))
					if not self.awardArray[k] and k <= MAX_AWARD_NUM then
						self.awardArray[k] = include("commonItemAward").new()
						self.awardArray[k]:setScale(0.7)
						self.awardArray[k]:setBaseScale(1.0)
						self.awardArray[k]:setOwnView(self)
						if k <= 4 then
							self.awardArray[k]:setPosition(-40, -45 - (k - 1) * 75)
						elseif k <= 8 then
							self.awardArray[k]:setPosition(40, -45 - (k - 5) * 75)
						end
						self.awardArray[k]:addTo(singleNode)
					end
					if self.awardArray[k] then
						self.awardArray[k]:initData(rewardList[k].id, rewardList[k].count)
						self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
					end
				end
				if #self.awardArray > #rewardList then
					for k = #self.awardArray, #rewardList + 1, -1 do
						self.awardArray[k]:setVisible(false)
					end
				end
			end
		end
	end
end
function anniversaryTreasureHuntShowPackageView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return anniversaryTreasureHuntShowPackageView
