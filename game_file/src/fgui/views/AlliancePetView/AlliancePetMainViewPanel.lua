local alliancePetRead = include("alliancePetRead")
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AlliancePetMainViewPanel = class("AlliancePetMainViewPanel", baseFguiPanel)
local string_fnt = string.formatnumberthousands
function AlliancePetMainViewPanel:ctor(...)
	AlliancePetMainViewPanel.super.ctor(self, ...)
	print("AlliancePetMainViewPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.donateData, AlliancePetMainViewPanel, self.state = gAlliancePetState.CALL, gAlliancePetState.CALL, gAlliancePetState.CALL
end
function AlliancePetMainViewPanel:onInit()
	print("=======AlliancePetMainViewPanel:onInit")
	self.fields.Com_title:initData(i18n("alliance_beast_text_31"), handler(self, self.onClickClose))
	if IsArClient then
		self.fields.Com_title:setHelpCallBack(handler(self, self.onClickHelp))
	end
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.petSingle = self.fields.pet_model
	self.Text_pet_name = self.fields.Text_pet_name
	self.Text_title = self.fields.Text_title
	self.fields.Button_trial:setString(i18n("alliance_beast_btn_03"))
	self.fields.Button_trial:addClickListener(handler(self, self.onClickTrial))
	self:setTrialBtnEffect()
	self.fields.Button_rank:setString(i18n("common_text_851"))
	self.fields.Button_rank:addClickListener(handler(self, self.onClickRank))
	self.fields.Text_state1_1:setString(i18n("alliance_beast_text_18"))
	self.Text_state_1_2 = self.fields.Text_state1_2
	self:setBlessEffect()
	self.loadingBar = self.fields.Node_bar:getChild("bar")
	self.labelCurPoint = self.loadingBar:getChild("title")
	self.fields.List_lv:setNumItems(2)
	local children = self.fields.List_lv:getChildren()
	local _fields1 = fguiHelper.get_fields(children[1])
	_fields1.Text_title:setString(i18n("common_text_279"))
	self.Text_row_1 = _fields1.Text_value1
	self.Sprite_row_1 = _fields1.Com_effect
	self.Text_value_1 = _fields1.Text_value2
	local _fields2 = fguiHelper.get_fields(children[2])
	_fields2.Text_title:setString(i18n("alliance_beast_text_13"))
	self.Text_row_2 = _fields2.Text_value1
	self.Sprite_row_2 = _fields2.Com_effect
	self.Text_value_2 = _fields2.Text_value2
	self.Text_donate_time = SoraDCreateTimerLabel(self, self.fields.Text_donate_time)
	self.Text_donate_time:setTimeEndListener(function(...)
		self.Text_donate_time:setVisible(false)
	end)
	self.fields.List_donate:setItemRenderer(handler(self, self.onDonateItemRenderer))
	self.fields.List_donate:setNeedAutoFix(false)
	self.fields.List_donate:setNumItems(3)
	self.Text_des_1 = self.fields.Text_des_1
	self.Text_des_1:setString(i18n("alliance_beast_text_17"))
	self.Text_des_2 = self.fields.Text_des_2
	self.Button_call = self.fields.Button_call
	self.Button_call:setTitleText(i18n("arena_btn_04"))
	self.Button_call:addClickListener(handler(self, self.onClickBtnCall))
	self.loadingBarHp = self.fields.bar_hp
	self.Text_cur_lv = self.loadingBarHp:getChild("Text_cur_lv")
	self.loadingBarHp_title = self.loadingBarHp:getChild("title")
	self:setTrialEffect()
	if not SoraDFIsRA() then
		for __, v in ipairs(children) do
			v:fixChildrenPos()
		end
		self.Sprite_row_1:setScaleX(-0.9)
		self.Sprite_row_2:setScaleX(-0.9)
		self.fields.Node_bar:fixPos()
		self.fields.Node_bar:fixChildrenPos()
		self.loadingBar:fixChildrenPos()
	end
end
function AlliancePetMainViewPanel:onShow()
	print("=======AlliancePetMainViewPanel:onShow")
	alliancePetCtrl:sendReqPetInfo()
	SoraDShowLoading(self, nil, nil, nil, 15)
	local director = cc.Director:getInstance()
	director:setProjection(cc.DIRECTOR_PROJECTION2_D)
end
function AlliancePetMainViewPanel:onHide(...)
	if SoraDCurrentSceneShowView("worldMapView") and gEnableWorldMap3D then
		local director = cc.Director:getInstance()
		director:setProjection(cc.DIRECTOR_PROJECTION3_D)
	end
end
function AlliancePetMainViewPanel:onClickHelp(...)
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_ALTAR_PET)
end
function AlliancePetMainViewPanel:onClickRank()
	SoraDPlaySound()
	alliancePetCtrl:sendReqWorshipRank()
	local panel = SoraDCreatePanel("collectSalaryAllianceRank")
	_ENV = nil
	;(nil).title = i18n("god_beast_text_45")
	;(nil).score = i18n("god_beast_text_46")
	panel:setNameData(nil)
	panel:show()
