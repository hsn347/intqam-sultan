local gametop = gModuleMgr.getObject("gametop")
local anchorCtrl = gametop.playertop_:getModule("anchorCtrl")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local _ENV, anchorUtil = gametop.playertop_, gametop.playertop_
function anchorUtil.checkSelectWatchMap(notip)
	local isWatch = anchorCtrl:hasWatchMap()
	if not isWatch and not notip then
		SoraDShowMsgTip(i18n("Anchor_text_16"))
	end
	return isWatch
end
function anchorUtil.selectWatchMap(mapID)
	mapID = mapID or 0
	anchorCtrl:setWatchMap(mapID)
	if 0 < mapID then
		local max = worldMapDefine.getMaxCoordinateByKid(mapID)
		SoraDGotoWorldMapPoint(cc.p(max * 0.5, max * 0.5), false, mapID, nil, nil, true)
	else
		SoraDGotoWorldMapPoint(cc.p(35, 35), false, 0, nil, nil, true)
	end
	SoraDRemoveAllPanelFromManager()
	remainsWarCtrl:resetData()
end
function anchorUtil.doWatchTower(kid, uid, teamId)
	anchorUtil.reqSyncRW(kid, uid, teamId)
	if not SoraDSearchPanelFromManagerByName("WatchTowerView") then
		uiManager:show("WatchTowerView")
	end
end
function anchorUtil.doAllianceWar(kid, uid, teamId)
	anchorUtil.reqSyncRW(kid, uid, teamId)
	if not SoraDSearchPanelFromManagerByName("allianceWarView") then
		uiManager:show("AllianceWarView")
	end
end
function anchorUtil.watchAllianceWar(teamId)
	anchorCtrl:reqAnchorRwTeamExistPlayer(worldMapDefine.currentMapKindomID, teamId)
end
function anchorUtil.reqSyncRW(mapId, uid, teamId)
	if anchorCtrl:reqSyncRW(mapId, uid) then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl.kingdomMapCell:switchLocalQueueUser(uid)
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		allianceMgr:setOwnTeamID(teamId)
	end
end
function anchorUtil:reqStopSyncRW()
	if anchorCtrl:reqStopSyncRW() then
		local uid = gametop.playertop_:getPlayerID()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl.kingdomMapCell:switchLocalQueueUser(uid)
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		allianceMgr:setOwnTeamID()
	end
end
_ENV, anchorUtil.doMail = function(kid, uid)
	anchorCtrl:setMailInfo(kid, uid)
	local mailView = SoraDCreatePanel("mailView")
	mailView:show()
	mailView:initWithData(nil)
end, function(kid, uid)
	anchorCtrl:setMailInfo(kid, uid)
	local mailView = SoraDCreatePanel("mailView")
	mailView:show()
	mailView:initWithData(nil)
end
;(function(kid, uid)
	anchorCtrl:setMailInfo(kid, uid)
	local mailView = SoraDCreatePanel("mailView")
	mailView:show()
	mailView:initWithData(nil)
end).NONE = 1
;(function(kid, uid)
	anchorCtrl:setMailInfo(kid, uid)
	local mailView = SoraDCreatePanel("mailView")
	mailView:show()
	mailView:initWithData(nil)
end).ANCHOR_STATUS = 2
anchorUtil.errType, (function(kid, uid)
	anchorCtrl:setMailInfo(kid, uid)
	local mailView = SoraDCreatePanel("mailView")
	mailView:show()
	mailView:initWithData(nil)
end).ACTIVITY = function(kid, uid)
	anchorCtrl:setMailInfo(kid, uid)
	local mailView = SoraDCreatePanel("mailView")
	mailView:show()
	mailView:initWithData(nil)
end, 3
local errType = anchorUtil.errType
function anchorUtil.checkCanSwitchToAnchor(noStatus)
	local err = errType.NONE
	if not _G.SoraDIsAnchor() then
		err = errType.ANCHOR_STATUS
	elseif not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RUINS_WAR) then
		err = errType.ACTIVITY
	else
		if not remainsTeamCtrl:isWarMatchBegin() and not remainsTeamCtrl:isWarBattle() then
			err = errType.ACTIVITY
		else
		end
	end
	return err
end
function anchorUtil.reqSwitchToAnchor()
	if not worldMapDefine.isInAnchorMode() then
		local err = anchorUtil.checkCanSwitchToAnchor()
		if err == errType.ANCHOR_STATUS then
			SoraDShowMsgTip(i18n("Anchor_text_01"))
		elseif err == errType.ACTIVITY then
			SoraDShowMsgTip(i18n("Anchor_text_02"))
		elseif err == errType.NONE then
			_G.SoraDGetCtrl("settingCtrl"):setAnchorSwitchOn()
		end
	end
end
function anchorUtil.reqSwitchToNormal()
	if worldMapDefine.isInAnchorMode() then
		_G.SoraDGetCtrl("settingCtrl"):setAnchorSwitchOff()
	end
end
local capi_replaceSrc_launchOpenLua = function()
	if cc.ReplaceSrc:GetInstance().LaunchOpenLua then
		cc.ReplaceSrc:GetInstance():LaunchOpenLua()
	else
		print("请手动重启客户端或者更新player")
	end
end
function anchorUtil.doSwitchAnchor()
	capi_replaceSrc_launchOpenLua()
end
return anchorUtil
