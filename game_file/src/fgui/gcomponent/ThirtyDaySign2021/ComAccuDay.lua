local gametop = gModuleMgr.getObject("gametop")
local signRewardCtrl = gametop.playertop_:getModule("signRewardCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ComAccuDay = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ThirtyDaySign2021/ComAccuDay", ComAccuDay)
function ComAccuDay:onInit()
	self.fields.Button_gift:addClickListener(handler(self, self.onClickCumuDaysReward))
	self.cumuDayArray = signRewardCtrl:getCumuDayArray()
end
function ComAccuDay:initData(cumuDaysIndex)
	self.cumuDaysIndex = cumuDaysIndex
	self.fields.Text_accuDays:setString(self.cumuDayArray[cumuDaysIndex])
	self.fields.Text_word:setString(i18n("common_text_548"))
	self.type = signRewardCtrl:getExtraRewardInfoByDay(self.cumuDayArray[self.cumuDaysIndex])
	self:setCumuTextColor(cc.c3b(215, 213, 197))
	if self.type == "1" then
		self:setCumuTextColor(cc.c3b(101, 101, 101))
		self.fields.Button_gift:setState(1)
	elseif self.type == "3" then
		self:setCumuTextColor(cc.c3b(255, 243, 146))
		self.fields.Button_gift:setState(2)
	else
		self.fields.Button_gift:setState(0)
	end
end
function ComAccuDay:setCumuTextColor(color)
	self.fields.Text_accuDays:setColor(color)
	self.fields.Text_word:setColor(color)
end
function ComAccuDay:onClickCumuDaysReward()
	SoraDPlaySound()
	if self.type == "1" then
		self:hadGetReward()
	elseif self.type == "2" then
		self:cannotGetReward()
	else
		if self.type == "3" then
			self:normalGetReward()
		else
		end
	end
end
function ComAccuDay:setNumColor(str, num, color)
	local colorNum = fguiHelper.getColorString(color, num)
	str = string.gsub(str, tostring(num), colorNum)
	return str
end
function ComAccuDay:getColoredDayNum()
	local color = "#4CE61A"
	local tNum = self.cumuDayArray[self.cumuDaysIndex]
	_ENV = nil
	;(nil).num = tNum
	local str = i18n("common_text_2877", nil)
	str = self:setNumColor(str, tNum, color)
	return str
end
function ComAccuDay:hadGetReward()
	local hadGet = function()
		SoraDShowMsgTip(i18n("common_text_1892"))
		return false
	end
	self.rewards = signRewardCtrl:getExtraAwardByDay(self.cumuDayArray[self.cumuDaysIndex])
	_UPVALUE2_ = self.cumuDayArray[self.cumuDaysIndex]
	self.cumuDayArray[self.cumuDaysIndex][1] = "id"
	self.cumuDayArray[self.cumuDaysIndex][2] = "count"
	_ENV, self.rewards = serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]), serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex])
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).disabled = true
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).greenFlag = true
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).title = i18n("decrypt_text_03")
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).tip = self:getColoredDayNum()
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).rewards = self.rewards
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).comfirmFlag = true
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).btnText = i18n("common_text_1892")
	local serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).handle, param = hadGet, serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex])
	uiManager:show("SignRewardView", param)
end
function ComAccuDay:normalGetReward()
	local normalGet = function()
		signRewardCtrl:sendGetExtraRewardMsg(self.cumuDayArray[self.cumuDaysIndex])
		return true
	end
	self.rewards = signRewardCtrl:getExtraAwardByDay(self.cumuDayArray[self.cumuDaysIndex])
	_UPVALUE2_ = self.cumuDayArray[self.cumuDaysIndex]
	self.cumuDayArray[self.cumuDaysIndex][1] = "id"
	self.cumuDayArray[self.cumuDaysIndex][2] = "count"
	signRewardCtrl, self.rewards = serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]), serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex])
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).disabled = false
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).greenFlag = true
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).title = i18n("decrypt_text_03")
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).tip = self:getColoredDayNum()
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).rewards = self.rewards
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).comfirmFlag = true
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).btnText = i18n("common_text_1146")
	local serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).handle, param = normalGet, serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex])
	uiManager:show("SignRewardView", param)
end
function ComAccuDay:cannotGetReward()
	local cannotGet = function()
		SoraDShowMsgTip(i18n("common_text_2876"))
		return false
	end
	self.rewards = signRewardCtrl:getExtraAwardByDay(self.cumuDayArray[self.cumuDaysIndex])
	_UPVALUE2_ = self.cumuDayArray[self.cumuDaysIndex]
	self.cumuDayArray[self.cumuDaysIndex][1] = "id"
	self.cumuDayArray[self.cumuDaysIndex][2] = "count"
	_ENV, self.rewards = serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]), serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex])
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).disabled = true
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).greenFlag = true
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).title = i18n("decrypt_text_03")
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).tip = self:getColoredDayNum()
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).rewards = self.rewards
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).comfirmFlag = true
	serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).btnText = i18n("common_text_1146")
	local serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex]).handle, param = cannotGet, serviceFunctions.tableFormat(self.rewards, self.cumuDayArray[self.cumuDaysIndex])
	uiManager:show("SignRewardView", param)
end
function ComAccuDay:onShow()
end
return ComAccuDay
