local publicRead = include("publicRead")
local ThirtyDaySign2022Ctrl = SoraDGetCtrl("ThirtyDaySign2022Ctrl")
local signRewadRead = include("signRewadRead")
local baseComponent = require("fgui.base.baseComponent")
local ButtonDay2022 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Anniversary2022/ButtonDay2022", ButtonDay2022)
function ButtonDay2022:onInit()
	self.day = 0
	self.type = "0"
	self:addClickListener(handler(self, self.onClickDay))
	self.fields.redPoint:initData(true, -1)
	local framesNpc = display.newFrames("dh_Tex_XL_znqd01_0%02d.png", 0, 23)
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_fade:setAnimation(animationNpc)
	function self.callFunc()
		self.transitions.t1:play()
		self.fields.Ani_fade:setPlaying(true)
		self.fields.Ani_fade:setVisible(true)
		self.fields.Ani_fade:setPlaySettings(1, -1, 1, -1, function()
			self.fields.Ani_fade:setVisible(false)
			self.fields.Ani_fade:setPlaying(false)
			self:initData(self.day)
		end)
	end
end
function ButtonDay2022:initData(index)
	self.day = index
	self.rewards = signRewadRead:getAnniversary2022Award(self.day)
	publicRead = self.day
	self.day[1] = "id"
	self.day[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.rewards, self.day)
	local rewards = signRewadRead:getAnniversary2022Award(self.day)
	local iconId = rewards[1]
	local iconName = publicRead.getIcon(iconId)
	self.fields.icon:setURL(iconName)
	self.fields.num:setURL("num_qzn_" .. index .. ".png")
	self.type = ThirtyDaySign2022Ctrl:getSignTypeByDay(index)
	local state = 0
	if self.type == "0" and ThirtyDaySign2022Ctrl:getCurDay() > self.day then
		state = 3
	elseif self.type == "0" and ThirtyDaySign2022Ctrl:getCurDay() == self.day then
		state = 1
	elseif self.type == "1" or self.type == "2" then
		state = 2
	end
	self.controllers.c1:setSelectedIndex(state)
	self.controllers.c2:setSelectedIndex(state == 1 and 1 or 0)
end
function ButtonDay2022:showEffect()
	self.callFunc()
end
function ButtonDay2022:onClickDay()
	SoraDPlaySound()
	self.type = ThirtyDaySign2022Ctrl:getSignTypeByDay(self.day)
	if ThirtyDaySign2022Ctrl:getCurDay() > self.day and self.type == "0" then
		self:Resign()
	elseif self.type == "0" then
		self:NormalSign()
	else
		self:HadSign()
	end
end
function ButtonDay2022:setNumColor(str, num, color)
	local colorNum = fguiHelper.getColorString(color, num)
	str = string.gsub(str, tostring(num), colorNum)
	return str
end
function ButtonDay2022:getColoredDayNum()
	local color = "#4CE61A"
	_ENV = nil
	;(nil).day = self.day
	local str = i18n("common_text_2872", nil)
	str = self:setNumColor(str, self.day, color)
	return str
end
function ButtonDay2022:NormalSign()
	local signHandle = function()
		if ThirtyDaySign2022Ctrl:getCurDay() == self.day then
			ThirtyDaySign2022Ctrl:sendSignMsg()
			return true
		else
			SoraDShowMsgTip(i18n("common_text_3070"))
			return false
		end
	end
	local flag = true
	if ThirtyDaySign2022Ctrl:getCurDay() == self.day then
		flag = false
	end
	ThirtyDaySign2022Ctrl = ThirtyDaySign2022Ctrl:getCurDay()
	ThirtyDaySign2022Ctrl:getCurDay().disabled = flag
	ThirtyDaySign2022Ctrl:getCurDay().greenFlag = true
	ThirtyDaySign2022Ctrl:getCurDay().title = i18n("common_text_2873")
	ThirtyDaySign2022Ctrl:getCurDay().btnText = i18n("common_text_2873")
	ThirtyDaySign2022Ctrl:getCurDay().tip = self:getColoredDayNum()
	ThirtyDaySign2022Ctrl:getCurDay().rewards = self.rewards
	ThirtyDaySign2022Ctrl:getCurDay().comfirmFlag = true
	ThirtyDaySign2022Ctrl:getCurDay().handle = signHandle
	local ThirtyDaySign2022Ctrl:getCurDay().controller, param = 0, ThirtyDaySign2022Ctrl:getCurDay()
	uiManager:show("ThirtyDaySign2022Reward", param)
end
function ButtonDay2022:HadSign()
	local HadSignHandle = function()
		SoraDShowMsgTip(i18n("common_text_2874"))
		return false
	end
	_ENV = nil
	;(nil).disabled = true
	;(nil).greenFlag = true
	;(nil).title = i18n("common_text_2873")
	;(nil).btnText = i18n("common_text_2874")
	;(nil).tip = self:getColoredDayNum()
	;(nil).rewards = self.rewards
	;(nil).comfirmFlag = true
	;(nil).handle = HadSignHandle
	local (nil).controller, param = 0, nil
	uiManager:show("ThirtyDaySign2022Reward", param)
end
function ButtonDay2022:Resign()
	local cost = signRewadRead.getAnniversary2022RemedyPrice(ThirtyDaySign2022Ctrl:getUseGoldDay() + 1)
	local resignHandle = function()
		if SoraDEnoughGold(cost) then
			ThirtyDaySign2022Ctrl:sendUseGoldSignMsg(self.day)
			return true
		else
			return false
		end
	end
	signRewadRead = ThirtyDaySign2022Ctrl
	ThirtyDaySign2022Ctrl.disabled = false
	ThirtyDaySign2022Ctrl.greenFlag = true
	ThirtyDaySign2022Ctrl.title = i18n("common_text_2873")
	ThirtyDaySign2022Ctrl.btnText = i18n("common_text_2875")
	ThirtyDaySign2022Ctrl.tip = self:getColoredDayNum()
	ThirtyDaySign2022Ctrl.rewards = self.rewards
	ThirtyDaySign2022Ctrl.comfirmFlag = false
	ThirtyDaySign2022Ctrl.cost = cost
	ThirtyDaySign2022Ctrl.handle = resignHandle
	local ThirtyDaySign2022Ctrl.controller, param = 0, ThirtyDaySign2022Ctrl
	uiManager:show("ThirtyDaySign2022Reward", param)
end
function ButtonDay2022:onShow()
end
return ButtonDay2022
