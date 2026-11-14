local armyCtrl = SoraDGetCtrl("armyCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local armyDesRead = include("armyDesRead")
local armyltCtrl = include("armyltCtrl")
local armyLogic = include("armyLogic")
local armorSystemRead = include("armorSystemRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local soldiersDetailViewPanel = class("soldiersDetailViewPanel", baseFguiPanel)
function soldiersDetailViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("soldiersDetailViewPanel:ctor", self.viewName)
end
function soldiersDetailViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function soldiersDetailViewPanel:onInit()
	print("=======soldiersDetailViewPanel:onInit")
	self.tableSoldierList, _ENV = print, print
	self.index = 1
	self.curSoldier = nil
	self.soldierType = 1
	self.skillList, _ENV, self.buildID = print, print, nil
	self.armorId = nil
	self.fields.Panel_bg:setString(i18n("common_title_02"))
	self.fields.Button_info:addClickListener(handler(self, self.btnInfoClickCallBack))
	self.fields.Button_left:addClickListener(handler(self, self.btnPreClickCallBack))
	self.fields.Button_right:addClickListener(handler(self, self.btnNextClickCallBack))
	self.fields.Text_skill:setString(i18n("common_title_03"))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRenderer))
	self.fields.List_page:setNeedAutoFix(false)
	self.fields.Button_promoteT:setString(i18n("gilt_armor_text18"))
	self.fields.Button_promoteT:addClickListener(handler(self, self.onPromoteTClick))
	self.fields.Button_promoteT:setVisible(false)
	self.fields.com_army:fixPos()
	self.fields.com_info:fixPos()
	self.fields.Button_info:fixPos()
end
function soldiersDetailViewPanel:onShow()
	print("=======soldiersDetailViewPanel:onShow")
	self.armyData = self.param.armyData
	self.showMode = self.param.showMode or 0
	self.buildID = self.armyData.bid
	self.soldierType = self.armyData.type
	self.tableSoldierList, self.index = armyLogic.getCanTrainList(self.buildID)
	for k, v in ipairs(self.tableSoldierList) do
		if v.armyid == self.armyData.armyData.armyid then
			self.index = k
			break
		end
	end
	self.controllers.c1:setSelectedIndex(self.showMode)
	self:initData()
end
function soldiersDetailViewPanel:onSkillRenderer(index, obj)
	obj:initData(self.skillList[index + 1])
end
function soldiersDetailViewPanel:initData()
	self:updateView()
end
function soldiersDetailViewPanel:updateView()
	self.curSoldier = self.tableSoldierList[self.index]
	self.fields.com_army:initData(self.curSoldier.armyid, 0, false, self.soldierType == TRAIN_TYPE.TRAP)
	self.fields.com_info:initData(self.curSoldier.armyid, false, nil, self.soldierType == TRAIN_TYPE.TRAP)
	self:updateOwn()
	self.skillList = armyDesRead.getSkill(self.curSoldier.armyid)
	self.fields.List_skill:setNumItems(#self.skillList)
	self.fields.List_page:setNumItems(#self.tableSoldierList)
	self.fields.List_page:setSelectedIndex(self.index - 1)
	local changeLv = armyDesRead.getStarchange(self.curSoldier.armyid)
	local armyLv = armyLogic.getArmyLV(self.curSoldier.armyid)
	if self.soldierType == TRAIN_TYPE.SOLDIERS and not armyLogic.isStarArmy(self.curSoldier.armyid) and (armyLv == 11 or armyLv == 12) and SoraDGetBuildStarLv(self.buildID) < gArmyStar.trainStarLv then
		_ENV = TRAIN_TYPE.TRAP
		TRAIN_TYPE.TRAP.lv = changeLv
		_ENV = nil
		;(nil).lv = armyDesRead.getName(self.curSoldier.armyid)
		TRAIN_TYPE.TRAP.name = i18n("Glory_text_26", nil)
		self.fields.Text_starTip:setString(i18n("Glory_text_01", TRAIN_TYPE.TRAP))
	else
		self.fields.Text_starTip:setString("")
	end
	if armyltCtrl.isWarframeArmyID(self.curSoldier.armyid) then
		self.armorId = armorSystemRead:getArmorIdByArmyId(self.curSoldier.armyid)
		local cfg = armorSystemRead:getArmorRefSoldierInfo(self.armorId)
		local limitTechNum = SoraDGetCtrl("technologyCtrl"):getTechnologyPower(gTechnologyType.ARMOR_SOLIDER_PROMOTION_NUM) or 0
		self.fields.Button_promoteT:setVisible(cfg.newLv == 13 and 0 < limitTechNum and SoraDIsTWarframeOpen(nil, armorSystemRead:getGildedArmorCfg(self.armorId)))
		self:updateBtnPromoteTRed()
	else
		self.armorId = nil
		self.fields.Button_promoteT:setVisible(false)
	end
end
function soldiersDetailViewPanel:updateBtnPromoteTRed()
	local leftPNum = armorSystemCtrl:getMothyPromoteNum()
	local armyNum = armyCtrl:getNormalArmyCount(self.curSoldier.armyid)
	armorSystemCtrl = nil
	;(nil).byUID = true
	self.redBool = SoraDConfigGet("Game:SoldiersCampView:pormoteT~bool", nil) or false
	self.fields.Button_promoteT:setReddot(0 < leftPNum and 0 < armyNum or not self.redBool)
end
function soldiersDetailViewPanel:updateOwn()
	local armyCount = armyCtrl:getArmyCount(self.curSoldier.armyid, ARMY_OPTYPE.NORMAL_ARMY)
	self.fields.Com_own:initData(armyCount, self.soldierType, self.curSoldier.armyid)
	if armyCount <= 0 and self.showMode == 1 then
		self:close()
	end
end
function soldiersDetailViewPanel:btnPreClickCallBack()
	SoraDPlaySound()
	self.index = self.index - 1
	if self.index < 1 then
		self.index = #self.tableSoldierList
	end
	self:updateView()
end
function soldiersDetailViewPanel:btnNextClickCallBack()
	SoraDPlaySound()
	self.index = self.index + 1
	if self.index > #self.tableSoldierList then
		self.index = 1
	end
	self:updateView()
end
function soldiersDetailViewPanel:btnInfoClickCallBack()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("soldier_text_17"))
end
function soldiersDetailViewPanel:onPromoteTClick()
	SoraDPlaySound()
	if not self.redBool then
		self.redBool = true
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:SoldiersCampView:pormoteT~bool", self.redBool, nil)
		self:updateBtnPromoteTRed()
	end
	_ENV = nil
	;(nil).armorId = self.armorId
	;(nil).armyID = self.curSoldier.armyid
	;(nil).isFromLv13 = true
	uiManager:show("soldiersPromoteTView", nil)
end
return soldiersDetailViewPanel
