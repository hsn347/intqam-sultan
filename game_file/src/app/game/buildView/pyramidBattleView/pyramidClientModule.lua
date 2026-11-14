local _ENV, pyramidClientModule
function pyramidClientModule.getDesFromPostSeasonState(...)
	return "pyramid_text_117", nil
end
function pyramidClientModule.getDesFromState(...)
	local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
	local regularEndTime = pyramidWarCtrl:getRegularEndTime()
	local remainTime = regularEndTime - serviceFunctions.systemTime()
	if 0 < remainTime then
		return "common_text_607", remainTime
	else
		return "pyramid_text_44"
	end
end
function pyramidClientModule.popSelectMenu(fun)
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local warState = lordInfoCtrl:getPlayerBattleGround()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityCenterUIEnum.PYRAMID_BATTLE)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	if gPlayerBattleGround.PYRAMID == warState then
		SoraDShowMsgTip(i18n("common_text_3311"))
		local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
		local mapClassType = kingdomMapCtrl:getKingdomClass()
	elseif gPlayerBattleGround.CONQUEST_WAR_ENEMY_KINGDOM == warState then
		SoraDShowMsgTip(i18n("common_text_3312"))
	elseif worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
	elseif pyramidWarCtrl.regularSeasonState == gRegularSeasonState.NOT_OPEN or pyramidWarCtrl.regularSeasonState == gRegularSeasonState.FINISH then
		SoraDShowMsgTip(i18n("devilvalley_text_08"))
	elseif pyramidWarCtrl.pyramidWarOpenState == gPyramidWarOpenState.NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV15_LIMITED then
		_ENV = i18n("common_text_2486")
		i18n("common_text_2486").lv = CASTLE_LV15_LIMITED
		SoraDShowMsgTip(i18n("common_text_3868", i18n("common_text_2486")))
	elseif fun then
		fun()
	else
		pyramidClientModule.checkAndShow("pyramidBattleView")
	end
end
function pyramidClientModule.popPBLView()
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	local groupType = gPinnacleSeasonAllianceState.NOT_APPLY
	local curMatchType = pyramidWarCtrl.curMatchType
	local seasonState = pyramidWarCtrl.pinnacleSeasonState
	local ownlegion = pyramidWarCtrl:getOwnLegion()
	if ownlegion then
		groupType = ownlegion.pinnacleSeasonAllianceState
	end
	if curMatchType == gPinnacleMatchType.GROUP_MATCH then
		if seasonState == gPinnacleSeasonState.APPLY_ING_A or seasonState == gPinnacleSeasonState.GROUP_LIST_WILL_SHOW or seasonState == gPinnacleSeasonState.GROUP_LIST_WAITING or seasonState == gPinnacleSeasonState.WAIT_APPLY_NEXT and groupType == gPinnacleSeasonAllianceState.PINNACLE_SIGN_UP then
			pyramidClientModule.checkAndShow("alliancePBLApplyView")
		else
			pyramidClientModule.checkAndShow("alliancePBLDrawView")
		end
	elseif curMatchType == gPinnacleMatchType.BREAKOUT_MATCH then
		if seasonState == gPinnacleSeasonState.WAIT_LOT and groupType == gPinnacleSeasonAllianceState.FINISH then
			pyramidClientModule.checkAndShow("alliancePBLMatchView")
		else
			pyramidClientModule.checkAndShow("alliancePBLDrawView")
		end
	elseif curMatchType == gPinnacleMatchType.CHAMPION_MATCH then
		pyramidClientModule.checkAndShow("alliancePBLMatchView")
	else
		pyramidClientModule.checkAndShow("alliancePBLApplyView")
	end
end
function pyramidClientModule.checkAndShow(view)
	if not SoraDSearchPanelFromManagerByName(view) then
		SoraDCreatePanel(view):show()
	end
end
return pyramidClientModule
