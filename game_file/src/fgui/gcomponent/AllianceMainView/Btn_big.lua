local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local allianceActiveCtrl = SoraDGetCtrl("allianceActiveCtrl")
local allianceCounterSysCtrl = SoraDGetCtrl("allianceCounterSysCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local alliancePetCtrl = SoraDGetCtrl("alliancePetCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseComponent = require("fgui.base.baseComponent")
local Btn_big = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceMainView/Btn_big", Btn_big)
fgui.register_extension("ui://AllianceMainView/Btn_small", Btn_big)
function Btn_big:onInit()
	self.isOpen = true
	self.fields.Label_reddot:setVisible(false)
	self.fields.timer:setVisible(false)
	self.fields.shadow:setVisible(false)
	self.fields.Text_des:setVisible(false)
	self.fields.Text_des:setAlign(0)
	if self.fields.Effect_cz then
		self.fields.Effect_cz:setVisible(false)
	end
	if self.fields.Effect_GuideMail then
		self.fields.Effect_GuideMail:setVisible(false)
	end
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Btn_big:onShow()
end
function Btn_big:registerEvent()
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.greenPointUpdate))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE_BYTYPE", handler(self, self.greenPointUpdateByType))
end
local checkInWar = function()
	return worldMapDefine.isInKingdomBattle() or worldMapDefine.isInWar()
end
function Btn_big:isAllianceTaskOpen()
	if checkInWar() then
		return false
	end
	local ret = false
	local playerMobilizationCtrl = SoraDGetCtrl("playerMobilizationCtrl")
	local activityStatus = playerMobilizationCtrl:getActivityStatus()
	if activityStatus.status == gMobilizationActivityStatus.ACTIVITY_OPEN then
		ret = true
	end
	return ret
end
function Btn_big:isAlliancePetOpen()
	if checkInWar() then
		return false
	end
	local allianceTerritoryAPI = include("allianceTerritoryAPI")
	local showAltar = allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.ALTAR)
	return showAltar
end
function Btn_big:cehckActive()
	if checkInWar() then
		return false
	end
	local time = allianceActiveCtrl:getJoinAllianceTime()
	return not time or not (0 < time)
end
function Btn_big:isForbiddenByInWar()
	if worldMapDefine.isInWarForbid(true) then
		return false
	end
	return true
end
function Btn_big:initData(enum, png, title)
	self.enum = enum
	if png then
		self.fields.icon:setSpriteFrame(png)
	end
	if title then
		self.fields.title:setString(title)
	end
	if self.enum == ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_TASK then
		self.isOpen = self:isAllianceTaskOpen()
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.PET then
		self.isOpen = self:isAlliancePetOpen()
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.ACTIVE then
		self.isOpen = self:cehckActive()
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.HUNT then
		self.isOpen = not checkInWar()
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.BUILD or self.enum == ALLIANCE_MAIN_MENU_TYPE.SCIENCE or self.enum == ALLIANCE_MAIN_MENU_TYPE.STORE or self.enum == ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE or self.enum == ALLIANCE_MAIN_MENU_TYPE.MESSAGE or self.enum == ALLIANCE_MAIN_MENU_TYPE.COUNTER_SYS then
		self.isOpen = self:isForbiddenByInWar()
	end
	self.fields.shadow:setVisible(not self.isOpen)
	self:greenPointUpdate()
