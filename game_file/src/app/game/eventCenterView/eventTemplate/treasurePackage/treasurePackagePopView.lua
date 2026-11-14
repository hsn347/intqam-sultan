local purchaseRebateCtrl = SoraDGetCtrl("purchaseRebateCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local publicRead = include("publicRead")
local treasurePackageRead = include("treasurePackageRead")
local treasurePackagePopView = class("treasurePackagePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("treasurePackagePopView")
	end
	return target
end)
MAX_AWARD_NUM = 4
function treasurePackagePopView:ctor()
	self:initControls()
end
function treasurePackagePopView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.awardArray, _ENV = SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget
	self.textIns = SoraDChangeTextToHtml(self.textIns)
	self.txtOpenIns = SoraDChangeTextToHtml(self.txtOpenIns)
	self.Panel_cut:setPositionY(display.height / 2)
end
function treasurePackagePopView:initData(packageIndex)
	if not packageIndex then
		return
	end
	local packageName = treasurePackageRead:getPackageNameByIndex(packageIndex)
	self.Text_name:setString(i18n(packageName))
	local taskData = purchaseRebateCtrl:getRebateTaskData()
	local classStr = ""
	if packageIndex == 1 then
		classStr = "first"
	elseif packageIndex == 2 then
		classStr = "second"
	elseif packageIndex == 3 then
		classStr = "third"
	end
	for i = 1, #taskData do
		if taskData[i].taskID == packageIndex then
			if taskData[i].status == gTreasurePackageType.LOCKED then
				self.iconTreasure:setSpriteFrame("icon_treasure_package_" .. classStr .. "_lock.png")
			elseif taskData[i].status == gTreasurePackageType.UNLOCK then
				self.iconTreasure:setSpriteFrame("icon_treasure_package_" .. classStr .. "_open.png")
			elseif taskData[i].status == gTreasurePackageType.CLAIMED then
				self.iconTreasure:setSpriteFrame("icon_treasure_package_" .. classStr .. "_empty.png")
			end
		end
	end
	local oriPrice = treasurePackageRead:getPackageSoldPriceByIndex(packageIndex)
	if SoraDGetDefaultLanguage() == "ko" then
		oriPrice = paymentManager.ko_judgePrice(oriPrice)
	end
	treasurePackageRead = self.iconTreasure
	self.iconTreasure.price = oriPrice
	treasurePackageRead, treasurePackageRead, self.iconTreasure.num = treasurePackageRead, treasurePackageRead:getVipPointsByIndex(packageIndex), treasurePackageRead:getVipPointsByIndex(packageIndex)
	treasurePackageRead, treasurePackageRead:getVipPointsByIndex(packageIndex).price, treasurePackageRead.color = treasurePackageRead, treasurePackageRead, "#FFFF00"
	treasurePackageRead:getVipPointsByIndex(packageIndex).num, treasurePackageRead.color = treasurePackageRead, "#FFFF00"
	self.textIns:setString(i18n_html("Gather_text_12", self.iconTreasure, (treasurePackageRead:getVipPointsByIndex(packageIndex))))
	treasurePackageRead = i18n_html("Gather_text_12", self.iconTreasure, (treasurePackageRead:getVipPointsByIndex(packageIndex)))
	treasurePackageRead, treasurePackageRead, i18n_html("Gather_text_12", self.iconTreasure, (treasurePackageRead:getVipPointsByIndex(packageIndex))).num = i18n_html("Gather_text_12", self.iconTreasure, (treasurePackageRead:getVipPointsByIndex(packageIndex)))
	i18n_html("Gather_text_12", self.iconTreasure, (treasurePackageRead:getVipPointsByIndex(packageIndex))).num, i18n_html("Gather_text_12", self.iconTreasure, (treasurePackageRead:getVipPointsByIndex(packageIndex))).color = i18n_html("Gather_text_12", self.iconTreasure, (treasurePackageRead:getVipPointsByIndex(packageIndex)))
	self.txtOpenIns:setString(i18n_html("Gather_text_13", i18n_html("Gather_text_12", self.iconTreasure, (treasurePackageRead:getVipPointsByIndex(packageIndex)))))
	local rewardlist = treasurePackageRead:getRewardByIndex(packageIndex)
	for k, v in ipairs(rewardlist) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(1.0)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self)
			if #rewardlist == 4 then
				self.awardArray[k]:setPosition(90 + (k - 1) * 120, 80)
			elseif #rewardlist == 3 then
				self.awardArray[k]:setPosition(150 + (k - 1) * 120, 80)
			end
			self.awardArray[k]:addTo(self.Panel_cut)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	for i = 1, #self.awardArray do
		self.awardArray[i]:setVisible(i <= #rewardlist)
	end
end
return treasurePackagePopView
