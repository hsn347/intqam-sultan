local prefabDef = include("prefabDef")
local Com_prefabEx = require("fgui.gcomponent.CommonNew.Com_prefabEX")
local baseComponent = require("fgui.base.baseComponent")
local Com_prefabEX_mask = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/Com_prefabEX_mask", Com_prefabEX_mask)
function Com_prefabEX_mask:onInit()
	self._loadedEffect = false
end
function Com_prefabEX_mask:onShow()
	self:setEffectPath(self:getCustomData())
end
function Com_prefabEX_mask:onHide()
	self:clearEffect()
end
function Com_prefabEX_mask:setEffectPath(path)
	self.fields.prefabEx:setEffectPath(path)
end
function Com_prefabEX_mask:clearEffect()
	self.fields.prefabEx:clearEffect()
end
function Com_prefabEX_mask:initData(prefabStr, maskPos, maskSize)
end
function Com_prefabEX_mask:setPb(value)
	self.fields.mask:setFillAmount(value)
end
return Com_prefabEX_mask
