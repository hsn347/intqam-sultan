local constantRead = include("constantRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local luckyWretchRead = include("luckyWretchRead")
local luckyWretchCtrl = SoraDGetCtrl("luckyWretchCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LuckyWretchMainPanel = class("LuckyWretchMainPanel", baseFguiPanel)
function LuckyWretchMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("LuckyWretchMainPanel:ctor", self.viewName)
end
function LuckyWretchMainPanel:onInit()
	print("=======LuckyWretchMainPanel:onInit")
	self.boxInfo = luckyWretchRead.getStageConfig(luckyWretchCtrl:getClassType())
	self.activityID = gActivityTimeActivityID.LUCKY_WRETCH_ACTIVITY
	self.itemID = constantRead.getConstValue("LUCKY_TWIST_EGG_ITEM", 861001)
	self.fields.n12:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Com_title:initData(i18n("activity_name_9001494"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_Preaward:setString(i18n("magic_flip_2"))
	self.fields.Button_Preaward:addClickListener(handler(self, self.onClickPreaward))
	self.fields.Com_Have:initData(self.itemID)
	self.fields.Button_One:setString(i18n("Lucky_twist_egg_05"))
	self.fields.Button_One:addClickListener(handler(self, self.onClickOne))
	self.fields.Button_Ten:setString(i18n("Lucky_twist_egg_06"))
	self.fields.Button_Ten:addClickListener(handler(self, self.onClickTen))
	local fields = fguiHelper.get_fields(self.fields.Com_score)
	if not SoraDFIsRA() then
		fields.Bar_score:fixChildrenPos(false, true)
	end
	fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
end
function LuckyWretchMainPanel:onShow()
	print("=======LuckyWretchMainPanel:onShow")
	luckyWretchCtrl:reqLuckyWretchInit()
end
function LuckyWretchMainPanel:updateButton()
	self.fields.Button_One:setCost(self.itemID, 1)
	self.fields.Button_Ten:setCost(self.itemID, 10)
	self.fields.Com_Have:updateNum()
	_ENV = nil
	;(nil).num = luckyWretchCtrl:getLottoryTimes()
	self.fields.Text_Tip:setString(i18n("Lucky_twist_egg_02", nil))
end
function LuckyWretchMainPanel:updateView()
	self:updateButton()
	self:initProgress()
end
function LuckyWretchMainPanel:playFlipAnimation(grade, isGold)
	self.fields.icon:setURL(string.format("twist_egg_grade%d.png", grade))
	self.transitions.t0:play(1, 0, function()
		self.isOpen = false
	end)
	if isGold then
		self.fields.Usm_1:play(false)
	end
end
function LuckyWretchMainPanel:initProgress()
	local fields = fguiHelper.get_fields(self.fields.Com_score)
	local personScore = luckyWretchCtrl:getLottoryTimes()
	local passIndex = 0
	fields.List_box:setNumItems(#self.boxInfo)
	local singlePassPercent = 1 / (#self.boxInfo - 1) * 100
	for i, v in ipairs(self.boxInfo) do
		if personScore >= v.donateScore then
			passIndex = passIndex + 1
		end
	end
	if personScore <= self.boxInfo[1].donateScore then
		fields.Bar_score:setPercent(0)
	elseif passIndex < #self.boxInfo then
		local littlePercent = (personScore - self.boxInfo[passIndex].donateScore) / (self.boxInfo[passIndex + 1].donateScore - self.boxInfo[passIndex].donateScore) * singlePassPercent
		fields.Bar_score:setPercent((singlePassPercent * (passIndex - 1) + littlePercent) / 100)
	else
		fields.Bar_score:setPercent(1)
	end
end
function LuckyWretchMainPanel:onBoxRenderer(index, obj)
	local boxInfo = self.boxInfo[index + 1]
	obj:initData(boxInfo, index + 1)
	obj:setClickHandler(handler(self, self.buttonGetRewardCallBack))
end
function LuckyWretchMainPanel:buttonGetRewardCallBack(button, index)
	SoraDPlaySound()
	_ENV = nil
	;(nil).boxInfo = self.boxInfo[index]
	uiManager:show("LuckyWretchPop", nil)
end
function LuckyWretchMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Lucky_twist_egg_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function LuckyWretchMainPanel:onClickPreaward()
	SoraDPlaySound()
	uiManager:show("LuckyWretchReward")
end
function LuckyWretchMainPanel:onClickOne()
	SoraDPlaySound()
	if self.isOpen then
		return
	end
	if backpackCtrl:getItemCount(self.itemID) > 0 then
		self.isOpen = true
		luckyWretchCtrl:reqLuckyWretchLottery()
	else
		SoraDShowMsgTip(i18n("dragoncave_text_02"))
	end
end
function LuckyWretchMainPanel:onClickTen()
	SoraDPlaySound()
	if self.isOpen then
		return
	end
	if backpackCtrl:getItemCount(self.itemID) >= 10 then
		self.isOpen = true
		luckyWretchCtrl:reqLuckyWretchLotteryTen()
	else
		SoraDShowMsgTip(i18n("dragoncave_text_02"))
	end
end
return LuckyWretchMainPanel
