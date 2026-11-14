local artisanHouseltCtrl = include("artisanHouseltCtrl")
local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_artisanBuffPreview = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ArtisanHouse/Com_artisanBuffPreview", Com_artisanBuffPreview)
function Com_artisanBuffPreview:onInit()
	self.fields.Text_1:setString(i18n("common_text_4488"))
	self.fields.Text_2:setString(i18n("Battle_Towers_24"))
	self.fields.Text_3:setString(i18n("Battle_Towers_25"))
	self.fields.Text_1:fixPos()
	self.fields.Text_2:fixPos()
	self.fields.Text_3:fixPos()
	self.fields.n14:fixPos()
	self.fields.n15:fixPos()
	self.fields.Text_Tips:setString(i18n("Battle_Towers_33"))
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function Com_artisanBuffPreview:initData()
	self.buffList = artisanHouseltCtrl.getBuffListEx()
	self.fields.Scroll_Buff:setNumItems(#self.buffList)
	self.fields.Scroll_Buff:resizeToFit(#self.buffList)
	self.curLv = SoraDGetCastleLv()
	self.controllers.c1:setSelectedIndex(self.curLv > self.buffList[#self.buffList].CastleLv and 1 or 0)
	print("wiseTutorBuffPanel", self.curLv, self.buffList[#self.buffList].CastleLv)
end
function Com_artisanBuffPreview:onItemRenderer(index, target)
	local lvMin = self.buffList[index] and self.buffList[index].CastleLv + 1 or artisanHouseCtrl:getLimitMinLevel()
	local lvMax = self.buffList[index + 1].CastleLv
	target:initData(lvMin, lvMax, self.buffList[index + 1].PrivilegeEffect, index)
end
function Com_artisanBuffPreview:onShow()
end
return Com_artisanBuffPreview
