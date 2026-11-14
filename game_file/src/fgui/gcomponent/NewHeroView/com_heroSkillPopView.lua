local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffDesRead = include("buffDesRead")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local com_heroSkillPopView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/com_heroSkillPopView", com_heroSkillPopView)
function com_heroSkillPopView:onInit()
	self.valList, _ENV = nil, nil
	self.fields.List_attr:setItemRenderer(handler(self, self.onItemRenderer))
end
function com_heroSkillPopView:onShow()
end
function com_heroSkillPopView:onItemRenderer(index, obj)
	obj:initData(self.valList[index + 1].val, self.valList[index + 1].quality)
	obj:isSelect(self.valList[index + 1].isSelect)
end
function com_heroSkillPopView:initData(heroID, skillID, quality, otherData, index)
	self.heroID = heroID
	self.skillID = skillID
	self.skillQuality = quality
	self.skillDes = heroltCtrl.getSkillDesInfo(self.skillID)
	self.allSkillInfo = heroltCtrl:getSkillInfo(self.skillID)
	self.otherData = otherData
	self:initView()
end
function com_heroSkillPopView:initView(...)
	local maxQuality = heroltCtrl:getHeroAwakeMaxQuality(self.heroID)
	self.fields.title:setString(i18n(self.skillDes.herName))
	local skillAddition, awakeAddition, stuntAddition, masteryAddition = heroCtrl:getHeroPalaceBuff(self.heroID)
	local skillCfg = heroltCtrl:getSkillCfg(self.skillID, self.skillQuality or maxQuality)
	local finalVal = math.floor(skillCfg.buffValue * (1 + skillAddition / 1000))
	local skillDesStr = buffDesRead.getTitleWithValue(skillCfg.buffType, finalVal)
	if 0 < skillAddition then
		local oriStr = buffDesRead.getTitleValueWithValue(skillCfg.buffType, skillCfg.buffValue, true)
		local palaceStr = buffDesRead.getTitleValueWithValue(skillCfg.buffType, finalVal - skillCfg.buffValue, true)
		heroltCtrl = true
		;(true).des = skillDesStr
		;(true).ori = oriStr
		;(true).add = palaceStr
		skillDesStr = i18n("%{des}(%{ori}+%{add})", true)
	end
	self.fields.Text_skillDes:setString(skillDesStr)
	local getFirstSkillData = self.allSkillInfo[gHeroQuality.WHITE]
	heroltCtrl = gHeroQuality.WHITE
	gHeroQuality.WHITE[gSkillActiveType.PASSIVE_SKILL] = i18n("hero_text_63")
	gHeroQuality.WHITE[gSkillActiveType.BATTLE_SKILL] = i18n("hero_text_64")
	local gHeroQuality.WHITE[gSkillActiveType.INITIATIVE_SKILL], desTbl = i18n("hero_text_65"), gHeroQuality.WHITE
	self.fields.Text_tip:setColor(cc.c3b(152, 152, 152))
	self.fields.Text_tip:setString(getFirstSkillData.activeType and desTbl[getFirstSkillData.activeType] or i18n("hero_text_63"))
	if self.otherData then
		if not self.otherData.isActive then
			heroltCtrl = cc.c3b(152, 152, 152)
			cc.c3b(152, 152, 152).lv = self.otherData.skillLv
			self.fields.Text_tip:setString(i18n("hero_text_81", cc.c3b(152, 152, 152)))
			self.myIsLock = true
		elseif self.otherData.isPreView then
			self.fields.Text_tip:setString(#self.allSkillInfo > 5 and i18n("hero_text_125") or i18n("hero_text_29"))
			self.fields.Text_tip:setColor(#self.allSkillInfo > 5 and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 0))
		end
	end
	self.valList, heroltCtrl = self.fields.Text_tip.setColor, self.fields.Text_tip.setColor
	for i, v in ipairs(self.allSkillInfo) do
		local isSelect = false
		if not self.myIsLock and self.skillQuality == v.quality or self.otherData.isPreView and v.quality == maxQuality then
			isSelect = true
		end
		heroltCtrl = i18n("hero_text_81", cc.c3b(152, 152, 152))
		i18n("hero_text_81", cc.c3b(152, 152, 152)).val = buffDesRead.getTitleValueWithValue(v.buffType, v.buffValue)
		i18n("hero_text_81", cc.c3b(152, 152, 152)).quality = v.quality
		i18n("hero_text_81", cc.c3b(152, 152, 152)).isSelect = isSelect
		table.insert(self.valList, i18n("hero_text_81", cc.c3b(152, 152, 152)))
	end
	self.fields.List_attr:setNumItems(#self.valList)
end
return com_heroSkillPopView
