local snowmanGiftCtrl = SoraDGetCtrl("snowmanGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Part1 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SnowmanGift/Com_Part1", Com_Part1)
fgui.register_extension("ui://SnowmanGift/Com_Part2", Com_Part1)
fgui.register_extension("ui://SnowmanGift/Com_Part3", Com_Part1)
fgui.register_extension("ui://SnowmanGift/Com_Part4", Com_Part1)
fgui.register_extension("ui://SnowmanGift/Com_Part5", Com_Part1)
fgui.register_extension("ui://SnowmanGift/Com_Part6", Com_Part1)
fgui.register_extension("ui://SnowmanGift/Com_Part7", Com_Part1)
_ENV, _UPVALUE7_ = "ui://SnowmanGift/Com_Part7", fgui.register_extension
;("ui://SnowmanGift/Com_Part7").base = "dh_xrkz_lsnk_%02d.png"
_ENV, ("ui://SnowmanGift/Com_Part7").effect = Com_Part1, "dh_xrkz_lsnktx_%02d.png"
Com_Part1.base = "dh_xrkz_ssnk_%02d.png"
_ENV, Com_Part1.effect = nil, "dh_xrkz_ssnktx_%02d.png"
;(nil).base = "dh_xrkz_xrbztx_%02d.png"
_ENV, (nil).effect = nil, "dh_xrkz_add_xrbztx_%02d.png"
;(nil).base = "dh_xrkz_szsb_%02d.png"
_ENV, (nil).effect = nil, "dh_xrkz_szsbtx_%02d.png"
;(nil).base = "dh_xrkz_mz_%02d.png"
_ENV, (nil).effect = nil, "dh_xrkz_mztx_%02d.png"
;(nil).base = "dh_xrkz_wj_%02d.png"
_ENV, (nil).effect = nil, "dh_xrkz_wjtx_%02d.png"
;(nil).base = "dh_xrkz_mzzs_%02d.png"
;(nil).effect = "dh_xrkz_mzzstx_%02d.png"
fgui.register_extension[1] = "ui://SnowmanGift/Com_Part7"
fgui.register_extension[2] = Com_Part1
fgui.register_extension[3] = nil
fgui.register_extension[4] = nil
fgui.register_extension[5] = nil
fgui.register_extension[6] = nil
local fgui.register_extension[7], iconList = nil, fgui.register_extension
function Com_Part1:onInit()
end
function Com_Part1:onShow()
end
function Com_Part1:initData(day)
	self.day = day
	self.fields.movie_Base:setAllFrameName(iconList[self.day].base, 1)
	self.fields.movie_Effect:setAllFrameName(iconList[self.day].effect, 1)
	self.fields.icon:stopAllActions()
	local status = snowmanGiftCtrl:getDayStatueByDay(day)
	if status == 0 or status == 3 then
		self.controllers.c1:setSelectedIndex(0)
		snowmanGiftCtrl = nil
		;(nil)[1] = ffa.fadeTo(1, 0.0)
		;(nil)[2] = ffa.fadeTo(1, 1)
		;(nil)[3] = ffa.fadeTo(1, 1)
		;(nil)[4] = ffa.fadeTo(1, 1)
		self.fields.icon:runAction(ffa.repeatForever(ffa.seq(nil)))
	elseif status == 2 then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(2)
	end
end
function Com_Part1:playFadeIn()
	self.controllers.c1:setSelectedIndex(1)
	self.fields.movie_Base:setPlaySettings(0, -1, 1)
	self.fields.movie_Effect:setPlaySettings(0, -1, 1)
end
return Com_Part1
