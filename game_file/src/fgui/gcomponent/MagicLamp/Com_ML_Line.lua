local baseComponent = require("fgui.base.baseComponent")
local Com_ML_Line = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_Line", Com_ML_Line)
fgui.register_extension("ui://MagicLamp/Com_ML_Line2", Com_ML_Line)
_ENV = fgui.register_extension
fgui.register_extension.lamp1 = "dh_zndzf_lx_%02d.png"
local _ENV, fgui.register_extension.lamp2, lineEffectNames = "ui://MagicLamp/Com_ML_Line2", "dh_shendengzflx_%02d.png", fgui.register_extension
;("ui://MagicLamp/Com_ML_Line2").lamp1 = 40
local ("ui://MagicLamp/Com_ML_Line2").lamp2, lineEffectAddHeight = 80, "ui://MagicLamp/Com_ML_Line2"
function Com_ML_Line:onInit()
	self.lampType = "lamp1"
	self.isFirst = true
	self.isLight = false
	self.isGray = false
	self.aniInited = false
end
function Com_ML_Line:setLampType(lampType)
	self.lampType = lampType
end
function Com_ML_Line:onShow()
	self.lineEffectName = lineEffectNames[self.lampType]
	self.lineEffectAddHeight = lineEffectAddHeight[self.lampType]
	if self.aniInited then
		self.fields.line:setSize(cc.size(self:getSize().height + self.lineEffectAddHeight, self.fields.line:getSize().height))
		self.fields.line:setAllFrameName(self.lineEffectName, 1)
		self.fields.line:setPlaySettings(0, -1, -1)
	end
end
function Com_ML_Line:initData(isLight, isGray, lineIdx)
	self.fields.line:setVisible(isLight)
	self.fields.bg:setVisible(not isLight)
	self.fields.line_gray:setVisible(isGray)
	local isShowAni = false
	if not self.isFirst and isLight and not self.isLight then
		self:setMask(self.fields.mask:displayObject())
		self.fields.mask:setVisible(true)
		self.fields.mask:setScaleY(0)
		self.fields.mask:setScaleX(1)
		local delay = ffa.delay((lineIdx - 1) * 0.5)
		local scaleTo = ffa.scaleTo(0.5, 1, 1)
		self.fields.mask:runAction(ffa.seq(delay, scaleTo, cca.callFunc(function()
			self.fields.mask:setVisible(true)
		end)))
		isShowAni = true
	end
	if not self.isFirst and isGray and not self.isGray and not self.isLight then
		self.fields.line_gray:setScaleY(0)
		self.fields.line_gray:setScaleX(1)
		local delay = ffa.delay((lineIdx - 1) * 0.5)
		local scaleTo = ffa.scaleTo(0.5, 1, 1)
		self.fields.line_gray:runAction(ffa.seq(delay, scaleTo))
		isShowAni = true
	end
	self.isLight = isLight
	if isLight and not self.aniInited then
		self.aniInited = true
		if self.lineEffectName ~= nil then
			self.fields.line:setSize(cc.size(self:getSize().height + self.lineEffectAddHeight, self.fields.line:getSize().height))
			self.fields.line:setAllFrameName(self.lineEffectName, 1)
			self.fields.line:setPlaySettings(0, -1, -1)
		end
	end
	self.isGray = isGray
	self.isFirst = false
	return isShowAni
end
return Com_ML_Line
