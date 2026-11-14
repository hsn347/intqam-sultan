local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local Com_runeInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_runeInfo", Com_runeInfo)
function Com_runeInfo:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.luckyLimit = artifactRuneRead.getLuckyValueLimit()
end
function Com_runeInfo:onShow()
	self.fields.single:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Com_stage:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_lucky:fixPos()
	self.fields.Text_base:fixPos()
end
function Com_runeInfo:onItemRenderer(index, obj)
	obj:initData(self.extraProperty[index + 1], self.data.rid, index + 1)
end
function Com_runeInfo:setRuneInfo(data)
	self.data = data
	self.controllers.c1:setSelectedIndex(0)
	self.fields.single:initData(data)
	local info = artifactRuneRead.getRuneInfo(data.rid)
	local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, data.level)
	self.fields.Text_name:setString(i18n(info.RuneName))
	self.fields.Com_stage:initData(data.class or lvCfg.Class)
	artifactRuneRead = i18n(info.RuneName)
	i18n(info.RuneName).level = data.cLevel or data.level
	self.fields.Text_lv:setString(i18n("common_text_600", i18n(info.RuneName)))
	self.fields.Lab_base:setString(i18n("Weapon_Rune_tips_007"))
	local pLvCfg = artifactRuneRead.getPropertiesLvCfg(info.BasicProperties.growType, data.level)
	self.fields.Text_base:setString(buffDesRead.getBuffDes(info.BasicProperties.buffType, info.BasicProperties.buffVal + pLvCfg.GrowingValue, info.BasicProperties.buffMode))
	self.fields.Lab_random:setString(i18n("Weapon_Rune_tips_008"))
	if not data.extraProperty then
		artifactRuneRead = data.extraProperty
	end
	self.extraProperty = data.extraProperty
	self.fields.List:setNumItems(#self.extraProperty)
	if self.data.luckyValue then
		self.fields.Text_lucky:setVisible(true)
		artifactRuneRead = i18n("Weapon_Rune_tips_008")
		i18n("Weapon_Rune_tips_008").var = SoradNumStringNoZero(self.data.luckyValue / self.luckyLimit * 100)
		self.fields.Text_lucky:setString(i18n("herovault_text_08", i18n("Weapon_Rune_tips_008")))
	else
		self.fields.Text_lucky:setVisible(false)
	end
end
function Com_runeInfo:setNoneInfo(str)
	self.fields.Text_choose:setString(str)
	self.controllers.c1:setSelectedIndex(1)
end
return Com_runeInfo
