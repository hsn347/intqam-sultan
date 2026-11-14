local baseComponent = require("fgui.base.baseComponent")
local Com_MC_ElementDetail = fgui.extension_class(fgui.GComponent, baseComponent)
local divineBeastMarkRead = include("divineBeastMarkRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_ElementDetail", Com_MC_ElementDetail)
_ENV = fgui.register_extension
local fgui.register_extension.color, numColor = "#70C723", fgui.register_extension
function Com_MC_ElementDetail:onInit()
	self:fixChildrenPos()
end
function Com_MC_ElementDetail:onShow()
end
function Com_MC_ElementDetail:initData(cfg, isActive, index)
	self.fields.bg:setVisible(index % 2 ~= 0)
	self.controllers.c1:setSelectedIndex(isActive and 1 or 0)
	local elementCfg = divineBeastMarkRead.getElementCfg(cfg.type)
	divineBeastMarkRead = nil
	;(nil).lv = cfg.lv
	self.fields.text_lv:setString(i18n("common_text_100", nil))
	divineBeastMarkRead = i18n("common_text_100", nil)
	i18n("common_text_100", nil).name = i18n(elementCfg.name)
	i18n("common_text_100", nil).num = cfg.need_elements
	self.fields.text_need:setString(i18n("Divine_beast_mark_text_22", i18n("common_text_100", nil)))
	local style
	if isActive then
		style, divineBeastMarkRead = self.fields.text_need, self.fields.text_need
		for k, v in pairs(cfg.introduce) do
			if k ~= 1 then
				style[k] = numColor
			end
		end
	end
	self.fields.text_desc:setString(i18n_html(cfg.introduce[1], cfg.introduce, style))
end
return Com_MC_ElementDetail
