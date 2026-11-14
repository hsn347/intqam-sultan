local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Mod_techTop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Mod_techTop", Mod_techTop)
function Mod_techTop:onInit()
	self:fixChildrenPos()
end
function Mod_techTop:onShow()
end
function Mod_techTop:initData(tid)
	self.fields.Com_tech:initData(tid)
	local lv = roaringFlameWarCtrl:getTechnologyLv(tid)
	local cfg = roaringFlameWarRead.getTechnologyCfg(tid, lv)
	self.fields.Text_des:setString(i18n(cfg.describe))
	roaringFlameWarCtrl = i18n(cfg.describe)
	i18n(cfg.describe).val = self:getBuffStr(cfg, lv)
	self.fields.Text_curLv:setString(i18n("flames_dunes_text77", i18n(cfg.describe)))
	self.fields.Text_nextLv:setVisible(lv < cfg.max_level)
	if lv < cfg.max_level then
		local nextCfg = roaringFlameWarRead.getTechnologyCfg(tid, lv + 1)
		roaringFlameWarCtrl = i18n("flames_dunes_text77", i18n(cfg.describe))
		i18n("flames_dunes_text77", i18n(cfg.describe)).val = self:getBuffStr(nextCfg)
		self.fields.Text_nextLv:setString(i18n("flames_dunes_text78", i18n("flames_dunes_text77", i18n(cfg.describe))))
	end
end
function Mod_techTop:getBuffStr(cfg, lv)
	local power_num = cfg.power_num
	if lv and lv == 0 then
		power_num = 0
	end
	local isIncrease = buffDesRead.isGoodBuff(cfg.buff_type)
	local char = isIncrease and "+" or "-"
	if cfg.buff_num_Type == 1 then
		return string.format(char .. "%s%%", tostring(SoraDPreciseDecimal(power_num / 10, 2)))
	else
		return string.format(char .. "%d", power_num)
	end
end
return Mod_techTop
