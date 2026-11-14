local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemHoleEnchantPanel = class("WarGemHoleEnchantPanel", baseFguiPanel)
function WarGemHoleEnchantPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("WarGemHoleEnchantPanel:ctor", self.viewName)
end
function WarGemHoleEnchantPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WarGem"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function WarGemHoleEnchantPanel:onInit()
	print("=======WarGemHoleEnchantPanel:onInit")
	self.fields.LittleResView:fixPos()
	self.fields.List_enchant:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Label_enchant:setString(i18n("gemEnchant_text_16"))
end
function WarGemHoleEnchantPanel:onItemRenderer(index, obj)
	obj:initData(self.lv, self.idx, index + 1)
end
function WarGemHoleEnchantPanel:onIntoPanel()
	self.fields.LittleResView:setVisible(true)
end
function WarGemHoleEnchantPanel:onLeavePanel()
	self.fields.LittleResView:setVisible(false)
end
function WarGemHoleEnchantPanel:onShow()
	print("=======WarGemHoleEnchantPanel:onShow")
	self.lv = self.param.lv
	self.idx = self.param.idx
	self.fields.LittleResView:setVisible(true)
	self.fields.LittleResView:initData(warGemCtrl:getResParam(self.lv, self.idx))
	self:updateView()
end
function WarGemHoleEnchantPanel:onEnchant(target, data)
	print("onEnchant", data.aniType, data.pos)
	local aniType = data.aniType
	local pos = data.pos
	print("onEnchant===", aniType, pos)
	local item = self.fields.List_enchant:getChildAt(pos - 1)
	if aniType == "enchanted" then
		item:showEnchantEffect()
	elseif aniType == "strenge" then
		item:showLvupEffect()
	elseif aniType == "lock" then
		item:updateEnchant()
	else
		error("undefined ani type:" .. (aniType == nil and "nil" or aniType))
	end
end
function WarGemHoleEnchantPanel:updateView()
	self:updateHole()
	self:updateEnchant()
end
function WarGemHoleEnchantPanel:updateHole()
	local color = warGemCtrl:getGemHoleColor(self.lv, self.idx)
	local title = wargemResRead.getColorTitle(color)
	self.fields.Panel_bg:setString(i18n(title))
	self.fields.Hole:initData(self.lv, self.idx)
	local gemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), self.lv, self.idx)
	if gemID and 0 < gemID then
		self.fields.Text_attr:setString(wargemResRead.getAttrHtmlByID(gemID))
	else
		self.fields.Text_attr:setString(i18n("gemEnchant_text_12"))
	end
end
function WarGemHoleEnchantPanel:updateEnchant()
	self.fields.List_enchant:setNumItems(3)
end
function WarGemHoleEnchantPanel:onHide()
	print("=======WarGemHoleEnchantPanel:onHide")
end
function WarGemHoleEnchantPanel:onDispose()
	print("=======WarGemHoleEnchantPanel:onDispose")
end
return WarGemHoleEnchantPanel
