local gametop = gModuleMgr.getObject("gametop")
local unchartedCtrl = gametop.playertop_:getModule("unchartedCtrl")
local unchartedAdventureRead = include("unchartedAdventureRead")
local unchartedFinalGridRewardView = class("unchartedFinalGridRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("unchartedFinalGridRewardView")
	end
	return target
end)
function unchartedFinalGridRewardView:ctor()
	self:initControls()
	self:initData()
end
function unchartedFinalGridRewardView:initControls()
	self.panel = SoraDGetChildByName(self, "Panel_2")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.txtGold = SoraDGetChildByName(self, "text_remainSet")
	self.panel:setPositionY(display.height / 2)
	self.rewardlist = unchartedAdventureRead.getClearanceReward()
	self.unchartedInfo = unchartedCtrl:getUnchartedInfo()
end
function unchartedFinalGridRewardView:initData()
	_ENV = nil
	;(nil).Num = self.unchartedInfo.curLayer
	local str1 = string.format("%s（%s）", i18n("Secret_explore_text_03"), i18n("Secret_explore_text_05", nil))
	self.ccs_bg:setTitleName(str1)
	if self.unchartedInfo.curLayer <= #self.rewardlist then
		local point = unchartedAdventureRead.getPointsRewardByIndex(self.unchartedInfo.curLayer)
		local singlePosY = 0
		if math.floor(#self.rewardlist[self.unchartedInfo.curLayer] / 2) <= 4 then
			self.ccs_bg:setSize(cc.size(542, 240))
			self.ccs_bg:setPositionY(self.panel:getContentSize().height / 2 - 70)
			singlePosY = 100
		end
		for j = 1, #self.rewardlist[self.unchartedInfo.curLayer] / 2 do
			local itemKey = self.rewardlist[self.unchartedInfo.curLayer][2 * j - 1]
			local itemCount = self.rewardlist[self.unchartedInfo.curLayer][2 * j]
			local singleItem = include("itemSingleView").new()
			singleItem:setScale(0.65)
			singleItem:setItemDelegate(handler(self, self.singleItemClick))
			singleItem:setRechargeUse(true)
			singleItem:setButtonTag(itemKey)
			singleItem:setScroll(self.scroll)
			singleItem:sendParentToButton(self)
			if 1 < math.ceil(j / 4) then
				singleItem:setPosition(cc.p(40 + 120 * (math.floor(j % 4) - 1), 70 * math.ceil(j / 4)))
			else
				singleItem:setPosition(cc.p(40 + 120 * (j - 1), (260 - singlePosY) * math.ceil(j / 4)))
			end
			singleItem:addTo(self.ccs_bg)
			singleItem:initRechargeForRewardData(itemKey, itemCount)
		end
		local str2 = string.format("%s +%d", i18n("Secret_explore_text_17"), point)
		self.txtGold:setString(str2)
	else
		local point = unchartedAdventureRead.getPointsRewardByIndex(#self.rewardlist)
		for j = 1, #self.rewardlist[#self.rewardlist] / 2 do
			local itemKey = self.rewardlist[#self.rewardlist][2 * j - 1]
			local itemCount = self.rewardlist[#self.rewardlist][2 * j]
			local singleItem = include("itemSingleView").new()
			singleItem:setScale(0.65)
			singleItem:setItemDelegate(handler(self, self.singleItemClick))
			singleItem:setRechargeUse(true)
			singleItem:setButtonTag(itemKey)
			singleItem:setScroll(self.scroll)
			singleItem:sendParentToButton(self)
			if 1 < math.ceil(j / 4) then
				singleItem:setPosition(cc.p(40 + 120 * (math.floor(j % 4) - 1), 80 * math.ceil(j / 4)))
			else
				singleItem:setPosition(cc.p(40 + 120 * (j - 1), 280 * math.ceil(j / 4)))
			end
			singleItem:addTo(self.ccs_bg)
			singleItem:initRechargeForRewardData(itemKey, itemCount)
		end
		local str2 = string.format("%s +%d", i18n("Secret_explore_text_17"), point)
		self.txtGold:setString(str2)
	end
end
return unchartedFinalGridRewardView
