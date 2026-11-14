local gametop = gModuleMgr.getObject("gametop")
local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroTrainSelectPanel = class("HeroTrainSelectPanel", baseFguiPanel)
function HeroTrainSelectPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroTrainSelectPanel:ctor", self.viewName)
end
function HeroTrainSelectPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroTrainSelectPanel:onInit()
	print("=======HeroTrainSelectPanel:onInit")
	self.lastIndex = -1
	self.fields.Com_Hero:fixPos()
	self.fields.skillList:fixPos()
	self.fields.Label_int:fixPos()
	self.fields.Label_armyNum:fixPos()
	self.fields.Label_needTime:fixPos()
	self.setArmyList, _ENV, self.myPosition = self.proxy.param.position, self.proxy.param.position, self.proxy.param.position
	self.fields.title:initData(i18n("herotrain_title_01"), handler(self, self.onClickClose))
	self.fields.Text_noHero:setString(i18n("herotrain_text_17"))
	self.fields.Text_HeroTitle:setString(i18n("hero_title_07"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addClickListener(handler(self, self.onClickHeroItem))
	self.fields.skillList:setItemRenderer(handler(self, self.onItemSkillRederer))
	self.fields.Button_addArmy:setString(i18n("herotrain_btn_01"))
	self.fields.Button_addArmy:addClickListener(handler(self, self.btnAddArmyClick))
	self.curHeroID = nil
	self.controllers.c1:setSelectedIndex(1)
end
function HeroTrainSelectPanel:onShow()
	print("=======HeroTrainSelectPanel:onShow")
	self:initData()
end
function HeroTrainSelectPanel:initData()
	self.canSelectHeros = heroTrainGroundCtrl:getCanTrainHeroList()
	dump(self.canSelectHeros, "self.canSelectHeros")
	self:initView()
end
function HeroTrainSelectPanel:initView(...)
	_ENV = nil
	;(nil)[gHeroState.HERO_STATE_NORMAL] = true
	;(nil)[gHeroState.HERO_STATE_DEAD] = false
	;(nil)[gHeroState.HERO_STATE_CAPTURED] = false
	;(nil)[gHeroState.HERO_STATE_BATTLE] = false
	;(nil)[gHeroState.HERO_STATE_DEFEND] = true
	local (nil)[gHeroState.HERO_STATE_ESCAPE], stateList = false, nil
	heroCtrl:sortDispatchHerosIDInTrain(self.canSelectHeros, stateList)
	self.fields.List:setNumItems(#self.canSelectHeros)
end
function HeroTrainSelectPanel:heroStateChange(target, redata)
	self:initData()
	self.curHeroID = nil
	self.controllers.c1:setSelectedIndex(1)
end
function HeroTrainSelectPanel:onItemRederer(index, target)
	target:initData(self.canSelectHeros[index + 1])
end
function HeroTrainSelectPanel:selectHeroClick(heroID)
	self.curHeroID = heroID
	self.controllers.c1:setSelectedIndex(0)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.curHeroID)
	if self.heroInfo then
		self.fields.Com_Hero:initData(self.curHeroID)
		local totalTime = heroTrainGroundCtrl:getCostTime(self.setArmyList)
		self.totalInt = math.floor(totalTime / 3600 * heroTrainGroundCtrl:getHourLeaderPoint(self.setArmyList).total)
		local caculateNum = function(armyList)
			local ret = 0
			for _, v in pairs(armyList) do
				ret = ret + v
			end
			return ret
		end
		heroCtrl = nil
		;(nil).num = self.totalInt
		self.fields.Label_int:setString(i18n("herotrain_text_07", nil))
		heroCtrl = i18n("herotrain_text_07", nil)
		i18n("herotrain_text_07", nil).time = SoraDConvertSecondToString(totalTime)
		self.fields.Label_needTime:setString(i18n("hero_text_80", i18n("herotrain_text_07", nil)))
		local armyNum = caculateNum(self.setArmyList)
		if 0 < armyNum then
			self.fields.Label_armyNum:setColor(cc.c3b(222, 182, 121))
			heroCtrl = cc.c3b(222, 182, 121)
			cc.c3b(222, 182, 121).num = caculateNum(self.setArmyList)
			self.fields.Label_armyNum:setString(i18n("herotrain_text_08", cc.c3b(222, 182, 121)))
		else
			self.fields.Label_armyNum:setColor(cc.c3b(255, 0, 0))
			self.fields.Label_armyNum:setString(i18n("herotrain_text_09"))
		end
		self:initSkills()
	end
end
function HeroTrainSelectPanel:cancelHeroClick()
	self.curHeroID = nil
	self.controllers.c1:setSelectedIndex(1)
end
function HeroTrainSelectPanel:initSkills(...)
	local skillIDs = table.keys(self.heroInfo.skillList)
	table.sort(skillIDs)
	local skillList = self.heroInfo.skillList
	self.skillList, _ENV = skillIDs, skillIDs
	for i, v in ipairs(skillIDs) do
		local skillData = skillList[v]
		_ENV = nil
		;(nil).index = i
		;(nil).skillID = v
		_ENV, (nil).quality = self.heroInfo.quality, self.heroInfo.quality
		self.heroInfo.quality.isActive = skillData.isActive
		;(nil).otherData, self.heroInfo.quality.skillLv = self.heroInfo.quality, skillData.activeLevel
		table.insert(self.skillList, nil)
	end
	self.fields.skillList:setNumItems(#self.skillList)
end
function HeroTrainSelectPanel:onItemSkillRederer(index, target)
	target:initData(self.skillList[index + 1], self.curHeroID)
end
function HeroTrainSelectPanel:btnAddArmyClick()
	SoraDPlaySound("checkedSoldier", 411)
	_ENV = nil
	;(nil).armyList = self.setArmyList
	;(nil).heroID = self.curHeroID
	;(nil).myPosition = self.myPosition
	uiManager:show("HeroTrainDispatchArmy", nil)
end
function HeroTrainSelectPanel:onClickHeroItem()
	local index = self.fields.List:getSelectedIndex()
	if index < 0 then
		return
	end
	SoraDPlaySound()
	local obj = self.fields.List:getChildAt(index)
	if self.lastIndex == index then
		self:cancelHeroClick()
		self.fields.List:setSelectedIndex(-1)
		self.lastIndex = -1
	elseif obj:buttonClickcheck() then
		self:selectHeroClick(obj.heroID)
		self.lastIndex = index
	else
		self.fields.List:setSelectedIndex(self.lastIndex)
	end
end
return HeroTrainSelectPanel