end
function AlliancePetMainViewPanel:initData(...)
	self.state = alliancePetCtrl:getAlliancePetState()
	self.curShowLv = alliancePetCtrl:getAlliancePetLv()
	if self.state == gAlliancePetState.BLESS then
		self:refreshState1()
	elseif self.state == gAlliancePetState.DONATE then
		self:refreshState2()
	elseif self.state == gAlliancePetState.TRIAL then
		self:refreshState3()
	end
	self.Text_pet_name:setString(alliancePetRead.getName(self.petType))
	self.petSingle:setVisible(true)
	self:refreshPetModel()
end
function AlliancePetMainViewPanel:refreshPetModel(...)
	local pid, rank = alliancePetRead.getPetSinglePidAndRank(self.petType, self.curShowLv)
	if not (self.curPid and self.curRank) or self.curPid ~= pid or self.curRank ~= rank then
		self.curPid = pid
		self.curRank = rank
		alliancePetRead = nil
		;(nil).pid = pid
		;(nil).rank = rank
		self.petSingle:initData(nil)
		self.petSingle:setPetScale(0.9)
	end
end
function AlliancePetMainViewPanel:refreshState1(...)
	self.controllers.c1:setSelectedIndex(0)
	self.Text_title:setString(i18n("alliance_beast_text_20"))
	self.Text_time:setTimeLast(function(ticket)
		return i18n("alliance_beast_text_19") .. ticket
	end)
	self.Text_time:beginTime(alliancePetCtrl:getAlliancePetBlessingTimeCD())
	local curLv = alliancePetCtrl:getAlliancePetLv()
	self.Text_state_1_2:setString(alliancePetRead.getWishDesByType(self.petType, curLv))
end
function AlliancePetMainViewPanel:refreshState2(...)
	self.controllers.c1:setSelectedIndex(1)
	self.Text_title:setString(i18n("alliance_beast_text_11"))
	self.Text_time:setTimeLast(function(ticket)
		return i18n("alliance_beast_text_10") .. ticket
	end)
	self.Text_time:beginTime(alliancePetCtrl:getAlliancePetReturnTimeCD())
	self.donateData = alliancePetCtrl:getAlliancePetData()
	for __, v in ipairs(self.fields.List_donate:getChildren()) do
		v:initData(self.petType)
	end
	local donateTimeCD = alliancePetCtrl:getDonateTimeCD()
	if donateTimeCD <= 0 then
		self.Text_donate_time:setVisible(false)
	else
		self.Text_donate_time:setVisible(true)
		self.Text_donate_time:beginTime(donateTimeCD)
		if alliancePetCtrl:checkDonateLock() then
			self.Text_donate_time:setTitleColor(display.COLOR_RED)
		else
			self.Text_donate_time:setTitleColor(cc.c3b(76, 230, 26))
		end
	end
	self:refreshNodeLvInfo()
