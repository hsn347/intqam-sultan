local RamadanSign2023Ctrl = SoraDGetCtrl("RamadanSign2023Ctrl")
local signRewadRead = include("signRewadRead")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local ButtonDay2023 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RamadanSign2023/ButtonDay2023", ButtonDay2023)
function ButtonDay2023:onInit()
	self:addClickListener(handler(self, self.onClickDay))
	self.fields.Label_reddot:fixPos()
	self.fields.Text_Resign:setString(i18n("common_text_2875"))
end
function ButtonDay2023:onShow()
end
function ButtonDay2023:initData(day)
	self.fields.Text_Day:setString(day)
	self.day = day
	self.rewards = signRewadRead:getRamadan2023Award(RamadanSign2023Ctrl:getClassType(), self.day)
	_ENV = RamadanSign2023Ctrl:getClassType()
	RamadanSign2023Ctrl:getClassType()[1] = "id"
	RamadanSign2023Ctrl:getClassType()[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.rewards, (RamadanSign2023Ctrl:getClassType()))
	local iconId = self.rewards[1].id
	local iconName = publicRead.getIcon(iconId)
	self.fields.icon:setURL(iconName)
	self.type = RamadanSign2023Ctrl:getSignTypeByDay(self.day)
	local state = 0
	if self.type == gSignRewardType.NO_SIGN and RamadanSign2023Ctrl:getCurDay() > self.day then
		state = 3
	elseif self.type == gSignRewardType.NO_SIGN and RamadanSign2023Ctrl:getCurDay() == self.day then
		state = 1
	elseif self.type == gSignRewardType.NORMAL_SIGN or self.type == gSignRewardType.USE_GOLD_SIGN then
		state = 2
	end
	local lastIndex = self.controllers.c1:getSelectedIndex()
	if state == 2 and (lastIndex == 3 or lastIndex == 1) then
		self.transitions.t1:play(1, 0, 0, -1, function()
			self.controllers.c1:setSelectedIndex(state)
		end)
		self.fields.Usm_3:play(false)
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(state)
	end
	self:setReddot(state == 1, -1)
end
function ButtonDay2023:onClickDay()
	SoraDPlaySound()
	local state = self.controllers.c1:getSelectedIndex()
	local cost = signRewadRead.getRamadan2023RemedyPrice(RamadanSign2023Ctrl:getClassType(), RamadanSign2023Ctrl:getUseGoldDay() + 1)
	local signHandle = function()
		if state == 1 then
			RamadanSign2023Ctrl:reqRamadanSign2023ActivitySign()
			return true
		elseif state == 0 then
			SoraDShowMsgTip(i18n("Nebula_sign_tips_003"))
			return false
		elseif state == 3 then
			if SoraDEnoughGold(cost) then
				RamadanSign2023Ctrl:reqRamadanSign2023ActivityUseGoldSign(self.day)
				return true
			else
				return false
			end
		elseif state == 2 then
			return false
		end
	end
	_ENV = RamadanSign2023Ctrl:getUseGoldDay() + 1
	;(RamadanSign2023Ctrl:getUseGoldDay() + 1).disabled = state == 2 or state == 0
	;(RamadanSign2023Ctrl:getUseGoldDay() + 1).greenFlag = true
	;(RamadanSign2023Ctrl:getUseGoldDay() + 1).title = i18n("common_text_2873")
	;(RamadanSign2023Ctrl:getUseGoldDay() + 1).btnText = i18n("common_text_2873")
	_ENV = nil
	_ENV, _ENV, (nil).day = nil, self.day, self.day
	_ENV, self.day.day, (nil).color = nil, nil, "#4CE61A"
	self.day.__default, (nil).color = nil, "#F0D69C"
	;(RamadanSign2023Ctrl:getUseGoldDay() + 1).tip = i18n_html("common_text_2872", nil, self.day)
	;(RamadanSign2023Ctrl:getUseGoldDay() + 1).rewards = self.rewards
	;(RamadanSign2023Ctrl:getUseGoldDay() + 1).comfirmFlag = true
	;(RamadanSign2023Ctrl:getUseGoldDay() + 1).handle = signHandle
	local (RamadanSign2023Ctrl:getUseGoldDay() + 1).controller, param = 0, RamadanSign2023Ctrl:getUseGoldDay() + 1
	if state == 3 then
		param.cost = cost
		param.comfirmFlag = false
		param.btnText = i18n("common_text_2875")
	elseif state == 2 then
		param.btnText = i18n("common_text_2874")
	end
	uiManager:show("SignRewardView", param)
end
return ButtonDay2023
