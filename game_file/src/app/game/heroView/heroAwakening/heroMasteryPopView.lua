local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local buffDesRead = include("buffDesRead")
local constantRead = include("constantRead")
local heroMasteryPopView = class("heroMasteryPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroMasteryPopView")
	end
	return target
end)
function heroMasteryPopView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Node_skill = SoraDGetChildByName(self, "Node_skill")
	self.Sprite_skill = SoraDGetChildByName(self.Node_skill, "Sprite_skill")
	self.Text_des = SoraDGetChildByName(self.Node_skill, "Text_des")
	self.Node_limit = SoraDGetChildByName(self, "Node_limit")
	self.Text_tip = SoraDGetChildByName(self.Node_limit, "Text_tip")
	self.Text_tip:setString(i18n("heroskill_text_07"))
	self.Node_title = SoraDGetChildByName(self.Node_limit, "Node_title")
	self.Text_title = SoraDGetChildByName(self.Node_title, "Text_title")
	self.Text_title:setString(i18n("common_text_2931"))
	SoraDToCenter(self.Node_title)
	self.Node_lv = SoraDGetChildByName(self, "Node_lv")
	self.Text_lvLimitDes = SoraDGetChildByName(self.Node_lv, "Text_lvLimitDes")
	_ENV = i18n("common_text_2931")
	i18n("common_text_2931").lv = gHeroMaxLevel
	self.Text_lvLimitDes:setString(i18n("hero_text_109", i18n("common_text_2931")))
	self.Button_lvGo = SoraDGetChildByName(self.Node_lv, "Button_go")
	self.Button_lvGo:setTitleText(i18n("common_text_477"))
	self.Button_lvGo = include("commonBtnInstance").new(self.Button_lvGo)
	self.Button_lvGo:setHandle(handler(self, self.btnLvGoClick))
	self.Node_chip = SoraDGetChildByName(self, "Node_chip")
	self.Text_chipLimitDes = SoraDGetChildByName(self.Node_chip, "Text_chipLimitDes")
	self.Button_chipGo = SoraDGetChildByName(self.Node_chip, "Button_go")
	self.Button_chipGo:setTitleText(i18n("common_text_477"))
	self.Button_chipGo = include("commonBtnInstance").new(self.Button_chipGo)
	self.Button_chipGo:setHandle(handler(self, self.btnChipGoClick))
	self.Text_active = SoraDGetChildByName(self.Node_skill, "Text_active")
end
function heroMasteryPopView:initData(heroID)
	self.heroID = heroID
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	local skillID = heroltCtrl:getAwakeSkill(self.heroID).skillID
	local skillInfo = heroltCtrl.getSkillDesInfo(skillID)
	local desStr = heroCtrl:getHeroUSkillDes(self.heroID)
	self.Text_des:setString(desStr)
	self.ccs_bg:setTitleName(i18n(skillInfo.herName))
	self.Sprite_skill:setSpriteFrame(skillInfo.herIcon)
	self:suitView()
	self:updateActive()
end
function heroMasteryPopView:suitView()
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	if heroInfo.isAwake then
		self.Node_limit:setVisible(false)
		self.ccs_bg:setSize(cc.size(560, 306))
		self.ccs_bg:setPositionY(-153)
		self.Node_skill:setPositionY(104)
		self.Text_active:setVisible(true)
		self.Text_des:setTextAreaSize(cc.size(300, 200))
		self.Text_active:setPositionY(-215)
	else
		self.Text_des:setTextAreaSize(cc.size(300, 140))
		local isLv = heroInfo.level < gHeroMaxLevel
		self.Text_lvLimitDes:setColor(isLv and cc.c3b(190, 40, 40) or cc.c3b(0, 190, 30))
		self.Button_lvGo:setVisible(isLv)
		SoraDGetChildByName(self.Node_lv, "icon_g"):setVisible(not isLv)
		local awakeInfo = heroltCtrl:getAwakeInfo(self.heroID)
		local ownNum = backpackCtrl:getItemCount(awakeInfo.item)
		local isChip = ownNum < awakeInfo.itemCount
		SoraDGetChildByName(self.Node_chip, "Sprite_chip"):setSpriteFrame(publicRead.getIcon(awakeInfo.item))
		heroCtrl = publicRead.getIcon(awakeInfo.item)
		publicRead.getIcon(awakeInfo.item).num = ownNum
		publicRead.getIcon(awakeInfo.item).need = awakeInfo.itemCount
		self.Text_chipLimitDes:setString(i18n("hero_text_110", publicRead.getIcon(awakeInfo.item)))
		self.Text_chipLimitDes:setColor(isChip and cc.c3b(190, 40, 40) or cc.c3b(0, 190, 30))
		self.Button_chipGo:setVisible(isChip)
		SoraDGetChildByName(self.Node_chip, "icon_g"):setVisible(not isChip)
		self.Text_active:setVisible(false)
	end
end
function heroMasteryPopView:updateActive()
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
		self.Text_active:setVisible(false)
	else
		self.Text_active:setString(desTbl[activeType] or i18n("hero_text_63"))
	end
end
function heroMasteryPopView:btnLvGoClick()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_HERO_SWITCHBOTTOM"
	SoraDSendMessage(nil)
	self:removeFromParent()
end
function heroMasteryPopView:btnChipGoClick()
	local awakeInfo = heroltCtrl:getAwakeInfo(self.heroID)
	heroltCtrl = nil
	;(nil).itemID = awakeInfo.item
	;(nil).needCount = awakeInfo.itemCount
	uiManager:show("newHeroGainChipMethodView", nil)
	self:removeFromParent()
end
return heroMasteryPopView
