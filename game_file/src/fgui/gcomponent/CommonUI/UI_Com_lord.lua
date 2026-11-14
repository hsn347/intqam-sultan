local lordLocalData = include("lordLocalData")
local lordSpineDef = include("lordSpineDef")
local baseComponent = require("fgui.base.baseComponent")
local UI_Com_lord = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_lord", UI_Com_lord)
function UI_Com_lord:onInit()
	self:setTouchEnabled(false)
end
function UI_Com_lord:onShow()
end
function UI_Com_lord:initData(headID)
	local portrait = lordLocalData.getPortrait(headID)
	self.fields.icon:setURL(portrait)
	local spineCfg = lordSpineDef.getSpinePathCfg(headID)
	if spineCfg then
		self.fields.Spine:clearEffect()
		self.fields.Spine:setEffectPath(spineCfg.path)
		if spineCfg.prefabCfg then
			for boneName, prefab in pairs(spineCfg.prefabCfg) do
				self.fields.Spine:addPrefab(boneName, prefab)
			end
		end
		self.fields.icon:setVisible(false)
		self.fields.Spine:setVisible(true)
	else
		self.fields.icon:setVisible(true)
		self.fields.Spine:setVisible(false)
	end
end
return UI_Com_lord