end
function AlliancePetMainViewPanel:refreshNodeLvInfo(...)
	local curLv = self.curShowLv
	local curSword = alliancePetRead.getSword(self.petType, curLv)
	self.maxLv = alliancePetRead.getMaxLevel(self.petType)
	if self.maxLv == curLv then
		alliancePetRead = nil
		;(nil).lv = curLv
		self.Text_row_1:setString(string.format("%s(MAX)", i18n("common_text_100", nil)))
		self.Text_row_2:setString(string.format("%s(MAX)", string_fnt(curSword)))
		self.Sprite_row_1:setVisible(false)
		self.Sprite_row_2:setVisible(false)
		self.Text_value_1:setVisible(false)
		self.Text_value_2:setVisible(false)
		self.loadingBar:setMax(1)
		self.loadingBar:setValue(1)
		self.labelCurPoint:setString(i18n("common_text_283"))
		return
	else
		alliancePetRead = i18n("common_text_283")
		i18n("common_text_283").lv = curLv
		self.Text_row_1:setString(string.format("%s", i18n("common_text_100", i18n("common_text_283"))))
		self.Text_row_2:setString(string.format("%s", string_fnt(curSword)))
	end
	local nextLv = self.curShowLv + 1
	local nextSword = alliancePetRead.getSword(self.petType, nextLv)
	if self.maxLv == nextLv then
		alliancePetRead = string.format("%s", string_fnt(curSword))
		string.format("%s", string_fnt(curSword)).lv = nextLv
		self.Text_value_1:setString(string.format("%s(MAX)", i18n("common_text_100", string.format("%s", string_fnt(curSword)))))
		self.Text_value_2:setString(string.format("%s(MAX)", string_fnt(nextSword)))
	else
		alliancePetRead = string.format("%s(MAX)", string_fnt(nextSword))
		string.format("%s(MAX)", string_fnt(nextSword)).lv = nextLv
		self.Text_value_1:setString(i18n("common_text_100", string.format("%s(MAX)", string_fnt(nextSword))))
		self.Text_value_2:setString(string_fnt(nextSword))
	end
	local needPoint = alliancePetRead.getNeedPoint(self.petType, self.curShowLv)
	if needPoint then
		self.loadingBar:setMax(needPoint)
		self.loadingBar:setValue(self.donateData.point)
		self.labelCurPoint:setString(string_fnt(self.donateData.point) .. "/" .. string_fnt(needPoint))
	end
