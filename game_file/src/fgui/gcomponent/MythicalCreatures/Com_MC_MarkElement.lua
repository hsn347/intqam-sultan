local baseComponent = require("fgui.base.baseComponent")
local Com_MC_MarkElement = fgui.extension_class(fgui.GButton, baseComponent)
local divineBeastMarkRead = include("divineBeastMarkRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkElement", Com_MC_MarkElement)
function Com_MC_MarkElement:onInit()
	self:addClickEventListener(handler(self, self.onMarkElementClick))
end
_ENV, Com_MC_MarkElement.onShow = function(self)
end, function(self)
end
;(function(self)
end)[1] = cc.c3b(125, 253, 80)
;(function(self)
end)[2] = cc.c3b(253, 80, 80)
;(function(self)
end)[3] = cc.c3b(255, 217, 217)
local (function(self)
end)[4], colors = cc.c3b(125, 80, 253), function(self)
end
function Com_MC_MarkElement:initData(eType, count, beastId)
	self.eType = eType
	self.beastId = beastId
	local elementCfg = divineBeastMarkRead.getElementCfg(eType)
	local elementEffectCfg, isMax = divineBeastMarkRead.getElementsEffect(self.beastId, eType, count or 0)
	local elv = elementEffectCfg and elementEffectCfg.lv or 0
	self:setIcon(elementCfg.icon)
	divineBeastMarkRead = nil
	;(nil).lv = elv
	self:setTitle(i18n("common_text_100", nil))
	self.fields.icon:setGrayed(elv == 0)
	self:setTitleColor(elv == 0 and cc.c3b(215, 195, 155) or cc.c3b(240, 230, 210))
	if self._lastElv ~= nil and elv > self._lastElv then
		self.fields.icon_effect:setVisible(true)
		self.fields.icon_effect:setURL(elementCfg.icon)
		self.fields.Ani_sj:setVisible(true)
		self.fields.icon_effect:setAlpha(0)
		self.fields.icon_effect:stopAllActions()
		self.fields.icon_effect:runAction(ffa.seq(ffa.fadeIn(0.5), ffa.fadeOut(0.5), ffa.callFunc(function()
			self.fields.icon_effect:setVisible(false)
			self.fields.Ani_sj:setVisible(false)
		end)))
		self.fields.Ani_sj:setAllFrameNameOnce("ssyj_effect_js_%02d.png", 1, false)
		self.fields.Ani_sj:setColor(colors[eType])
	end
	self.fields.Ani_mj:setVisible(isMax)
	if isMax then
		self.fields.Ani_mj:setAllFrameNameOnce("ssyj_effect_mj_%02d.png", 1, true)
	end
	self._lastElv = elv
end
function Com_MC_MarkElement:onMarkElementClick(context)
	_ENV = nil
	;(nil).beastId = self.beastId
	;(nil).type = self.eType
	uiManager:show("DivineBeastMarkElement", nil)
end
return Com_MC_MarkElement
