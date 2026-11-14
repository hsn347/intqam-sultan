local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local Com_runeInfobig = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_runeInfobig", Com_runeInfobig)
function Com_runeInfobig:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_add:addClickListener(handler(self, self.onAddClick))
	self.fields.Btn_replace:setString(i18n("common_text_1417"))
	self.fields.Btn_replace:addClickListener(handler(self, self.onReplaceClick))
	self.luckyLimit = artifactRuneRead.getLuckyValueLimit()
end
function Com_runeInfobig:onItemRenderer(index, obj)
	obj:initData(self.extraProperty[index + 1], self.data.rid, index + 1)
end
function Com_runeInfobig:onShow()
	self.fields.single:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Com_stage:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_lucky:fixPos()
	self.fields.Text_base:fixPos()
	self.fields.Btn_replace:fixPos()
end
function Com_runeInfobig:setRuneInfo(data, tag)
	self.data = data
	self.tag = tag
	self.controllers.c1:setSelectedIndex(1)
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
	artifactRuneRead = i18n("Weapon_Rune_tips_008")
	i18n("Weapon_Rune_tips_008").var = SoradNumStringNoZero(self.data.luckyValue / self.luckyLimit * 100)
	self.fields.Text_lucky:setString(i18n("herovault_text_08", i18n("Weapon_Rune_tips_008")))
end
function Com_runeInfobig:setNoneInfo(str, tag)
	self.tag = tag
	self.fields.Text_choose:setString(str)
	self.controllers.c1:setSelectedIndex(0)
end
function Com_runeInfobig:setCurData(source, target)
	self.sourceData = source
	self.targetData = target
end
function Com_runeInfobig:onAddClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).tag = self.tag
	;(nil).source = self.sourceData
	;(nil).target = self.targetData
	uiManager:show("RuneInheritChoose", nil)
end
function Com_runeInfobig:onReplaceClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).tag = self.tag
	;(nil).source = self.sourceData
	;(nil).target = self.targetData
	uiManager:show("RuneInheritChoose", nil)
end
return Com_runeInfobig
