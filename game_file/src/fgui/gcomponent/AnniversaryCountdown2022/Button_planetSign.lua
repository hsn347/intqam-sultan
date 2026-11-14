local annivCountdown2022Ctrl = SoraDGetCtrl("annivCountdown2022Ctrl")
local annivCountdown2022Read = include("annivCountdown2022Read")
local baseComponent = require("fgui.base.baseComponent")
local Button_planetSign = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AnniversaryCountdown2022/Button_planetSign", Button_planetSign)
_UPVALUE7_, Button_planetSign.onInit = function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end, function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end
;(function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end)[1] = 1
;(function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end)[2] = 3
;(function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end)[3] = 5
;(function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end)[4] = 6
;(function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end)[5] = 10
;(function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end)[6] = 12
local (function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end)[7], imageIndex = 14, function(self)
	self.fields.Ani_open:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	self.fields.Ani_get:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	self.fields.touch:addClickListener(handler(self, self.onClickDay))
end
function Button_planetSign:initData(index)
	self.index = index
	self.fields.icon:setIcon("frame_nebula_wonderland_" .. imageIndex[index] .. ".png")
	imageIndex = ".png"
	;(".png").day = index
	self.fields.Label_day:setString(i18n("common_text_3723", ".png"))
	self.state = annivCountdown2022Ctrl:getSignState(self.index)
	if index == 2 then
		dump(self.state, "fkldkfldk")
	end
	self:getController("planet"):setSelectedIndex(index - 1)
	self:getController("c1"):setSelectedIndex(self.state - 1)
	self.fields.Ani_get:setPlaying(self.state == 2)
	self.fields.Ani_open:setPlaying(self.state == 3)
	self.fields.Label_day:getController("c1"):setSelectedIndex(self.state - 1)
end
function Button_planetSign:onClickDay()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	;(nil).title = i18n("common_text_2873")
	;(nil).btnTitle = i18n("common_text_2873")
	;(nil).gotTitle = i18n("common_text_2874")
	;(nil).reward = annivCountdown2022Read.getRewardConfigByDay(self.index).reward
	;(nil).state = self.state
	;(nil).state7 = annivCountdown2022Ctrl:getDay7SignState(self.index)
	;(nil).callFunc = function(index)
		annivCountdown2022Ctrl:reqAnnivCountdownSign(self.index, 1)
	end
	uiManager:show("AnnivCountdownReward2022", nil)
end
function Button_planetSign:onShow()
end
function Button_planetSign:onHide()
	self.fields.Ani_get:setPlaying(false)
	self.fields.Ani_open:setPlaying(false)
end
return Button_planetSign
