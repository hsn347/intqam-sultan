local gametop = gModuleMgr.getObject("gametop")
local ThirtyDaySign2022Ctrl = SoraDGetCtrl("ThirtyDaySign2022Ctrl")
local signRewadRead = include("signRewadRead")
local baseComponent = require("fgui.base.baseComponent")
local ComAccuDay2022 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Anniversary2022/ComAccuDay2022", ComAccuDay2022)
function ComAccuDay2022:onInit()
	self.fields.touch:addClickListener(handler(self, self.onClickCumuDaysReward))
end
function ComAccuDay2022:initData(index, nDay)
	self.nDay = nDay
	self.rewards = signRewadRead:getAnniversary2022Extra(self.nDay)
	ThirtyDaySign2022Ctrl = self.nDay
	self.nDay[1] = "id"
	self.nDay[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.rewards, self.nDay)
	self.fields.Text_accuDays:setString(nDay .. i18n("common_text_548"))
	self.type = ThirtyDaySign2022Ctrl:getExtraRewardType(nDay)
	self:setCumuTextColor(cc.c3b(215, 213, 197))
	if self.type == 3 then
		self:setCumuTextColor(cc.c3b(101, 101, 101))
		self.fields.Button_gift:setState(2)
	elseif self.type == 2 then
		self:setCumuTextColor(cc.c3b(255, 243, 146))
		self.fields.Button_gift:setState(1)
	else
		self.fields.Button_gift:setState(0)
	end
end
function ComAccuDay2022:setCumuTextColor(color)
	self.fields.Text_accuDays:setColor(color)
end
function ComAccuDay2022:onClickCumuDaysReward()
	SoraDPlaySound()
	if self.type == 3 then
		self:hadGetReward()
	elseif self.type == 1 then
		self:cannotGetReward()
	elseif self.type == 2 then
		self:normalGetReward()
	end
end
function ComAccuDay2022:setNumColor(str, num, color)
	local colorNum = fguiHelper.getColorString(color, num)
	str = string.gsub(str, tostring(num), colorNum)
	return str
end
function ComAccuDay2022:getColoredDayNum()
	local color = "#4CE61A"
	local tNum = self.nDay
	_ENV = nil
	;(nil).num = tNum
	local str = i18n("common_text_2877", nil)
	str = self:setNumColor(str, tNum, color)
	return str
end
function ComAccuDay2022:hadGetReward()
	local hadGet = function()
		SoraDShowMsgTip(i18n("common_text_1892"))
		return false
	end
	_ENV = nil
	;(nil).disabled = true
	;(nil).greenFlag = true
	;(nil).title = i18n("common_text_2876")
	;(nil).tip = self:getColoredDayNum()
	;(nil).rewards = self.rewards
	;(nil).comfirmFlag = true
	;(nil).btnText = i18n("common_text_1892")
	;(nil).handle = hadGet
	local (nil).controller, param = 1, nil
	uiManager:show("ThirtyDaySign2022Reward", param)
end
function ComAccuDay2022:normalGetReward()
	local normalGet = function()
		ThirtyDaySign2022Ctrl:sendGetExtraRewardMsg(self.nDay)
		return true
	end
	ThirtyDaySign2022Ctrl = nil
	;(nil).disabled = false
	;(nil).greenFlag = true
	;(nil).title = i18n("common_text_2876")
	;(nil).tip = self:getColoredDayNum()
	;(nil).rewards = self.rewards
	;(nil).comfirmFlag = true
	;(nil).btnText = i18n("common_text_1146")
	;(nil).handle = normalGet
	local (nil).controller, param = 1, nil
	uiManager:show("ThirtyDaySign2022Reward", param)
end
function ComAccuDay2022:cannotGetReward()
	local cannotGet = function()
		SoraDShowMsgTip(i18n("common_text_2876"))
		return false
	end
	_ENV = nil
	;(nil).disabled = true
	;(nil).greenFlag = true
	;(nil).title = i18n("common_text_2876")
	;(nil).tip = self:getColoredDayNum()
	;(nil).rewards = self.rewards
	;(nil).comfirmFlag = true
	;(nil).btnText = i18n("common_text_1146")
	;(nil).handle = cannotGet
	local (nil).controller, param = 1, nil
	uiManager:show("ThirtyDaySign2022Reward", param)
end
function ComAccuDay2022:onShow()
end
return ComAccuDay2022
