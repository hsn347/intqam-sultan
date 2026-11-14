local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newHeroMasteryPopViewPanel = class("newHeroMasteryPopViewPanel", baseFguiPanel)
function newHeroMasteryPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("newHeroMasteryPopViewPanel:ctor", self.viewName)
end
function newHeroMasteryPopViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NewHeroView"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function newHeroMasteryPopViewPanel:onInit()
	print("=======newHeroMasteryPopViewPanel:onInit")
	self.fields.Text_title:setString(i18n("common_text_2931"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.heroID = self.param.heroID
	self:initData(self.heroID)
end
function newHeroMasteryPopViewPanel:onShow()
	print("=======newHeroMasteryPopViewPanel:onShow")
end
function newHeroMasteryPopViewPanel:onHide()
	print("=======newHeroMasteryPopViewPanel:onHide")
end
function newHeroMasteryPopViewPanel:onDispose()
	print("=======newHeroMasteryPopViewPanel:onDispose")
end
function newHeroMasteryPopViewPanel:initData(heroID)
	self.heroID = heroID
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	local skillID = heroltCtrl:getAwakeSkill(self.heroID).skillID
	local skillInfo = heroltCtrl.getSkillDesInfo(skillID)
	local skillAddition, awakeAddition, stuntAddition, masteryAddition = heroCtrl:getHeroPalaceBuff(self.heroID)
	local desStr = heroCtrl:getHeroUSkillDes(self.heroID, awakeAddition)
	self.fields.Text_des:setString(desStr)
	self.fields.Panel_bg:setTitle(i18n(skillInfo.herName))
	self.fields.skillIcon:setIcon(skillInfo.herIcon)
	self:suitView()
	self:updateActive()
end
function newHeroMasteryPopViewPanel:suitView()
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	if heroInfo.isAwake then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_get:setString(i18n("prison_text_25"))
		self.fields.Text_get:setColor(cc.c3b(240, 230, 210))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_get:setString(i18n("heroskill_text_07"))
		self.fields.Text_get:setColor(cc.c3b(190, 40, 40))
		local isLv = heroInfo.level < gHeroMaxLevel
		local awakeInfo = heroltCtrl:getAwakeInfo(self.heroID)
		local ownNum = backpackCtrl:getItemCount(awakeInfo.item)
		local heroCtrl, heroltCtrl, isChip = cc.c3b(190, 40, 40)
		cc.c3b(190, 40, 40).icon = "btn_main_hero.png"
		heroCtrl = cc.c3b(190, 40, 40)
		cc.c3b(190, 40, 40).lv = gHeroMaxLevel
		cc.c3b(190, 40, 40).title = i18n("hero_text_109", cc.c3b(190, 40, 40))
		cc.c3b(190, 40, 40).isLock = isLv
		heroCtrl, cc.c3b(190, 40, 40).type = i18n("hero_text_109", cc.c3b(190, 40, 40)), 1
		i18n("hero_text_109", cc.c3b(190, 40, 40)).icon = publicRead.getIcon(awakeInfo.item)
		heroCtrl = gHeroMaxLevel
		gHeroMaxLevel.num = ownNum
		gHeroMaxLevel.need = awakeInfo.itemCount
		i18n("hero_text_109", cc.c3b(190, 40, 40)).title = i18n("hero_text_110", gHeroMaxLevel)
		i18n("hero_text_109", cc.c3b(190, 40, 40)).isLock = isChip
		i18n("hero_text_109", cc.c3b(190, 40, 40)).type = 2
		self.limitList, awakeInfo.item[1] = awakeInfo.item, cc.c3b(190, 40, 40)
		self.limitList, awakeInfo.item[2] = awakeInfo.item, i18n("hero_text_109", cc.c3b(190, 40, 40))
		self.fields.List:setNumItems(#self.limitList)
	end
end
function newHeroMasteryPopViewPanel:onItemRederer(index, target)
	target:initData(self.limitList[index + 1])
	target:setHandle(handler(self, self.btnGoClick))
end
function newHeroMasteryPopViewPanel:updateActive()
	_ENV = nil
	;(nil)[gSkillActiveType.PASSIVE_SKILL] = i18n("hero_text_63")
	;(nil)[gSkillActiveType.BATTLE_SKILL] = i18n("hero_text_64")
	local (nil)[gSkillActiveType.INITIATIVE_SKILL], desTbl = i18n("hero_text_65"), nil
	local awakeInfo = heroltCtrl:getAwakeSkill(self.heroID)
	local activeType = awakeInfo.activeType[1] or 1
	local isSame = true
	for k, v in ipairs(awakeInfo.activeType) do
		if v ~= activeType then
			isSame = false
			break
		end
	end
	if not isSame then
		self.fields.Text_get:setVisible(false)
	else
		self.fields.Text_get:setVisible(true)
		self.fields.Text_get:setColor(cc.c3b(240, 230, 210))
		self.fields.Text_get:setString(desTbl[activeType] or i18n("hero_text_63"))
	end
end
function newHeroMasteryPopViewPanel:btnGoClick(type)
	if type == 1 then
		self:close()
	elseif type == 2 then
		local awakeInfo = heroltCtrl:getAwakeInfo(self.heroID)
		heroltCtrl = nil
		;(nil).itemID = awakeInfo.item
		;(nil).needCount = awakeInfo.itemCount
		uiManager:show("newHeroGainChipMethodView", nil)
		self:close()
	end
end
return newHeroMasteryPopViewPanel
