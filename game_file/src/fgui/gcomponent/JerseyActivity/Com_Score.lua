local jerseyRead = include("jerseyRead")
local footballClothesCtrl = SoraDGetCtrl("footballClothesCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Score = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://JerseyActivity/Com_Score", Com_Score)
function Com_Score:onInit()
	self.itemsList, _ENV = nil, nil
	self.maxLen = 550
	self.maxPosx = 595
	self.fields.Button_Q:addClickEventListener(handler(self, self.onClickQuestion))
end
function Com_Score:onShow()
end
function Com_Score:initData(type)
	self.type = type
	self.awardList = jerseyRead.getAwardList(SoraDGetCtrl("activityShowCtrl"):getParamClassType(gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY), type)
	self.maxValue = self.awardList[#self.awardList].num
	self.fields.Com_BosList:setBarMax(self.maxValue)
	table.sort(self.awardList, function(l, r)
		return l.num < r.num
	end)
	dump(self.awardList, "self.awardList")
	self.totalNum = table.nums(self.awardList)
	self.fields.Com_BosList:initData(self.totalNum, self.awardList, self.type)
	self.controllers.c1:setSelectedIndex(self.type - 1)
end
function Com_Score:updateItems()
	self:updateScore(footballClothesCtrl:getScoreByType(self.type))
	self.fields.Com_BosList:updateItems()
end
function Com_Score:updateScore(score)
	local percent = 0
	local percentOffset = 100 / (self.totalNum - 1)
	local lastNum = self.awardList[1].num
	local maxNum = 0
	if score <= lastNum then
		percent = 0
	elseif score >= self.maxValue then
		percent = 100
	else
		for i, v in ipairs(self.awardList) do
			if score <= v.num then
				maxNum = v.num
				break
			end
			lastNum = v.num
			if i ~= 1 then
				percent = percent + percentOffset
			end
		end
		percent = percent + math.max(0, score - lastNum) / (maxNum - lastNum) * percentOffset
	end
	print("...", percent)
	self.fields.Com_BosList:setBarValue(percent / 100 * self.maxValue)
end
function Com_Score:onClickQuestion()
	SoraDPlaySound()
	uiManager:show("jerseyScore")
end
return Com_Score
