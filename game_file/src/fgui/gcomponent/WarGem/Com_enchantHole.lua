local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local MAX_LV = table.nums(ESI.data)
_UPVALUE2_, _ENV = nil, ESI.data
_UPVALUE2_, ESI.data[0], (nil)[1] = nil, nil, "img_baoshi_fumo_00.png"
_UPVALUE2_, ESI.data[0], (nil)[2] = nil, nil, "img_baoshi_fumo_00_02.png"
_UPVALUE2_, ESI.data[1], (nil)[1] = nil, nil, "img_baoshi_fumo_01.png"
_UPVALUE2_, ESI.data[1], (nil)[2] = nil, nil, "img_baoshi_fumo_01_02.png"
_UPVALUE2_, ESI.data[2], (nil)[1] = nil, nil, "img_baoshi_fumo_02.png"
_UPVALUE2_, ESI.data[2], (nil)[2] = nil, nil, "img_baoshi_fumo_02_02.png"
_UPVALUE2_, ESI.data[3], (nil)[1] = nil, nil, "img_baoshi_fumo_03.png"
_UPVALUE2_, ESI.data[3], (nil)[2] = nil, nil, "img_baoshi_fumo_03_02.png"
_UPVALUE2_, ESI.data[4], (nil)[1] = nil, nil, "img_baoshi_fumo_04.png"
_UPVALUE2_, ESI.data[4], (nil)[2] = nil, nil, "img_baoshi_fumo_04_02.png"
_UPVALUE2_, ESI.data[5], (nil)[1] = nil, nil, "img_baoshi_fumo_05.png"
_UPVALUE2_, ESI.data[5], (nil)[2] = nil, nil, "img_baoshi_fumo_05_02.png"
ESI.data[6], (nil)[1] = nil, "img_baoshi_fumo_06.png"
ESI.data[6], (nil)[2] = nil, "img_baoshi_fumo_06_02.png"
local colors = ESI.data
local baseComponent = require("fgui.base.baseComponent")
local Com_enchantHole = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarGem/Com_enchantHole", Com_enchantHole)
function Com_enchantHole:onInit()
	self.icon = self.fields.icon
end
function Com_enchantHole:onShow()
end
function Com_enchantHole:initData(lv, idx, position)
	local color = warGemCtrl:getGemHoleColor(lv, idx)
	MAX_LV = lv
	lv[1] = lv
	lv[2] = MAX_LV
	dump(lv, "lv >= MAX_LV")
	local info = warGemCtrl:getEnchantedInfo(idx, lv, position)
	local strengthenLv = info and info.strengthenLv or 0
	self.icon:setURL(colors[color][strengthenLv >= MAX_LV and 1 or 2])
	local gemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), lv, idx)
	local unlockLv = ESL.data[position].gemlv
	local gemlv = wargemResRead.getLevel(gemID) or 0
	local isActive = unlockLv <= gemlv and warGemCtrl:isEnchantColorValid(lv, idx, position)
	self:setSelected(isActive)
end
return Com_enchantHole
