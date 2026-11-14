local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local Com_Intensify = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_Intensify", Com_Intensify)
function Com_Intensify:onInit()
	self.fields.Lab_base:setString(i18n("Weapon_Rune_tips_007"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_Intensify:onShow()
	self.fields.com_stage:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_curLv:fixPos()
	self.fields.Text_nextLv:fixPos()
	self.fields.n33:fixPos()
	self.fields.n33:setScaleX(SoraDFIsRA() and 0.55 or -0.55)
	self.fields.com_curStage:fixPos()
	self.fields.com_nextStage:fixPos()
	self.fields.n45:setScaleX(SoraDFIsRA() and 0.55 or -0.55)
end
function Com_Intensify:onItemRenderer(index, obj)
	obj:initData(self.baseProperty[index + 1])
end
function Com_Intensify:setShowIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function Com_Intensify:initData(data)
	local info = artifactRuneRead.getRuneInfo(data.rid)
	local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, data.level)
	self.fields.single:initData(data)
	self.fields.Text_name:setString(i18n(info.RuneName))
	self.fields.com_stage:initData(lvCfg.Class)
	artifactRuneRead = i18n(info.RuneName)
	i18n(info.RuneName).level = lvCfg.Level
	self.fields.Text_curLv:setString(i18n("common_text_600", i18n(info.RuneName)))
	artifactRuneRead = i18n("common_text_600", i18n(info.RuneName))
	i18n("common_text_600", i18n(info.RuneName)).level = lvCfg.Level
	self.fields.Text_lv:setString(i18n("common_text_600", i18n("common_text_600", i18n(info.RuneName))))
	self.curLv = data.level
	artifactRuneRead = i18n("common_text_600", i18n("common_text_600", i18n(info.RuneName)))
	i18n("common_text_600", i18n("common_text_600", i18n(info.RuneName))).curVal = data.exp
	i18n("common_text_600", i18n("common_text_600", i18n(info.RuneName))).nextVal = lvCfg.Exp
	self.fields.bar:setCur(i18n("common_text_600", i18n("common_text_600", i18n(info.RuneName))))
	self.baseProperty, artifactRuneRead = self.fields.bar.setCur, self.fields.bar.setCur
	local pLvCfg = artifactRuneRead.getPropertiesLvCfg(info.BasicProperties.growType, data.level)
	local base = buffDesRead.getBuffDes(info.BasicProperties.buffType, info.BasicProperties.buffVal + pLvCfg.GrowingValue, info.BasicProperties.buffMode)
	self.baseProperty[1], artifactRuneRead = info.BasicProperties.buffVal + pLvCfg.GrowingValue, info.BasicProperties.buffVal + pLvCfg.GrowingValue
	self.baseProperty[1].cur = base
	self.fields.List:setNumItems(#self.baseProperty)
end
function Com_Intensify:setPreData(preData)
	local info = artifactRuneRead.getRuneInfo(preData.rid)
	local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, preData.level)
	artifactRuneRead = nil
	;(nil).level = lvCfg.Level
	self.fields.Text_nextLv:setString(i18n("common_text_600", nil))
	self.preLv = preData.level
	local isUnlock, classLimit, levlLimit = artifactRuneRead.getLimitSeaonCfg(lvCfg.season)
	if levlLimit <= lvCfg.Slevel then
		lvCfg.Exp = 0
	end
	artifactRuneRead = i18n("common_text_600", nil)
	i18n("common_text_600", nil).preVal = preData.exp
	i18n("common_text_600", nil).nextPreVal = lvCfg.Exp
	i18n("common_text_600", nil).total = preData.addExp
	i18n("common_text_600", nil).preLevel = self.preLv
	i18n("common_text_600", nil).maxLv = levlLimit
	self.fields.bar:setPre(i18n("common_text_600", nil))
	local pLvCfg = artifactRuneRead.getPropertiesLvCfg(info.BasicProperties.growType, preData.level)
	local preBase = buffDesRead.getBuffDes(info.BasicProperties.buffType, info.BasicProperties.buffVal + pLvCfg.GrowingValue, info.BasicProperties.buffMode)
	self.baseProperty[1].pre = preBase
	self.fields.List:setNumItems(#self.baseProperty)
end
function Com_Intensify:setAdvanceData(data)
	local info = artifactRuneRead.getRuneInfo(data.rid)
	local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, data.level)
	self.fields.single:initData(data)
	self.fields.Text_name:setString(i18n(info.RuneName))
	self.fields.com_curStage:initData(lvCfg.Class)
	self.fields.com_nextStage:initData(lvCfg.Class + 1)
	self.baseProperty, artifactRuneRead = self.fields.com_nextStage.initData, self.fields.com_nextStage.initData
	local pLvCfg = artifactRuneRead.getPropertiesLvCfg(info.BasicProperties.growType, data.level)
	local base = buffDesRead.getBuffDes(info.BasicProperties.buffType, info.BasicProperties.buffVal + pLvCfg.GrowingValue, info.BasicProperties.buffMode)
	self.baseProperty[1], artifactRuneRead = info.BasicProperties.buffVal + pLvCfg.GrowingValue, info.BasicProperties.buffVal + pLvCfg.GrowingValue
	self.baseProperty[1].cur = base
	local npLvCfg = artifactRuneRead.getPropertiesLvCfg(info.BasicProperties.growType, data.level + 1)
	local preBase = buffDesRead.getBuffDes(info.BasicProperties.buffType, info.BasicProperties.buffVal + npLvCfg.GrowingValue, info.BasicProperties.buffMode)
	self.baseProperty[1].pre = preBase
	self.fields.List:setNumItems(#self.baseProperty)
end
return Com_Intensify
