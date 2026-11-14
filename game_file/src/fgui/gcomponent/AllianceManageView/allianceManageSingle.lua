local gametop = gModuleMgr.getObject("gametop")
local allianceDesRead = include("allianceDesRead")
local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local baseComponent = require("fgui.base.baseComponent")
local allianceManageSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/allianceManageSingle", allianceManageSingle)
function allianceManageSingle:onInit()
	self.fields.Label_reddot:setVisible(false)
	self:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Label_reddot:fixPos()
end
function allianceManageSingle:onShow()
end
function allianceManageSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateGreen))
end
function allianceManageSingle:initData(mid)
	self.mid = mid
	self.fields.icon:setSpriteFrame(allianceDesRead.getManageIcon(self.mid))
	self.fields.title:setString(allianceDesRead.getManageName(self.mid))
	self:updateGreen()
end
function allianceManageSingle:updateGreen()
	if allianceDesRead.checkRank() and self.mid == gAManage.ALLIANCE_RELATION then
		local inviteNum = allianceRelationCtrl:getAllyInviteNum()
		self.fields.Label_reddot:initData(0 < inviteNum, inviteNum)
	else
		self.fields.Label_reddot:setVisible(false)
	end
end
function allianceManageSingle:showManageSecondView()
	_ENV = nil
	;(nil)[gAManage.SETTINGS] = true
	;(nil)[gAManage.QUIT] = true
	local (nil)[gAManage.DISMISS], checkList = true, nil
	if checkList[self.mid] and not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	if self.mid == gAManage.BWLIST then
		uiManager:show("allianceBlackWhiteView")
	elseif self.mid == gAManage.SETTINGS then
		uiManager:show("allianceSettingsView")
	elseif self.mid == gAManage.RANK_INFO then
		uiManager:show("allianceMemberRankInfoView")
	elseif self.mid == gAManage.VIEW_BANNER then
		uiManager:show("allianceChangeFlagView")
	elseif self.mid == gAManage.OTHER_ALLIANCE then
		uiManager:show("AllianceJoinView")
	elseif self.mid == gAManage.ALLIANCE_WAREHOUSE then
		uiManager:show("allianceWarehouseView")
	elseif self.mid == gAManage.ALLIANCE_RELATION then
		uiManager:show("allianceRelationView")
	elseif self.mid == gAManage.VIEW_ALLIANCE then
		_ENV = nil
		;(nil).alliance = allianceMgr:getAlliance()
		uiManager:show("allianceInfoView", nil)
	elseif self.mid == gAManage.DONATE_RANKINGS then
		uiManager:show("allianceDonateRankingsView")
	elseif self.mid == gAManage.UNLOCK_MESSAGES then
		uiManager:show("allianceUnlockMessagesView")
	elseif self.mid == gAManage.QUIT then
		local ownmember = memberMgr:getOwnMember()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
		local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
		local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
		local ownRank = ownmember:getProperty("rank")
		if ownRank == gAllianceRank.R5 then
			SoraDShowMsgTip(i18n("notice_0076"))
		elseif kingdomMapCtrl:isHasMassQueue4Uid(ownmember:getProperty("uid")) then
			SoraDShowMsgBox(i18n("common_text_808"), i18n("common_text_204"))
		elseif kingdomMapCtrl:isHasQueue4UidToHold(ownmember:getProperty("uid")) then
			SoraDShowMsgBox(i18n("alliance_stronghold_text_125"), i18n("common_text_204"))
		elseif kingdomMapCtrl:hasMyOccupyQueueToAncientTreasure() then
			_ENV = i18n("common_text_204")
			i18n("common_text_204").activity = i18n("activity_name_9001201")
			SoraDShowMsgBox(i18n("AncienTreasure_text_76", i18n("common_text_204")), i18n("common_text_204"))
		elseif kingdomMapCtrl:hasKWQueue(ownmember:getProperty("uid")) then
			if worldMapDefine.isInNewTrial() then
				SoraDShowMsgBox(i18n("devilvalley_tips_10"), i18n("common_text_204"))
			else
				SoraDShowMsgBox(i18n("common_text_1438"), i18n("common_text_204"))
			end
		elseif devilValleyCtrl:hasTeams() then
			SoraDShowMsgBox(i18n("devilvalley_text_47"), i18n("common_text_204"))
		elseif allianceTreasureCtrl:getDigRewardCount() > 0 or 0 < allianceTreasureCtrl:getHelpRewardCount() then
			SoraDShowMsgBox(i18n("allitreas_text_39"), i18n("common_text_204"), i18n("common_text_185"), handler(self, self.sureQuit))
		elseif allianceTreasureCtrl:isDigging() or allianceTreasureCtrl:isHelping() then
			SoraDShowMsgBox(i18n("allitreas_text_24"), i18n("common_text_204"), i18n("common_text_185"), handler(self, self.sureQuit))
		else
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			if activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY) then
				SoraDShowMsgBox(i18n("devilvalley_text_62"), i18n("common_text_204"), nil, handler(self, self.sureQuit))
			elseif activityShowCtrl:isActivityOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) then
				SoraDShowMsgBox(i18n("AncienTreasure_text_66"), i18n("common_text_204"), nil, handler(self, self.sureQuit))
			else
				SoraDShowMsgBox(i18n("common_text_809"), i18n("common_text_204"), nil, handler(self, self.sureQuit))
			end
		end
	elseif self.mid == gAManage.DISMISS and not allianceDesRead.getAllianceConquestWarMigration() then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
		local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
		local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
		local ownmember = memberMgr:getOwnMember()
		local ownalliance = allianceMgr:getAlliance()
		local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
		if kingdomMapCtrl:isHasMassQueue4Uid(ownmember:getProperty("uid")) then
			SoraDShowMsgBox(i18n("common_text_810"), i18n("common_text_204"))
		elseif kingdomMapCtrl:isHasQueue4UidToHold(ownmember:getProperty("uid")) then
			SoraDShowMsgBox(i18n("alliance_stronghold_text_121"), i18n("common_text_204"))
		elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) then
			_ENV = i18n("common_text_204")
			i18n("common_text_204").activity = i18n("activity_name_9001201")
			SoraDShowMsgBox(i18n("AncienTreasure_text_76", i18n("common_text_204")), i18n("common_text_204"))
		elseif kingdomMapCtrl:hasKWQueue(ownmember:getProperty("uid")) then
			SoraDShowMsgBox(i18n("common_text_1439"), i18n("common_text_204"))
		elseif romeActivityCtrl:isOpenAllianceRomeActivity() then
			SoraDShowMsgBox(i18n("common_text_1511"), i18n("common_text_204"))
		elseif ownalliance:getProperty("isMigration") then
			SoraDShowMsgBox(i18n("common_text_2167"), i18n("common_text_204"))
		elseif pyramidWarCtrl:hasApplyGroup() then
			SoraDShowMsgBox(i18n("common_text_3299"), i18n("common_text_204"))
		elseif allianceDesRead.checkAlliancePackStatus() then
			SoraDShowMsgBox(i18n("common_text_811"), i18n("common_text_204"), nil, handler(self, self.sureQuit))
		end
	end
end
function allianceManageSingle:sureQuit(type, target)
	if type == MSGBOX_CALLBACK_YES then
		if self.mid == gAManage.QUIT then
			local ownmember = memberMgr:getOwnMember()
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			local ownRank = ownmember:getProperty("rank")
			if ownRank == gAllianceRank.R5 then
				SoraDShowMsgTip(i18n("notice_0076"))
			elseif kingdomMapCtrl:isHasMassQueue4Uid(ownmember:getProperty("uid")) then
				SoraDShowMsgBox(i18n("common_text_808"), i18n("common_text_204"))
			elseif kingdomMapCtrl:hasAtkAllianceBuildQueue() then
				SoraDShowMsgBox(i18n("notice_0203"), i18n("common_text_204"))
			else
				allianceMgr:reqQuitAlliance()
				SoraDShowLoading()
			end
		elseif self.mid == gAManage.DISMISS then
			allianceMgr:reqDismissAlliance()
			SoraDShowLoading()
		end
	end
end
function allianceManageSingle:btnClickCallBack()
	SoraDPlaySound()
	self:showManageSecondView()
end
return allianceManageSingle
