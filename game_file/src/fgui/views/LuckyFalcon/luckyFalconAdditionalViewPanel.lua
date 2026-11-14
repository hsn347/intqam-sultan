local luckyFalconCtrl = SoraDGetCtrl("luckyFalconCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local luckyFalconRead = include("luckyFalconRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local luckyFalconAdditionalViewPanel = class("luckyFalconAdditionalViewPanel", baseFguiPanel)
function luckyFalconAdditionalViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("luckyFalconAdditionalViewPanel:ctor", self.viewName)
end
function luckyFalconAdditionalViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function luckyFalconAdditionalViewPanel:onInit()
	print("=======luckyFalconAdditionalViewPanel:onInit")
	self.showHeroList, _ENV = print, print
	self.fields.Text_title:setString(i18n("Promise_Summit_text_41"))
	self.fields.Text_ins:setString(i18n("luckyFalcon_text06"))
	self.fields.Text_long:setString(i18n("luckyFalcon_text15"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.bar:setMax(100)
	self.fields.Text_title:fixPos()
	self.fields.Text_ins:fixPos()
	self.fields.Text_count:fixPos()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.bar:fixPos()
	for i = 1, 9 do
		self.fields["n" .. i]:fixPos()
		self.fields["box" .. i]:fixPos()
	end
end
function luckyFalconAdditionalViewPanel:onShow()
	print("=======luckyFalconAdditionalViewPanel:onShow")
	self:initData()
end
function luckyFalconAdditionalViewPanel:onItemRenderer(index, obj)
	obj:initData(self.showHeroList[index + 1])
end
function luckyFalconAdditionalViewPanel:initData()
	local rotteryTimes = luckyFalconCtrl:getRotteryTimes()
	local classType = luckyFalconCtrl:getClassType()
	local heroName = luckyFalconRead.getHeroNameList(classType)
	self.showHeroList = luckyFalconRead.getHeroList(classType)
	self.fields.List:setNumItems(#self.showHeroList)
	if heroName and next(heroName) then
		local heroNameStr = ""
		for i, v in ipairs(heroName) do
			if heroNameStr == "" then
				heroNameStr = i18n(v)
			else
				heroNameStr = string.format("%s,%s", heroNameStr, i18n(v))
			end
		end
		local str = 1 < #heroName and "luckyFalcon_text21" or "luckyFalcon_text20"
		luckyFalconCtrl = string.format("%s,%s", heroNameStr, i18n(v))
		string.format("%s,%s", heroNameStr, i18n(v)).name = fguiHelper.getColorString("#AE5405", heroNameStr)
		self.fields.Text_HeroShow:setString(i18n(str, (string.format("%s,%s", heroNameStr, i18n(v)))))
	end
	self.stageList = luckyFalconRead.getRewardStageTimes(classType)
	local val = self:getPercentCalculate(rotteryTimes, self.stageList)
	self.fields.bar:setValue(val)
	luckyFalconCtrl = i18n(str, (string.format("%s,%s", heroNameStr, i18n(v))))
	i18n(str, (string.format("%s,%s", heroNameStr, i18n(v)))).var = fguiHelper.getColorString("#FFAA11", rotteryTimes)
	self.fields.Text_count:setString(i18n("luckyFalcon_text14", i18n(str, (string.format("%s,%s", heroNameStr, i18n(v))))))
	for i = 1, 9 do
		self.fields["n" .. i]:setString(self.stageList[i])
		local boxStatus = 1
		local isGot = luckyFalconCtrl:isStageRewardGot(i)
		if isGot then
			boxStatus = 3
		elseif rotteryTimes >= self.stageList[i] then
			boxStatus = 2
		end
		self.fields["box" .. i]:initData(i, boxStatus)
	end
end
function luckyFalconAdditionalViewPanel:getPercentCalculate(rotteryTimes, stageList)
	local val = 0
	local minVar = stageList[1]
	local maxVar = stageList[#stageList]
	local per = 100 / #stageList
	local index = 1
	for k, v in ipairs(stageList) do
		if rotteryTimes < v then
			index = k
			break
		end
	end
	if rotteryTimes <= minVar then
		val = rotteryTimes / minVar * per
	elseif rotteryTimes >= maxVar then
		val = 100
	else
		val = (index - 1) * per + (rotteryTimes - stageList[index - 1]) * per / (stageList[index] - stageList[index - 1])
	end
	return val
end
return luckyFalconAdditionalViewPanel
