local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_techSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_techSingle", Com_techSingle)
function Com_techSingle:onInit()
end
function Com_techSingle:onShow()
end
function Com_techSingle:initData(tid, lv)
	local lv = lv or roaringFlameWarCtrl:getTechnologyLv(tid)
	local cfg = roaringFlameWarRead.getTechnologyCfg(tid, lv)
	self.fields.Image_techBg:setSpriteFrame(cfg.base)
	self.fields.Image_icon:setSpriteFrame(cfg.icon)
	roaringFlameWarCtrl = nil
	;(nil).lv = lv
	;(nil).max = cfg.max_level
	self.fields.Text_lv:setString(i18n("%{lv}/%{max}", nil))
end
return Com_techSingle
