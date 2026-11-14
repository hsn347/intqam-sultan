local allianceDesRead = include("allianceDesRead")
local AllianceManageSingle = class("allianceManageSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceManageSingle")
	end
	return target
end)
function AllianceManageSingle:ctor()
	self.scroll = nil
	self.singleIsMoved = false
	self.mid = 0
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.btnIcon = SoraDGetChildByName(self, "Button_icon")
	self.btnIcon:setSwallowTouches(false)
	self.spriteGreen = SoraDGetChildByName(self, "Sprite_green")
	self.spriteGreen:setVisible(false)
	self.labelNum = SoraDGetChildByName(self.spriteGreen, "Text_num")
	if self.btnIcon then
		self.btnIcon:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateGreen))
end
function AllianceManageSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceManageSingle:initData(mid)
	self.mid = mid
	self.spriteIcon:setSpriteFrame(allianceDesRead.getManageIcon(self.mid))
	self.labelName:setString(allianceDesRead.getManageName(self.mid))
	self:updateGreen()
end
function AllianceManageSingle:updateGreen()
	if allianceDesRead.checkRank() and self.mid == gAManage.ALLIANCE_RELATION then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		local inviteNum = allianceRelationCtrl:getAllyInviteNum()
		self.spriteGreen:setVisible(0 < inviteNum)
		self.labelNum:setString(tostring(inviteNum))
	else
		self.spriteGreen:setVisible(false)
	end
end
function AllianceManageSingle:showManageSecondView()
	local gametop = gModuleMgr.getObject("gametop")
	_ENV = "gametop"
	;("gametop")[gAManage.SETTINGS] = true
	;("gametop")[gAManage.QUIT] = true
	local ("gametop")[gAManage.DISMISS], checkList = true, "gametop"
	if checkList[self.mid] and not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	if self.mid == gAManage.BWLIST then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceBlackWhiteView")
		else
			SoraDCreatePanel("allianceBlackWhiteView"):show()
		end
	elseif self.mid == gAManage.SETTINGS then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceSettingsView")
		else
			SoraDCreatePanel("allianceSettingsView"):show()
		end
	elseif self.mid == gAManage.RANK_INFO then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceMemberRankInfoView")
		else
			SoraDCreatePanel("allianceMemberRankInfoView"):show()
		end
	elseif self.mid == gAManage.VIEW_BANNER then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceChangeFlagView")
		else
			SoraDCreatePanel("allianceChangeFlagView"):show()
		end
	elseif self.mid == gAManage.OTHER_ALLIANCE then
		uiManager:show("AllianceJoinView")
	elseif self.mid == gAManage.ALLIANCE_WAREHOUSE then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceWarehouseView")
		else
			SoraDCreatePanel("allianceWarehouseView"):show()
		end
	elseif self.mid == gAManage.ALLIANCE_RELATION then
		if GLOBAL_GAME_ALLIANCE_MODE then
			untiliManager:show("allianceRelationView")
		else
			SoraDCreatePanel("allianceRelationView"):show()
		end
	elseif self.mid == gAManage.VIEW_ALLIANCE then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		SoraDOpenAllianceInfoView(allianceMgr:getAlliance())
	elseif self.mid == gAManage.DONATE_RANKINGS then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceDonateRankingsView")
		else
			SoraDCreatePanel("allianceDonateRankingsView"):show()
		end
	elseif self.mid == gAManage.UNLOCK_MESSAGES then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceUnlockMessagesView")
		else
			SoraDCreatePanel("allianceUnlockMessagesView"):show()
		end
	elseif self.mid == gAManage.QUIT then
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
		local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
		local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
		local ownRank = ownmember:getProperty("rank")
		if ownRank == gAllianceRank.R5 then
			SoraDShowMsgTip(i18n("notice_0076"), nil, self.btnIcon)
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
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
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
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
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
function AllianceManageSingle:sureQuit(type, target)
	if type == MSGBOX_CALLBACK_YES then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if self.mid == gAManage.QUIT then
			local memberMgr = gametop.playertop_:getModule("memberMgr")
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
function AllianceManageSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		self:showManageSecondView()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return AllianceManageSingle
