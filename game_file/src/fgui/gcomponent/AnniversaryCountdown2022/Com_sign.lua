local annivCountdown2022Ctrl = SoraDGetCtrl("annivCountdown2022Ctrl")
local annivCountdown2022Read = include("annivCountdown2022Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_sign = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AnniversaryCountdown2022/Com_sign", Com_sign)
_ENV = fgui.register_extension
fgui.register_extension.COUNTDOWN = 1
fgui.register_extension.WELFARE = 2
local fgui.register_extension.BAG, viewType = 3, fgui.register_extension
function Com_sign:onInit()
	self.signCfg = annivCountdown2022Read.getSignCfg()
	self.indexMax = table.nums(self.signCfg)
	self.fields.Text_sign:setString(i18n("common_text_2876"))
	self.fields.Com_box:addClickListener(handler(self, self.onClickBox))
end
function Com_sign:initData()
	local cumuDay = annivCountdown2022Ctrl:getCumuDay()
	cumuDay = math.clamp(cumuDay, 1, self.indexMax)
	self.boxState = annivCountdown2022Ctrl:getBigRewardState()
	self.fields.Com_day:initData()
	self.controllers.c1:setSelectedIndex(self.boxState - 1)
	self.fields.Usm_normal:setVisible(self.boxState ~= 3)
	self.fields.Usm_get:setVisible(self.boxState == 2)
	self.fields.Usm_open:setVisible(self.boxState == 3)
end
function Com_sign:onItemRenderer(index, obj)
	obj:initData(index + 1)
end
function Com_sign:onClickBox()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("signin_text_01")
	;(nil).reward = annivCountdown2022Read.getBigRewardCfg().reward
	;(nil).state = self.boxState
	;(nil).callFunc = function()
		annivCountdown2022Ctrl:reqAnnivCountdownSign(annivCountdown2022Read.getBigRewardCfg().days, 2)
	end
	uiManager:show("AnnivCountdownReward2022", nil)
end
function Com_sign:onHide()
	self.fields.Usm_normal:setVisible(false)
	self.fields.Usm_get:setVisible(false)
	self.fields.Usm_open:setVisible(false)
end
function Com_sign:onShow()
	self:initData()
end
return Com_sign
