local MAX_AWARD_NUM = 4
local allianceActiveLevelSingle = class("allianceActiveLevelSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceActiveLevelSingle")
	end
	return target
end)
function allianceActiveLevelSingle:ctor()
	self.awardArray, _ENV = nil, nil
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Font_level = SoraDGetChildByName(self, "Font_level")
end
function allianceActiveLevelSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	self.ownScroll = otherData.scroll
	_ENV = nil
	;(nil).num = string.formatnumberthousands(self.data.activeNum[1])
	self.Text_des:setString(i18n("alliance_text_26", nil))
	self.Font_level:setString(self.data.index)
	self:setAward()
end
function allianceActiveLevelSingle:setAward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(self.data.reward, nil)
	for k, v in ipairs(rewardList) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.7)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(386 - (60 + (k - 1) * 90), 520), 45)
			self.awardArray[k]:addTo(self)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #rewardList then
		for k = #self.awardArray, #rewardList + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
end
return allianceActiveLevelSingle
