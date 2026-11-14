local baseComponent = require("fgui.base.baseComponent")
local Com_ML_SRLine = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_SRLine", Com_ML_SRLine)
function Com_ML_SRLine:onInit()
	self.isFirst = true
	self.isLight = false
	self.isGray = false
	self.aniInited = false
end
function Com_ML_SRLine:onShow()
	self.lineEffectName = "ccxh_G_line_%02d.png"
	self.lineEffectAddHeight = 20
	if self.aniInited then
		self.fields.line:setSize(cc.size(self:getSize().height + self.lineEffectAddHeight, self.fields.line:getSize().height))
		self.fields.line:setAllFrameName(self.lineEffectName, 1)
		self.fields.line:setPlaySettings(0, -1, -1)
	end
end
function Com_ML_SRLine:initData(isLight, isGray, lineIdx)
	self.fields.line:setVisible(isLight)
	self.fields.bg:setVisible(not isGray)
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
return Com_ML_SRLine
