local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local baseComponent = require("fgui.base.baseComponent")
local WarGemHoleColorSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarGem/WarGemHoleColorSingle", WarGemHoleColorSingle)
function WarGemHoleColorSingle:onInit()
	self.fields.Text_name:fixPos()
	self.fields.Text_desc:fixPos()
	self.fields.Com_hole:fixPos()
	self.fields.Check_tick:fixPos()
end
function WarGemHoleColorSingle:onShow()
end
function WarGemHoleColorSingle:initData(data, index)
	self.fields.Image_bg:setVisible(index % 2 ~= 0)
	self.data = data
	local color = data.color
	self.fields.Com_hole:setColor(color)
	local title = wargemResRead.getColorTitle(color)
	self.fields.Text_name:setString(i18n(title))
	local colorValue = warGemltCtrl:getColorValue(color)
	self.fields.Text_name:setColor(SoraDHtmlColor2RGB(colorValue))
	local colorDes = warGemltCtrl:getColorDescribe(color)
	self.fields.Text_desc:setString(i18n(colorDes))
end
return WarGemHoleColorSingle
