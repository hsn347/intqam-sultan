local MAX_AWARD_NUM = 4
local allianceActiveLogSingle = class("allianceActiveLogSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceActiveLogSingle")
	end
	return target
end)
function allianceActiveLogSingle:ctor()
	self.awardArray, _ENV = nil, nil
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	SoraDChangeTextToHtml(self.Text_des)
	self.Text_des:setTextColor(cc.c3b(215, 195, 155))
	self.Text_des:setColor(cc.c3b(255, 255, 255))
end
function allianceActiveLogSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	self.ownScroll = otherData.scroll
	local _ENV, config = otherData.scroll, otherData.scroll
	config.name = string.htmlspecialchars(self.data.name) or ""
	config.num = self.data.task.acceptLimit or 0
	config.taskdes = i18n(self.data.des)
	local numColor = cc.c3b(255, 200, 100)
	_ENV, _ENV = nil, nil
	;(nil).name, (nil).color = nil, numColor
	local strScore = i18n_html("alliance_text_45", config, nil)
	self.Text_des:setString(strScore)
	local timeStr = _G.SoraDConverTimeStr(data.publishTime or 0)
	_ENV = nil
	;(nil).time = timeStr
	self.Text_time:setString(i18n("alliance_text_46", nil))
	self:setAward()
end
function allianceActiveLogSingle:setAward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(self.data.task.reward, nil)
	for k, v in ipairs(rewardList) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(436 - (60 + (k - 1) * 90), 520), 58)
			self.awardArray[k]:addTo(self, 1)
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
return allianceActiveLogSingle
