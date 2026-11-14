local snowmanGiftCtrl = SoraDGetCtrl("snowmanGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_day = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SnowmanGift/Com_day", Com_day)
_UPVALUE7_ = fgui.register_extension
fgui.register_extension[1] = "8250.png"
fgui.register_extension[2] = "8254.png"
fgui.register_extension[3] = "8251.png"
fgui.register_extension[4] = "8249.png"
fgui.register_extension[5] = "icon_xrkz_maozi.png"
fgui.register_extension[6] = "icon_xrkz_weijin.png"
local fgui.register_extension[7], iconList = "icon_xrkz_zhuangshi.png", fgui.register_extension
function Com_day:onInit()
	self.fields.movie_Today:setAllFrameName("dh_xrkz_klqtx_%02d.png", 1)
	self.fields.movie_LastDay:setAllFrameName("dh_xrkz_klqwltx_%02d.png", 1)
end
function Com_day:onShow()
end
function Com_day:initData(day)
	self.day = day
	self.controllers.c1:setSelectedIndex(snowmanGiftCtrl:getDayStatueByDay(day))
	self.fields.icon:setURL(iconList[day])
	snowmanGiftCtrl = snowmanGiftCtrl:getDayStatueByDay(day)
	snowmanGiftCtrl:getDayStatueByDay(day).num = day
	self:setString(i18n("newYearRecharge_003", snowmanGiftCtrl:getDayStatueByDay(day)))
	self.fields.Text_L:setString(i18n("common_text_2875"))
end
function Com_day:updateData()
	self.controllers.c1:setSelectedIndex(snowmanGiftCtrl:getDayStatueByDay(self.day))
end
return Com_day
