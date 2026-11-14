local buildLogic = include("buildLogic")
local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local artisanHouseltCtrl = include("artisanHouseltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_artisanBlessLightMain = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ArtisanHouse/Com_artisanBlessLightMain", Com_artisanBlessLightMain)
function Com_artisanBlessLightMain:onInit()
	self:fixChildrenPos()
	local lang = SoraDGetDefaultLanguage()
	if lang ~= "ar" and artisanHouseCtrl:isMaxLevel() then
		self.fields.n29:setPositionX(self.fields.Text_GoldNum:getPositionX() + self.fields.Text_GoldNum:getWidth() + 80)
	end
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Title3:setString(i18n("Artisan_House_06"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_Tips:setColorinfo("#E6C8A1", "#DFDFDF")
	self.fields.Text_Tips:initData()
	self:initData()
end
function Com_artisanBlessLightMain:initData()
	self.isMaxLv = artisanHouseCtrl:isMaxLevel()
	self.controllers.c2:setSelectedIndex(self.isMaxLv and 0 or 1)
	local effectInfo = artisanHouseltCtrl.getNowEffectInfo(SoraDGetCastleLv())
	self.fields.Buff_Item1:initData2(effectInfo.EffectIcon[1] .. ".png", effectInfo.PrivilegeEffect[1], "#E6C8A1", "#BEBEBE")
	self.fields.Buff_Item2:initData2(effectInfo.EffectIcon[2] .. ".png", effectInfo.PrivilegeEffect[2], "#E6C8A1", "#BEBEBE")
	self.giftInfo = artisanHouseltCtrl.getGiftAwardInfo(artisanHouseCtrl:getLevelIndex())
	_ENV = artisanHouseCtrl:getLevelIndex()
	artisanHouseCtrl:getLevelIndex()[1] = "id"
	artisanHouseCtrl:getLevelIndex()[2] = "count"
	self.giftAward = serviceFunctions.tableFormat(self.giftInfo.Rewards, artisanHouseCtrl:getLevelIndex())
	self.fields.Text_GoldNum:setString(string.formatnumberthousands(self.giftInfo.Gold))
	_, self.allSpecialAward = artisanHouseltCtrl.getAllAwardByIndex(artisanHouseCtrl:getLevelIndex())
	_ENV = artisanHouseCtrl:getLevelIndex()
	artisanHouseCtrl:getLevelIndex()[1] = "id"
	artisanHouseCtrl:getLevelIndex()[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(self.allSpecialAward, artisanHouseCtrl:getLevelIndex())
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
end
function Com_artisanBlessLightMain:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function Com_artisanBlessLightMain:onItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1].id, self.allSpecialAward[index + 1].count)
end
function Com_artisanBlessLightMain:onShow()
end
return Com_artisanBlessLightMain
