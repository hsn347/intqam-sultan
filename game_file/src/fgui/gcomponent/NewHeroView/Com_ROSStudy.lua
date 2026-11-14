local baseComponent = require("fgui.base.baseComponent")
local Com_ROSStudy = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_ROSStudy", Com_ROSStudy)
function Com_ROSStudy:onInit()
end
function Com_ROSStudy:onShow()
end
function Com_ROSStudy:initData(preBuff, afterBuff, isCrit, maxValue)
	self.fields.Text_oriBuff:setString(SoraDPreciseDecimal(preBuff / 1000, 4) * 100 .. "%")
	self.controllers.c1:setSelectedIndex(0)
	if afterBuff then
		self.controllers.c1:setSelectedIndex(1)
		local char = 0 < afterBuff - preBuff and "+" or ""
		local valueNow = afterBuff - preBuff
		self.fields.Text_preBuff:setString(char .. SoraDPreciseDecimal(valueNow / 1000, 4) * 100 .. "%")
		self.fields.Text_preBuff:setColor(isCrit and cc.c3b(255, 255, 0, 1) or cc.c3b(0, 190, 30))
	end
	self.fields.frameBuff:setSpriteFrame(isCrit and "img_lwbj_jiantou.png" or "frame_YX_juejiup.png")
	self.fields.Bar_skill:setBar(preBuff, afterBuff or 0, maxValue)
end
return Com_ROSStudy
