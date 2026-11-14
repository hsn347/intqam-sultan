local activity_9001655_Ctrl = SoraDGetCtrl("activity_9001655_Ctrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001655_Read = include("activity_9001655_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001655Panel = class("Activity_9001655Panel", baseFguiPanel)
function Activity_9001655Panel:ctor(...)
	Activity_9001655Panel.super.ctor(self, ...)
	print("Activity_9001655Panel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEW_STAR_MOON_TREASURE_ACTIVITY
end
function Activity_9001655Panel:onInit()
	print("=======Activity_9001655Panel:onInit")
	_UPVALUE12_, self.starSign = print, nil
	self.starSignArray, print[1] = print, 1
	self.starSignArray, print[2] = print, 2
	self.starSignArray, print[3] = print, 3
	self.starSignArray, print[4] = print, 4
	self.starSignArray, print[5] = print, 5
	self.starSignArray, print[6] = print, 6
	self.starSignArray, print[7] = print, 7
	self.starSignArray, print[8] = print, 8
	self.starSignArray, print[9] = print, 9
	self.starSignArray, print[10] = print, 10
	self.starSignArray, print[11] = print, 11
	self.starSignArray, print[12] = print, 12
	self.fields.Com_title:initData(i18n("activity_name_9001655"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	fguiHelper.SoraDSetComFields(self)
	self.fields.mv_sxb:setAllFrameName("9001655_boom_%.2d.png", 1)
	self.fields.mv_xb:setAllFrameName("9001655_boom_%.2d.png", 1)
	self.fields.mv_xb:setVisible(false)
	self.fields.Button_reward:setString(i18n("constellation_departure_text6"))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Btn_cost:setString(i18n("Shine_text_05"))
	self.fields.Btn_cost:addClickListener(handler(self, self.btnCostClick))
	self.fields.Text_warn:setString(i18n("constellation_departure_text3"))
	self.fields.Text_tip:setString(i18n("constellation_departure_text5"))
end
function Activity_9001655Panel:onShow()
	print("=======Activity_9001655Panel:onShow")
	self.fields.Com_bg:setGradientColor()
	local birthDay = exaltedPrivilegeCtrl:getBirthdayInfo()
	local info = lordInfoCtrl:getLordInfo()
	local createTime = info.base.createTime
	self.starSign = SoraDGetStarSigns(birthDay.month, birthDay.day, createTime) or gStarSigns.waterCarrier
	self:initStarSigns()
	self.fields.Com_starSign:init(self.starSign, true)
	local rateItem = activity_9001655_Read.getRareItem()
	self.fields.item_rate:initData(rateItem.id, rateItem.count)
	activity_9001655_Ctrl:sendReqInitDataMsg()
	SoraDShowLoading(self)
end
function Activity_9001655Panel:onMsgUpdateView(target, data)
	SoraDCloseLoading(self)
	self.history = activity_9001655_Ctrl:getHistory()
	local round = activity_9001655_Ctrl:getRound()
	self.costInfo = activity_9001655_Read.getCostByRound(round)
	self.myCount = backpackCtrl:getItemCount(self.costInfo.id)
	self.fields.Com_have:initData(self.costInfo.id)
	self.fields.Com_have:updateNum(self.myCount)
	self.fields.Btn_cost:setCost2(self.costInfo.id, self.costInfo.count, self.myCount)
	self:setStarSigns(data)
end
function Activity_9001655Panel:initStarSigns()
	if self.starSign ~= 2 then
		self.starSignArray[2] = self.starSign
		self.starSignArray[self.starSign] = 2
	end
	for k, v in ipairs(self.starSignArray) do
		self.fields["starSign_" .. k]:init(v)
	end
end
function Activity_9001655Panel:setStarSigns(data)
	local historyMap = activity_9001655_Ctrl:getHistoryMap()
	if data and data.position then
		local effectPos = data.position
		if data.position == 1 then
			effectPos = 2
		elseif data.position == 2 then
			effectPos = self.starSign ~= 2 and self.starSign or 1
		elseif data.position == self.starSign then
			effectPos = 1
		end
		local targetObj = self.fields["starSign_" .. effectPos]
		targetObj:initData(data.position)
		print("effectPos====", effectPos, self.starSign, data.position)
		self.fields.mv_xb:setVisible(true)
		self.fields.mv_xb:setPosition(cc.p(targetObj:getPositionX(), targetObj:getPositionY()))
		self.fields.mv_xb:setScale(targetObj:getScaleX() * 2)
		self.fields.mv_xb:setPlaySettings(0, -1, 1, -1, function()
			self.fields.mv_xb:setVisible(false)
		end)
	else
		for pos, _ in pairs(historyMap) do
			if pos == 1 then
				self.fields.starSign_2:initData(pos)
			elseif pos == 2 then
				local rPos = self.starSign ~= 2 and self.starSign or 1
				self.fields["starSign_" .. rPos]:initData(pos)
			elseif pos == self.starSign then
				self.fields.starSign_1:initData(pos)
			else
				self.fields["starSign_" .. pos]:initData(pos)
			end
		end
	end
	self.fields.Btn_cost:setBright(#self.history < #self.starSignArray)
end
function Activity_9001655Panel:btnCostClick()
	SoraDPlaySound()
	if #self.history >= #self.starSignArray then
		SoraDShowMsgTip(i18n("universe_text_04"))
		return
	end
	if self.myCount < self.costInfo.count then
		_ENV = i18n("universe_text_04")
		i18n("universe_text_04").content = i18n("constellation_departure_text4")
		i18n("universe_text_04").confirmString = i18n("common_text_204")
		i18n("universe_text_04").confirmFunc = function()
			_ENV = nil
			;(nil).itemID = self.costInfo.id
			uiManager:show("CommonSourceGuide", nil)
		end
		uiManager:show("MessageBox", i18n("universe_text_04"))
		return
	end
	activity_9001655_Ctrl:reqSearchMsg()
	SoraDShowLoading(self)
end
function Activity_9001655Panel:btnRewardClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001655_reward")
end
function Activity_9001655Panel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("constellation_departure_text1")
	uiManager:show("RuleView", nil)
end
return Activity_9001655Panel