end
function AlliancePetMainViewPanel:refreshState3(...)
	self.controllers.c1:setSelectedIndex(2)
	self.Text_title:setString(i18n("alliance_beast_btn_04"))
	self.Text_time:setTimeLast(function(ticket)
		return i18n("alliance_beast_text_10") .. ticket
	end)
	self.Text_time:beginTime(alliancePetCtrl:getAlliancePetReturnTimeCD())
	if not alliancePetRead.getRewards(self.petType, self.curShowLv) then
		local _ENV, rewards = alliancePetRead.getRewards(self.petType, self.curShowLv), alliancePetRead.getRewards(self.petType, self.curShowLv)
	end
	local _ENV, rewardsList = self.petType, self.petType
	if IsArClient then
		alliancePetRead = alliancePetCtrl:getAlliancePetReturnTimeCD()
		alliancePetCtrl:getAlliancePetReturnTimeCD()[1] = "id"
		alliancePetCtrl:getAlliancePetReturnTimeCD()[2] = "count"
		rewardsList = serviceFunctions.tableFormat(rewards, alliancePetCtrl:getAlliancePetReturnTimeCD())
	else
		_UPVALUE3_ = alliancePetCtrl:getAlliancePetReturnTimeCD()
		alliancePetCtrl:getAlliancePetReturnTimeCD()[1] = "id"
		alliancePetCtrl:getAlliancePetReturnTimeCD()[2] = "count"
		alliancePetCtrl:getAlliancePetReturnTimeCD()[3] = "weight"
		rewardsList = serviceFunctions.tableFormat(rewards, alliancePetCtrl:getAlliancePetReturnTimeCD())
	end
	self.fields.List_reward:setItemRenderer(function(index, obj)
		local item = rewardsList[index + 1]
		obj:initData(item.id, item.count)
	end)
	self.fields.List_reward:setNumItems(#rewardsList)
	_ENV = alliancePetCtrl:getAlliancePetReturnTimeCD()
	alliancePetCtrl:getAlliancePetReturnTimeCD().lv = self.curShowLv
	self.Text_title:setString(string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", alliancePetCtrl:getAlliancePetReturnTimeCD())))
	self.Text_des_2:setString(alliancePetRead.getWishDesByType(self.petType, self.curShowLv))
	_ENV = alliancePetRead.getWishDesByType(self.petType, self.curShowLv)
	alliancePetRead.getWishDesByType(self.petType, self.curShowLv).lv = self.curShowLv
	self.Text_cur_lv:setString(i18n("common_text_100", alliancePetRead.getWishDesByType(self.petType, self.curShowLv)))
	local leftLife = alliancePetCtrl:getAlliancePetLeftLife()
	self.loadingBarHp:setValue(leftLife)
	self.loadingBarHp_title:setString(SoraDFValueSuit(leftLife, "%"))
end
function AlliancePetMainViewPanel:donateBtnCallBack(type)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	local curtime = serviceFunctions.systemTime()
	local needtime = gConstValue.ALLIANCE_DONATE_NEE_JOIN_ALLIANCE_TIME
	if needtime > curtime - jointime then
		SoraDShowMsgTip(i18n("alliance_beast_notice_07"))
		return
	end
	if self.maxLv == self.curShowLv then
		SoraDShowMsgTip(i18n("common_text_283"))
		return
	end
	if alliancePetCtrl:checkDonateLock() then
		i18n("common_text_283").data, gametop, gametop = i18n("common_text_283")
		gametop, i18n("common_text_283").msg = i18n("common_text_656"), i18n("common_text_656")
		i18n("common_text_283").tableArgv, i18n("common_text_656").speedUpName = i18n("common_text_656"), i18n("common_text_655")
		uiManager:show("AlliancePetSpeedUpBox", i18n("common_text_283"))
	else
		alliancePetCtrl:reqDonatePet(type)
		SoraDShowLoading(self, nil, nil, nil, 15)
	end
end
function AlliancePetMainViewPanel:updateDonateData(target, event)
	SoraDCloseLoading(self)
	self.curShowLv = alliancePetCtrl:getAlliancePetLv()
	self:refreshState2()
	self:refreshPetModel()
end
function AlliancePetMainViewPanel:updateDonateCD(target, event)
	SoraDCloseLoading(self)
	self.Text_donate_time:setVisible(false)
end
function AlliancePetMainViewPanel:setPetInfo(petType)
	self.petType = petType
	self:initData()
end
function AlliancePetMainViewPanel:setBlessEffect(...)
end
function AlliancePetMainViewPanel:setTrialEffect(...)
end
function AlliancePetMainViewPanel:setTrialBtnEffect(...)
end
function AlliancePetMainViewPanel:onClickTrial()
	SoraDPlaySound()
	_ENV = nil
	;(nil).petType = self.petType
	uiManager:show("AlliancePetRewardPop", nil)
end
function AlliancePetMainViewPanel:onDonateItemRenderer(index, obj)
	obj:setDonateType(index + 1)
	obj:setHandle(handler(self, self.donateBtnCallBack))
end
function AlliancePetMainViewPanel:onClickBtnCall(...)
	local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
	if permissionCtrl:hasPlayerPermission(gAPermission.LAUNCH_WAR) then
		local allianceTerritoryAPI = include("allianceTerritoryAPI")
		local pos = allianceTerritoryAPI:getMainBuildingPos(gAllianceBuilding.ALTAR)
		local instanceID = alliancePetCtrl:getMapAltarId()
		worldMapFunction.GotoTrialMass(pos, instanceID)
	else
		_ENV = worldMapFunction.GotoTrialMass
		worldMapFunction.GotoTrialMass.des = i18n("common_text_2373")
		SoraDShowMsgBox(i18n("common_text_2371", worldMapFunction.GotoTrialMass), i18n("common_text_204"))
	end
end
function AlliancePetMainViewPanel:onMsgAlliancePetUpdateInfo(target, data)
	if data.statusChange then
		local state = alliancePetCtrl:getAlliancePetState()
		if gAlliancePetState.CALL == state then
			SoraDRemoveAllAfterPanelFromManager(self)
		else
			SoraDRemoveAllAfterPanelFromManager(self, true)
			self:initData()
		end
	elseif data.lvChange then
		self:updateDonateData()
	elseif data.pointChange then
		self:updateDonateData()
	elseif data.lifeChange then
		local leftLife = alliancePetCtrl:getAlliancePetLeftLife()
		self.loadingBarHp:setValue(leftLife)
		self.loadingBarHp_title:setString(SoraDFValueSuit(leftLife, "%"))
	end
end
return AlliancePetMainViewPanel
