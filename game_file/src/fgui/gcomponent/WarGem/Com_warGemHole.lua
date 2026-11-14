local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_warGemHole = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarGem/Com_warGemHole", Com_warGemHole)
function Com_warGemHole:onInit()
	_UPVALUE3_ = nil
	self.enchants, (nil)[1] = nil, self.fields.enchant1
	self.enchants, (nil)[2] = nil, self.fields.enchant2
	self.enchants, (nil)[3] = nil, self.fields.enchant3
	self.fields.enchant1:fixPos()
	self.fields.enchant3:fixPos()
end
function Com_warGemHole:onShow()
end
function Com_warGemHole:initData(lv, idx)
	self.lv = lv
	self.idx = idx
	local buildLv = SoraDGetBuildLv(BUILDID.MIRACLE)
	local isWarLv, warLv = buildLogic.isBuildWarLv(buildLv)
	local unlock = isWarLv and warLv >= self.lv
	if not unlock then
		self.controllers.Ctrl_status:setSelectedIndex(2)
		return
	end
	local gemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), lv, idx)
	self:setGem(gemID)
	local color = warGemCtrl:getGemHoleColor(lv, idx)
	self:setColor(color)
	self:updateEnchant()
end
function Com_warGemHole:setGem(gemID)
	self.gemID = gemID
	if gemID and 0 < gemID then
		self.controllers.Ctrl_status:setSelectedIndex(1)
		local icon = wargemResRead.getIcon(gemID)
		self.fields.Icon_gem:setURL(icon)
		local lv = wargemResRead.getLevel(gemID)
		self.fields.Text_lv:setString("LV." .. lv)
	else
		self.controllers.Ctrl_status:setSelectedIndex(0)
	end
end
function Com_warGemHole:updateEnchant()
	for i = 1, 3 do
		self.enchants[i]:initData(self.lv, self.idx, i)
	end
end
function Com_warGemHole:setLv(lv)
	self.controllers.Ctrl_status:setSelectedIndex(0 < lv and 1 or 0)
	self.fields.Text_lv:setString("LV." .. lv)
end
function Com_warGemHole:setColor(color)
	self.fields.Com_color:setColor(color)
	if not self.gemID or self.gemID == 0 then
		self.fields.Icon_small:setURL(warGemltCtrl:getStoneColorIconSmall(color))
	end
end
function Com_warGemHole:playMerge()
	self.transitions.merge:play()
end
function Com_warGemHole:playInlay()
	self.transitions.inlay:play()
end
function Com_warGemHole:playChangeColor()
	self.transitions.changeColor:play()
end
return Com_warGemHole
