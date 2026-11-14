local allianceEscortCtrl = SoraDGetCtrl("allianceEscortCtrl")
local heroltCtrl = include("heroltCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EscortSignUpPanel = class("EscortSignUpPanel", baseFguiPanel)
function EscortSignUpPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EscortSignUpPanel:ctor", self.viewName)
end
function EscortSignUpPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EscortSignUpPanel:onInit()
	print("=======EscortSignUpPanel:onInit")
	self.fields.Com_title:initData(i18n("treasureEscort_text34"), handler(self, self.onClickClose))
	self.fields.Text_tips:setString(i18n("treasureEscort_text35"))
	self.fields.Button_signUp:setString(i18n("pyramid_text_109"))
	self.fields.Button_signUp:addClickListener(handler(self, self.onClickBtnSignUp))
	self.fields.List_team:setItemRenderer(handler(self, self.onTeamItemRenderer))
	local totalNum = armyCtrl:getArmyCompileCount()
	self.fields.List_team:setNumItems(totalNum)
	self.fields.List_team:setScrollEnable(false)
	local heroSelectBanner = SoraDCreatePanel("heroSelectBanner")
	heroSelectBanner:setPosition(0, 0)
	heroSelectBanner:setMode(gHeroSelectBannerStyle.arena)
	self.fields.Loader3D:setContent(heroSelectBanner)
	self.nodeHero = heroSelectBanner
	local data = allianceEscortCtrl:getSignUpData()
	local heroList = data.heroList
	if heroList and next(heroList) then
		local armsList = data.armsList
		local divineBeastList = data.divineBeastList
		local heroCtrl = SoraDGetCtrl("heroCtrl")
		local heroIDList, lieutenantList = heroCtrl:getHeroAndLieutenant(heroList)
		self.nodeHero:filterHerosByMode(heroIDList, armsList, lieutenantList, divineBeastList)
	else
		self.nodeHero:autoFillHeros()
	end
end
function EscortSignUpPanel:onShow()
	print("=======EscortSignUpPanel:onShow")
end
function EscortSignUpPanel:onTeamItemRenderer(index, obj)
	local teamId = index + 1
	local teamName = armyCtrl:getArmyCompileName(teamId) or teamId
	obj:setString(teamName)
	obj:addClickListener(handler(self, self.onClickTeam))
	obj.teamId = teamId
end
function EscortSignUpPanel:onClickTeam(EventContext)
	SoraDPlaySound()
	local teamId = EventContext:getSender().teamId
	armyCtrl:getArmyCompile(teamId)
end
function EscortSignUpPanel:adaptTeam(target, redata)
	dump(redata, "==EscortSignUpPanel:adaptTeam==", 10)
	if not redata or not redata.redata then
		return
	end
	local compile = redata.redata
	local noneCompile = true
	if next(compile) ~= nil then
		for _, v in pairs(compile) do
			if 0 < v then
				noneCompile = false
				break
			end
		end
	end
	if noneCompile then
		SoraDShowMsgBox(i18n("common_text_1449"), i18n("common_text_204"))
		return
	end
	local heroList = redata.heroList
	local armsList = redata.armsList
	local divineBeastList = redata.divineBeastList
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroIDList, lieutenantList = heroCtrl:getHeroAndLieutenant(heroList)
	self.nodeHero:filterHerosByMode(heroIDList, armsList, lieutenantList, divineBeastList)
end
function EscortSignUpPanel:onClickBtnSignUp()
	SoraDPlaySound()
	local heroList = self.nodeHero:exportNewHeros()
	local armsInfo = self.nodeHero:exportArms()
	local divineBeastInfo = self.nodeHero:exportDivineBeast()
	dump(heroList, "==exportNewHeros==")
	if not next(heroList) then
		SoraDShowMsgTip(i18n("treasureEscort_text56"))
		return
	end
	local nameStr = ""
	for i, v in ipairs(heroList) do
		local heroName = i18n(heroltCtrl.getHeroName(v.heroID))
		if i ~= 1 then
			nameStr = nameStr .. "、" .. heroName
		else
			nameStr = nameStr .. heroName
		end
		if v.slaveHeroID then
			local slaveHeroName = i18n(heroltCtrl.getHeroName(v.slaveHeroID))
			nameStr = nameStr .. "、" .. slaveHeroName
		end
	end
	_ENV = ipairs(heroList)
	ipairs(heroList).name = nameStr
	local showMsg = i18n("treasureEscort_text37", ipairs(heroList))
	SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			allianceEscortCtrl:reqSignUp(heroList, armsInfo, divineBeastInfo)
			self:closePanel()
		end
	end)
end
return EscortSignUpPanel