end
function Btn_big:greenPointUpdate(target, data)
	self.fields.Label_reddot:setVisible(false)
	self.fields.timer:setVisible(false)
	self.fields.shadow:setVisible(not self.isOpen)
	self.fields.Text_des:setVisible(false)
	if self.fields.Effect_cz then
		self.fields.Effect_cz:setVisible(false)
	end
	if self.fields.Effect_GuideMail then
		self.fields.Effect_GuideMail:setVisible(false)
	end
	if self.enum == ALLIANCE_MAIN_MENU_TYPE.HELP then
		local allianceHelp = SoraDGetCtrl("allianceHelp")
		local helpCount = #allianceHelp:getHelpList().otherhelplist
		self.fields.Label_reddot:initData(0 < helpCount, helpCount)
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.BATTLE then
		local queueCtrl = SoraDGetCtrl("queueCtrl")
		local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
		local allianceCount = kingdomMapCtrl:getHallWarCount()
		self.fields.Label_reddot:initData(0 < allianceCount, allianceCount)
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.BUILD then
		local allianceTerritoryAPI = include("allianceTerritoryAPI")
		local buildCount = allianceTerritoryAPI:getWellDestroyBuildingNum()
		self.fields.Label_reddot:initData(0 < buildCount, buildCount)
		local isHaveBuidingInConstruction = allianceTerritoryAPI:getIsHaveBuidingInConstruction()
		if self.fields.Effect_cz then
			self.fields.Effect_cz:setVisible(isHaveBuidingInConstruction)
		end
		self:initGuideMail()
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.STRONGPOINT then
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.SCIENCE then
		local rewardsCount = SoraDGetCtrl("allianceScience"):getProsperityRewardsCount()
		self.fields.Label_reddot:initData(0 < rewardsCount, rewardsCount)
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE then
		local allianceTreasureCtrl = SoraDGetCtrl("allianceTreasureCtrl")
		local mineNum = allianceTreasureCtrl:getDigRewardCount()
		local helpNum = allianceTreasureCtrl:getHelpRewardCount()
		local num = mineNum + helpNum
		self.fields.Label_reddot:initData(0 < num, num)
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_TASK then
		local playerMobilizationCtrl = SoraDGetCtrl("playerMobilizationCtrl")
		local hasActived = playerMobilizationCtrl:isHaveActived()
		self.fields.Label_reddot:initData(0 < hasActived, hasActived)
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.HUNT then
		local allianceHuntCtrl = SoraDGetCtrl("allianceHuntCtrl")
		local hasActived = allianceHuntCtrl:getCheckChanllengeTimes()
		self.fields.Label_reddot:initData(0 < hasActived, hasActived)
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.PET then
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.COUNTER_SYS then
		local newPoint = allianceCounterSysCtrl:getNewPoint()
		self.fields.Label_reddot:initData(0 < newPoint, newPoint)
		local num = table.nums(allianceCounterSysCtrl.allianceListData)
		_ENV = 0 < num
		;(0 < num).num = num
		self.fields.Text_des:setString(i18n("CounterSystem_text_13", 0 < num))
		self.fields.Text_des:setVisible(true)
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.ACTIVE then
		self.fields.Text_des:setVisible(true)
		_ENV = true
		;(true).lv = allianceActiveCtrl:getActiveLevel()
		self.fields.Text_des:setString(i18n("common_text_2567", true))
		self:setCoolingStatus()
		_ENV = i18n("common_text_2567", true)
		i18n("common_text_2567", true).byUID = true
		local ret = SoraDConfigGet("Game:allianceActiveView:weakPoint~bool", i18n("common_text_2567", true))
		if not ret then
			local isInWar = worldMapDefine.isInKingdomBattle() or worldMapDefine.isInWar()
			self.fields.Label_reddot:initData(not isInWar)
		else
			local receiveNum = allianceActiveCtrl:getCanReceiveTaskNum()
			self.fields.Label_reddot:initData(0 < receiveNum, receiveNum)
		end
	end
end
function Btn_big:greenPointUpdateByType(target, data)
	if self.enum == data.type then
		self:greenPointUpdate()
	end
end
function Btn_big:initGuideMail()
	local allianceGuideCtrl = SoraDGetCtrl("allianceGuideCtrl")
	local isShow = allianceGuideCtrl:getGuideStauts() == 0 or allianceGuideCtrl:getGuideStauts() == 1
	if self.fields.Effect_GuideMail then
		self.fields.Effect_GuideMail:setVisible(isShow)
	end
end
function Btn_big:setCoolingStatus()
	local time = allianceActiveCtrl:getJoinAllianceTime()
	local isInWar = worldMapDefine.isInKingdomBattle() or worldMapDefine.isInWar()
	if time then
		self.fields.timer:setVisible(true)
		self.fields.timer:beginTime(time)
		self.fields.shadow:setVisible(true)
	else
		self.fields.timer:setVisible(false)
		self.fields.shadow:setVisible(isInWar)
	end
