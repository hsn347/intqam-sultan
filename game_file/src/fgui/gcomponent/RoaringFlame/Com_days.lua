local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_days = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_days", Com_days)
function Com_days:onInit()
	self.rewards, _ENV = nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_days:onItemRenderer(index, obj)
	obj:initData(self.rewards[index + 1], self.status)
end
function Com_days:onShow()
end
function Com_days:initData(day)
	self.day = day
	_ENV = nil
	;(nil).day = self.day
	self.fields.title:setString(i18n("flames_dunes_text53", nil))
	local cfg = roaringFlameWarRead.getWeeklyPackCfg(self.day)
	self.rewards = cfg.rewrad
	self.weekGift = roaringFlameWarCtrl:getWeeklyGift()
	self.status = 0
	if serviceFunctions.getWeekDayEx() >= self.day then
		self.status = self.day > self.weekGift.getedDay and 1 or 2
	end
	self.fields.Label_reddot:setVisible(self.weekGift.isBuy and self.day > self.weekGift.getedDay and serviceFunctions.getWeekDayEx() >= self.day)
	self.fields.List:setNumItems(#self.rewards)
end
return Com_days
