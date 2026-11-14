local baseComponent = require("fgui.base.baseComponent")
local Com_luckyBless = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TreasurePool/Com_luckyBless", Com_luckyBless)
function Com_luckyBless:onInit()
	self.isShowTip = false
	self.fields.Spine_lucky:setEffectPath("spine/xingyunri.skel", "activation01")
	self.fields.timer:setTimeUpdateListener(handler(self, self.updateTip))
	self:addClickListener(handler(self, self.onClick))
end
function Com_luckyBless:onShow()
end
function Com_luckyBless:setTime(leftTime, discount)
	self.leftTime = leftTime
	self.discount = discount
	self.fields.timer:beginTime(leftTime)
	_ENV = nil
	;(nil).num = string.format("%d%%", self.discount)
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.fields.tip:setString(i18n("lucky_text_31", nil))
end
function Com_luckyBless:updateTip(time)
	_ENV = nil
	;(nil).num = string.format("%d%%", self.discount)
	;(nil).time = SoraDConvertSecondToString(time)
	self.fields.tip:setString(i18n("lucky_text_31", nil))
end
function Com_luckyBless:showBlessTip(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
function Com_luckyBless:onClick()
	SoraDPlaySound()
	self.isShowTip = not self.isShowTip
	self:showBlessTip(self.isShowTip)
end
return Com_luckyBless
