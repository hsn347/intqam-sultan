local heroltCtrl = include("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SpineShaderTestPanel = class("SpineShaderTestPanel", baseFguiPanel)
function SpineShaderTestPanel:ctor(...)
	self.isLRU = true
	SpineShaderTestPanel.super.ctor(self, ...)
	print("SpineShaderTestPanel:ctor", self.viewName)
end
function SpineShaderTestPanel:onInit()
	print("=======SpineShaderTestPanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Com_title:setString(i18n("贝塞尔曲线测试"))
	self.spriteList, _ENV = self.fields.Com_title.setString, self.fields.Com_title.setString
	local spriteMax = 11
	for i = 1, spriteMax do
		local sprite = display.newSprite("#1001.png")
		sprite:addTo(self.view)
		sprite:setPosition(320, 480)
		sprite:setScale(0.3)
		table.insert(self.spriteList, sprite)
	end
	local beginPos = cc.p(100, 480)
	local endPos = cc.p(540, 480)
	local pScale = 0.5
	local px = endPos.x * pScale + beginPos.x * (1 - pScale)
	local p = cc.p(px, 800)
	local dt = 1 / (spriteMax - 1)
	_UPVALUE11_ = 800
	;(800)[1] = 1
	;(800)[2] = 1.9
	;(800)[3] = 1.8
	;(800)[4] = 1.7
	;(800)[5] = 1.6
	;(800)[6] = 1.5
	;(800)[7] = 1.4
	;(800)[8] = 1.3
	;(800)[9] = 1.2
	;(800)[10] = 1.1
	local (800)[11], config = 1, 800
	for i, sprite in ipairs(self.spriteList) do
		local t = (i - 1) * dt
		local ret = SoraDCalcQuadBezier(beginPos, p, endPos, t)
		sprite:setPosition(ret)
	end
end
function SpineShaderTestPanel:endShow()
	print("=======SpineShaderTestPanel:endShow")
end
return SpineShaderTestPanel