end
function Btn_big:btnClick()
	SoraDPlaySound()
	if not self.isOpen then
		if SoraDGetCtrl("conquestWarCtrl"):isHelper() then
			SoraDShowMsgTip(i18n("common_text_3302"))
			return
		end
		if self.enum == ALLIANCE_MAIN_MENU_TYPE.PET then
			if worldMapDefine.inInCrossWar() then
				SoraDShowMsgTip(i18n("common_text_3302"))
			else
				SoraDShowMsgTip(i18n("common_text_4459"))
			end
		elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.ACTIVE then
			local time = allianceActiveCtrl:getJoinAllianceTime()
			if worldMapDefine.inInCrossWar() then
				SoraDShowMsgTip(i18n("common_text_3302"))
			elseif time and 0 < time then
				_ENV = i18n("common_text_3302")
				i18n("common_text_3302").num = ALLIANCE_ACTIVE_JOINALLIANCE_TIME
				SoraDShowMsgTip(i18n("alliance_text_43", i18n("common_text_3302")))
			else
				SoraDShowMsgTip(i18n("common_text_699"))
			end
		elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.HUNT then
			if worldMapDefine.inInCrossWar() then
				SoraDShowMsgTip(i18n("common_text_3302"))
			else
				SoraDShowMsgTip(i18n("common_text_699"))
			end
		else
			SoraDShowMsgTip(i18n("common_text_699"))
		end
		return
	end
	userSDKManager.report2firebase("reportAlliance")
	_ENV = userSDKManager.report2firebase
	userSDKManager.report2firebase[ALLIANCE_MAIN_MENU_TYPE.BUILD] = true
	userSDKManager.report2firebase[ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE] = true
	userSDKManager.report2firebase[ALLIANCE_MAIN_MENU_TYPE.ACTIVE] = true
	local userSDKManager.report2firebase[ALLIANCE_MAIN_MENU_TYPE.HUNT], checkList = true, userSDKManager.report2firebase
	if checkList[self.enum] and not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	if self.enum == ALLIANCE_MAIN_MENU_TYPE.BATTLE then
		uiManager:show("AllianceWarView")
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.BUILD then
		uiManager:show("AllianceBuildView")
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.SCIENCE then
		uiManager:show("AllianceScience")
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.STRONGPOINT then
		uiManager:show("AllianceStrongPoint")
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.STORE then
		uiManager:show("AllianceShopView")
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE then
		local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
		if tonumber(depotBcell.info.lv) >= DEPOT_LV_ALLIANCE_TRRASURE then
			local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
			if isInConquestWar then
				SoraDShowMsgBox(i18n("common_text_2166"), i18n("common_text_204"))
			else
				uiManager:show("allianceStoreHouseView")
				_ENV = "allianceStoreHouseView"
				;("allianceStoreHouseView").position = 2
				userSDKManager.logEvent(gSDKDef.TDonEvent.click_alliance_treasure, "allianceStoreHouseView")
			end
		else
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = i18n("common_text_204")
			i18n("common_text_204").bid = BUILDID.DEPOT
			i18n("common_text_204").lv = DEPOT_LV_ALLIANCE_TRRASURE
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, i18n("common_text_204"))
		end
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.ACTIVE then
		uiManager:show("allianceActiveView")
		_ENV = "allianceActiveView"
		;("allianceActiveView").byUID = true
		if not SoraDConfigGet("Game:allianceActiveView:weakPoint~bool", "allianceActiveView") then
			_ENV = mildGuideManager
			mildGuideManager.byUID = true
			SoraDConfigSet("Game:allianceActiveView:weakPoint~bool", true, mildGuideManager)
			self:greenPointUpdate()
		end
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.HELP then
		uiManager:show("EmbassyView")
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_TASK then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY, 3)
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.PET then
		local state = alliancePetCtrl:getAlliancePetState()
		if state == gAlliancePetState.CALL then
			local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
			if callTimeCD <= 0 then
				uiManager:show("AlliancePetSelect")
			else
				uiManager:show("AlliancePetReduceTime")
			end
		else
			uiManager:show("AlliancePetMainView")
		end
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.HUNT then
		if SoraDGetCastleLv() < ALLIANCE_HUNT_CASTLE_LV_MIN then
			_ENV = "AlliancePetMainView"
			;("AlliancePetMainView").num = ALLIANCE_HUNT_CASTLE_LV_MIN
			SoraDShowMsgTip(i18n("common_text_1795", "AlliancePetMainView"))
		else
			uiManager:show("allianceHuntView")
		end
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.MESSAGE then
		local allianceId = allianceMgr:getOwnAid()
		_ENV = "allianceHuntView"
		;("allianceHuntView").allianceId = allianceId
		SoraDCreateAllianceChatView("allianceHuntView")
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.COUNTER_SYS then
		uiManager:show("AllianceCounterSysView")
	elseif self.enum == ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_WAREHOUSE then
		local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
		if isInConquestWar then
			SoraDShowMsgBox(i18n("common_text_2166"), i18n("common_text_204"))
		else
			uiManager:show("allianceWarehouseView")
		end
	end
end
return Btn_big
