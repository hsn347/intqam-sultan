local RamadanSign2023Ctrl = SoraDGetCtrl("RamadanSign2023Ctrl")
local signRewadRead = include("signRewadRead")
local baseComponent = require("fgui.base.baseComponent")
local ComAccuDay2023 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanSign2023/ComAccuDay2023", ComAccuDay2023)
function ComAccuDay2023:onInit()
	self.fields.touch:addClickListener(handler(self, self.onClickCumuDaysReward))
end
function ComAccuDay2023:onShow()
end
function ComAccuDay2023:initData(nDay)
	self.nDay = nDay
	self.rewards = signRewadRead:getRamadan2023Extra(RamadanSign2023Ctrl:getClassType(), self.nDay)
	_ENV = RamadanSign2023Ctrl:getClassType()
	RamadanSign2023Ctrl:getClassType()[1] = "id"
	RamadanSign2023Ctrl:getClassType()[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.rewards, (RamadanSign2023Ctrl:getClassType()))
	self.fields.Text_accuDays:setString(nDay .. i18n("common_text_548"))
	self.type = RamadanSign2023Ctrl:getExtraRewardType(nDay)
	self.fields.Text_accuDays:setColor(cc.c3b(215, 213, 197))
	if self.type == 3 then
		self.fields.Text_accuDays:setColor(cc.c3b(101, 101, 101))
		self.fields.Button_gift:setState(2)
	elseif self.type == 2 then
		self.fields.Text_accuDays:setColor(cc.c3b(255, 243, 146))
		self.fields.Button_gift:setState(1)
	else
		self.fields.Button_gift:setState(0)
	end
end
function ComAccuDay2023:onClickCumuDaysReward()
	SoraDPlaySound()
	local hadGet = function()
		if self.type == 3 then
			return false
		elseif self.type == 1 then
			SoraDShowMsgTip(i18n("snowmangift_text_01"))
			return false
		elseif self.type == 2 then
			RamadanSign2023Ctrl:reqRamadanSign2023ActivityGetExtraReward(self.nDay)
			return true
		end
	end
	_ENV = nil
	;(nil).disabled = self.type ~= 2
	;(nil).greenFlag = true
	;(nil).title = i18n("common_text_2876")
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, self.nDay, self.nDay
	_ENV, self.nDay.num, (nil).color = nil, nil, "#4CE61A"
	self.nDay.__default, (nil).color = nil, "#F0D69C"
	;(nil).tip = i18n_html("common_text_2877", nil, self.nDay)
	;(nil).rewards = self.rewards
	;(nil).comfirmFlag = true
	;(nil).btnText = i18n("common_text_1146")
	;(nil).handle = hadGet
	local (nil).controller, param = 1, nil
	if self.type == 3 then
		param.btnText = i18n("common_text_1892")
	end
	uiManager:show("SignRewardView", param)
end
return ComAccuDay2023
