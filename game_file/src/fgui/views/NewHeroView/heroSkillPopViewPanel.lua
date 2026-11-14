local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroSkillPopViewPanel = class("heroSkillPopViewPanel", baseFguiPanel)
function heroSkillPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("heroSkillPopViewPanel:ctor", self.viewName)
end
function heroSkillPopViewPanel:onInit()
	print("=======heroSkillPopViewPanel:onInit")
	self.valList, _ENV = print, print
	self.fields.List_attr:setItemRenderer(handler(self, self.onItemRenderer))
end
function heroSkillPopViewPanel:onShow()
	print("=======heroSkillPopViewPanel:onShow")
	self.heroID = self.param and self.param.heroID
	self.skillID = self.param.skillID
	self.skillQuality = self.param.quality
	self.otherData = self.param.otherData
	self:initData()
end
function heroSkillPopViewPanel:onItemRenderer(index, obj)
	obj:initData(self.valList[index + 1].val, self.valList[index + 1].quality)
	obj:isSelect(self.valList[index + 1].isSelect)
end
function heroSkillPopViewPanel:initData()
	local maxQuality = self.skillQuality
	if self.heroID then
		maxQuality = heroltCtrl:getHeroAwakeMaxQuality(self.heroID)
	end
	self.skillDes = heroltCtrl.getSkillDesInfo(self.skillID)
	self.allSkillInfo = heroltCtrl:getSkillInfo(self.skillID)
	self.fields.Panel_bg:setString(i18n(self.skillDes.herName))
	self.fields.Sprite_skillBg:setSpriteFrame(heroltCtrl.getSkillBg(self.skillQuality))
	self.fields.Image_skillIcon:setSpriteFrame(self.skillDes.herIcon)
	self.fields.Text_skillDes:setString(heroltCtrl:getSkillDes(self.skillID, self.skillQuality or maxQuality))
	local getFirstSkillData = self.allSkillInfo[gHeroQuality.WHITE]
	heroltCtrl = gHeroQuality.WHITE
	gHeroQuality.WHITE[gSkillActiveType.PASSIVE_SKILL] = i18n("hero_text_63")
	gHeroQuality.WHITE[gSkillActiveType.BATTLE_SKILL] = i18n("hero_text_64")
	local gHeroQuality.WHITE[gSkillActiveType.INITIATIVE_SKILL], desTbl = i18n("hero_text_65"), gHeroQuality.WHITE
	self.fields.Text_tip:setColor(cc.c3b(215, 195, 155))
	self.fields.Text_tip:setString(getFirstSkillData.activeType and desTbl[getFirstSkillData.activeType] or i18n("hero_text_63"))
	if self.otherData then
		if not self.otherData.isActive then
			heroltCtrl = cc.c3b(215, 195, 155)
			cc.c3b(215, 195, 155).lv = self.otherData.skillLv
			self.fields.Text_tip:setString(i18n("hero_text_81", cc.c3b(215, 195, 155)))
			self.myIsLock = true
		elseif self.otherData.isPreView then
			self.fields.Text_tip:setString(#self.allSkillInfo > 5 and i18n("hero_text_125") or i18n("hero_text_29"))
			self.fields.Text_tip:setColor(#self.allSkillInfo > 5 and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 0))
		end
	end
	self.valList, heroltCtrl = self.fields.Text_tip.setColor, self.fields.Text_tip.setColor
	for i, v in ipairs(self.allSkillInfo) do
		local isSelect = false
		if not self.myIsLock and self.skillQuality == v.quality or self.otherData and self.otherData.isPreView and v.quality == maxQuality then
			isSelect = true
		end
		heroltCtrl = i18n("hero_text_81", cc.c3b(215, 195, 155))
		i18n("hero_text_81", cc.c3b(215, 195, 155)).val = buffDesRead.getTitleValueWithValue(v.buffType, v.buffValue)
		i18n("hero_text_81", cc.c3b(215, 195, 155)).quality = v.quality
		i18n("hero_text_81", cc.c3b(215, 195, 155)).isSelect = isSelect
		table.insert(self.valList, i18n("hero_text_81", cc.c3b(215, 195, 155)))
	end
	self.fields.List_attr:setNumItems(#self.valList)
end
return heroSkillPopViewPanel
