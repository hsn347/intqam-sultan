local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local signRewardCtrl = gametop.playertop_:getModule("signRewardCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ButtonDay = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ThirtyDaySign2021/ButtonDay", ButtonDay)
function ButtonDay:onInit()
	self.day = 0
	self.type = "0"
	self:addClickListener(handler(self, self.onClickDay))
	self.fields.Usm_signSuccess:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	function self.callFunc()
		self.transitions.t0:play()
		self.transitions.t1:play()
		self.fields.Usm_signSuccess:setVisible(true)
	end
end
function ButtonDay:showEffect()
	SoraDCreateDelayTimer(self, self.callFunc, 1.5)
end
function ButtonDay:initData(index)
	self.day = index
	local rewards = signRewardCtrl:getAwardByDay(self.day)
	local iconId = rewards[1]
	local iconName = publicRead.getIcon(iconId)
	self.fields.icon:setURL(iconName)
	self.fields.num:setURL("day" .. index .. ".png")
	self.type = signRewardCtrl:getSignTypeByDay(index)
	self.fields.highlight:setVisible(false)
	self.fields.redPoint:setVisible(false)
	self.fields.icon_resign:setVisible(false)
	self.fields.tex:setVisible(false)
	self.fields.mask:setVisible(false)
	self:showIcon(false)
	if signRewardCtrl:getCurDay() > self.day and self.type == "0" then
		self.fields.mask:setVisible(true)
		self.fields.icon_resign:setVisible(true)
		self.fields.tex:setVisible(true)
		self:showIcon(true)
	elseif self.type == "0" then
		if signRewardCtrl:getCurDay() == self.day then
			self.fields.highlight:setVisible(true)
			self.fields.redPoint:setVisible(true)
			self:showIcon(true)
		end
	else
		self.fields.tex:setVisible(true)
		self.fields.ok:setVisible(true)
		self.fields.num:setVisible(false)
	end
end
function ButtonDay:showIcon(flag)
	self.fields.num:setVisible(not flag)
	self.fields.icon:setVisible(flag)
end
function ButtonDay:onClickDay()
	SoraDPlaySound()
	self.type = signRewardCtrl:getSignTypeByDay(self.day)
	if signRewardCtrl:getCurDay() > self.day and self.type == "0" then
		self:Resign()
	elseif self.type == "0" then
		self:NormalSign()
	else
		self:HadSign()
	end
	self:initData(self.day)
end
function ButtonDay:setNumColor(str, num, color)
	local colorNum = fguiHelper.getColorString(color, num)
	str = string.gsub(str, tostring(num), colorNum)
	return str
end
function ButtonDay:getColoredDayNum()
	local color = "#4CE61A"
	_ENV = nil
	;(nil).day = self.day
	local str = i18n("common_text_2872", nil)
	str = self:setNumColor(str, self.day, color)
	return str
end
function ButtonDay:NormalSign()
	local signHandle = function()
		if signRewardCtrl:getCurDay() == self.day then
			signRewardCtrl:sendSignMsg()
			return true
		else
			SoraDShowMsgTip(i18n("common_text_3070"))
			return false
		end
	end
	self.rewards = signRewardCtrl:getAwardByDay(self.day)
	_UPVALUE2_ = self.day
	self.day[1] = "id"
	self.day[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.rewards, self.day)
	local flag = true
	if signRewardCtrl:getCurDay() == self.day then
		flag = false
	end
	signRewardCtrl = signRewardCtrl:getCurDay()
	signRewardCtrl:getCurDay().disabled = flag
	signRewardCtrl:getCurDay().greenFlag = true
	signRewardCtrl:getCurDay().title = i18n("decrypt_text_03")
	signRewardCtrl:getCurDay().btnText = i18n("common_text_2873")
	signRewardCtrl:getCurDay().tip = self:getColoredDayNum()
	signRewardCtrl:getCurDay().rewards = self.rewards
	signRewardCtrl:getCurDay().comfirmFlag = true
	local signRewardCtrl:getCurDay().handle, param = signHandle, signRewardCtrl:getCurDay()
	uiManager:show("SignRewardView", param)
end
function ButtonDay:HadSign()
	local HadSignHandle = function()
		SoraDShowMsgTip(i18n("common_text_2874"))
		return false
	end
	self.rewards = signRewardCtrl:getAwardByDay(self.day)
	_UPVALUE2_ = self.day
	self.day[1] = "id"
	self.day[2] = "count"
	_ENV, self.rewards = serviceFunctions.tableFormat(self.rewards, self.day), serviceFunctions.tableFormat(self.rewards, self.day)
	serviceFunctions.tableFormat(self.rewards, self.day).disabled = true
	serviceFunctions.tableFormat(self.rewards, self.day).greenFlag = true
	serviceFunctions.tableFormat(self.rewards, self.day).title = i18n("decrypt_text_03")
	serviceFunctions.tableFormat(self.rewards, self.day).btnText = i18n("common_text_2874")
	serviceFunctions.tableFormat(self.rewards, self.day).tip = self:getColoredDayNum()
	serviceFunctions.tableFormat(self.rewards, self.day).rewards = self.rewards
	serviceFunctions.tableFormat(self.rewards, self.day).comfirmFlag = true
	local serviceFunctions.tableFormat(self.rewards, self.day).handle, param = HadSignHandle, serviceFunctions.tableFormat(self.rewards, self.day)
	uiManager:show("SignRewardView", param)
end
function ButtonDay:Resign()
	local resignHandle = function()
		if SoraDEnoughGold(signRewardCtrl:getCostGold()) then
			signRewardCtrl:sendUseGoldSignMsg(self.day)
			return true
		else
			return false
		end
	end
	self.rewards = signRewardCtrl:getAwardByDay(self.day)
	_UPVALUE2_ = self.day
	self.day[1] = "id"
	self.day[2] = "count"
	_ENV, self.rewards = serviceFunctions.tableFormat(self.rewards, self.day), serviceFunctions.tableFormat(self.rewards, self.day)
	serviceFunctions.tableFormat(self.rewards, self.day).disabled = false
	serviceFunctions.tableFormat(self.rewards, self.day).greenFlag = true
	serviceFunctions.tableFormat(self.rewards, self.day).title = i18n("decrypt_text_03")
	serviceFunctions.tableFormat(self.rewards, self.day).btnText = i18n("common_text_2875")
	serviceFunctions.tableFormat(self.rewards, self.day).tip = self:getColoredDayNum()
	serviceFunctions.tableFormat(self.rewards, self.day).rewards = self.rewards
	serviceFunctions.tableFormat(self.rewards, self.day).comfirmFlag = false
	serviceFunctions.tableFormat(self.rewards, self.day).cost = signRewardCtrl:getCostGold()
	local serviceFunctions.tableFormat(self.rewards, self.day).handle, param = resignHandle, serviceFunctions.tableFormat(self.rewards, self.day)
	uiManager:show("SignRewardView", param)
end
function ButtonDay:onShow()
end
return ButtonDay
